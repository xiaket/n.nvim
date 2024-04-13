local C = {}

C.defaults = {
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

return C
