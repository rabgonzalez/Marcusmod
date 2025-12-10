SMODS.Atlas({
    key = "marcus",
    path = "sample_joker.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "marcus",
    config = { extra = { mult = 0, mult_mod = 20 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'marcus',

    calculate = function(self, card, context)
    end,

    -- Description of the variables to show in the UI
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
    end
}
