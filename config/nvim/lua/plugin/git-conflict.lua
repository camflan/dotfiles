git_conflict = require("git-conflict")

git_conflict.setup({
    disable_diagnostics = false,
    highlights = {
        incoming = 'DiffText',
        current = 'DiffAdd'
    }
})
