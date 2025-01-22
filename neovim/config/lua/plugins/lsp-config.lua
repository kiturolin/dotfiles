---@diagnostic disable: undefined-global
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
        "rmagatti/goto-preview",
        event = "BufEnter",
        config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88

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
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                map('gd', function()
                    local builtin = require 'telescope.builtin'
                    local params = vim.lsp.util.make_position_params()
                    vim.lsp.buf_request(params.bufnr, 'textDocument/definition', params, function(_, result, _, _)
                        if not result or vim.tbl_isempty(result) then
                            vim.notify('No definition found', vim.log.levels.INFO)
                        else
                            -- vim.lsp.buf.definition()
                            builtin.lsp_definitions()
                        end
                    end)
                end, 'Goto Definition')

                map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
                map('gr', require('telescope.builtin').lsp_references, 'Goto References')

                require('goto-preview').setup {}
                map('gp', function(opts)
                    local params = vim.lsp.util.make_position_params()
                    vim.lsp.buf_request(params.bufnr, 'textDocument/definition', params, function(_, result, _, _)
                        if not result or vim.tbl_isempty(result) then
                            vim.notify('No definition found', vim.log.levels.INFO)
                        else
                            require('goto-preview').goto_preview_definition(opts)
                        end
                    end)
                end, 'Preview definition')

            map('gP', require('goto-preview').goto_preview_declaration, 'Preview declaration')
            map('<leader>la', vim.lsp.buf.code_action, 'Lsp Action')
            map('<leader>rn', vim.lsp.buf.rename, 'Lsp Rename')

            -- Diagnostics
            map('<leader>ld', function()
              vim.diagnostic.open_float { source = true }
            end, 'LSP Open Diagnostic')

            map(
              '<leader>td',
              (function()
                    local diag_status = 1 -- 1 is show; 0 is hide
                    return function()
                    if diag_status == 1 then
                        diag_status = 0
                        vim.diagnostic.config { underline = false, virtual_text = false, signs = false, update_in_insert = false }
                    else
                        diag_status = 1
                        vim.diagnostic.config { underline = true, virtual_text = true, signs = true, update_in_insert = true }
                    end
                end
              end)(),
              'Toggle diagnostics display'
            )

            local client = vim.lsp.get_client_by_id(event.data.client_id)
            -- Inlay hint
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                vim.lsp.inlay_hint.enable()
                map('<leader>th', function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, 'Toggle Inlay Hints')
                end

            -- Highlight words under cursor
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) and vim.bo.filetype ~= 'bigfile' then
                local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
            })
            end
          end,
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
   
