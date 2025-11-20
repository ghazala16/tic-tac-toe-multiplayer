local nk = require("nakama")

local function matchmaker_matched(ctx, logger, nk, matches)
    local match_id = nk.match_create("tick-tac", {})
    return match_id
end

nk.register_matchmaker_matched(matchmaker_matched)
