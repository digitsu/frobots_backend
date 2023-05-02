// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"
import {Game} from "./game.js"

let game = null;

function connectToSocket({ match_id, match_details, arena, s3_base_url }) {
  // connects to the socket endpoint
  let socket = new Socket('/socket', { params: { token: window.userToken } })
  socket.connect()
  let channel = socket.channel('match:' + match_id, {})
  // joins the channel
  channel
    .join()
    .receive('ok', (resp) => {
      //Create a Pixi Application
      game = new Game([], [], { match_id, match_details, arena, s3_base_url })
      game.header()
    })
    .receive('error', (resp) => {
      console.log('Unable to join', resp)
    })

    console.log("Socket outside");
  //
  channel.on('arena_event', (payload) => {
    console.log("Inside Arena Event");
    game.event(payload)
  })
}

export {connectToSocket}
