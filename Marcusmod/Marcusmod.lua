-- Enable Steamodded's Joker retrigger calculation contexts for The Unplugged.
SMODS.current_mod.optional_features = SMODS.current_mod.optional_features or {}
SMODS.current_mod.optional_features.retrigger_joker = true

if SMODS.Atlas then
    SMODS.Atlas({
        key = "modicon",
        path = "modicon.png",
        px = 32,
        py = 32
    })
end

-- Dinamic loaded Jokers
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "jokers")
for _, file in ipairs(joker_src) do
    assert(SMODS.load_file("jokers/" .. file))()
end

-- Dynamically load custom Tarot consumables after the mod's Jokers so their
-- weighted generation table can refer to the registered Joker centers.
local tarot_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "tarots")
for _, file in ipairs(tarot_src) do
    assert(SMODS.load_file("tarots/" .. file))()
end

local blind_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "blinds")
for _, file in ipairs(blind_src) do
    assert(SMODS.load_file("blinds/" .. file))()
end

-- Power Down temporarily sets Blind.disabled directly. Do NOT call Blind:disable():
-- Steamodded dispatches the Blind's permanent `disable` callback from that method,
-- which clears custom state (for example The Glitch mapping and The Script target).
local function mm_power_down_recalculate_all_cards(blind)
    if not (G and G.GAME) then return end

    if SMODS and SMODS.recalc_debuff then
        for _, card in ipairs(G.playing_cards or {}) do
            SMODS.recalc_debuff(card)
        end
        for _, card in ipairs((G.jokers and G.jokers.cards) or {}) do
            SMODS.recalc_debuff(card)
        end
    elseif blind and blind.debuff_card then
        for _, card in ipairs(G.playing_cards or {}) do blind:debuff_card(card) end
        for _, card in ipairs((G.jokers and G.jokers.cards) or {}) do blind:debuff_card(card) end
    end
end

local function mm_power_down_finish_hand()
    if not (G and G.GAME and G.GAME.mm_power_down_pending) then return end

    local blind = G.GAME.mm_power_down_blind
    G.GAME.mm_power_down_pending = nil
    G.GAME.mm_power_down_blind = nil

    -- Re-enable the same Blind after the played hand has finished scoring.
    -- Assigning the flag directly avoids invoking its permanent `enable/disable`
    -- lifecycle callbacks and preserves all custom boss state.
    if blind and G.GAME.blind == blind then
        blind.disabled = false
        if blind.set_text then blind:set_text() end
        mm_power_down_recalculate_all_cards(blind)

        -- The Unplugged applies Joker debuffs through a custom SMODS debuff
        -- source rather than Blind:debuff_card. Re-apply that source explicitly
        -- after the generic recalculation, which cannot recreate custom sources.
        if G.GAME.mm_unplugged_active and MM_UNPLUGGED
            and MM_UNPLUGGED.refresh_jokers then
            MM_UNPLUGGED.refresh_jokers()
        end

        if blind.wiggle then blind:wiggle() end
    end
end

-- Expire Power Down after scoring the next played hand, not on a later draw.
if SMODS.calculate_context and not SMODS._mm_tarot_context_wrapped then
    local old_calculate_context = SMODS.calculate_context
    SMODS.calculate_context = function(context, return_table, ...)
        local result = old_calculate_context(context, return_table, ...)

        if context and context.after and G and G.GAME then
            mm_power_down_finish_hand()

            if G.GAME.mm_encore_pending then
                G.GAME.mm_encore_pending = nil
                G.GAME.mm_encore_source_card = nil
            end
        end
        return result
    end
    SMODS._mm_tarot_context_wrapped = true
end

-- Add one extra calculation for every non-debuffed Joker while Encore is
-- pending. Keep the original Steamodded retrigger calculation intact.
if SMODS.calculate_retriggers and not SMODS._mm_encore_retriggers_wrapped then
    local old_calculate_retriggers = SMODS.calculate_retriggers
    SMODS.calculate_retriggers = function(card, context, ret, ...)
        local repetitions = old_calculate_retriggers(card, context, ret, ...)
        if G and G.GAME and G.GAME.mm_encore_pending
            and card and card.area == G.jokers
            and not card.debuff
            and context and not context.retrigger_joker then
            repetitions = repetitions or {}
            SMODS.insert_repetitions(repetitions, { repetitions = 1 }, G.GAME.mm_encore_source_card, 'joker_retrigger')
        end
        return repetitions
    end
    SMODS._mm_encore_retriggers_wrapped = true
end
