# Getting Started

Welcome to FROBOTs!

FROBOTs are functions. They are essentially recursive functions. 
The FROBOTs are edited in Lua, or through the Block Editor in the Garage page of the platform.  To start, head over to http://frobots.io and setup an account.  Once you have logged onto the account you will be brought to the Dashboard where you can see the high level details of your statistics, latest news, matches, blogs and the number of other players online.

Head on over to the Garage, where we can get started with writing your first FROBOT!

## The Garage

Here is where you can build, upgrade, and gear up your FROBOTs that you own.  Each can be seen as an icon to the side.  When you create a new FROBOT, you will be asked if you want to start the frobot modelled after an existing PROTObot.  These PROTOBOTs are prototypes of basic strategies which you can modify and customize, and represent just some very basic tactics that you can employ in your FROBOT.  We encourage you to experient with other ones, combinations of them, or invent your own!  Your FROBOTs success in the arena will reflect upon YOUR coding skills and ingenuity, so don't hesitate to experiment! 

FROBOTs comprised of BRAINCODE, BLOCKCODE, and installed equipment.  We will go over each in turn:

BRAINCODE is the Lua code that your represents your FROBOT's brain.  It is actually the code that runs on the simulator, and it is structured as one function that takes a STATE object and returns a STATE object.  Objects are represented as Lua tables.  The STATE object is the one place where your braincode can store information that is retrievable at the next iteration of the function call.  It is essential to store state variable in the STATE object without which your FROBOTs brain would have no way to store information between cycles.

BLOCKCODE is the block representation of code that helps you create your BRAINCODE.  Blocks can be dragged and dropped in the editor which makes it easy to assemble BRAINCODE.  While you create blocks, the Lua code that is representative of the blocks is shown to the right.  After you are done, you can click SYNC button, to copy over the Lua code from the blocks into your BRAINCODE.  Also, when you click SAVE, BRAINCODE and the BLOCKCODE is saved.  Keep in mind that only the BRAINCODE is used when your FROBOT is run.

When you create a new FROBOT you will be given a full set of MK1, and MK2 equipments with the FROBOT.  These include:
1) Cannon Mk1, Mk2
2) Scanner Mk1, Mk2
3) Missile Mk1, Mk2
4) Chassis Mk1, Mk2

### Equipping your FROBOT

In the Garage, you can click the Equipment Bay, which will take you to the equipping screen.  This is where you can setup your FROBOT.

A FROBOT must start with a basic XFrame.  An XFrame provides the general Hitpoints and mobility options of your robot.  It also determines how many weapon and sensor slots that your FROBOT can equippe.  

Weapons include cannons, which fire projectiles. What ammunition is loaded for each cannon determines what it will fire.
Sensors help your FROBOT detect where its enemies are, so that you can blow them up!

Cannons is your primary weapon.  They fire a certain distance, a magazine size and a rate of fire, which is the number of shots that can be made in 1 second.  After emptying the magazine, you must wait the reload time to get a new full magazine.

Scanners are your primary sensor.  They send a directed radar ping in a given direction.  If an enemy is detected, then the distance at which they were detected is returned.  You should then fire your gun at that bearing and distance!

#### Slots

Slots is the number of weapons or sensors that you can equippe.  The number of slots is determined by the Xframe that you are using.


