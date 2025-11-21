local nk = require("nakama")

local function save_name(context, payload)
    local data = nk.json_decode(payload)
    nk.account_update_identities(context.user_id, {
        { id = data.name, provider = "name" }
    })
    return nk.json_encode({ success = true })
end

nk.register_rpc(save_name, "save_name")
