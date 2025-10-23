local ok_src, copilot_cmp = pcall(require, "copilot_cmp")
if not ok_src then return end
copilot_cmp.setup()

local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then return end

local cfg = cmp.get_config()
table.insert(cfg.sources, 1, { name = "copilot" })
cmp.setup(cfg)
