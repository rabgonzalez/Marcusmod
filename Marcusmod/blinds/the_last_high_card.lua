-- The Last High Card: when the played poker hand is High Card, give the
-- final selected card a random enhancement before the hand is scored.
local function mm_last_high_card_enhance(card)
    if not card or card.removed or not G.GAME then return end

    G.GAME.mm_last_high_card_roll = (G.GAME.mm_last_high_card_roll or 0) + 1
    local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
    local seed = 'mm_last_high_card_' .. tostring(ante) .. '_' .. tostring(G.GAME.mm_last_high_card_roll)
    local enhancements = {
        'm_bonus', 'm_mult', 'm_wild', 'm_glass',
        'm_steel', 'm_stone', 'm_gold', 'm_lucky'
    }
    local available = {}
    for _, key in ipairs(enhancements) do
        if G.P_CENTERS and G.P_CENTERS[key] then
            available[#available + 1] = key
        end
    end

    if #available == 0 then return end
    local key = pseudorandom_element(available, pseudoseed(seed))
    card:set_ability(G.P_CENTERS[key], nil, true)
    card_eval_status_text(card, 'extra', nil, nil, nil, {
        message = localize('k_mm_blessed'), colour = G.C.GREEN
    })
end

SMODS.Blind {
    key = 'the_last_high_card',
    discovered = true,
    vars = {},
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 1, max = 10 },
    boss_colour = HEX('7A9B68'),

    loc_vars = function(self)
        return { vars = {} }
    end,

    set_blind = function(self)
        G.GAME.mm_last_high_card_roll = 0
        G.GAME.mm_last_high_card_last_selected = nil
        G.GAME.mm_last_high_card_applied = false
    end,

    -- Remember the last selected card, but do not enhance it yet: the actual
    -- poker hand name is only definitive in debuff_hand(check == false).
    press_play = function(self)
        local selected = G.hand and G.hand.highlighted
        G.GAME.mm_last_high_card_last_selected = selected and selected[#selected] or nil
        G.GAME.mm_last_high_card_applied = false
    end,

    -- This runs for the real submitted hand before scoring. The preview call
    -- has check=true and must not trigger the effect.
    debuff_hand = function(self, cards, hand, handname, check)
        if not check
            and handname == 'High Card'
            and not G.GAME.mm_last_high_card_applied then
            G.GAME.mm_last_high_card_applied = true
            mm_last_high_card_enhance(G.GAME.mm_last_high_card_last_selected)
        end
        return false
    end,

    disable = function(self)
        G.GAME.mm_last_high_card_roll = nil
        G.GAME.mm_last_high_card_last_selected = nil
        G.GAME.mm_last_high_card_applied = nil
    end,
    defeat = function(self)
        G.GAME.mm_last_high_card_roll = nil
        G.GAME.mm_last_high_card_last_selected = nil
        G.GAME.mm_last_high_card_applied = nil
    end,
}
