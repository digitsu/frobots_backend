// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"
// import { Application } from '@pixi/app'
// import * as PIXI from 'pixi.js';

import {Game} from "./game.js"
// The application will create a renderer using WebGL, if possible,
// with a fallback to a canvas render. It will also setup the ticker
// and the root stage PIXI.Container
// const app = new PIXI.Application({
//   width: 250, height: 250, backgroundColor: 0x1099bb, resolution: window.devicePixelRatio || 1,
// });
// document.body.appendChild(app.view);

// const container = new PIXI.Container();
// app.stage.addChild(container);

// // Create a new texture
// const texture = PIXI.Texture.from('images/bullet.png');

// // Create a 5x5 grid of bunnies
// for (let i = 0; i < 25; i++) {
//   const bunny = new PIXI.Sprite(texture);
//   bunny.anchor.set(0.5);
//   bunny.x = (i % 5) * 40;
//   bunny.y = Math.floor(i / 5) * 40;
//   container.addChild(bunny);
// }

// // Move container to the center
// container.x = app.screen.width / 2;
// container.y = app.screen.height / 2;

// // Center bunny sprite in local container coordinates
// container.pivot.x = container.width / 2;
// container.pivot.y = container.height / 2;

// // Listen for animate update
// app.ticker.add((delta) => {
//   // rotate the container!
//   // use delta to create frame-independent transform
//   container.rotation -= 0.01 * delta;
// });

//Add the canvas that Pixi automatically created for you to the HTML document
// And connect to the path in "lib/frobots_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.


// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/frobots_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/frobots_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/frobots_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:

const game = new Game();
console.log("Game Is -", game)
game.header()

function connectToSocket(match_id) {
  // connects to the socket endpoint
  let socket = new Socket("/socket", {params: {token: window.userToken}})
  socket.connect()
  let channel = socket.channel("match:" + match_id, {})
  // joins the channel
  channel.join()
  .receive("ok", resp => { 
    //Create a Pixi Application
    
  })
  .receive("error", resp => { console.log("Unable to join", resp) })
  //
  // channel.on("arena_event", payload => {
  //   console.log(payload)
  // })
}

export {connectToSocket}
