# Getting Started

The frobots_client repository contains the client app and simulator GUI that you need to run the FUBARs arena to develop your own Frobots locally.

FROBOTS are functions. They are essentially recursive functions.

## Login to Beta Server

Website is at [http://beta.frobots.io](http://beta.frobots.io)

 But you need to login with the invite link you recieved in your email. The first time you login, you will be asked to change your password.

## Running the Client

### Dependencies

The client uses the Scenic library for Elixir, which is a thin gui library for IoT interfaces, but works well enough for our purposes.

Install OpenGL dependencies [https://hexdocs.pm/scenic/install_dependencies.html#content](https://hexdocs.pm/scenic/install_dependencies.html#content)

Running the pre-built install or binary

1. Download the latest release [here](https://github.com/Bittoku/frobots_client/).

2. Unzip the files and start a new terminal session in that directory.

3. Run the client:

    If you downloaded the tar file

    ```lua
    <tardir>/bin/frobots_client start
    ```

    or if you downloaded the prebuilt single binary

    ```lua
    ./frobots_client
    ```

4. Login by entering your beta access username and password on the
            client landing page. You only need to do this once.

5. If you have not created a frobot before, you should create a new
            frobot, create a bots dir in your $HOME dir, and create a .lua file.
            The name of the file will be your FROBOT name

    ```lua
    $HOME/bots/[myfrobot].lua
    ```  

6. You can use any editor or IDE to create and edit the .lua file, and  you may find it easiest to keep the file open. Save it.

7. On the client, upload your FROBOT to the beta server with the Upload
            button. The client looks for all *.lua files in your $HOME/bots dir.

8. If you previously updoaded FROBOTS but have deleted the local copies
            of their brain files, you can press the Download button to get saved
            Frobots. These FROBOTs will overwrite any in your /bots directory.

9. Once uploaded, you should be able to see you FROBOT in the dropdown
            list, to choose to battle.

10. Click FIGHT to start the match.

11. After the match, the results will be recorded. You can check the
            results on the beta console&apos;s Leaderboard page.

12. You should upload your FROBOTs code often, as it is only the copy
            that is on the server which is used in matches, not your local
            editable copy.

13. Instructions on how to program your FROBOT can be found on the beta
            console page, but you can experiment!

14. You can only play your FROBOT against proto-bots for the beta. After
            the game is released you will be able to pit your FROBOT against
            other users FROBOTs in FUBARs.

15. You can create as many FROBOTS as you like. But only a maximum of 3
            will be preserved post-beta. The rest will go into the parts bin!

### OPTIONAL Building locally

1. Clone the game client repository

   ```lua
   git clone git@github.com:Bittoku/frobots_client.git
   --recurse-submodules
   ```

2. Ensure you have Elixir 1.13 installed and Erlang 24, as there are
        some incompatibilities with Erlang 25 with some of the dependencies.

3. If you need to switch versions, install a version manager like [asdf](https://asdf-vm.com/guide/getting-started.html)

4. Update your needed deps and build a release binary for the client using the following command:

   ```lua
   frobots_client$ mix deps.get

   frobots_client$ MIX_ENV=prod mix release frobots_client
   ```

5. Run the binary

   ```lua
   frobots_client<rel version>/bin/frobots_client start
   ```
