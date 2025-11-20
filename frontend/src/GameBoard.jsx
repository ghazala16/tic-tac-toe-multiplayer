import { useState, useEffect } from "react";

export default function GameBoard({ socket }) {
  const [state, setState] = useState(null);

  useEffect(() => {
    socket.onmatchdata = (msg) => {
      const gameState = JSON.parse(new TextDecoder().decode(msg.data));
      setState(gameState);
    };
  }, []);

  const sendMove = (i) => {
    if (!state || state.winner) return;
    const payload = {
      position: i + 1,
      symbol: state.current_player
    };
    socket.sendMatchState(state.matchId, 1, payload);
  };

  return (
    <div className="board">
      {state?.board?.map((cell, i) => (
        <button key={i} className="cell" onClick={() => sendMove(i)}>
          {cell}
        </button>
      ))}
      {state?.winner && <h2>Winner: {state.winner}</h2>}
    </div>
  );
}
