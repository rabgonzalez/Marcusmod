SMODS.Atlas({
    key = "the_worm_atlas",
    path = "the_worm.png",
    px = 64,
    py = 64
})

SMODS.Blind {
    key = "the_worm",
    discovered = true,
    pos = { x = 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = {min = 1, max = 10},
    boss_colour = HEX('56789A'),
    vars = {},

    loc_vars = function(self)
        return { vars = { } }
    end
}
