local Note = require("n.note")
local api = vim.api

local M = {}

local t = Note:New()

function M.setup(cfg)
  t:Setup(cfg)
end

---Toggles the default terminal
function M.toggle()
  t:Toggle()
end

function M.search()
  t:Search()
end

function M.manage()
  t:Manage()
end

return M
