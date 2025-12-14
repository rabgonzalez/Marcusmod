SMODS.Atlas({
    key = "stealth_mode",
    path = "j_stealth_mode.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "stealth_mode",
    config = { extra = { poker_hand = nil } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'stealth_mode',

    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.poker_hand = nil
        end

        if context.joker_main then
            -- We save the hand name of the first hand played this round
            if G.GAME.current_round.hands_played == 0 then card.ability.poker_hand = context.scoring_name end

            -- If the current hand played is different from the saved one, we clear it
            if context.scoring_name ~= card.ability.poker_hand then card.ability.poker_hand = nil end
        end

        -- At the end of the round, if all hands played were the same type, we give a Planet card of that type
        if context.end_of_round and not context.repetition then
            if card.ability.poker_hand then
                local winning_hand = card.ability.poker_hand
                card.ability.poker_hand = nil
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = function()
                            local _planet = nil
                            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                                if v.config.hand_type == winning_hand then
                                    _planet = v.key
                                    break
                                end
                            end

                            if _planet then
                                local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, _planet,
                                'stealth')
                                new_card:add_to_deck()
                                G.consumeables:emplace(new_card)
                                G.GAME.consumeable_buffer = 0
                            end
                            return true
                        end
                    }))
                    return {
                        message = localize('k_plus_planet'),
                        colour = G.C.SECONDARY_SET.Planet
                    }
                end
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.poker_hand or 'none' } }
    end
}
