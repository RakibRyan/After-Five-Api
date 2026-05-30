SMODS.PokerHandPart {
    key = 'mxms_s_flush',
    prefix_config = {
        key = { mod = false }
    },
    func = function(hand)
        if G.STAGE == G.STAGES.RUN and G.hand.config.highlighted_limit >= 6 then
            local ret = {}
            local four_fingers = SMODS.four_fingers() + 1
            local suits = SMODS.Suit.obj_buffer
            if #hand < four_fingers then
                return ret
            else
                for j = 1, #suits do
                    local t = {}
                    local suit = suits[j]
                    local flush_count = 0
                    for i = 1, #hand do
                        if hand[i]:is_suit(suit, nil, true) then
                            flush_count = flush_count + 1; t[#t + 1] = hand[i]
                        end
                    end
                    if flush_count >= four_fingers then
                        table.insert(ret, t)
                        return ret
                    end
                end
                return {}
            end
        end
    end
}
