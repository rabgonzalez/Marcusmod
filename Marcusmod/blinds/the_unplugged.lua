-- The Unplugged: the three rightmost Jokers are always debuffed, even if
-- Jokers are sold or rearranged during the blind. Every other Joker retriggers once.
local MM_UNPLUGGED_DEBUFF_SOURCE = "mm_the_unplugged"

-- Expose the refresh routine so Power Down can restore this blind's custom
-- source-based Joker debuffs after it re-enables the blind.
MM_UNPLUGGED = MM_UNPLUGGED or {}

local function mm_unplugged_refresh_jokers()
    if not G.jokers or not G.jokers.cards then return end

    local cards = G.jokers.cards
    local first_disabled = math.max(1, #cards - 2)
    for index, card in ipairs(cards) do
        local should_debuff = index >= first_disabled
        if SMODS.debuff_card then
            -- Source-based debuffs avoid overwriting debuffs from other effects.
            SMODS.debuff_card(card, should_debuff, MM_UNPLUGGED_DEBUFF_SOURCE)
        else
            card.debuff = should_debuff or card.debuff
        end
    end
end

MM_UNPLUGGED.refresh_jokers = mm_unplugged_refresh_jokers

local function mm_unplugged_clear_jokers()
    if not G.jokers or not G.jokers.cards then return end
    for _, card in ipairs(G.jokers.cards) do
        if SMODS.debuff_card then
            SMODS.debuff_card(card, false, MM_UNPLUGGED_DEBUFF_SOURCE)
        end
    end
end

SMODS.Blind {
    key = "the_unplugged",
    discovered = true,
    vars = {},
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { min = 1, max = 10 },
    boss_colour = HEX("B94C4C"),

    loc_vars = function(self)
        return { vars = {} }
    end,

    set_blind = function(self)
        if G and G.GAME then G.GAME.mm_unplugged_active = true end
        mm_unplugged_refresh_jokers()
    end,

    -- Refresh immediately before scoring so the rightmost-three rule reflects
    -- the current order, not only the order at blind selection time.
    press_play = function(self)
        mm_unplugged_refresh_jokers()
    end,

    drawn_to_hand = function(self)
        mm_unplugged_refresh_jokers()
    end,

    calculate = function(self, context)
        -- The feature is enabled in Marcusmod.lua. Steamodded repeats the
        -- calculation for this Joker once when repetitions = 1 is returned.
        if context.retrigger_joker_check and context.other_card
            and context.other_card.area == G.jokers
            and not context.other_card.debuff then
            return { repetitions = 1 }
        end
    end,

    disable = function(self)
        if G and G.GAME then G.GAME.mm_unplugged_active = nil end
        mm_unplugged_clear_jokers()
    end,
    defeat = function(self)
        if G and G.GAME then G.GAME.mm_unplugged_active = nil end
        mm_unplugged_clear_jokers()
    end,
}
