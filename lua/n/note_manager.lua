local A = vim.api
local N = require("n.note")

local NoteManager = {}

local defaults = {
  db = "~/notes.db",
  -- ref: https://neovim.io/doc/user/api.html#api-win_config
  border = "rounded",
  ft = "markdown",
  hl = "Normal",
  dimensions = {
    height = 0.8,
    width = 0.8,
    x = 0.5,
    y = 0.5,
  },
}

function NoteManager:New()
  return setmetatable({
    win = nil,
    buf = nil,
    note = nil,
    config = defaults,
  }, { __index = self })
end

function NoteManager:Setup(cfg)
  self.config = vim.tbl_deep_extend("force", self.config, cfg)
end

-- Toggle the notes window
function NoteManager:Toggle()
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    -- save current buf
    self.note:save(self.buf)
    -- If window is stored and valid then it is already opened, close it.
    A.nvim_win_close(self.win, {})
    self.win = nil
  else
    -- Get or create a buffer and open a window.
    buf = self:get_or_create_buf()
    self.win = A.nvim_open_win(buf, true, self:buf_cfg())

    A.nvim_win_set_option(self.win, "winhl", ("Normal:%s"):format(self.config.hl))
  end
end

-- DbInit initializes the database if needed
function NoteManager:DbInit()
  if self.note == nil then
    self.note = N:new({
      dbpath = self.config.db,
      path = vim.loop.cwd(),
    })
    self.note:load()
  end
end

-- NoteManager:buf_cfg returns the window configuration
function NoteManager:buf_cfg()
  local opts = self.config.dimensions
  -- get lines and columns
  local cl = vim.o.columns
  local ln = vim.o.lines

  -- calculate our floating window size
  local width = math.ceil(cl * opts.width)
  local height = math.ceil(ln * opts.height - 4)

  -- and its starting position
  local col = math.ceil((cl - width) * opts.x)
  local row = math.ceil((ln - height) * opts.y - 1)

  return {
    border = self.config.border,
    relative = "editor",
    style = "minimal",
    width = width,
    height = height,
    col = col,
    row = row,
  }
end

-- NoteManager:get_or_create_buf gets or creates a new buffer
function NoteManager:get_or_create_buf()
  if self.buf == nil then
    -- do not show up in buffer list
    -- this is not a scratch buffer
    self.buf = A.nvim_create_buf(false, true)
    -- Load content from db
    A.nvim_buf_set_text(self.buf, 0, 0, 0, 0, self.note:load())

    -- setup filetype for syntax highlighting
    A.nvim_buf_set_option(self.buf, "filetype", self.config.ft)
  end

  return self.buf
end

-- Toggle the notes window, everytime we
function NoteManager:Search()
  print("search not implemented")
end

-- Toggle the notes window, everytime we
function NoteManager:Manage()
  print("manage not implemented")
end

return NoteManager