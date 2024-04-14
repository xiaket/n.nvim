local A = vim.api
local S = require("sqlite")

local Note = {}

function Note:new(opts)
  local db = S({
    uri = opts.dbpath,
    notes = {
      id = true,
      content = { "text", required = true },
      path = { "text", required = true },
      created_at = { "int", default = os.time() },
      updated_at = { "int" },
    },
  })
  return setmetatable({
    content = nil,
    id = nil,
    path = opts.path,
    updated_at = nil,
    db = db,
  }, { __index = self })
end

function Note:save(buf)
  local content_as_table = A.nvim_buf_get_lines(buf, 0, A.nvim_buf_line_count(buf), false)
  local content = table.concat(content_as_table, "\n")
  self.db.notes:update({
    where = { id = self.id, path = self.path },
    set = {
      content = content,
      updated_at = os.time(),
    },
  })
end

function Note:load()
  local loaded = self.db.notes:get({ where = { path = self.path } })
  if loaded[1] ~= nil then
    self.id = loaded[1].id
    return splitByNewline(loaded[1].content)
  end

  -- entry does not exist, create it.
  self.id = self.db.notes:insert({
    path = self.path,
    content = "",
  })
  return {}
end

-- split the content into lines, handles empty lines
local function splitByNewline(str)
  local t = {}
  -- Match all lines including empty ones
  for line in (str .. "\n"):gmatch("(.-)\n") do
    table.insert(t, line)
  end
  return t
end

return Note
