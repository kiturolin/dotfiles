return{
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {"clangd", "cmake", "lua_ls", "pylsp"},
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup({})
            lspconfig.clangd.setup({})
            lspconfig.pylsp.setup({})
            lspconfig.cmake.setup({})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        end
    }
   }
