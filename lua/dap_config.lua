local icons = require("icons")
local dap = require("dap")

require("nvim-dap-virtual-text").setup({})
require("dapui").setup()

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

dap.adapters.node_debug = {
	type = "executable",
	command = "node-debug2-adapter",
}
dap.adapters.chrome_debug = {
	type = "executable",
	command = "chrome-debug-adapter",
}

dap.adapters.firefox_debug = {
	type = "executable",
	command = "firefox-debug-adapter",
}

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "js-debug-adapter",
		-- 💀 Make sure to update this path to point to your installation
		args = { "${port}" },
	},
}

-- for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
-- 	dap.configurations[language] = {
-- 		{
-- 			type = "node2",
-- 			request = "attach",
-- 			name = "Attach",
-- 			port = 9229,
-- 			cwd = "${workspaceFolder}",
-- 		},
-- 	}
-- end

local dapui = require("dapui")

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
