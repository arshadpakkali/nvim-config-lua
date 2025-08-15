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

dap.adapters.coreclr = function(cb, config, parent)
	if config.preLaunchTask then
		vim.fn.system(config.preLaunchTask)
	end

	local adapter = {
		type = "executable",
		command = "netcoredbg",
		args = { "--interpreter=vscode" },
	}
	cb(adapter)
end

dap.adapters.vsdbg = function(cb, config, parent)
	local adapter = {
		type = "executable",
		command = "/home/arshad/Documents/Code/vsdbg/vsdbg",
		args = { "--interpreter=vscode", "--engineLogging=/home/arshad/vsdbg.log" },
	}
	cb(adapter)
end
dap.set_log_level("trace")

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

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch ManageService - netcoredbg",
		request = "launch",
		program = function()
			-- return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
			return vim.fn.getcwd() .. "/ManageService/bin/Debug/net8.0/ManageService.dll"
		end,
		env = {
			ASPNETCORE_ENVIRONMENT = function()
				-- todo: request input from ui
				return "Development"
			end,
			ASPNETCORE_URLS = function()
				-- todo: request input from ui
				return "http://localhost:5064"
			end,
		},
		cwd = function()
			-- return vim.fn.input("CWD", vim.fn.getcwd() .. "/", "file")
			return vim.fn.getcwd() .. "/ManageService"
		end,
		preLaunchTask = "dotnet build",
	},
	{
		type = "coreclr",
		name = "Launch Generic - netcoredbg",
		request = "launch",
		program = function()
			local scandir = require("plenary.scandir")
			local csprojFiles = scandir.scan_dir(".", { search_pattern = "%.csproj$", depth = 1 })

			if #csprojFiles == 1 then
				local projectName = vim.fn.fnamemodify(csprojFiles[1], ":t:r")

				local dllFile = projectName .. ".dll"

				local dllSearchResults = scandir.scan_dir(".", {
					search_pattern = dllFile,
					depth = 4,
				})

				for _, path in ipairs(dllSearchResults) do
					if path:match("Debug") then
						return path
					end
				end
			end

			return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
		end,
		env = {
			ASPNETCORE_ENVIRONMENT = function()
				-- todo: request input from ui
				return "Development"
			end,
			ASPNETCORE_URLS = function()
				-- todo: request input from ui
				return "http://localhost:5064"
			end,
		},
		cwd = function()
			local csprojFiles = require("plenary.scandir").scan_dir(".", { search_pattern = "%.csproj$", depth = 1 })

			if #csprojFiles > 0 then
				return vim.fn.getcwd()
			end

			return vim.fn.input("CWD", vim.fn.getcwd() .. "/", "file")
		end,
		preLaunchTask = "dotnet build",
	},
	{
		type = "coreclr",
		name = "attach - netcoredbg",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
}

vim.keymap.set("n", "<leader>dop", function()
	local session = assert(require("dap").session(), "has active session")
	local arguments = {
		expression = vim.fn.expand("<cword>"),
	}
	coroutine.wrap(function()
		local err, result = session:request("evaluate", arguments)
		vim.print(err or "No error")
		vim.print(result or "No result")
	end)()
end, {
	desc = "hover",
})

vim.keymap.set("n", "<leader>dol", function()
	local session = assert(require("dap").session(), "has active session")
	local arguments = {
		variablesReference = tonumber(vim.fn.input("var ref")),
	}
	coroutine.wrap(function()
		local err, result = session:request("variables", arguments)
		vim.print(err or "No error")
		vim.print(result or "No result")
	end)()
end, {
	desc = "hover",
})

-- require("nvim-dap-virtual-text").setup({
-- 	enabled = true, -- enable this plugin (the default)
-- 	enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
-- 	highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
-- 	highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
-- 	show_stop_reason = true, -- show stop reason when stopped for exceptions
-- 	commented = false, -- prefix virtual text with comment string
-- 	only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
-- 	all_references = false, -- show virtual text on all all references of the variable (not only definitions)
-- 	clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
-- 	--- A callback that determines how a variable is displayed or whether it should be omitted
-- 	--- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
-- 	--- @param buf number
-- 	--- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
-- 	--- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
-- 	--- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
-- 	--- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
-- 	display_callback = function(variable, buf, stackframe, node, options)
-- 		local dap_helper = require("dap-pretty-print")
-- 		local var_name = variable.evaluateName or variable.name
-- 		local result = dap_helper.resolve(stackframe.id, var_name, variable.type, function(res)
-- 			if res == false then
-- 				return " " .. variable.value
-- 			end
-- 			vim.cmd("DapVirtualTextForceRefresh")
-- 		end)
--
-- 		if result == false then
-- 			return " " .. variable.value
-- 		elseif result == "pending" then
-- 			return " " .. variable.value .. " (loading...)"
-- 		end
-- 		return result
-- 	end,
-- 	-- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
-- 	virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
--
-- 	-- experimental features:
-- 	all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
-- 	virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
-- 	virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
-- 	-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
-- })
