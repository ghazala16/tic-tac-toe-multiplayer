export default function Lobby({ onPlay }) {
    return (
      <div className="lobby">
        <h1>Tic Tac Toe Multiplayer</h1>
        <button className="play-btn" onClick={onPlay}>
          Play Online
        </button>
      </div>
    );
  }
  