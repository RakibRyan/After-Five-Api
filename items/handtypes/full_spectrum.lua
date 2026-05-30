SMODS.PokerHand {
    key = 'Full Spectrum',
    chips = 200, -- Adjusted up: a 6-of-a-kind with 6 unique suits is significantly harder to draw than a standard Spectrum
    mult = 20,
    l_chips = 50,
    l_mult = 4,
    visible = false,
    example = {
        { 'S_7', true },
        { 'D_7', true },
        { 'six_STAR_7', true },
        { 'six_MOON_7', true },
        { 'H_7', true },
        { 'C_7', true }
    },
    loc_txt = {
        name = 'Full Spectrum',
        description = { '6 cards of the same rank,', 'each with a different suit' }
    },
    evaluate = function(parts, hand)
        if #hand < 6 then return {} end
        
        -- Step 1: Group the played cards by their rank (e.g., all 7s together, all Kings together)
        local rank_groups = {}
        for i = 1, #hand do
            local rank = hand[i]:get_id()
            if not rank_groups[rank] then rank_groups[rank] = {} end
            table.insert(rank_groups[rank], hand[i])
        end
        
        -- Step 2: Iterate through these groups. We only care if a rank has 6 or more cards.
        for rank, group in pairs(rank_groups) do
            if #group >= 6 then
                local suits = {}
                
                -- Dynamically initialize suit tracking based on loaded suits (including Six Suits)
                for _, v in ipairs(SMODS.Suit.obj_buffer) do
                    suits[v] = 0
                end
                
                -- Step 3a: Greedy allocation for standard/base suits
                for i = 1, #group do
                    if group[i].ability.name ~= 'Wild Card' then
                        for k, v in pairs(suits) do
                            -- is_suit(k, nil, true) handles multi-suit jokers like Smeared Joker
                            if group[i]:is_suit(k, nil, true) and v == 0 then
                                suits[k] = v + 1
                                break
                            end
                        end
                    end
                end
                
                -- Step 3b: Fill in the remaining missing suits using Wild Cards
                for i = 1, #group do
                    if group[i].ability.name == 'Wild Card' then
                        for k, v in pairs(suits) do
                            if group[i]:is_suit(k, nil, true) and v == 0 then
                                suits[k] = v + 1
                                break
                            end
                        end
                    end
                end
                
                -- Step 4: Verify we successfully filled at least 6 distinct suit slots
                local num_suits = 0
                for _, v in pairs(suits) do
                    if v > 0 then num_suits = num_suits + 1 end
                end
                
                if num_suits >= 6 then
                    return { group } -- Returns ONLY the matching group of cards to be scored
                end
            end
        end
        
        return {}
    end
}
