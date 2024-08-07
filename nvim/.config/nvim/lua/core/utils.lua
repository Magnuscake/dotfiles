local U = {}

-- @class Autocommand
-- @field description string
-- @field event  string[] list of autocommand events
-- @field pattern string[] list of autocommand patterns
-- @field command string | function
-- @field nested  boolean
-- @field once    boolean
-- @field buffer  number

-- Create an autocommand
-- returns the group ID so that it can be cleared or manipulated.
-- @param name string
-- @param commands Autocommand[]
-- @return number
U.augroup = function(name, commands)
  local id = vim.api.nvim_create_augroup(name, { clear = true })

  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = id,
      pattern = autocmd.pattern,
      desc = autocmd.description,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean

---Create an nvim command
---@param name any
---@param rhs string | function(args: CommandArgs)
---@param opts table
function U.command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

-- Reload current buffer if it is a vim or lua file
U.source_filetype = function()
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  if ft == "lua" or ft == "vim" then
    vim.cmd("source %")
    U.info(ft .. " file reloaded!")
  else
    U.err("Not a lua or vim file")
  end
end

U.is_git_directory = function()
  local git_dir = io.popen("git rev-parse --git-dir 2>/dev/null")
  if git_dir then
    local git_dir_result = git_dir:read("*a")
    git_dir:close()

    return git_dir_result ~= ""
  end
end

local function branch_name()
  local cmd_output = vim.fn.systemlist("git branch --show-current 2> /dev/null")
  return #cmd_output > 0 and cmd_output[1] or ""
end

-- Display the filename in the statusbar
local function file_name()
  local root_path = vim.fn.getcwd()
  local root_dir = root_path:match("[^/]+$")
  local home_path = vim.fn.expand("%:~")
  local overlap, _ = home_path:find(root_dir)
  if home_path == "" then
    return root_path:gsub("/Users/[^/]+", "~")
  elseif overlap then
    return home_path:sub(overlap)
  else
    return home_path
  end
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "FocusGained" }, {
  callback = function()
    vim.b.branch_name = branch_name()
    vim.b.file_name = file_name()
  end,
})

U.is_buffer_empty = function()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function U._echo_multiline(msg)
  for _, s in ipairs(vim.fn.split(msg, "\n")) do
    vim.cmd("echom '" .. s:gsub("'", "''") .. "'")
  end
end

function U.prequire(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end
  return nil
end

function U.info(msg)
  vim.cmd("echohl Directory")
  U._echo_multiline(msg)
  vim.cmd("echohl None")
end

function U.warn(msg)
  vim.cmd("echohl WarningMsg")
  U._echo_multiline(msg)
  vim.cmd("echohl None")
end

function U.err(msg)
  vim.cmd("echohl ErrorMsg")
  U._echo_multiline(msg)
  vim.cmd("echohl None")
end

-- sudo write and execute within neovim
-- directly stolen from https://github.com/ibhagwan/nvim-lua/blob/main/lua/utils.lua#L307
U.sudo_exec = function(cmd, print_output)
  local password = vim.fn.inputsecret("Password: ")
  if not password or #password == 0 then
    U.warn("Invalid password, sudo aborted")
    return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    U.err(out)
    return false
  end
  if print_output then
    print("\r\n", out)
  end
  return true
end

U.sudo_write = function(tmpfile, filepath)
  if not tmpfile then
    tmpfile = vim.fn.tempname()
  end
  if not filepath then
    filepath = vim.fn.expand("%")
  end
  if not filepath or #filepath == 0 then
    U.err("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1U. for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1U. and `bs=1m` are non-POSIX
  local cmd = string.format(
    "dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath)
  )
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
  if U.sudo_exec(cmd) then
    U.info(string.format('\r\n"%s" written', filepath))
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

return U
