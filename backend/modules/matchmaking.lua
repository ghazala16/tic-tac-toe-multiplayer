local nk = require("nakama")

local function matchmaker(ctx, logger, nk, params)
    local match_id = nk.match_create("tic")
    return match_id
end

nk.register_matchmaker_matched(matchmaker)
