return {
    descriptions = {
        Joker = {
            j_mm_sus_rock = {
                name = "Roca Sospechosa",
                text = {
                    "Este comodín consigue un multi",
                    "{X:mult,C:white}X#2#{} cada vez que se descarte",
                    "una carta de {C:attention}piedra{} {s:0.8}(máximo{} {C:red,s:0.8}X#3#{} {s:0.8}multi){}",
                    "{C:inactive}(Actual: multi{} {X:mult,C:white}X#1#{}{C:inactive}){}",
                },
            },
            j_mm_rigatoni_pasta = {
                name = "Pasta Rigatoni",
                text = {
                    "{C:green}#2# en #1#{} probabilidades",
                    "de añadir el comodín {C:attention}Ramen{}",
                    "al inicio de la ronda",
                    "{C:inactive}(Debe haber espacio){}",
                },
            },
            j_mm_marcus = {
                name = "Marcus",
                text = {
                    "{C:red}+#2#{} multi por cada otro",
                    "comodín de {X:attention,C:white}Marcusmod{}",
                    "en la ranura de comodines",
                    "{C:inactive}(Actual:{} {C:red}+#1#{} {C:inactive}de multi){}",
                },
            },
            j_mm_3per_low_fat_milk = {
                name = "3% Low Fat Milk",
                text = {
                    "{C:green}#2# en #1#{} probabilidades de mejorar",
                    "al comodín {C:legendary,E:1}1% Low Fat Milk{}",
                },
            },
            j_mm_1per_low_fat_milk = {
                name = "1% Low Fat Milk",
                text = {
                    "{C:chips,E:1}+#1#{} fichas",
                    "cada vez que se juega una mano",
                },
            },
            j_mm_walgreens_coupon = {
                name = "Cupón de Walgreens",
                text = {
                    "Da un {C:attention}#1#%{} de descuento",
                    "en la tienda cada {C:red}#2#{}",
                    "ciegas omitidas",
                    "{C:inactive}({C:red}#3#{} {C:inactive}saltos restantes){}",
                },
            },
            j_mm_stealth_mode = {
                name = "Modo Sigilo",
                text = {
                    "Si todas las manos jugadas",
                    "son del mismo tipo, da una",
                    "{C:planet}carta planeta{} para esa mano",
                    "{C:inactive}(mano jugada: {C:attention}#1#{}{C:inactive}){}"
                },
            },
        },
        Tarot = {
            c_mm_michigan = {
                name = "Michigan",
                text = {
                    "Al final de cada ronda,",
                    "gana {C:money}+$1{} de valor de venta"
                }
            },
            c_mm_marcus_delivery = {
                name = "Envío de Marcus",
                text = {
                    "Crea un comodín aleatorio",
                    "de {C:attention}Marcusmod{}",
                }
            },
            c_mm_jimbo_james = {
                name = "Jimbo James",
                text = {
                    "Desactiva una {C:attention}Ciega jefe{}",
                    "durante la siguiente mano jugada",
                }
            },
            c_mm_kiss_me = {
                name = "Beso",
                text = {
                    "Vuelve a activar cada",
                    "{C:attention}comodín{} durante",
                    "la siguiente mano jugada"
                }
            },
        },
        Blind = {
            bl_mm_the_son = { name = "El hijo", text = { "Jugar una {C:attention}Carta alta{} mejora la carta" } },
            bl_mm_the_robert = { name = "El Robert", text = { "Juega la mano indicada", "cambia tras cada jugada" } },
            bl_mm_the_glitch = { name = "El Glitch", text = { "Cada mano cuenta como una mano diferente" } },
            bl_mm_the_money_laundry = { name = "El Lavado de Dinero", text = { "Crea un {C:tarot}Tarot{} aleatorio tras cada mano jugada" } },
            bl_mm_the_government = { name = "El Gobierno", text = { "Desactiva los últimos {C:attention}3{} comodines", "Todos los comodines se activan una vez más" } },
        }
    },

    misc = {
        dictionary = {
            a_chips = "+#1#",
            a_chips_minus = "-#1#",
            a_hands = "+#1# Manos",
            a_handsize = "+#1# Tamaño de Mano",
            a_handsize_minus = "-#1# Tamaño de Mano",
            a_mult = "+#1# Mult",
            a_mult_minus = "-#1# Mult",
            a_remaining = "#1# Restante",
            a_sold_tally = "#1#/#2# Vendidos",
            a_xmult = "X#1# Mult",
            a_xmult_minus = "-X#1# Mult",
            k_mm_blessed = "¡Bendecida!",
            k_mm_play_hand = "Juega:",
            k_mm_wrong_hand = "Mano requerida:",
            k_mm_randomly_becomes = "Cuenta como:",
            k_mm_sell_value_up = "Valor de venta +$1",
            k_mm_kiss_me_ready = "Besame Robert",
            k_mm_kiss_me_done = "Muah",
        },
    }
}
