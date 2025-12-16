SMODS.Atlas({
    key = "marcus",
    path = "j_marcus.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "marcus",
    config = { extra = { mult_mod = 10 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'marcus',

    calculate = function(self, card, context)
        if context.joker_main then
            local total_mult = total_marcus_jokers(card) * card.ability.extra.mult_mod
            return {
                mult = total_mult
            }
        end
    end,

    loc_vars = function(self, info_queue, card)
        local total_mult = total_marcus_jokers(card) * card.ability.extra.mult_mod
        return { vars = { total_mult, card.ability.extra.mult_mod } }
    end
}

function total_marcus_jokers(own_card)
    local marcus_jokers_count = 0

    -- Check if there are jokers in hand (prevents collection crash)
    if G.jokers then
        for _, v in ipairs(G.jokers.cards) do
            -- For every joker in hand (except own joker), check if it's from Marcusmod
            if v ~= own_card then
                if v.config.center.mod and v.config.center.mod.id == 'Marcusmod' then marcus_jokers_count = marcus_jokers_count + 1  end
            end
        end
    end
    return marcus_jokers_count
end
