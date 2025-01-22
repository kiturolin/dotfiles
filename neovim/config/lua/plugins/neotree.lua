return{
    {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
        },
    config = function()
        local neotree = require("neo-tree")
        vim.keymap.set('n', '<leader>t', ':Neotree filesystem reveal left<CR>', {})
        neotree.setup({
            window = {
                width = 35,
            }
        })
    end
    }
}
