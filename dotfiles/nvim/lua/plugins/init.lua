-- Plugin management with Packer (official bootstrap pattern)
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- LSP and related plugins (including autocompletion)
  require('plugins.lsp').plugins(use)
  require('plugins.treesitter')(use)
  require('plugins.ui')(use)
  require('plugins.git')(use)
  require('plugins.editor')(use)

  if packer_bootstrap then
    require('packer').sync()
  end
end)
