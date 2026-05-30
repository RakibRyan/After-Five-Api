SMODS.PokerHand {
    key = 'Spectrum',
    visible = false,
    discovered = false,
    chips = 120,
    mult = 12,
    l_chips = 40,
    l_mult = 3,
    example = {
        { 'S_7', true },
        { 'D_8', true },
        { 'six_STAR_9', true },
        { 'H_J', true },
        { 'C_Q', true }
    },
    loc_txt = {
        name = 'Spectrum',
        description = { '5 cards with different suits' }
    },
    evaluate = function(parts, hand)
        -- Hard fail if fewer than 5 cards are played
        if #hand < 5 then return {} end
        
        local suits = {}
        for _, v in ipairs(SMODS.Suit.obj_buffer) do
            suits[v] = 0
        end
        
        local valid_cards = {}
        
        -- Step 1: Check base suits first
        for i = 1, #hand do
            if hand[i].ability.name ~= 'Wild Card' then
                for k, v in pairs(suits) do
                    if hand[i]:is_suit(k, nil, true) and v == 0 then
                        suits[k] = 1
                        table.insert(valid_cards, hand[i])
                        break
                    end
                end
            end
            -- Optimization/Boundary: Stop collecting once we hit 5 unique suits
            if #valid_cards == 5 then break end
        end
        
        -- Step 2: Fill in remaining gaps with Wild Cards if we don't have 5 yet
        if #valid_cards < 5 then
            for i = 1, #hand do
                if hand[i].ability.name == 'Wild Card' then
                    for k, v in pairs(suits) do
                        if hand[i]:is_suit(k, nil, true) and v == 0 then
                            suits[k] = 1
                            table.insert(valid_cards, hand[i])
                            break
                        end
                    end
                end
                -- Optimization/Boundary: Stop collecting once we hit 5 unique suits
                if #valid_cards == 5 then break end
            end
        end
        
        -- Step 3: Verify we collected exactly 5 distinct suits
        if #valid_cards == 5 then
            return { valid_cards }
        end
        
        return {}
    end
}
