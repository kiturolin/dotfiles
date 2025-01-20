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
                ensure_installed = {"clangd", "cmake", "lua_ls", "pylsp", "marksman"},
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup({})
            lspconfig.pylsp.setup({})
            lspconfig.cmake.setup({})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})

            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
            })
        end
    },
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require('lspsaga').setup({})
        end,
    }
}
   
