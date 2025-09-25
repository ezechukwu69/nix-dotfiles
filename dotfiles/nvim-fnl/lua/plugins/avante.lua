vim.pack.add({
	"https://github.com/yetone/avante.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
})

require("avante").setup({
	provider = "gemini-cli",
	acp_providers = {
		["gemini-cli"] = {
			command = "gemini",
			args = { "--experimental-acp" },
			env = {
				NODE_NO_WARNINGS = "1",
				GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
			},
		},
		["claude-code"] = {
			command = "npx",
			args = { "acp-claude-code" },
			env = {
				NODE_NO_WARNINGS = "1",
				-- ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
			},
		},
	},
	selector = {
		provider = "snacks",
	},
})
