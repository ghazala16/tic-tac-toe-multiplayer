import * as nakamajs from "@heroiclabs/nakama-js";

export const client = new nakamajs.Client("defaultkey", "127.0.0.1", "7350");
client.useSSL = false;

export async function initSession(username) {
    // 1. Create or authenticate session
    const session = await client.authenticateDevice(username);
    await client.rpc(session, "save_name", { name: username });
    const socket = client.createSocket(false, false);
    await socket.connect(session);
  
    console.log("Connected to Nakama!");
    return { session, socket };
  }

export async function joinMatch(socket) {
    const ticket = await socket.addMatchmaker(2, 2, {});
    socket.onMatchmakerMatched = async (matched) => {
      const matchId = matched.match_id;
      await socket.joinMatch(matchId);
      console.log("Joined match:", matchId);
    };
  }
  