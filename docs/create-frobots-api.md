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

&nbsp;&nbsp;&nbsp;&nbsp;battlelogs: [],

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
show_global_stats(): This function currently returns a static map. It is TBD where these details come from now that nakama is out of scope at least for now.



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

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;frobots_count: 4

}]

## player leaderboard stats

This is shape of data of frobot leaderboard stats:

[{username: "bob", //string

points: 44,  //integer

xp: 100, //integer

attempts: 4, //integer

matches_won: 4, //integer

matches_participated: 4, //integer

frobots_count: 4

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

&nbsp;&nbsp;&nbsp;&nbsp;equipment: [ list of equipements owned by frobot]

&nbsp;&nbsp;&nbsp;&nbsp;battlelogs: [ battlelogs  in which frobot particpated in],

&nbsp;&nbsp;&nbsp;&nbsp;inserted_at: \<timestamp\>,

&nbsp;&nbsp;&nbsp;&nbsp;updated_at: \<timestamp\>

}]



**list xframes**
Assets.get_xframes()



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

To create a frobot the following information must be passed to create_frobot. To upload avatar image, s3 url will be passed via socket and made available to react. React will upload image to this location and pass the path back to elixir.



name:  string , required

brain_code: string, required

avatar: string, optional

blockly_code: string, optional

class: optional



On successful creation of frobot, current user frobot list is updated and add to socket.

on error: error_message field in socket is set with error messages in the following format. For example when we attempt to create a frobot without passsing brain_code and name which are mandatory



[

brain_code: {"can't be blank", [validation: :required]},

name: {"can't be blank", [validation: :required]}

]



**Create Frobot Equipment**



**Update Frobot: Call update_frobot event in garage_live/index.ex**

To update an existing frobot pass the following info

frobot_id: integer

brain_code - string

avatar - string

brain_code: string



frobot_id is required, you can send a combination of the rest of the fields.










