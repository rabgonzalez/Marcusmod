return {
    descriptions = {
        Joker = {
            j_mm_sus_rock = {
                name = "Sus Rock",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "gains {X:mult,C:white}X#2#{} Mult every time",
                    "a {C:attention}Stone{} card is {C:red}discarded{}",
                },
            },
            j_mm_rigatoni_pasta = {
                name = "Rigatoni pasta",
                text = {
                    "{C:green}#2# in #1#{} chance to add",
                    "{C:attention}Ramen{} joker at the",
                    "start of round",
                    "{C:inactive}(Must have room){}",
                },
            },
            j_mm_marcus = {
                name = "Marcus",
                text = {
                    "Gives {C:red}+#2#{} Mult",
                    "for every {C:attention}Marcusmod{}",
                    "joker in hand",
                    "{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult){}",
                },
            },
        }
    },

    misc = {
        -- do note that when using messages such as:
        -- message = localize{type='variable',key='a_xmult',vars={current_xmult}},
        -- that the key 'a_xmult' will use provided values from vars={} in that order to replace #1#, #2# etc... in the localization file.
        dictionary = {
            a_chips = "+#1#",
            a_chips_minus = "-#1#",
            a_hands = "+#1# Hands",
            a_handsize = "+#1# Hand Size",
            a_handsize_minus = "-#1# Hand Size",
            a_mult = "+#1# Mult",
            a_mult_minus = "-#1# Mult",
            a_remaining = "#1# Remaining",
            a_sold_tally = "#1#/#2# Sold",
            a_xmult = "X#1# Mult",
            a_xmult_minus = "-X#1# Mult",
        }
    }
}
