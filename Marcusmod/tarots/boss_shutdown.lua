-- Power Down: suppresses the active Boss Blind for the next played hand only.
SMODS.Consumable {
    key = 'boss_shutdown',
    set = 'Tarot',
    atlas = 'Tarot',
    prefix_config = { atlas = false },
    pos = { x = 2, y = 2 },
    cost = 3,
    unlocked = true,
    discovered = true,

    can_use = function(self, card)
        return G and G.GAME and G.GAME.blind
            and G.GAME.blind.boss
            and not G.GAME.blind.disabled
            and not G.GAME.mm_power_down_pending
    end,

    use = function(self, card, area, copier)
        if not (G and G.GAME and G.GAME.blind and G.GAME.blind.boss)
            or G.GAME.blind.disabled then return end

        G.GAME.mm_power_down_pending = true
        G.GAME.mm_power_down_active = true

        -- Bell's forced-selection rule is stored on individual playing cards,
        -- so hide it for this hand and restore it when context.after fires.
        G.GAME.mm_power_down_forced_cards = {}
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if playing_card.ability and playing_card.ability.forced_selection then
                G.GAME.mm_power_down_forced_cards[#G.GAME.mm_power_down_forced_cards + 1] = {
                    card = playing_card,
                    value = playing_card.ability.forced_selection
                }
                playing_card.ability.forced_selection = nil
            end
        end

        -- Recalculate immediately while the Blind callbacks are bypassed.
        -- This clears existing Boss debuffs from both playing cards and Jokers
        -- without changing debuffs owned by other effects.
        if SMODS and SMODS.recalc_debuff then
            for _, target in ipairs(G.playing_cards or {}) do
                SMODS.recalc_debuff(target)
            end
            for _, target in ipairs((G.jokers and G.jokers.cards) or {}) do
                SMODS.recalc_debuff(target)
            end
        end
    end
}
