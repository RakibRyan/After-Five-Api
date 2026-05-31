SMODS.PokerHand {
    key = 'mxms_7oak',
    prefix_config = {
        key = { mod = false }
    },
    mult = 30,   
    chips = 300, 
    l_mult = 5,
    l_chips = 50,
    atlas = 'poker_hands',
    pos = { x = 0, y = 3 }, -- Verify this Y-coordinate points to a valid sprite
    example = {
        { 'S_K', true },
        { 'D_K', true },
        { 'C_K', true },
        { 'H_K', true },
        { 'S_K', true },
        { 'D_K', true },
        { 'C_K', true }
    },
    visible = false,
    evaluate = function(parts, hand)
        return next(parts.mxms_7) and parts.mxms_7 or {}
    end
}
