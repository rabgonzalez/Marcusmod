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
        local blind = G and G.GAME and G.GAME.blind
        if not blind or not blind.boss or blind.disabled
            or G.GAME.mm_power_down_pending then return end

        -- Temporarily suppress the same disabled flag checked by the base game,
        -- but do not call blind:disable(): that invokes permanent boss cleanup
        -- callbacks and destroys state owned by custom bosses.
        G.GAME.mm_power_down_pending = true
        G.GAME.mm_power_down_blind = blind
        blind.disabled = true

        -- Remove currently applied playing-card and Joker debuffs immediately.
        if SMODS and SMODS.recalc_debuff then
            for _, target in ipairs(G.playing_cards or {}) do
                SMODS.recalc_debuff(target)
            end
            for _, target in ipairs((G.jokers and G.jokers.cards) or {}) do
                SMODS.recalc_debuff(target)
            end
        end

        -- Cerulean Bell can already have marked cards in hand as forced.
        -- Clear those marks for this hand; its normal draw hook can apply them
        -- again once the Blind has been re-enabled.
        for _, target in ipairs(G.playing_cards or {}) do
            if target.ability then target.ability.forced_selection = nil end
        end
    end
}
