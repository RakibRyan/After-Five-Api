-- CONFIG
--#region Config --------------------------------------------------------------------------------------------
OneTooMany = SMODS.current_mod
OneTooMany_path = SMODS.current_mod.path
OneTooMany_config = SMODS.current_mod.config
--#endregion

-- CROSS-MOD
--#region Talisman compat -----------------------------------------------------------------------------------

if next(SMODS.find_mod("AntePreview")) then -- Ante Preview compat
    SMODS.Atlas {
        key = 'poker_hands',
        path = "Poker Hands.png",
        px = 53,
        py = 13
    }
end

--#endregion

-- CREDITS SYSTEM
--#region Card Credits System (Derived from Cryptid's cry_credits) ------------------------------------------
local smcmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
    smcmb(obj, badges)
    if not SMODS.config.no_mod_badges and obj and obj.otm_credits then
        local function calc_scale_fac(text)
            local size = 0.9
            local font = G.LANG.font
            local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
            local calced_text_width = 0
            -- Math reproduced from DynaText:update_text
            for _, c in utf8.chars(text) do
                local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
                    + 2.7 * 1 * G.TILESCALE * font.FONTSCALE
                calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
            end
            local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
            return scale_fac
        end
        if obj.otm_credits.art or obj.otm_credits.code or obj.otm_credits.idea or obj.otm_credits.custom then
            local scale_fac = {}
            local min_scale_fac = 1
            local strings = { OneTooMany.display_name }
            for _, v in ipairs({ "idea", "art", "code" }) do
                if obj.otm_credits[v] then
                    if type(obj.otm_credits[v]) == "string" then obj.otm_credits[v] = { obj.otm_credits[v] } end
                    for i = 1, #obj.otm_credits[v] do
                        strings[#strings + 1] =
                            localize({ type = "variable", key = "otm_" .. v, vars = { obj.otm_credits[v][i] } })[1]
                    end
                end
            end
            if obj.otm_credits.custom then
                strings[#strings + 1] = localize({ type = "variable", key = obj.otm_credits.custom.key, vars = { obj.otm_credits.custom.text } })
            end
            for i = 1, #strings do
                scale_fac[i] = calc_scale_fac(strings[i])
                min_scale_fac = math.min(min_scale_fac, scale_fac[i])
            end
            local ct = {}
            for i = 1, #strings do
                ct[i] = {
                    string = strings[i],
                }
            end
            local otm_badge = {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = {
                            align = "cm",
                            colour = OneTooMany.badge_colour,
                            r = 0.1,
                            minw = 2 / min_scale_fac,
                            minh = 0.36,
                            emboss = 0.05,
                            padding = 0.03 * 0.9,
                        },
                        nodes = {
                            { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                            {
                                n = G.UIT.O,
                                config = {
                                    object = DynaText({
                                        string = ct or "ERROR",
                                        colours = { obj.otm_credits and obj.otm_credits.text_colour or OneTooMany.badge_text_colour },
                                        silent = true,
                                        float = true,
                                        shadow = true,
                                        offset_y = -0.03,
                                        spacing = 1,
                                        scale = 0.33 * 0.9,
                                    }),
                                },
                            },
                            { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                        },
                    },
                },
            }
            local function eq_col(x, y)
                for i = 1, 4 do
                    if x[i] ~= y[i] then
                        return false
                    end
                end
                return true
            end
            for i = 1, #badges do
                if badges[i].nodes[1].nodes[2].config.object.string == OneTooMany.display_name then --this was meant to be a hex code but it just doesnt work for like no reason so its hardcoded
                    badges[i].nodes[1].nodes[2].config.object:remove()
                    badges[i] = otm_badge
                    break
                end
            end
        end
    end
end

--#endregion

-- OBJECTS

--#region Consumables ---------------------------------------------------------------------------------------

SMODS.Atlas { -- Main Consumable Atlas
    key = 'Consumables',
    path = "Consumables.png",
    px = 71,
    py = 95
}

local ENABLED_CONSUMABLES = {
    'microscopii',
    'wasp',
    'pegasi',
    'trappist',
    'corot',
    'poltergeist',
    'gliese',
    'cancri',
    'proxima',
    'phobetor',
    'kepler',
}

sendDebugMessage("Loading Consumables...", 'OneTooMany')
for i = 1, #ENABLED_CONSUMABLES do
    assert(SMODS.load_file('items/consumables/' .. ENABLED_CONSUMABLES[i] .. '.lua'))()
    sendDebugMessage("Loaded consumable: " .. ENABLED_CONSUMABLES[i], 'OneTooMany')
end

sendDebugMessage("", 'OneTooMany')

--#endregion

--#region Hand Types ----------------------------------------------------------------------------------------

--#region Hand Parts ------------------------------------------------------------------------------------
local ENABLED_HAND_PARTS = {
    '_6',
    's_flush',
    's_straight'
}

sendDebugMessage("Loading Hand Parts...", 'OneTooMany')
for i = 1, #ENABLED_HAND_PARTS do
    assert(SMODS.load_file('items/handtypes/parts/' .. ENABLED_HAND_PARTS[i] .. '.lua'))()
    sendDebugMessage("Loaded hand part: " .. ENABLED_HAND_PARTS[i], 'OneTooMany')
end
--#endregion

local ENABLED_HANDS = {
    'three_pair',
    'double_triple',
    '6oak',
    's_straight',
    's_flush',
    'house_party',
    'f_three_pair',
    'f_double_triple',
    'full_spectrum', 
    's_straight_f',
    'f_party',
    'f_6oak',
    'Artifact', 
    'spectrum', 
    'test', 
}

sendDebugMessage("Loading Hand Types...", 'OneTooMany')
for i = 1, #ENABLED_HANDS do
    assert(SMODS.load_file('items/handtypes/' .. ENABLED_HANDS[i] .. '.lua'))()
    sendDebugMessage("Loaded hand type: " .. ENABLED_HANDS[i], 'OneTooMany')
end
sendDebugMessage("", 'OneTooMany')

--#endregion
