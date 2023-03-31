local icons = require("icons")
local dap = require("dap")

require("nvim-dap-virtual-text").setup({})
require("dapui").setup()

-- require("dap-vscode-js").setup({
-- 	debugger_cmd = { "js-debug-adapter" },
-- 	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
-- })

vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })
vim.fn.sign_define("DapBreakpoint", { text = icons.ui.Circle, texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = icons.ui.CircleWithGap, texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
)
vim.fn.sign_define("DapLogPoint", { text = icons.ui.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })
vim.fn.sign_define(
	"DapStopped",
	{ text = icons.ui.ChevronRight, texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = icons.diagnostics.Error, texthl = "Error", linehl = "", numhl = "" }
)

dap.adapters.node2 = {
	type = "executable",
	command = "node-debug2-adapter",
}
dap.adapters.web = {
	type = "executable",
	command = "chrome-debug-adapter",
}

for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
	dap.configurations[language] = {
		{
			type = "node2",
			request = "attach",
			name = "Attach",
			port = 9229,
			cwd = "${workspaceFolder}",
		},
	}
end

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.after.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.after.event_exited["dapui_config"] = function()
	dapui.close()
end
