SMODS.Atlas({
    key = "3per_low_fat_milk",
    path = "j_3per_low_fat_milk.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "3per_low_fat_milk",
    config = { extra = { odds = 100 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 3,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = '3per_low_fat_milk',

    calculate = function(self, card, context)
        if context.joker_main then
            if (math.random() * card.ability.extra.odds) < G.GAME.probabilities.normal then
                G.jokers:remove_card(card)
                card:remove()

                G.E_MANAGER:add_event(Event({
                    trigger = "before",
                    func = function()
                        add_joker("j_mm_1per_low_fat_milk", nil, nil, nil)
                        return true
                    end,
                }))

                return {
                    message = "Upgraded!",
                    colour = G.C.PURPLE,
                    card = card
                }
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.odds, G.GAME.probabilities.normal } }
    end
}
