-- Set up AutoCmds for file skeletons
-- Add file/pattern to the skeletons table and the file in this directory
--
---@class SkeletonConfig
---@field skeleton string
---@field enabled? boolean

---@type table<string, SkeletonConfig>
local skeletons = {
    ["*.sh"] = {
        skeleton = "skeleton.sh",
    },
    ["docker-compose.yml"] = {
        skeleton = "docker-compose.yml",
    },
    ["mise.toml"] = {
        skeleton = "mise.toml",
    },
}

local dirname = string.sub(debug.getinfo(1).source, 2, string.len("/plugin/skeletons.lua") * -1)
local group = vim.api.nvim_create_augroup("cf_skeletons", { clear = true })

---@param pattern string
---@param skeleton_filepath string
---@param bufnr? number
local load_skeleton = function(pattern, skeleton_filepath, bufnr)
    -- Define the path to your skeleton file
    local skeleton_file = vim.fn.expand(dirname .. "skeletons/" .. skeleton_filepath)
    -- Check if the skeleton file exists
    if vim.fn.filereadable(skeleton_file) == 1 then
        -- Read the content of the skeleton file
        local skeleton_content = vim.fn.readfile(skeleton_file)

        -- Get the current buffer number
        local buf_nr = bufnr or vim.api.nvim_get_current_buf()

        -- Insert the skeleton content into the buffer
        vim.api.nvim_buf_set_lines(buf_nr, 0, 0, false, skeleton_content)
    else
        vim.notify("Skeleton file not found for " .. pattern, vim.log.levels.WARN)
    end
end

for p, config in pairs(skeletons) do
    if config.enabled == false then
        goto continue
    end

    vim.api.nvim_create_autocmd("BufNewFile", {
        group = group,
        pattern = p,
        callback = function(event)
            load_skeleton(p, config.skeleton, event.buf)
        end,
    })

    ::continue::
end
