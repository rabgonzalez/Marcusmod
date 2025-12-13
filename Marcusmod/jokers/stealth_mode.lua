SMODS.Atlas({
    key = "stealth_mode",
    path = "j_stealth_mode.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "stealth_mode",
    config = { extra = { poker_hand = 'High Card' } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'stealth_mode',

    calculate = function(self, card, context)
        -- TODO: Check if all hands played this round are of the specified suit
        -- If so, give a planet card for that hand

        if context.end_of_round then 
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible then _poker_hands[#_poker_hands+1] = k end
            end
            local old_hand = card.ability.poker_hand
            card.ability.poker_hand = nil

            while not card.ability.poker_hand do
                card.ability.poker_hand = _poker_hands[math.random(1, #_poker_hands)]
                if card.ability.poker_hand == old_hand then card.ability.poker_hand = nil end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.poker_hand } }
    end
}