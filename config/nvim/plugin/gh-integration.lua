-- GitHub CLI integration for code reviews
-- Requires: gh CLI (brew install gh)

-- Check if gh is available
local gh_available = vim.fn.executable("gh") == 1

if not gh_available then
    vim.notify("gh CLI not found. Install with: brew install gh", vim.log.levels.WARN)
    return
end

-- PR Management
vim.keymap.set("n", "<leader>gpo", "<cmd>!gh pr view --web<cr>", { desc = "Open PR in browser" })
vim.keymap.set("n", "<leader>gpv", "<cmd>!gh pr view<cr>", { desc = "View PR details" })
vim.keymap.set("n", "<leader>gpd", "<cmd>!gh pr diff<cr>", { desc = "View PR diff" })
vim.keymap.set("n", "<leader>gpc", "<cmd>!gh pr checks<cr>", { desc = "View PR checks" })
vim.keymap.set("n", "<leader>gpl", "<cmd>!gh pr list<cr>", { desc = "List PRs" })

-- PR Checkout with completion
vim.api.nvim_create_user_command("PRCheckout", function(opts)
    local pr_number = opts.args
    if pr_number == "" then
        vim.notify("Usage: :PRCheckout <pr-number>", vim.log.levels.ERROR)
        return
    end
    vim.cmd("!gh pr checkout " .. pr_number)
end, {
    nargs = 1,
    desc = "Checkout a PR by number",
})

-- Quick PR review
vim.api.nvim_create_user_command("PRReview", function()
    local choice = vim.fn.confirm("Review action:", "&Approve\n&Request Changes\n&Comment\n&Cancel", 4)

    if choice == 1 then
        vim.cmd("!gh pr review --approve")
    elseif choice == 2 then
        vim.cmd("!gh pr review --request-changes")
    elseif choice == 3 then
        vim.cmd("!gh pr review --comment")
    end
end, { desc = "Review current PR" })

-- View PR for current branch
vim.keymap.set("n", "<leader>gpb", function()
    local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
    vim.cmd("!gh pr view " .. branch)
end, { desc = "View PR for current branch" })

-- Create PR (opens editor for description)
vim.keymap.set("n", "<leader>gpr", "<cmd>!gh pr create<cr>", { desc = "Create PR" })

-- Comment on specific line (visual selection)
vim.keymap.set("v", "<leader>gcc", function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local file = vim.fn.expand("%")

    -- Get comment from user
    local comment = vim.fn.input("Comment: ")
    if comment ~= "" then
        local cmd = string.format("gh pr comment --body '%s' --line %d --file %s",
            comment, start_line, file)
        vim.cmd("!" .. cmd)
    end
end, { desc = "Comment on selected lines" })

-- Browse file on GitHub at current line
vim.keymap.set("n", "<leader>gbo", function()
    local file = vim.fn.expand("%")
    local line = vim.fn.line(".")
    vim.cmd(string.format("!gh browse %s:%d", file, line))
end, { desc = "Browse file on GitHub" })

-- Useful commands to remember:
-- :PRCheckout 123      - Checkout PR #123
-- :PRReview            - Interactive review menu
-- <leader>gpo          - Open PR in browser
-- <leader>gpr          - Create new PR
