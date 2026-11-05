-- Marcus Delivery: create a weighted random Joker from Marcusmod.
-- 1% Low Fat Milk is intentionally excluded because it is Legendary and is
-- only obtainable through the 3% Low Fat Milk Joker.
local MM_MARCUS_JOKER_WEIGHTS = {
    j_mm_marcus = 10,
    j_mm_3per_low_fat_milk = 10,
    j_mm_stealth_mode = 10,
    j_mm_sus_rock = 10,
    j_mm_rigatoni_pasta = 5,
    j_mm_walgreens_coupon = 2
}

local function mm_pick_marcus_joker()
    local valid_keys = {}
    local total_weight = 0

    -- Sorting the map keys keeps the seeded result deterministic.
    for key, weight in pairs(MM_MARCUS_JOKER_WEIGHTS) do
        if G.P_CENTERS and G.P_CENTERS[key] and weight > 0 then
            valid_keys[#valid_keys + 1] = key
        end
    end
    table.sort(valid_keys)

    for _, key in ipairs(valid_keys) do
        total_weight = total_weight + MM_MARCUS_JOKER_WEIGHTS[key]
    end
    if total_weight <= 0 then return nil end

    G.GAME.mm_marcus_delivery_roll = (G.GAME.mm_marcus_delivery_roll or 0) + 1
    local ante = (G.GAME.round_resets and G.GAME.round_resets.ante) or 0
    local seed = pseudoseed('mm_marcus_delivery_' .. tostring(ante) .. '_' .. tostring(G.GAME.mm_marcus_delivery_roll))
    local roll = pseudorandom(seed) * total_weight
    local cumulative = 0

    for _, key in ipairs(valid_keys) do
        cumulative = cumulative + MM_MARCUS_JOKER_WEIGHTS[key]
        if roll < cumulative then return key end
    end

    return valid_keys[#valid_keys]
end

SMODS.Consumable {
    key = 'marcus_delivery',
    set = 'Tarot',
    atlas = 'Tarot',
    prefix_config = { atlas = false }, -- Use Balatro's vanilla Tarot atlas (do not prefix it with mm_)
    pos = { x = 4, y = 0 }, -- Placeholder art: The Emperor
    cost = 3,
    unlocked = true,
    discovered = true,

    can_use = function(self, card)
        return G.jokers
            and #G.jokers.cards + (G.GAME.joker_buffer or 0) < G.jokers.config.card_limit
    end,

    use = function(self, card, area, copier)
        local joker_key = mm_pick_marcus_joker()
        if not joker_key then return end

        -- Reserve a slot until the creation event runs, preventing the Joker
        -- area from becoming over capacity if another effect creates a Joker.
        G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) + 1
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if G.jokers and G.P_CENTERS[joker_key] then
                    local new_joker = SMODS.add_card({
                        key = joker_key,
                        set = 'Joker',
                        area = G.jokers,
                        key_append = 'mm_marcus_delivery'
                    })
                    if new_joker then new_joker:juice_up(0.3, 0.2) end
                end
                G.GAME.joker_buffer = math.max((G.GAME.joker_buffer or 1) - 1, 0)
                return true
            end
        }))
    end
}
