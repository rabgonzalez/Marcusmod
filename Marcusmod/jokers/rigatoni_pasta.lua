SMODS.Atlas({
    key = "rigatoni_pasta",
    path = "j_rigatoni_pasta.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "rigatoni_pasta",
    config = { extra = { odds = 6 } },
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'rigatoni_pasta',

    calculate = function(self, card, context)
        if not context.setting_blind then return  end
        if #G.jokers.cards >= G.jokers.config.card_limit then
            return {
                message = "No space",
                colour = G.C.PURPLE,
                card = card,
            }
        end

        if (math.random() * card.ability.extra.odds) < G.GAME.probabilities.normal then
            -- We create and add to deck a Ramen Joker
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_joker("j_ramen", nil, nil, nil)
                    return true
                end,
            }))
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.odds, G.GAME.probabilities.normal } }
    end
}
