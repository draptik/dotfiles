---@diagnostic disable: undefined-global
-- Packages that update frequently enough that the "recently modified"
-- check would otherwise block them indefinitely. These are always
-- allowed through regardless of last_modified.
--
-- The list is stored in a plain text file inside the yay cache directory
-- (same location style as the maintainer cache), one package name per
-- line. Blank lines and lines starting with '#' are ignored, so you can
-- comment the file.
--
-- File location: <cache_dir>/recently_modified_allowlist

local cache_dir = (os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")) .. "/yay"
local allowlist_file = cache_dir .. "/recently_modified_allowlist"

local function load_allowlist()
	local allow = {}
	local f = io.open(allowlist_file, "r")
	if not f then
		return allow
	end
	for line in f:lines() do
		local name = line:match("^%s*([^#%s][^%s]*)%s*$")
		if name then
			allow[name] = true
		end
	end
	f:close()
	return allow
end

yay.create_autocmd("UpgradeSelect", {
	desc = "skip recently modified AUR upgrades",
	callback = function(event)
		yay.log.info("pre-excluding AUR packages modified in the last 3 days")
		local always_allow = load_allowlist()
		local exclude = {}
		local recent_cutoff = os.time() - (3 * 24 * 60 * 60)
		for _, pkg in ipairs(event.data.upgrades) do
			if pkg.repository == "aur" and pkg.last_modified >= recent_cutoff and not always_allow[pkg.name] then
				yay.log.warn("pre-excluding recently modified AUR package: ", pkg.name)
				table.insert(exclude, pkg.name)
			end
		end
		return { exclude = exclude, skip_menu = false }
	end,
})
