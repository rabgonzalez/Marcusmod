SMODS.Atlas({
    key = "sus_rock",
    path = "j_sus_rock.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "sus_rock",
    config = { extra = { x_mult = 1, x_mult_gain = 0.5 } },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 1,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'sus_rock',

    calculate = function(self, card, context)
        -- If we are discarding and it's not due to blueprint
        if context.discard and context.other_card and not context.blueprint then
            -- If the discarded card is a Stone Card
            if context.other_card.ability.name == 'Stone Card' then
                -- We add the x_mult_gain to the current x_mult value
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain

                -- We show a message every time it upgrades
                return {
                    message = "Upgrade!",
                    colour = G.C.RED,
                    card = card
                }
            end
        end

        -- When we are in the joker scoring phase
        if context.joker_main then
            return {
                -- It multiplies the existing mult by the x_mult value
                x_mult = card.ability.extra.x_mult,
            }
        end
    end,

    -- Description of the variables to show in the UI
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone -- Add Stone tag to the joker info queue
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
    end
}
