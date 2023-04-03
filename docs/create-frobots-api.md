This document will summarise the functions called and the responses received in different liveviews.

## Homelive (dashboard)

Functions related to created to creating and managing fobots are locates in side   **apps/frobots/assets.ex**



**list user frobost**

Assets.list_user_frobots(current_user)).  Note:  current_user is extracted from socket inside elixir.

%{

&nbsp;&nbsp;&nbsp;&nbsp;id: 5,

&nbsp;&nbsp;&nbsp;&nbsp;name: "sniper",

&nbsp;&nbsp;&nbsp;&nbsp;brain_code: "-- lua code-- ",

&nbsp;&nbsp;&nbsp;&nbsp;class: "Proto",

&nbsp;&nbsp;&nbsp;&nbsp;xp: 0,

&nbsp;&nbsp;&nbsp;&nbsp;blockly_code: "blocky code",

&nbsp;&nbsp;&nbsp;&nbsp;avatar: "<https://via.placeholder.com/50.png>",

&nbsp;&nbsp;&nbsp;&nbsp;user_id: 1,

&nbsp;&nbsp;&nbsp;&nbsp;user: \<current_user\>,

&nbsp;&nbsp;&nbsp;&nbsp;equipment: [],

&nbsp;&nbsp;&nbsp;&nbsp;inserted_at: \<timestamp\>,

&nbsp;&nbsp;&nbsp;&nbsp;updated_at: \<timestamp\>

}



**get featured frobots**
get_featured_frobots(): currently this is a function that returns a static list with the following shape

[%{

"name" =\> "X-tron",

"xp" =\> "65700 xp",

"image_path" =\> base_path \<\> "/featured_one.png"

}]



**get blog posts**

This is the structure of the blog posts payload

[{

&nbsp;&nbsp;&nbsp;&nbsp;"id": "6371bab185134604362c677a",

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"title": "First post!",

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"html": "\<p\>post html\</p\>",

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"feature_image": "<https://static.ghost.org/v4.0.0/images/feature-image.jpg>",

&nbsp;&nbsp;&nbsp;&nbsp;"url": "<https://ghost.fubars.tech/first-post/>"}]



**get user stats**
Assets.get_user_stats(current_user):  returns the current users stats with the following shape

*Note:* current_user is extracted from socket inside elixir. FE does not need to be concerned with this.

%{

frobots_count: 4,

total_xp: 600,

matches_participated: 12,

upcoming_matches: 0

}



**show global stats**
show_global_stats(): This function currently returns a static map. With updated Matches and Slots tables, we will be able to get the data below from the DB. **This is new code to be written.**



%{

"players_online" =\> 250,

"matches_in_progress" =\> 65,

"players_registered" =\> 1500,

"matches_completed" =\> 376

}



## Frobot leaderboard stats

This is shape of data of frobot leaderboard stats:

[{ frobot: "spinner",

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;username: "bob", //string

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;points: 44,  //integer

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;xp: 100, //integer

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;attempts: 4, //integer

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;matches_won: 4, //integer

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;matches_participated: 4, //integer

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;frobots_count: 4,

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;avatar: "path/frobot.png"

}]

## player leaderboard stats

This is shape of data of player leaderboard stats:

[{username: "bob", //string

points: 44,  //integer

xp: 100, //integer

attempts: 4, //integer

matches_won: 4, //integer

matches_participated: 4, //integer

frobots_count: 4,

avatar: "path/user_avatar.png"



}]



## garage

**list user frobots**
Assets.list_user_frobots(current_user): Fetches frobots owned by current user

*Note:* current_user is extracted from socket inside elixir. FE does not need to be concerned with this.

