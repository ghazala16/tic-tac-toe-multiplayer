local nk = require("nakama")

local WIN_PATTERNS = {
    {1,2,3}, {4,5,6}, {7,8,9},
    {1,4,7}, {2,5,8}, {3,6,9},
    {1,5,9}, {3,5,7}
}

local function check_winner(board)
    for _, p in ipairs(WIN_PATTERNS) do
        local a, b, c = p[1], p[2], p[3]
        if board[a] ~= "" and board[a] == board[b] and board[b] == board[c] then
            return board[a]
        end
    end
    return nil
end

local function validate_move(state, action)
    if state.winner then return false end
    if action.position < 1 or action.position > 9 then return false end
    if state.board[action.position] ~= "" then return false end
    if action.symbol ~= state.current_player then return false end
    return true
end

local M = {}

function M.match_init(ctx, logger, nk, params)
    local state = {
        board = { "", "", "", "", "", "", "", "", "" },
        current_player = "X",
        winner = nil,
        players = {}
    }
    return state, 20 -- Tick rate
end

function M.match_join_attempt(ctx, logger, nk, dispatcher, tick, state, presence, metadata)
    if #state.players >= 2 then
        return state, false, "Match is full"
    end
    return state, true
end

function M.match_join(ctx, logger, nk, dispatcher, tick, state, presences)
    for _, p in ipairs(presences) do
        table.insert(state.players, p)
    end
    return state
end

function M.match_leave(ctx, logger, nk, dispatcher, tick, state, presences)
    state.winner = "Opponent Left"
    dispatcher.broadcast_message(1, nk.json_encode(state))
    return state
end

function M.match_loop(ctx, logger, nk, dispatcher, tick, state, messages)
    for _, msg in ipairs(messages) do
        local action = nk.json_decode(msg.data)
        if validate_move(state, action) then
            state.board[action.position] = state.current_player

            local winner = check_winner(state.board)
            if winner then
                state.winner = winner
                dispatcher.broadcast_message(1, nk.json_encode(state))
                return state
            end

            -- Check draw
            local full = true
            for _, v in ipairs(state.board) do
                if v == "" then full = false end
            end
            if full then
                state.winner = "Draw"
                dispatcher.broadcast_message(1, nk.json_encode(state))
                return state
            end

            -- Switch turn
            state.current_player = (state.current_player == "X") and "O" or "X"
            dispatcher.broadcast_message(1, nk.json_encode(state))
        end
    end

    return state
end

return M
