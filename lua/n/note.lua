local A = vim.api
local C = require("n.config")

local Note = {}

function Note:New()
  return setmetatable({
    win = nil,
    buf = nil,
    config = C.defaults,
  }, { __index = self })
end

function Note:Setup(cfg)
  self.config = vim.tbl_deep_extend("force", self.config, cfg)
end

-- Toggle the notes window
function Note:Toggle()
  if self.win and vim.api.nvim_win_is_valid(self.win) then
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

-- Note:buf_cfg returns the window configuration
function Note:buf_cfg()
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

-- Note:get_or_create_buf gets or creates a new buffer
function Note:get_or_create_buf()
  if self.buf == nil then
    -- do not show up in buffer list
    -- this is not a scratch buffer
    self.buf = A.nvim_create_buf(false, false)
    -- setup filetype for syntax highlighting
    A.nvim_buf_set_option(self.buf, "filetype", self.config.ft)
  end

  return self.buf
end

-- Toggle the notes window, everytime we
function Note:Search()
  print("search not implemented")
end

-- Toggle the notes window, everytime we
function Note:Manage()
  print("manage not implemented")
end

return Note
