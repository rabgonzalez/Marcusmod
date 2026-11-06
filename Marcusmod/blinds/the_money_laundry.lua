-- The Money Laundry: an extra-large boss blind that grants a Tarot after each hand played.
SMODS.Blind {
    key = "the_money_laundry",
    discovered = true,
    vars = {},
    pos = { x = 0, y = 0 },
    dollars = 8,
    mult = 4,
    boss = { min = 1, max = 10 },
    boss_colour = HEX("C58A45"),

    -- Steamodded expects a vars table when building the blind popup.
    loc_vars = function(self)
        return { vars = {} }
    end,

    press_play = function(self)
        if #G.consumeables.cards >= G.consumeables.config.card_limit then return end
        local tarot = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "mm_the_money_laundry")
        if tarot then
            tarot:add_to_deck()
            G.consumeables:emplace(tarot)
            tarot:juice_up(0.3, 0.2)
        end
    end,
}
