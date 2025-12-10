--- GLOBALS
G.C.MM = {
    -- Colours
    RED = HEX("FF0000"),
    BLACK = HEX("000000"),
    BLUE = HEX("0000FF"),
    GREEN = HEX("00FF00"),
    WHITE = HEX("FFFFFF"),
    TRANSPARENT = HEX("00000000"),

    -- Game Data
    DISCARDS = {
        STONE_CRAD = 0
    },

    TOTAL = {
        MARCUSMOD = {
            JOKER = 0
        }
    }
}

-- Hooks
local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        loc_colour_ref()
    end
    G.ARGS.LOC_COLOURS.mm_red = G.C.MM.RED
    G.ARGS.LOC_COLOURS.mm_black = G.C.MM.BLACK
    G.ARGS.LOC_COLOURS.mm_blue = G.C.MM.BLUE
    G.ARGS.LOC_COLOURS.mm_green = G.C.MM.GREEN
    G.ARGS.LOC_COLOURS.mm_white = G.C.MM.WHITE
    G.ARGS.LOC_COLOURS.mm_transparent = G.C.MM.TRANSPARENT
    return loc_colour_ref(_c, _default)
end