{

&nbsp;&nbsp;&nbsp;&nbsp;id: 5,

&nbsp;&nbsp;&nbsp;&nbsp;name: "sniper",

&nbsp;&nbsp;&nbsp;&nbsp;brain_code: "-- lua code-- ",

&nbsp;&nbsp;&nbsp;&nbsp;class: "Proto",

&nbsp;&nbsp;&nbsp;&nbsp;xp: 0,

&nbsp;&nbsp;&nbsp;&nbsp;blockly_code: "blocky code",

&nbsp;&nbsp;&nbsp;&nbsp;avatar: "<https://via.placeholder.com/50.png>",

&nbsp;&nbsp;&nbsp;&nbsp;user_id: 1,

&nbsp;&nbsp;&nbsp;&nbsp;user: \<current_user\>,

&nbsp;&nbsp;&nbsp;&nbsp;equipment: [],

&nbsp;&nbsp;&nbsp;&nbsp;inserted_at: \<timestamp\>,

&nbsp;&nbsp;&nbsp;&nbsp;updated_at: \<timestamp\>

}



equipment:

**list template frobots**
Assets.list_template_frobots():  returns a list of template frobots with the following shape.

[%{

&nbsp;&nbsp;&nbsp;&nbsp;id: 6,

&nbsp;&nbsp;&nbsp;&nbsp;name: "target",

&nbsp;&nbsp;&nbsp;&nbsp;brain_code: "brain code....",

&nbsp;&nbsp;&nbsp;&nbsp;blockly_code: nil,

&nbsp;&nbsp;&nbsp;&nbsp;avatar: "<https://via.placeholder.com/50.png>",

&nbsp;&nbsp;&nbsp;&nbsp;user_id: 1,

&nbsp;&nbsp;&nbsp;&nbsp;user: \<user_object\>,

&nbsp;&nbsp;&nbsp;&nbsp;inserted_at: \<timestamp\>,

&nbsp;&nbsp;&nbsp;&nbsp;updated_at: \<timestamp\>

}]



**list xframes**
Assets.get_xframes(): Returns list of xframes

[{

&nbsp;&nbsp;&nbsp;&nbsp;id: 10,

&nbsp;&nbsp;&nbsp;&nbsp;xframe_type: :Chassis_Mk3,

&nbsp;&nbsp;&nbsp;&nbsp;max_speed_ms: 40,

&nbsp;&nbsp;&nbsp;&nbsp;turn_speed: 65,

&nbsp;&nbsp;&nbsp;&nbsp;scanner_hardpoint: 2,

&nbsp;&nbsp;&nbsp;&nbsp;weapon_hardpoint: 1,

&nbsp;&nbsp;&nbsp;&nbsp;movement_type: :hover,

&nbsp;&nbsp;&nbsp;&nbsp;max_health: 80,

&nbsp;&nbsp;&nbsp;&nbsp;max_throttle: 100,

&nbsp;&nbsp;&nbsp;&nbsp;accel_speed_mss: 7,

&nbsp;&nbsp;&nbsp;&nbsp;inserted_at:  \<timestamp\>,

&nbsp;&nbsp;&nbsp;&nbsp;updated_at: \<timestamp\>

}]



**list cannons**
Assets.get_cannons(): returns list of cannons

[%{

&nbsp;&nbsp;&nbsp;&nbsp;id: 1,

&nbsp;&nbsp;&nbsp;&nbsp;cannon_type: :Cannon_Mk1,

&nbsp;&nbsp;&nbsp;&nbsp;reload_time: 5,

&nbsp;&nbsp;&nbsp;&nbsp;rate_of_fire: 1,

&nbsp;&nbsp;&nbsp;&nbsp;magazine_size: 2,

&nbsp;&nbsp;&nbsp;&nbsp;inserted_at: \<timestamp\>,

&nbsp;&nbsp;&nbsp;&nbsp;updated_at: \<timestamp\>

}]



**Scanners**

Assets.get_scanners(): return list of scanners

