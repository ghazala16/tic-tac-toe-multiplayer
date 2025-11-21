import { useEffect, useState } from "react";

export default function GameBoard({ socket, session }) {

  const [game, setGame] = useState(null);
  const [matchId, setMatchId] = useState(null);
  const [playerSymbol, setPlayerSymbol] = useState(null);

  useEffect(() => {
    socket.onmatchdata = (msg) => {
      const json = JSON.parse(new TextDecoder().decode(msg.data));
      setGame(json);

      if (!playerSymbol && json.players) {
        const symbols = Object.keys(json.players);
        setPlayerSymbol(json.players[session.user_id]);
      }
    };
  }, []);

  const sendMove = (i) => {
    if (!game || game.winner) return;

    const payload = {
      position: i + 1,
      symbol: playerSymbol
    };

    socket.sendMatchState(matchId, 1, payload);
  };

  return (
    <div className="container">
      <h2>
        {game?.winner
          ? `Winner: ${game.winner}`
          : `Turn: ${game?.current_player}`}
      </h2>

      <div className="board">
        {game?.board?.map((cell, i) => (
          <button
            key={i}
            className="cell"
            disabled={!!cell || game.winner}
            onClick={() => sendMove(i)}
          >
            {cell}
          </button>
        ))}
      </div>
      <button onClick={requestRematch}>Play Again</button>
    </div>
  );
}
