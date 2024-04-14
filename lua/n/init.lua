local NoteManager = require("n.note_manager")
local api = vim.api

local M = {}

local nm = NoteManager:New()

function M.setup(cfg)
  nm:Setup(cfg)
end

---Toggles the default terminal
function M.toggle()
  nm:DbInit()
  nm:Toggle()
end

function M.search()
  nm:DbInit()
  nm:Search()
end

function M.manage()
  nm:DbInit()
  nm:Manage()
end

return M
