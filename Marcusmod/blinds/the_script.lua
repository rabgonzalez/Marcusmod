-- The Script: require a weighted random poker hand. The requirement changes
-- after every completed play, never selecting the same hand twice in a row.
local mm_script_hands = {
    { hand = 'High Card', weight = 10 },
    { hand = 'Pair', weight = 10 },
    { hand = 'Two Pair', weight = 8 },
    { hand = 'Three of a Kind', weight = 7 },
    { hand = 'Straight', weight = 5 },
    { hand = 'Flush', weight = 5 },
    { hand = 'Full House', weight = 4 },
    { hand = 'Four of a Kind', weight = 3 },
    { hand = 'Straight Flush', weight = 1 }
}

local function mm_script_pick_hand(previous)
    local choices = {}
    for _, entry in ipairs(mm_script_hands) do
        if entry.hand ~= previous then
            for _ = 1, entry.weight do
                choices[#choices + 1] = entry.hand
            end
        end
    end
    if #choices == 0 then return 'High Card' end

    G.GAME.mm_script_turn = (G.GAME.mm_script_turn or 0) + 1
    local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
    local seed = pseudoseed('mm_the_script_' .. tostring(ante) .. '_' .. tostring(G.GAME.mm_script_turn))
    return pseudorandom_element(choices, seed)
end

local function mm_script_show_hand()
    local hand = G.GAME and G.GAME.mm_script_required_hand
    if hand and attention_text then
        attention_text({
            text = localize('k_mm_play_hand') .. ' ' .. localize(hand, 'poker_hands'),
            scale = 0.9, hold = 1.5, align = 'cm', major = G.play,
            colour = G.C.RED
        })
    end
end

local function mm_script_advance_requirement()
    local previous = G.GAME.mm_script_required_hand
    G.GAME.mm_script_required_hand = mm_script_pick_hand(previous)
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.1,
        func = function()
            mm_script_show_hand()
            return true
        end
    }))
end

SMODS.Blind {
    key = 'the_script',
    discovered = true,
    vars = {},
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 1, max = 10 },
    boss_colour = HEX('A65D9A'),

    set_blind = function(self)
        G.GAME.mm_script_turn = 0
        G.GAME.mm_script_hands_played_at_press = nil
        G.GAME.mm_script_advanced_for_play = false
        G.GAME.mm_script_required_hand = mm_script_pick_hand(nil)
        mm_script_show_hand()
    end,

    -- Snapshot the round counter when a play starts. This is independent of
    -- debuff_hand's preview/real-check calls and cannot advance on previews.
    press_play = function(self)
        if self.disabled then return end
        G.GAME.mm_script_hands_played_at_press = G.GAME.current_round.hands_played or 0
        G.GAME.mm_script_advanced_for_play = false
    end,

    -- Balatro calls drawn_to_hand after the played hand resolves and the new
    -- hand is dealt. hands_played has then increased, so advance exactly once.
    drawn_to_hand = function(self)
        if self.disabled then return end
        local before = G.GAME.mm_script_hands_played_at_press
        local now = G.GAME.current_round.hands_played or 0
        if before ~= nil and now > before and not G.GAME.mm_script_advanced_for_play then
            G.GAME.mm_script_advanced_for_play = true
            G.GAME.mm_script_hands_played_at_press = nil
            mm_script_advance_requirement()
        end
    end,

    debuff_hand = function(self, cards, hand, handname, check)
        if self.disabled then return false end
        return handname ~= G.GAME.mm_script_required_hand
    end,

    get_loc_debuff_text = function(self)
        local hand = G.GAME.mm_script_required_hand or 'High Card'
        return localize('k_mm_wrong_hand') .. ' ' .. localize(hand, 'poker_hands')
    end,

    loc_vars = function(self)
        return { vars = {} }
    end,

    disable = function(self)
        G.GAME.mm_script_required_hand = nil
        G.GAME.mm_script_turn = nil
        G.GAME.mm_script_hands_played_at_press = nil
        G.GAME.mm_script_advanced_for_play = nil
    end,
    defeat = function(self)
        G.GAME.mm_script_required_hand = nil
        G.GAME.mm_script_turn = nil
        G.GAME.mm_script_hands_played_at_press = nil
        G.GAME.mm_script_advanced_for_play = nil
    end,
}
