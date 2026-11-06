-- Michigan: while this Tarot remains in the consumable inventory,
-- its sell value increases by $1 at the end of every completed round.
SMODS.Consumable {
    key = 'michigan',
    set = 'Tarot',
    atlas = 'Tarot',
    prefix_config = { atlas = false }, -- Use Balatro's vanilla Tarot atlas (do not prefix it with mm_)
    pos = { x = 0, y = 2 }, -- Placeholder art: Temperance
    cost = 3,
    unlocked = true,
    discovered = true,

    calculate = function(self, card, context)
        if context.end_of_round
            and context.main_eval
            and context.cardarea == G.consumeables
            and not context.game_over then
            card.ability.extra_value = (card.ability.extra_value or 0) + 1

            -- Recalculate the cached sell_cost so the updated value is visible
            -- immediately and is correct when the Tarot is sold.
            if card.set_cost then card:set_cost() end
            card:juice_up(0.3, 0.2)

            return {
                message = localize('k_mm_sell_value_up'),
                colour = G.C.MONEY,
                card = card
            }
        end
    end
}
