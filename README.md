# draft.nvim

**draw** is a plugin for Neovim to improve the experience of writing prose.

> [!WARNING]  
> Project is still in early stage of development.

<img width="1192" height="930" alt="Image" src="https://github.com/user-attachments/assets/8b29467b-bea8-4b2e-b2e3-ae0dd95f4c5a" />

## Idea

The plugin is designed to help writers by visual text formatting (indents, highlightx) and use characters (dashes and quotation marks) to create the most complete story draft possible. The text should have no additional formatting, with the rule:  **one line representing a single paragraph**.
~~Text should be fully portabled to other filetypes.~~

> [!NOTE]  
> The upcoming plan is to create a *converter* that removes all comments and other metadata from files to produce a clean .txt version for portability purposes.

## Features

- indents for better reading experince
- syntax for dialogues and quotes and in-file comments to distinguish it from actulal story
- auto repleacment for dashes and quotation marks
- fast/not distracting jumping through mulitple project files
- section and groups for createing a story context


## Requirements

- Neovim >= 0.10.0
- [tree-sitter-draft](https://github.com/anti-precog/tree-sitter-draft) parser for suport syntax and typography

## Installation

Install the plugin with lazy package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

Minimal setup:

```lua
{
    "anti-precog/draft.nvim",
    opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    },
}
```

For proper lazy loading, it’s best to add the creation of the new file type in your neovim configuration:

Proposed (out of box) setup:
<details>
<summary>Installation snippet.</summary>

```lua
{
    "anti-precog/draft.nvim",
    ft = "draft",
    init = function()
        -- add filetype before lazy load
        vim.filetype.add({
            extension = {
                draft = "draft",
            },
        })
    end,
    opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    },
}
```
</details>

## Configuration

Defualt options:

```lua
{
	-- select how to recognize dialogues as em-dash or en-dash
	dash_symbol = "em-dash",

	-- Configuration for core module
	core = {
		repleace_dash = "--",
		repleace_ellipsis = "...",
		smart_quotes = true,
		move_by_visual_lines = true,
		auto_turn_page = true,
	},

	-- Configuration for typography module
	typography = {
		indent_size = 4,
		center_header = false,
		center_asterix = true,

    	-- tree-sitter integration:
		skip_meta_lines = true,
		group_frames = true,
		info_bar = false,
	},

}
```

## Suggestions for other plugins

- [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) - to focus only on writing
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - for better comment expose
- [catppucin](https://github.com/catppuccin/nvim) - syntax proposition 

### Sidebar extension
- [outline.nvim](https://github.com/hedyhli/outline.nvim) a sidebar with a tree-like outline of symbols from your story structure
    It can be integrated with external provider: [outline-draft-provider](https://github.com/anti-precog/outline-draft-provider.nvim)

