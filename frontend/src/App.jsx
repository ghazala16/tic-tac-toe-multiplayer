import { useEffect } from "react";
import { initSession } from "./RealtimeClient";

function App() {
  useEffect(() => {
    initSession("user_" + Date.now());
  }, []);

  return <h1>Multiplayer Tic Tac Toe — Day 1 Setup Complete</h1>;
}

export default App;
