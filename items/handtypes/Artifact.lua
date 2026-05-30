SMODS.PokerHand {
    key = 'Artifact',
    chips = 160,
    mult = 16,
    l_chips = 50,
    l_mult = 4,
    example = {
        { 'S_7', true },
        { 'D_8', true },
        { 'six_STAR_9', true },
        { 'six_MOON_T', true },
        { 'H_J', true },
        { 'C_Q', true }
    },
    loc_txt = {
        name = 'Artifact',
        description = { '6 cards with different suits' }
    },
        visible = false,
    evaluate = function(parts, hand)
        -- Hard fail if fewer than 6 cards are played
        if #hand < 6 then return {} end
        
        local suits = {}
        for _, v in ipairs(SMODS.Suit.obj_buffer) do
            suits[v] = 0
        end
        
        local valid_cards = {}
        
        -- Step 1: Check base suits first to prevent Wild Cards from being consumed unnecessarily
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
        end
        
        -- Step 2: Use Wild Cards to fill in any remaining suit gaps
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
        end
        
        -- Step 3: Verify we have collected at least 6 distinct suits
        if #valid_cards >= 6 then
            -- Return ONLY the valid scoring cards, ignoring any excess non-scoring cards
            return { valid_cards }
        end
        
        return {}
    end
}
