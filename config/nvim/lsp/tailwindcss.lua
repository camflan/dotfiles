vim.lsp.config("tailwindcss", {
    settings = {
        tailwindCSS = {
            classAttributes = {
                "class",
                "className",
                "ngClass",
                ".*Class",
                ".*Classes",
                ".*ClassNames",
                ".*CLASSNAMES",
                ".*Styles",
            },
            experimental = {
                classRegex = {
                    { "cva\\(((?:[^()]|\\([^()]*\\))*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                    { "classnames\\(([^)]*)\\)", "'([^']*)'" },
                    { "cx\\(([^)]*)\\)", "'([^']*)'" },
                    { "clsx\\(([^)]*)\\)", "'([^']*)'" },
                    -- { "cva\\(([^)]*)\\)", "'([^']*)'" },
                },
            },
        },
    },
})
