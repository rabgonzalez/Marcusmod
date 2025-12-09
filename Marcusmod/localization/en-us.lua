return {
    descriptions = {
        Joker = {
            j_mm_sus_rock = {
                name = "Sus Rock",
                text = {
                    "This joker gains",
                    "{X:mult,C:white}X#2#{} Mult every time",
                    "a {C:attention}Stone{} card is {C:red}discarded{}",
                    "{C:inactive}(Currently{} {X:mult,C:white}X#1#{} {C:inactive}Mult){}",
                },
            },
            j_mm_rigatoni_pasta = {
                name = "Rigatoni pasta",
                text = {
                    "{C:green}#1# in 3{} chance to add",
                    "{C:attention}Ramen{} joker at the",
                    "start of round",
                    "{C:inactive}(Must have room){}",
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
