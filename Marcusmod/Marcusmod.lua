if SMODS.Atlas then
    SMODS.Atlas({
        key = "modicon",
        path = "modicon.png",
        px = 32,
        py = 32
    })
end

-- Dinamic loaded Jokers
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")
for _, file in ipairs(joker_src) do
    assert(SMODS.load_file("jokers/" .. file))()
end

local blind_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "blinds")
for _, file in ipairs(blind_src) do
    assert(SMODS.load_file("blinds/" .. file))()
end
