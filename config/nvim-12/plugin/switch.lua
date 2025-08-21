vim.g.switch_custom_definitions = {
    { "attach", "detach" },
    { "enabled", "disabled" },
}

vim.pack.add(
    {
        { src = "https://github.com/AndrewRadev/switch.vim" }
    },
    {
        load = true
    }
)
