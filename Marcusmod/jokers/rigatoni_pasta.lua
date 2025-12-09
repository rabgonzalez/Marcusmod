SMODS.Atlas({
    key = "rigatoni_pasta",
    path = "j_awebo_bird.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "rigatoni_pasta",
    config = { extra = { odds = 2 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'rigatoni_pasta',

    calculate = function(self, card, context)
        if not context.setting_blind or context.blueprint then
            return
        end

        if #G.jokers.cards >= G.jokers.config.card_limit then
            return {
                message = "No space",
                colour = G.C.PURPLE,
                card = card,
            }
        end

        local odds = tonumber(card.ability.extra.odds)

        if (math.random() * 3) < odds then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    -- TODO: Hay que buscar la forma de crear un huevo, y no un joker aleatorio
                    local new_card = create_card("Joker", G.jokers, nil, 0.99, nil, nil, nil, "Ramen") -- (type, parent, suit, r, rank, debuff, edition, name)
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)
                    new_card:start_materialize()
                    return true
                end,
            }))
        end
    end,

    -- Description of the variables to show in the UI
    loc_vars = function(self, info_queue, card)
        -- TODO: Si uso self en lugar de card, podré cambiar los valores de todos los awebo?
        return { vars = { card.ability.extra.chance_numerator, card.ability.extra.chance_denominator } } 
    end
}
