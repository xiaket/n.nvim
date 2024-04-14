local A = vim.api
local Note = {}

-- split the content into lines, handles empty lines
local function split_by_newline(str)
  local t = {}
  -- Match all lines including empty ones
  for line in (str .. "\n"):gmatch("(.-)\n") do
    table.insert(t, line)
  end
  return t
end

function Note:new(opts)
  return setmetatable({
    -- content should be a string.
    content = nil,
    id = nil,
    path = opts.path,
    updated_at = nil,
    db = opts.db,
  }, { __index = self })
end

function Note:save(buf)
  local content_as_table = A.nvim_buf_get_lines(buf, 0, A.nvim_buf_line_count(buf), false)
  self.content = table.concat(content_as_table, "\n")
  self.db:save_note(self)
end

function Note:load()
  local note = self.db:load_note(self.path)
  self.id = note.id
  self.content = note.content
  return split_by_newline(self.content)
end

return Note
