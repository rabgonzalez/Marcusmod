SMODS.Atlas({
    key = "walgreens_coupon",
    path = "j_walgreens_coupon.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "walgreens_coupon",
    config = { extra = { discount = 10, every = 2, remaining = 2 } },
    pos = { x = 0, y = 0 },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'walgreens_coupon',

    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            -- If remaining is 0 or less, reset to base value
            if card.ability.extra.remaining <= 0 then
                card.ability.extra.remaining = card.ability.extra.every
            end
            -- Each skipped blind reduces remaining by 1
            card.ability.extra.remaining = card.ability.extra.remaining - 1
            return {
                    message = "SKIPPED",
                    colour = G.C.PURPLE,
                    card = card
                }
        end

        if context.end_of_round and not context.blueprint then 
            if card.ability.extra.remaining <= 0 then
                card.ability.extra.remaining = card.ability.extra.every

                -- We apply the discount
                G.GAME.discount_percent = G.GAME.discount_percent + card.ability.extra.discount

                return {
                    message = "-" .. card.ability.extra.discount .. "%",
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.discount, card.ability.extra.every, card.ability.extra.remaining } }
    end
}
