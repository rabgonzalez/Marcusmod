SMODS.Atlas({
    key = "sus_rock",
    path = "j_sus_rock.png",
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "sus_rock",
    config = { extra = 0.25, Xmult = 1, max_Xmult = 5 },
    pos = { x = 0, y = 0 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'sus_rock',

    calculate = function(self, card, context)
        if card.ability.Xmult >= card.ability.max_Xmult then return end

        if context.discard and context.other_card then
            -- If the discarded card is a Stone Card
            if context.other_card.ability.name == 'Stone Card' then
                -- We add the extra to the current Xmult value
                card.ability.Xmult = card.ability.Xmult + card.ability.extra

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
                -- It multiplies the existing mult by the Xmult value
                Xmult = card.ability.Xmult,
            }
        end
    end,

    -- Local variables
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone -- Add Stone tag to the joker info queue
        return { vars = { card.ability.Xmult, card.ability.extra, card.ability.max_Xmult } }
    end
}
