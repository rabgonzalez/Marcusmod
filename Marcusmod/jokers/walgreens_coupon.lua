SMODS.Atlas({
    key = "walgreens_coupon",
    path = "j_walgreens_coupon.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "walgreens_coupon",
    config = { extra = { interest = 5, every = 5, remaining = 5 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'walgreens_coupon',

    calculate = function(self, card, context)
        if context.skip_blind then
            if card.ability.extra.remaining <= 0 then
                card.ability.extra.remaining = card.ability.extra.every
            end
            card.ability.extra.remaining = card.ability.extra.remaining - 1
        end

        if context.end_of_round then 
            if card.ability.extra.remaining <= 0 then
                card.ability.extra.remaining = card.ability.extra.every
                G.GAME.interest_amount = G.GAME.interest_amount + card.ability.extra.interest

                return {
                    message = "+" .. card.ability.extra.interest .. "$",
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.interest, card.ability.extra.every, card.ability.extra.remaining } }
    end
}
