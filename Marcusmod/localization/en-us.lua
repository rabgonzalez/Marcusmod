return {
    descriptions = {
        Joker = {
            j_mm_sus_rock = {
                name = "Sus Rock",
                text = {
                    "This joker gains {X:mult,C:white}X#2#{} Mult",
                    "every time a {C:attention}Stone{}",
                    "card is discarded",
                    "{C:inactive}(Currently{} {C:red}X#1#{} {C:inactive}Mult){}",
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
                    "for all other {C:attention}Marcusmod{}",
                    "jokers in hand",
                    "{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult){}",
                },
            },
            j_mm_3per_low_fat_milk = {
                name = "3% Low Fat Milk",
                text = {
                    "Has a {C:green}#2# in #1#{}",
                    "chance to upgrade to",
                    "{C:attention}1% Low Fat Milk{} joker",
                },
            },
            j_mm_1per_low_fat_milk = {
                name = "1% Low Fat Milk",
                text = {
                    "Gains {C:chips,E:1}+#1#{} Chips",
                    "each time a",
                    "hand is played"
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
