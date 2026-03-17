# draft.nvim

**nvim-draw** is a lua plugin for Neovim to improve the experience of writing prose.

> [!WARNING]  
> Project is still in early stage of development.

## Features
- file extension "draft" 
- **highlight** for dialogs, quotes, headers and comments
- autorepleace for dash '–'  and em-dash '—'
- fast jumping between files (chapters/scenes/parts)

## Installation

Install the plugin with lazy package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
	"anti-precog/draft.nvim",
    opts = {},
    ft = "draft"
}
```

## Configuration

```lua
{
	-- all loaded features works only fot that filetypes
	filetypes = { "draft" },

	-- [[ CORE module options ]]
	-- improved moved on features
	-- true - navigating [j/k] through the file ignore line wraping
	-- false - disable that feature
	move_by_visual_lines = true,

	-- emdahs(—) and dash(–) can be auto replace by selected phraze
	-- it can be symbol one even characters string
	-- nil - disable that repleacment
	auto_repleace_symbols = {
		emdash = "--", -- used to mark dialogues
		dash = "=", -- used as dash (not hyphen)
	},

	-- [[ NAVIGATOR module options ]]
	-- load page navigator feature
	navigator = true,

	-- [[ DECORATOR module options ]]
	-- set indent size for all paragraph
	indent = 4, -- set to 0 to disable

	-- use accessible highlight-groups to syntax specific section
	-- nil - disable syntax
	syntax = {
		dialogue = "Statement",
		quote = "Statement",
		comment = "NonText",
		header = "Statement",
	},

	-- center selected sections
	-- nil - leave default indent
	center = {
		header = true,
		asterix = true,
	},
}
```

## Requirements

For proper lazy loading, it’s best to add the creation of the draft file type in your neovim configuration:

```lua
vim.filetype.add({
	extension = {
		draft = "draft",
	},
})
```

## Navigation

You can fast jumps between your chapters, scenes or pages if the files have number in it.

### Commands
 - SelectPage - jump to file by number
 - NextPage/PrefPage - open existed or create new file with according number

