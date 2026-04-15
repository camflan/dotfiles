-- Declarative wrapper around vim.pack
--
-- Startup uses packadd (fast). vim.pack.add is only called
-- for install/update via :PackInstall / :PackUpdate.
--
-- Spec fields:
--   src           GitHub URL (required)
--   name          Plugin name, derived from src if omitted
--   version       Git tag/branch to pin to
--   deps          Plugin names that must load before this one
--   event         Load on autocmd event(s)
--   ft            Load on filetype pattern
--   setup         Called after the plugin is loaded
--   build         Shell command to run post-install
--   build_output  Path relative to plugin dir — skip build if exists
--   enabled       Set false to skip entirely (default true)
--   pre           Called before loading (for vim.g.* etc)

---@class PackSpec
---@field src string
---@field name? string
---@field version? string
---@field deps? string[]
---@field event? string|string[]
---@field ft? string
---@field setup? fun()
---@field build? string
---@field build_output? string
---@field enabled? boolean
---@field pre? fun()

---@class PackProfile
---@field name string
---@field setup_ms number
---@field kind "immediate"|"deferred"

---@class PackModule
---@field setup fun(specs: PackSpec[])
---@field profile PackProfile[]
---@field _specs PackSpec[]
---@field _total_ms number
local M = {
    ---@type PackProfile[]
    profile = {},
    ---@type PackSpec[]
    _specs = {},
    ---@type number
    _total_ms = 0,
}

---@type string
local pack_dir = vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "site", "pack", "core", "opt")

---@return number
local function hrtime_ms()
    return vim.uv.hrtime() / 1e6
end

---@param src string
---@return string
local function name_from_src(src)
    return src:match("[^/]+$")
end

---@param specs PackSpec[]
---@return PackSpec[]
local function toposort(specs)
    ---@type table<string, PackSpec>
    local by_name = {}
    for _, spec in ipairs(specs) do
        by_name[spec.name] = spec
    end

    ---@type PackSpec[]
    local sorted = {}
    ---@type table<string, boolean>
    local visited = {}
    ---@type table<string, boolean>
    local visiting = {}

    ---@param spec PackSpec
    local function visit(spec)
        if visited[spec.name] then return end
        if visiting[spec.name] then
            vim.notify("pack: circular dependency involving " .. spec.name, vim.log.levels.ERROR)
            return
        end
        visiting[spec.name] = true
        for _, dep_name in ipairs(spec.deps or {}) do
            local dep = by_name[dep_name]
            if dep then
                visit(dep)
            end
        end
        visiting[spec.name] = nil
        visited[spec.name] = true
        table.insert(sorted, spec)
    end

    for _, spec in ipairs(specs) do
        visit(spec)
    end

    return sorted
end

---@param spec PackSpec
---@param path string
local function maybe_build(spec, path)
    if not spec.build then return end
    if spec.build_output and vim.uv.fs_stat(path .. "/" .. spec.build_output) then
        return
    end
    vim.notify("pack: building " .. spec.name .. "…", vim.log.levels.INFO)
    vim.system({ "sh", "-c", spec.build }, { cwd = path }):wait()
end

---@param name string
---@return boolean
local function is_on_disk(name)
    return vim.uv.fs_stat(pack_dir .. "/" .. name) ~= nil
end

---@param spec PackSpec
---@param kind "immediate"|"deferred"
local function run_post_load(spec, kind)
    local t0 = hrtime_ms()

    if spec.build then
        local path = pack_dir .. "/" .. spec.name
        if vim.uv.fs_stat(path) then
            maybe_build(spec, path)
        end
    end

    if spec.setup then
        spec.setup()
    end

    table.insert(M.profile, {
        name = spec.name,
        setup_ms = hrtime_ms() - t0,
        kind = kind,
    })
end

---@param spec PackSpec
local function defer_load(spec)
    if spec.ft then
        vim.api.nvim_create_autocmd("FileType", {
            pattern = spec.ft,
            once = true,
            callback = function()
                vim.cmd.packadd(spec.name)
                run_post_load(spec, "deferred")
            end,
        })
    elseif spec.event then
        ---@type string[]
        local events = type(spec.event) == "string" and { spec.event } or spec.event
        vim.api.nvim_create_autocmd(events, {
            once = true,
            callback = function()
                vim.cmd.packadd(spec.name)
                run_post_load(spec, "deferred")
            end,
        })
    end
end

---Check for drift between specs and installed plugins
---@param sorted PackSpec[]
---@return string[] missing plugins not on disk
---@return string[] extra plugins on disk but not in specs
local function check_drift(sorted)
    ---@type string[]
    local missing = {}
    ---@type table<string, boolean>
    local spec_names = {}

    for _, spec in ipairs(sorted) do
        spec_names[spec.name] = true
        if not is_on_disk(spec.name) then
            table.insert(missing, spec.name)
        end
    end

    ---@type string[]
    local extra = {}
    local handle = vim.uv.fs_scandir(pack_dir)
    if handle then
        while true do
            local name, typ = vim.uv.fs_scandir_next(handle)
            if not name then break end
            if typ == "directory" and not spec_names[name] then
                table.insert(extra, name)
            end
        end
    end

    return missing, extra
