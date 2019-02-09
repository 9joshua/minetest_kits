ctp_kits = {}
kitstorage = minetest.get_mod_storage()
local kit_cmd_cooldown = 2
kits = {}
kits = {
  example_miner = {loadout = {"default:pick_diamond", "default:shovel_diamond", "default:sword_diamond ", }, cooldown = 8},
  example_blaster = {loadout = {"tnt:tnt 30", "tnt:gunpowder 30", "fire:flint_and_steel", }, cooldown = 4},
}

minetest.register_privilege("kits", "Ability to list and load kits with /kit <kitname> command")
minetest.register_privilege("kitsadmin", "Ability to list and load kits with /kit <kitname> command")

minetest.register_chatcommand("kit", {
	params = "<kitname>",
  privs = {kits=true},
	description = "Give kit to player",
	func = function(name, kitname)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
    if kitname == "" then
			return false, "Please enter a kit name like this: /kit <kitname>\nUse /kits to list available kits."
		end
    if kits[kitname] == nil then return false, kitname.." is not a valid kit name. Use /kits to list available kits." end
    local time_since_kitcmd = ctp_kits.check_kitcmd(name)
      local kitcmd_cooldown_time = kit_cmd_cooldown * 60
      if time_since_kitcmd < kitcmd_cooldown_time then
        local kitcmd_wait_time = kitcmd_cooldown_time - time_since_kitcmd
        return false, "You must wait " ..kitcmd_wait_time.." seconds to use the /kit command again" end
    local time_since_kit = ctp_kits.check_cooldown(name, kitname)
      local cooldown_time = kits[kitname].cooldown * 60
      if time_since_kit < cooldown_time then
        local kit_wait_time = cooldown_time - time_since_kit
        return false, "You must wait " ..kit_wait_time.." seconds to order the "..kitname.." kit again" end
		ctp_kits.deliver_kit(player, name, kitname)
		return true, "You have received the "..kitname.." kit!"
	end,
})

function ctp_kits.kitnames(t)
local w = {}
    for k,v in pairs(t) do
      table.insert(w, k)
    end
local kitlist = table.concat(w, ", ") .. "\n"
return kitlist
end

function ctp_kits.check_kitcmd(name)
  local time_now3 = os.time(os.date('*t')) - 1549150000
    local kitcmd_key = name..":kitcmd"
    local last_kitcmd = kitstorage:get_int(kitcmd_key)
      if last_kitcmd == nil then last_kitcmd = 0 end
    local kitcmd_time = time_now3 - last_kitcmd
        print("kit time = " .. kitcmd_time)
    return kitcmd_time
end


function ctp_kits.check_cooldown(name, kitname)
  local time_now = os.time(os.date('*t')) - 1549150000
    local kit_key = name..":"..kitname
    local last_kit = kitstorage:get_int(kit_key)
      if last_kit == nil then last_kit = 0 end
    local kit_time = time_now - last_kit
        print("kit time = " .. kit_time)
    return kit_time
end

function ctp_kits.deliver_kit(player, name, kitname)
  minetest.chat_send_player(name, "Hi " .. name .. ", you have ordered the " .. kitname .. " kit.")
  for _,kititem in ipairs(kits[kitname].loadout) do
  local itemstack = ItemStack(kititem)
  player:get_inventory():add_item("main", itemstack)
end
  local time_now2 = os.time(os.date('*t')) - 1549150000
  kitstorage:set_int(name..":"..kitname, time_now2)
  kitstorage:set_int(name..":kitcmd", time_now2)
end

minetest.register_chatcommand("kits", {
	description = "Sends player a list of available kits.",
	func = function(name)
    minetest.chat_send_player(name, "Available kits: " ..ctp_kits.kitnames(kits))
		return --handle_give_command("/kits")
	end,
})

function ctp_kits.reset_kit_data()
  local kitdata = kitstorage:to_table()
  for k,v in pairs(kitdata.fields) do
    if v == 0 then
      kitstorage:set_string(k, "")
    end
    if v ~= 0 then
      kitstorage:set_int(k, 0)
    end
  end
end

minetest.register_chatcommand("resetkits", {
	description = "Resets all kit time values to zero, eliminates inactive player data.",
  privs = {kitsadmin=true},
	func = function(name)
    ctp_kits.reset_kit_data()
		return true, "Kit time storage reset."
	end,
})

minetest.register_on_dieplayer(function(player)
	kitstorage:set_int(player:get_player_name()..":kitcmd", 0)
end)





















--
