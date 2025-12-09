Marcusmod = {}

-- Load global functions and variables
assert(SMODS.load_file("globals.lua"))()

-- Dinamic loaded Jokers
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")
for _, file in ipairs(joker_src) do
    assert(SMODS.load_file("jokers/" .. file))()
end
