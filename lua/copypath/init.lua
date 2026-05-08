local M = {}

local defaults = {
  mappings = {
    absolute = "<leader>yp",
    relative = "<leader>yr",
    name = "<leader>yn",
  },
}

local registered_lhs = {}

local function buf_path()
  local p = vim.api.nvim_buf_get_name(0)
  if p == "" then
    return nil
  end
  return p
end

local function clipboard_available()
  return vim.fn.has("clipboard") == 1
end

local function copy_text(text, what)
  if not clipboard_available() then
    vim.notify("copypath: clipboard (+/* register) not available", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", text)
  vim.fn.setreg("*", text)
  vim.notify(string.format("copypath: copied %s", what), vim.log.levels.INFO)
end

function M.copy_absolute()
  local path = buf_path()
  if not path then
    vim.notify("copypath: buffer has no file path", vim.log.levels.WARN)
    return
  end
  copy_text(vim.fn.fnamemodify(path, ":p"), "absolute path")
end

function M.copy_relative()
  local path = buf_path()
  if not path then
    vim.notify("copypath: buffer has no file path", vim.log.levels.WARN)
    return
  end
  copy_text(vim.fn.fnamemodify(path, ":."), "relative path")
end

function M.copy_name()
  local path = buf_path()
  if not path then
    vim.notify("copypath: buffer has no file path", vim.log.levels.WARN)
    return
  end
  copy_text(vim.fn.fnamemodify(path, ":t"), "file name")
end

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

  for _, lhs in ipairs(registered_lhs) do
    pcall(vim.keymap.del, "n", lhs)
  end
  registered_lhs = {}

  local function map(lhs, fn, desc)
    if lhs and lhs ~= "" then
      vim.keymap.set("n", lhs, fn, { desc = desc })
      registered_lhs[#registered_lhs + 1] = lhs
    end
  end

  map(opts.mappings.absolute, M.copy_absolute, "Copy absolute file path")
  map(opts.mappings.relative, M.copy_relative, "Copy relative file path")
  map(opts.mappings.name, M.copy_name, "Copy file name")
end

return M
