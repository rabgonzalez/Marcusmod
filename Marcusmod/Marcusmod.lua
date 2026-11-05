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

-- Runtime hooks for the one-hand Tarot effects.
-- Power Down bypasses the active Boss Blind's gameplay callbacks for exactly
-- one played hand. It does NOT set Blind.disabled, so the Blind lifecycle,
-- scoring requirement and end-of-round handling remain intact.
local function mm_power_down_is_active()
    return G and G.GAME and G.GAME.mm_power_down_active == true
end

local function mm_power_down_recalculate_all_cards()
    if not (G and G.GAME) then return end
    if SMODS and SMODS.recalc_debuff then
        for _, card in ipairs(G.playing_cards or {}) do
            SMODS.recalc_debuff(card)
        end
        for _, card in ipairs((G.jokers and G.jokers.cards) or {}) do
            SMODS.recalc_debuff(card)
        end
    end
end

local function mm_power_down_restore_forced_selection()
    if not (G and G.GAME) then return end
    for _, entry in ipairs(G.GAME.mm_power_down_forced_cards or {}) do
        if entry.card and entry.card.ability then
            entry.card.ability.forced_selection = entry.value
        end
    end
    G.GAME.mm_power_down_forced_cards = nil
end

local function mm_power_down_finish_hand()
    if not (G and G.GAME and G.GAME.mm_power_down_pending) then return end
    -- Stop bypassing Blind callbacks first, then restore any state that was
    -- explicitly removed for the protected hand and recalculate both card
    -- areas. This restores Boss debuffs on Jokers as well as playing cards.
    G.GAME.mm_power_down_active = nil
    G.GAME.mm_power_down_pending = nil
    mm_power_down_restore_forced_selection()
    mm_power_down_recalculate_all_cards()
end

local function mm_wrap_blind_method(method_name, bypass)
    if not Blind or type(Blind[method_name]) ~= 'function' then return end
    local marker = '_mm_power_down_wrapped_' .. method_name
    if Blind[marker] then return end

    local original = Blind[method_name]
    Blind[method_name] = function(self, ...)
        if mm_power_down_is_active() then
            return bypass(self, ...)
        end
        return original(self, ...)
    end
    Blind[marker] = true
end

-- Suppress all standard Blind callbacks that can impose restrictions or
-- stateful effects. In particular calculate() covers effects such as losing
-- money, while recalc_debuff() covers both Joker and playing-card debuffs.
mm_wrap_blind_method('calculate', function(self, context, ...)
    return nil
end)
mm_wrap_blind_method('recalc_debuff', function(self, card, from_blind, ...)
    return false
end)
mm_wrap_blind_method('debuff_card', function(self, card, from_blind, ...)
    return nil
end)
mm_wrap_blind_method('debuff_hand', function(self, cards, hand, handname, check, ...)
    return false
end)
mm_wrap_blind_method('drawn_to_hand', function(self, ...)
    return nil
end)
mm_wrap_blind_method('press_play', function(self, ...)
    return nil
end)
mm_wrap_blind_method('stay_flipped', function(self, area, card, ...)
    return false
end)
mm_wrap_blind_method('modify_hand', function(self, cards, poker_hands, text, mult, hand_chips, ...)
    return mult, hand_chips, false
end)

-- Power Down expires after the next hand has fully resolved. context.after is
-- emitted after a played hand's scoring, not at the end of the round.
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
