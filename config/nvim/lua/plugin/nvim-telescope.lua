telescope = require("telescope")
telescope_actions = require("telescope.actions")

telescope.setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                ["<esc>"] = telescope_actions.close
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            }
        }
    },
    pickers = {
        find_files = {
            theme = "dropdown"
        }
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
            --   picker_config_key = value,
            --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    }
}

telescope.load_extension('fzf')
