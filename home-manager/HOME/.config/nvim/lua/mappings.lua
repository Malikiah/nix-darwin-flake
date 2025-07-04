require "nvchad.mappings"

local map = vim.keymap.set
local wk = require("which-key")




map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<esc>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Nvim DAP

map("n", "<leader>d", "", { desc = "Debug" })
map("n", "<leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
	"n",
	"<leader>dd",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debugger set conditional breakpoint" }
)
map("n", "<leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })


-- Terminal mode mapping: Pressing <Esc> will exit to Normal mode.
map("t", "<esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Map <leader>cw to close the current window
map("n", "<C-q>", ":q<CR>", { desc = "Close current window" })

-- DAP mappings, Cargo Run, etc.
-- map("n", "<leader>cr", ":split term://cargo run <CR>", { desc = "Cargo Run" })
--


function _CARGO_TOGGLE(method)
  local Options = {
      RUN = "run",
      BUILD = "build",
      RELEASE = "release",
      TEST = "test"
  }
  local cargoCommand = ""
  if selectedOption == Options.RUN then
      cargoCommand = string.format("cargo %s!", method)
  elseif selectedOption == Options.BUILD then
      cargoCommand = string.format("cargo %s!", method)
  elseif selectedOption == Options.RELEASE then
      cargoCommand = string.format("cargo %s!", method)
  elseif selectedOption == Options.TEST then
      cargoCommand = string.format("cargo %s!", method)
  else
      message = "Invalid option selected."
  end
  print(cargoCommand)
  local Terminal  = require("toggleterm.terminal").Terminal
  -- Create a dedicated Terminal instance for running `cargo run`
  local cargoRun = Terminal:new({
    cmd = cargoCommand,
    direction = "horizontal",      -- you can also set "vertical" or "float"
    close_on_exit = false,          -- close the terminal window when cargo run exits
    hidden = false,
    count = 1,                     -- optional: a number identifier if you use multiple terminals
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
    or_exit = function(term, exit_code, _)
      print("Cargo run exited with code: " .. exit_code)
    end,
  })
  
  -- Define a function to toggle the dedicated cargo run terminal
  cargoRun:toggle()
end

-- Map a key (for example, <leader>cr) to toggle the cargo run terminal

map("n", "<leader>p", "", {desc = "Compilers"})
map("n", "<leader>pc", "", {desc = "Cargo"})
map("n", "<leader>pcr", "<cmd>lua _CARGO_TOGGLE(\"run\")<CR>", { noremap = true, silent = true, desc = "Toggle cargo run terminal" })
