-- Kiss Me: arms a one-hand Joker retrigger effect. The Tarot is consumed
-- normally; the pending state is stored in G.GAME, not on the Tarot card.
SMODS.Consumable {
    key = 'kiss_me',
    set = 'Tarot',
    atlas = 'Tarot',
    prefix_config = { atlas = false },
    pos = { x = 6, y = 2 },
    cost = 3,
    unlocked = true,
    discovered = true,

    can_use = function(self, card)
        return not (G and G.GAME and G.GAME.mm_kiss_me_pending)
    end,

    use = function(self, card, area, copier)
        G.GAME.mm_kiss_me_pending = true
        G.GAME.mm_kiss_me_source_card = card
        if card_eval_status_text then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize('k_mm_kiss_me_ready'),
                colour = G.C.MULT
            })
        end
    end
}
