// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"
import {Game} from "./game.js"

let game = null;

function connectToSocket(match_id) {
  // connects to the socket endpoint
  let socket = new Socket("/socket", {params: {token: window.userToken}})
  socket.connect()
  let channel = socket.channel("match:" + match_id, {})
  // joins the channel
  channel.join()
  .receive("ok", resp => { 
    //Create a Pixi Application
    game = new Game();
    console.log("GAME IS: ", game)
    game.header()
  })
  .receive("error", resp => { console.log("Unable to join", resp) })
  //
  channel.on("arena_event", payload => {
    console.log("Payload Received", payload);
      game.event(payload);
  })
}

export {connectToSocket}
