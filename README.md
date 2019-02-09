Kits v1.0
==============
Adds kits and kit commands to Minetest


Configuration
-------------
This mod provides two sample kits: example miner and example_blaster
Follow the sample to add more kits. There is no limit to the number of kits that can be added.

There are several type of cooldowns for a particular kit and for the kit command...

Individual kit cooldown are specified in the kits table. For eample, the kit below has a cooldown of 8 minutes: 
`example_miner = {loadout = {"default:pick_diamond", "default:shovel_diamond", "default:sword_diamond ", }, cooldown = 8},`

The kit command cooldown time specifies, in minutes, how long a player must wait to use the /kit command again. The default value is 2 minutes and can be changed by setting the value of `local kit_cmd_cooldown`

By default, the kit command cooldown for a player resets to zero if they die. This can be configured by setting a new value for `local kit_cmd_cooldown_on_die`. To disable a reset of the kit command time on player death, set this value to -1.


Commands
--------
/kit <kitname>  Gives player the specified kit
/kits           Shows a list of available kits
/resetkits      Resets kit and kit command times for all players


Privileges
---------
Two privileges are added by this mod.
`kits` allows a player to use the /kit command
`kitsadmin` allows admin to reset the kit temporary data for all players.
