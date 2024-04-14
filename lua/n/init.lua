local NoteManager = require("n.note_manager")
local api = vim.api

local M = {}

local nm = NoteManager:New()

-- setup will take a config table as argument and config the NoteManager instance accordingly.
function M.setup(cfg)
  nm:Setup(cfg)
end

-- Toggles the note window on and off
function M.toggle()
  nm:Toggle()
end

-- Search note by path/content
function M.search()
  nm:Search()
end

-- Manage notes
function M.manage()
  nm:Manage()
end

return M
