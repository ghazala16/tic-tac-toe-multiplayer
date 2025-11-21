local nk = require("nakama")

local function rematch_rpc(ctx, payload)
  local match_id = nk.match_create("tick-tac", {})
  return nk.json_encode({ match_id = match_id })
end

nk.register_rpc(rematch_rpc, "rematch")
