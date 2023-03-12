local icons = require("icons")
local dap = require("dap")

require('nvim-dap-virtual-text').setup({})
require('dapui').setup()

dap.adapters.node2 = {
    type = "executable",
    command = "node-debug2-adapter"
}



vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })
vim.fn.sign_define("DapBreakpoint", { text = icons.ui.Circle, texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition",
    { text = icons.ui.CircleWithGap, texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = icons.ui.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped",
    { text = icons.ui.ChevronRight, texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = icons.diagnostics.Error, texthl = "Error", linehl = "", numhl = "" })





for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
    dap.configurations[language] = {
        {
            type = "node2",
            request = "attach",
            name = "Attach to 9229",
            cwd = "${workspaceFolder}",
            port = 9229,
        }
    }
end
