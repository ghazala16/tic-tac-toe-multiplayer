import * as nakamajs from "@heroiclabs/nakama-js";

export const client = new nakamajs.Client("defaultkey", "127.0.0.1", "7350");
client.useSSL = false;

export async function initSession(username) {
  const session = await client.authenticateDevice(username);
  const socket = client.createSocket(false, false);
  await socket.connect(session);

  console.log("Connected to Nakama!");
  return { session, socket };
}
