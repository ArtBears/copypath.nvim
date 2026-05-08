# copypath.nvim

Neovim plugin: copy the current buffer’s **absolute path**, **path relative to `:pwd`**, or **file name** to the system clipboard (`+` / `*`).

Defaults use **`<leader>` plus two keys** so chords stay short and work well with [LazyVim](https://www.lazyvim.org/) / [lazy.nvim](https://github.com/folke/lazy.nvim).

## Requirements

- Neovim **0.9+** (uses `vim.deepcopy`, `vim.tbl_deep_extend`)
- A working clipboard provider (`:echo has('clipboard')` → `1`)

## Installation (lazy.nvim)

Add a spec under `lua/plugins/` in your config (LazyVim picks up every file in that folder).

**From Git:**

```lua
return {
  {
    "ArtBears/copypath.nvim",
    event = "VeryLazy",
    config = function()
      require("copypath").setup()
    end,
  },
}
```

**Local checkout** (good while developing):

```lua
return {
  {
    dir = vim.fn.expand("~/Projects/oss/copypath"),
    event = "VeryLazy",
    config = function()
      require("copypath").setup()
    end,
  },
}
```

## Usage

| Mapping       | Action                                          |
| ------------- | ----------------------------------------------- |
| `<leader>yp`  | Copy absolute path                              |
| `<leader>yr`  | Copy path relative to current working directory |
| `<leader>yn`  | Copy file name (tail)                           |

Maps are **normal mode** only. Unnamed buffers show a warning and do nothing.

Why `<leader>y…` and not `<leader>c…`? In LazyVim, `<leader>c` is usually the **code** group, so `cp` / `cr` / `cn` often clash. You can change every LHS in `setup()` (below).

## Configuration

```lua
require("copypath").setup({
  mappings = {
    absolute = "<leader>yp",
    relative = "<leader>yr",
    name = "<leader>yn",
  },
})
```

Set any value to `""` to skip registering that map.

## API

You can call these from your own mappings or commands:

- `require("copypath").copy_absolute()`
- `require("copypath").copy_relative()`
- `require("copypath").copy_name()`

Calling `setup()` again removes previously registered default mappings and applies the new options.

## License

[MIT](LICENSE)
