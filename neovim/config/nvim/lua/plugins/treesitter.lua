return{
    {
        "nvim-treesitter/nvim-treesitter", 
        build = ":TSUpdate",
        configs = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
            ensure_installed = { "c", "lua", "python","vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },  
            })
        end
    }
}
