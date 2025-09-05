local ensure_installed = function(specs)
    vim.pack.add(specs, { load = function() end })
end

---@param event table<string>
---@param on_load_fn? function
local make_load_on_event = function(event, on_load_fn)
    local group = vim.api.nvim_create_augroup('LoadOn' .. table.concat(event, ":"), {})

    return function(spec)
        vim.api.nvim_create_autocmd(event, {
            group = group,
            once = true,
            callback = function() vim.pack.add({ spec.name }) end,
        })

        if on_load_fn then
            on_load_fn()
        end
    end
end

---@param event table<string>
---@param on_load_fn? function
local add_on_event = function(event, specs, on_load_fn)
    vim.pack.add(specs, { load = make_load_on_event(event, on_load_fn) })
end

---@param filetype_pattern string
---@param on_load_fn? function
local load_on_filetype = function(filetype_pattern, on_load_fn)
    return function (spec)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetype_pattern,
            callback = function()
                vim.cmd.packadd(spec.name)

                if on_load_fn then
                    on_load_fn()
                end
            end,
        })
    end
end

return {
    add_on_event = add_on_event,
    ensure_installed = ensure_installed,
    load_on_event = make_load_on_event,
    load_on_filetype = load_on_filetype,
}
