SMODS.Atlas({
    key = "1per_low_fat_milk",
    path = "j_1per_low_fat_milk.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "1per_low_fat_milk",
    config = { extra = { chips = 10000 } },
    pos = { x = 0, y = 0 },
    rarity = 4,
    cost = nil,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    discovered = true,
    atlas = '1per_low_fat_milk',

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end
}
