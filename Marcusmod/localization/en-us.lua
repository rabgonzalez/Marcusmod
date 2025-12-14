return {
    descriptions = {
        Joker = {
            j_mm_sus_rock = {
                name = "Sus Rock",
                text = {
                    "This joker gains {X:mult,C:white}X#2#{} Mult",
                    "every time a {C:attention}Stone{} card",
                    "is discarded {s:0.8}(Max{} {C:red,s:0.8}X#3#{} {s:0.8}Mult){}",
                    "{C:inactive}(Currently{} {C:red}X#1#{} {C:inactive}Mult){}",
                },
            },
            j_mm_rigatoni_pasta = {
                name = "Rigatoni pasta",
                text = {
                    "{C:green}#2# in #1#{} chance to add",
                    "{C:attention}Ramen{} joker at",
                    "the start of round",
                    "{C:inactive}(Must have room){}",
                },
            },
            j_mm_marcus = {
                name = "Marcus",
                text = {
                    "Gives {C:red}+#2#{} Mult",
                    "for all other {X:attention,C:white}Marcusmod{}",
                    "jokers in hand",
                    "{C:inactive}(Currently{} {C:red}+#1#{} {C:inactive}Mult){}",
                },
            },
            j_mm_3per_low_fat_milk = {
                name = "3% Low Fat Milk",
                text = {
                    "Has a {C:green}#2# in #1#{}",
                    "chance to upgrade to",
                    "{C:legendary,E:1}1% Low Fat Milk{} joker",
                },
            },
            j_mm_1per_low_fat_milk = {
                name = "1% Low Fat Milk",
                text = {
                    "Gains {C:chips,E:1}+#1#{} Chips",
                    "each time a hand is played"
                },
            },
            j_mm_walgreens_coupon = {
                name = "Walgreens Coupon",
                text = {
                    "Gives {C:attention}#1#%{} discount",
                    "in the shop every {C:red}#2#{}",
                    "skipped blinds",
                    "{C:inactive}({C:red}#3#{} {C:inactive}skips remaining){}",
                },
            },
            j_mm_stealth_mode = {
                name = "Stealth Mode",
                text = {
                    "If all hands played this round",
                    "are the same type, gives",
                    "{C:planet}planet card{} for that hand",
                    "{C:inactive}(playing hand: {C:attention}#1#{}{C:inactive}){}"
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
        },
    }
}
