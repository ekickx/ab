Inspired by [install-node](https://github.com/vercel/install-node), this is an one-liner bash script to install various neovim plugin manager.

### Usage

#### Create an alias

```bash
alias install-nvim-pm="curl -sfLS https://install-nvim-pm.vercel.app | bash -s --"
```

Or

#### Place it in your $PATH

```bash
curl -sfLo ~/.local/bin/install-nvim-pm https://install-nvim-pm.vercel.app
chmod +x ~/.local/bin/install-nvim-pm
```

### Reason

Have you ever want to try another neovim plugin manager but it's a hassle to create new bootstrap for that plugin?

That's also want I experienced. Now I can just use this script for bootstrapping plugin manager, like this

```lua
vim.fn.system { "install-nvim-pm", "-y", "-f", "dep" }
```
