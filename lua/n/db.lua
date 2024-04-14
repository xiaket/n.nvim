local S = require("sqlite")

local DB = {}

-- Initialise a db.
function DB:init(dbpath)
  local sqlite_conn = S({
    uri = dbpath,
    notes = {
      id = true,
      content = { "text", required = true },
      path = { "text", required = true },
      created_at = { "int", default = os.time() },
      updated_at = { "int" },
    },
  })
  return setmetatable({
    notes = sqlite_conn.notes,
  }, { __index = self })
end

-- Save note
function DB:save_note(note)
  self.notes:update({
    where = { id = note.id, path = note.path },
    set = {
      content = note.content,
      updated_at = os.time(),
    },
  })
end

-- Load a note by its path
function DB:load_note(path)
  local loaded = self.notes:get({ where = { path = path } })
  if loaded[1] ~= nil then
    return {
      id = loaded[1].id,
      content = loaded[1].content,
    }
  end

  -- entry does not exist, create it.
  local id = self.notes:insert({
    path = path,
    content = "",
  })
  return {
    id = id,
    content = "",
  }
end

return DB
