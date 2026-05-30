SMODS.PokerHandPart {
    key = 'mxms_s_straight',
    prefix_config = {
        key = { mod = false }
    },
    func = function(hand)
        if G.STAGE == G.STAGES.RUN and G.hand.config.highlighted_limit >= 6 then
            return get_straight(hand, SMODS.four_fingers() + 1, SMODS.shortcut(), SMODS.wrap_around_straight())
        end
    end
}
