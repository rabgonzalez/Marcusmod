-- The Glitch: creates one random, fixed mapping between the real poker hands
-- and the hands used for scoring. The mapping remains unchanged for the whole blind.
local mm_glitch_hands = {
    "High Card", "Pair", "Two Pair", "Three of a Kind", "Straight",
    "Flush", "Full House", "Four of a Kind", "Straight Flush"
}

local function mm_glitch_create_mapping()
    local shuffled = {}
    for i, hand in ipairs(mm_glitch_hands) do shuffled[i] = hand end

    local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
    for i = #shuffled, 2, -1 do
        local seed = pseudoseed("mm_the_glitch_mapping_" .. tostring(ante) .. "_" .. tostring(i))
        local j = math.floor(pseudorandom(seed) * i) + 1
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end

    -- Avoid the uninteresting case where the random permutation maps every
    -- hand to itself (a cyclic shift preserves a valid one-to-one mapping).
    local identity = true
    for i, hand in ipairs(mm_glitch_hands) do
        if shuffled[i] ~= hand then identity = false break end
    end
    if identity then
        local first = table.remove(shuffled, 1)
        shuffled[#shuffled + 1] = first
    end

    G.GAME.mm_glitch_map = {}
    for i, real_hand in ipairs(mm_glitch_hands) do
        G.GAME.mm_glitch_map[real_hand] = shuffled[i]
    end
end

local function mm_glitch_show_hand(real_hand)
    local mapped_hand = real_hand and G.GAME.mm_glitch_map and G.GAME.mm_glitch_map[real_hand]
    local stats = mapped_hand and G.GAME.hands and G.GAME.hands[mapped_hand]
    if not mapped_hand or not stats or not update_hand_text then return end

    update_hand_text({ immediate = true, nopulse = true, delay = 0 }, {
        handname = localize(mapped_hand, "poker_hands"),
        chips = stats.chips,
        mult = stats.mult,
        level = stats.level
    })
end

SMODS.Blind {
    key = "the_glitch",
    discovered = true,
    vars = {},
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 1, max = 10 },
    boss_colour = HEX("6B65B5"),

    loc_vars = function(self)
        return { vars = {} }
    end,

    set_blind = function(self)
        mm_glitch_create_mapping()
        G.GAME.mm_glitch_current_real_hand = nil
    end,

    -- The actual hand name is supplied by the game during the hand check.
    -- Show its fixed equivalent in the score marker.
    debuff_hand = function(self, cards, hand, handname, check)
        if self.disabled then return false end
        G.GAME.mm_glitch_current_real_hand = handname
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0,
            func = function()
                if G.GAME and G.GAME.mm_glitch_map then
                    mm_glitch_show_hand(G.GAME.mm_glitch_current_real_hand)
                end
                return true
            end
        }))
        return false
    end,

    -- Replace the base chips/mult with the levelled values of the mapped hand.
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        if self.disabled then return mult, hand_chips, false end
        local mapped_hand = G.GAME.mm_glitch_map and G.GAME.mm_glitch_map[text]
        local stats = mapped_hand and G.GAME.hands and G.GAME.hands[mapped_hand]
        if stats and stats.chips and stats.mult then
            return stats.mult, stats.chips, true
        end
        return mult, hand_chips, false
    end,

    disable = function(self)
        G.GAME.mm_glitch_map = nil
        G.GAME.mm_glitch_current_real_hand = nil
    end,
    defeat = function(self)
        G.GAME.mm_glitch_map = nil
        G.GAME.mm_glitch_current_real_hand = nil
    end,
}