[%{

&nbsp;&nbsp;&nbsp;&nbsp;id: 5,

&nbsp;&nbsp;&nbsp;&nbsp;scanner_type: :Scanner_Mk1,

&nbsp;&nbsp;&nbsp;&nbsp;max_range: 700,

&nbsp;&nbsp;&nbsp;&nbsp;resolution: 10,

&nbsp;&nbsp;&nbsp;&nbsp;inserted_at: \<timestamp\>,

&nbsp;&nbsp;&nbsp;&nbsp;updated_at: \<timestamp\>

}]



**Missiles**

Assets.get_missiles(): return list of missiles

[%{

&nbsp;&nbsp;&nbsp;&nbsp;id: 3,

&nbsp;&nbsp;&nbsp;&nbsp;missile_type: :Missile_Mk1,

&nbsp;&nbsp;&nbsp;&nbsp;damage_direct: [5, 10],

&nbsp;&nbsp;&nbsp;&nbsp;damage_near: [20, 5],

&nbsp;&nbsp;&nbsp;&nbsp;damage_far: [40, 3],

&nbsp;&nbsp;&nbsp;&nbsp;speed: 400,

&nbsp;&nbsp;&nbsp;&nbsp;range: 900,

&nbsp;&nbsp;&nbsp;&nbsp;inserted_at: \<timestamp\>,

&nbsp;&nbsp;&nbsp;&nbsp;updated_at: \<timestamp\>

}]



**Create Frobot: Call create_frobot event in garage_live/index.ex**

To create a frobot the following information must be passed to *create_frobot.* To upload avatar image, s3 url will be passed via socket and made available to react. React will upload image to this location and pass the path back to elixir.

* name:  string , required
* brain_code: string, required
* avatar: string, optional
* bio: string, optional
* pixellated_img: string, optional
* blockly_code: string, optional

On successful creation of frobot, current user frobot list is updated and add to socket.

on error: error_message field in socket is set with error messages in the following format. For example when we attempt to create a frobot without passsing brain_code and name which are mandatory



[ brain_code: {"can't be blank", [validation: :required]},

name: {"can't be blank", [validation: :required]} ]



**Update Frobot: Call update_frobot event in garage_live/index.ex**

To update an existing frobot pass the following info

frobot_id  and any of the following fields

* brain_code - string
* avatar - string
* brain_code: string
* bio
* pixellated_img

frobot_id is required, you can send a combination of the rest of the fields. For updating braincode, frobot bio or avatar, update_frobot event is called



**Create Frobot Equipment**

This function is called when new equipement instances are added to frobots.  From the front end "*create_frobot_equipment*" event is called the following parameters must be passed

* Frobot id,
* instance type ( xframe, cannon, scanner, missile)
* instance params (for cannon instance , you need to pass reload_time, rate_of_fire, magazine_size

**delete Frobot Equipment**

This function is called when equipement instances need to be detached from frobot.  From the front end "*delete_frobot_equipment*" event is called with the following parameters

* equipment_instance_id

Note: This is a **new event** that i will be adding to garage_live/index.ex



**get frobot equipment details (new)**

Need to create **new event** in garage_frobotdetails_live/index.ex  "get_frobot_equipment_details", FE must call this event with equipment_id and equipment_type ( ex: xframe, cannon, scanner, missile)

* returns equipment_detail if successful
* nil on failure
* 

**Get frobot battlelogs (new)**

Call get_frobot_battle_logs(frobot_id) with the following params. This function will return a combination of completed, upcoming and scheduled matches where this particular frobot oparticipated or will participate.



[

{  "match_id":  123,

&nbsp;&nbsp;&nbsp;&nbsp;"match_name": "mymatch",

&nbsp;&nbsp;&nbsp;&nbsp;"winner_name":  "winning frobot name",

&nbsp;&nbsp;&nbsp;&nbsp;"xp" : 100,

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"status" :  "completed\| upcoming\| live",

&nbsp;&nbsp;&nbsp;&nbsp;"time":  \<timestamp\>  //denotes when match was completed/scheduled to start or started

}]
