local nk = require("nakama")

local function validate_move(state, action)
    -- Validate: turn, position, board state
    return true -- to implement Day 2
end

local function apply_move(state, action)
    -- Apply move to board
    return state
end

local M = {}

function M.tic_init(ctx, logger, nk, params)
    return {
        board = { "", "", "", "", "", "", "", "", "" },
        current_player = "X",
        winner = nil
    }
end

function M.tic_loop(ctx, logger, nk, state, action)
    if validate_move(state, action) then
        state = apply_move(state, action)
        return state
    else
        return nk.match_terminate(state)
    end
end

return M