end

---@param specs PackSpec[]
function M.setup(specs)
    local t_start = hrtime_ms()
    M.profile = {}

    -- normalize
    for _, spec in ipairs(specs) do
        spec.name = spec.name or name_from_src(spec.src)
        if spec.enabled == nil then spec.enabled = true end
    end

    ---@type PackSpec[]
    local enabled = vim.tbl_filter(function(s) return s.enabled end, specs)

    ---@type PackSpec[]
    local sorted = toposort(enabled)
    M._specs = sorted

    -- run pre-hooks
    for _, spec in ipairs(sorted) do
        if spec.pre then spec.pre() end
    end

    -- check for missing plugins
    local missing, _ = check_drift(sorted)
    if #missing > 0 then
        vim.notify(
            "pack: " .. #missing .. " plugin(s) not installed: " .. table.concat(missing, ", ")
                .. "\nRun :PackInstall to install them.",
            vim.log.levels.WARN
        )
    end

    -- split into immediate vs deferred, load via packadd
    ---@type PackSpec[]
    local immediate_specs = {}
    ---@type PackSpec[]
    local deferred_specs = {}

    for _, spec in ipairs(sorted) do
        if spec.ft or spec.event then
            table.insert(deferred_specs, spec)
        else
            -- packadd is a no-op if plugin isn't on disk
            vim.cmd.packadd({ spec.name, bang = true })
            table.insert(immediate_specs, spec)
        end
    end

    -- run setup callbacks for immediate plugins
    for _, spec in ipairs(immediate_specs) do
        run_post_load(spec, "immediate")
    end

    -- register autocmds for deferred plugins
    for _, spec in ipairs(deferred_specs) do
        defer_load(spec)
    end

    M._total_ms = hrtime_ms() - t_start
end

---Install/sync all plugins via vim.pack.add
---@param opts? { force?: boolean }
function M.install(opts)
    opts = opts or {}
    ---@type table[]
    local pack_specs = {}
    for _, spec in ipairs(M._specs) do
        ---@type { src: string, version?: string, name?: string }
        local ps = { src = spec.src }
        if spec.version then ps.version = spec.version end
        if spec.name then ps.name = spec.name end
        table.insert(pack_specs, ps)
    end

    vim.pack.add(pack_specs, {
        load = function() end,
        confirm = not opts.force,
    })

    -- run builds for anything that needs it
    for _, spec in ipairs(M._specs) do
        if spec.build then
            local path = pack_dir .. "/" .. spec.name
            if vim.uv.fs_stat(path) then
                maybe_build(spec, path)
            end
        end
    end

    vim.notify("pack: install complete. Restart nvim to load new plugins.", vim.log.levels.INFO)
end

---Show drift between config and installed plugins
function M.status()
    local missing, extra = check_drift(M._specs)

    ---@type string[]
    local lines = {}

    if #missing > 0 then
        table.insert(lines, "Missing (run :PackInstall):")
        for _, name in ipairs(missing) do
            table.insert(lines, "  + " .. name)
        end
    end

    if #extra > 0 then
        table.insert(lines, "Extra (not in config):")
        for _, name in ipairs(extra) do
            table.insert(lines, "  - " .. name)
        end
    end

    if #lines == 0 then
        table.insert(lines, "All plugins in sync.")
    end

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Commands
vim.api.nvim_create_user_command("PackInstall", function()
    M.install({ force = true })
end, { desc = "Install/sync all plugins" })

vim.api.nvim_create_user_command("PackUpdate", function()
    vim.pack.update()
end, { desc = "Update all plugins" })

vim.api.nvim_create_user_command("PackStatus", function()
    M.status()
end, { desc = "Show drift between config and installed plugins" })

vim.api.nvim_create_user_command("PackProfile", function()
    ---@type PackProfile[]
    local sorted = vim.deepcopy(M.profile)
    table.sort(sorted, function(a, b) return a.setup_ms > b.setup_ms end)

    ---@type string[]
    local lines = {
        string.format("Total: %.1f ms  (%d plugins)", M._total_ms or 0, #sorted),
        string.format("%-35s %8s  %s", "Plugin", "Time", "Kind"),
        string.rep("─", 56),
    }

    for _, p in ipairs(sorted) do
        table.insert(lines, string.format("%-35s %6.1f ms  %s", p.name, p.setup_ms, p.kind))
    end

    vim.cmd("enew")
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "packprofile"
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
end, { desc = "Show plugin load times" })

return M
