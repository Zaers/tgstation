//These procs handle putting stuff in your hand. It's probably best to use these rather than setting stuff manually
//as they handle all relevant stuff like adding it to the player's screen and such

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)

/mob/living/silicon/robot/mommi/get_active_held_item()
	return module_active



/mob/living/silicon/robot/mommi/proc/is_in_modules(obj/item/W, var/permit_sheets=0)
	// Exact matching for stacks (so we can load machines)
	if(!module)
		return 1
	if(istype(W, /obj/item/stack/sheet))
		for(var/obj/item/stack/sheet/S in src.module.modules)
			if(S.type==W.type)
				return permit_sheets ? 0 : S
	else
		return locate(W) in module.modules


/mob/living/silicon/robot/mommi/activate_module(var/obj/item/O)
	if(!(locate(O) in src.module.modules))
		return
	if(activated(O))
		to_chat(src, "<span class='notice'>Already activated</span>")
		return
	if(!tool_state)
		tool_state = O
		O.equipped(src, SLOT_HANDS)
		O.mouse_opacity = initial(O.mouse_opacity)
		O.layer = ABOVE_HUD_LAYER
		O.plane = ABOVE_HUD_PLANE
		observer_screen_update(O,TRUE)
		O.forceMove(src)
		if(hud_used)
			hud_used.update_robot_modules_display()

	// Make crap we pick up active so there's less clicking and carpal. - N3X
		module_active=tool_state
		if(inv_tool)
			inv_tool.icon_state = "inv1 +a"
	else
		to_chat(src, "<span class='notice'>You need to store a module first!</span>")

/mob/living/silicon/robot/mommi/toggle_module() //Only one module

	if(module_selected(INV_SLOT_TOOL))
		deselect_module(INV_SLOT_TOOL)
		if (hud_used)
			hud_used.update_robot_modules_display()
	else
		select_module(INV_SLOT_TOOL)
		if (hud_used)
			hud_used.update_robot_modules_display()
	return

/mob/living/silicon/robot/mommi/put_in_hands(var/obj/item/W)
	// Fixing NPEs caused by PDAs giving me NULLs to hold :V - N3X
	// And before you ask, this is how /mob handles NULLs, too.
	if(!W)
		return 0
	if(W == tool_state) //We're already holding it!
		return 1
	// Make sure we're not picking up something that's in our factory-supplied toolbox.
	//if(is_type_in_list(W,src.module.modules))
	if(is_in_modules(W))
		to_chat(src,"<span class='warning'> Picking up something that's built-in to you seems a bit silly.</span>")
		put_in_inactive_hand(W)
		return 0
	if(tool_state)
		//var/obj/item/found = locate(tool_state) in src.module.modules
		W.forceMove(drop_location())
		W.layer = initial(W.layer)
		W.plane = initial(W.plane)
		W.dropped(src)
		return 0
	tool_state = W
	if(istype(W))
		W.equipped(src, SLOT_HANDS)
		W.mouse_opacity = initial(W.mouse_opacity)
		W.layer = ABOVE_HUD_LAYER
		W.plane = ABOVE_HUD_PLANE

	W.forceMove(src) //ensures the loc is correct
	if (hud_used)
		hud_used.update_robot_modules_display()

	// Make crap we pick up active so there's less clicking and carpal. - N3X
	module_active=tool_state
	if(inv_tool)
		inv_tool.icon_state = "inv1 +a"
	//inv_sight.icon_state = "sight"

	if (hud_used)
		hud_used.update_robot_modules_display()
	return 1

//Attemps to remove an object on a mob.  Will not move it to another area or such, just removes from the mob.
/mob/living/silicon/robot/mommi/proc/remove_from_mob(var/obj/item/O)
	src.temporarilyRemoveItemFromInventory(O, 1)
	if (src.client)
		src.client.screen -= O
	O.layer = initial(O.layer)
	O.plane = initial(O.plane)
	O.screen_loc = null
	O.dropped(src)
	return 1


//makes it so unequipping unsets the module
/mob/living/silicon/robot/mommi/doUnEquip(obj/item/I, force, newloc, no_move, invdrop = TRUE) //Force overrides TRAIT_NODROP for things like wizarditis and admin undress.
	if(I == tool_state)
		uneq_module(I, newloc)
	else if (I == hat)
		unequip_head()
	return ..(I,force,newloc)


// Override the default /mob version since we only have one hand slot.
/mob/living/silicon/robot/mommi/put_in_active_hand(var/obj/item/W)
	// If we have anything active, deactivate it.
	if(!W)
		return 0
	if(get_active_held_item())
		uneq_active()
	if(is_in_modules(W))
		to_chat(src,"<span class='warning'> Picking up something that's built-in to you seems a bit silly.</span>")
		put_in_inactive_hand(W)
		return 0
	return put_in_hands(W)

/mob/living/silicon/robot/mommi/put_in_inactive_hand(var/obj/item/W)
	W.forceMove(drop_location())
	W.layer = initial(W.layer)
	W.plane = initial(W.plane)
	W.dropped(src)
	return 0




/*-------TODOOOOOOOOOO--------*/
// Called by store button
/mob/living/silicon/robot/mommi/uneq_active()
	var/obj/item/TS
	if(isnull(module_active))
		return
	if(tool_state == module_active)
		//var/obj/item/found = locate(tool_state) in src.module.modules
		TS = tool_state
		uneq_module(TS, drop_location())

/mob/living/silicon/robot/mommi/uneq_all()
	module_active = null

	unequip_head()
	uneq_module(tool_state, drop_location())
	if(hud_used)
		hud_used.update_robot_modules_display()

// Unequips an object from the MoMMI's head

/mob/living/silicon/robot/mommi/proc/unequip_head()
	// If there is a hat on the MoMMI's head
	if(hat)

		// Select the MoMMI's claw
		select_module(INV_SLOT_TOOL)

		// Put the hat in the MoMMI's claw
		put_in_hands(hat)
		if(hud_used)
			hud_used.update_robot_modules_display()
		// Delete the hat from the head
		hat = null

		// Update the MoMMI's head inventory icons
		update_icons()


/mob/living/silicon/robot/mommi/uneq_module(obj/item/O, atom/newloc)
	if(!O)
		return 0
	O.mouse_opacity = initial(O.mouse_opacity)
	if(client)
		client.screen -= O
	observer_screen_update(O,FALSE)

	if(module_active == O)
		module_active = null
	if(tool_state == O)
		inv_tool.icon_state = "inv1"
		tool_state = null

	if(is_in_modules(O))
		if(O.item_flags & DROPDEL)
			O.item_flags &= ~DROPDEL //we shouldn't HAVE things with DROPDEL_1 in our modules, but held items can have it. so this supposedly prevents shit from breaking
		O.forceMove(module)
	else
		if(!newloc)
			newloc = drop_location() //if still no loc, it'll runtime
		O.forceMove(newloc)
	O.dropped(src)
	O.cyborg_unequip(src)


	if(hud_used)
		hud_used.update_robot_modules_display()

	return 1

/mob/living/silicon/robot/mommi/activated(obj/item/O)
	if(tool_state == O)
		return 1
	else
		return 0


//Helper procs for cyborg modules on the UI.
//These are hackish but they help clean up code elsewhere.

//module_selected(module) - Checks whether the module slot specified by "module" is currently selected.
/mob/living/silicon/robot/mommi/module_selected(var/module) //Module is 1-3
	return module == get_selected_module()

//module_active(module) - Checks whether there is a module active in the slot specified by "module".
/mob/living/silicon/robot/mommi/module_active(var/module)
	if(!(module in list(INV_SLOT_TOOL)))
		return

	switch(module)
		if(INV_SLOT_TOOL)
			if(tool_state)
				return 1
	return 0

//get_selected_module() - Returns the slot number of the currently selected module.  Returns 0 if no modules are selected.
/mob/living/silicon/robot/mommi/get_selected_module()
	if(tool_state && module_active == tool_state)
		return INV_SLOT_TOOL

	return 0

//select_module(module) - Selects the module slot specified by "module"
/mob/living/silicon/robot/mommi/select_module(var/module)
	if(!(module in list(INV_SLOT_TOOL)))
		return
	if(!module_active(module)) return

	switch(module)
		if(INV_SLOT_TOOL)
			if(module_active != tool_state)
				inv_tool.icon_state = "inv1 +a"
				module_active = tool_state
				return
	return

//deselect_module(module) - Deselects the module slot specified by "module"
/mob/living/silicon/robot/mommi/deselect_module(var/module)
	if(!(module in list(INV_SLOT_TOOL)))
		return

	switch(module)
		if(INV_SLOT_TOOL)
			if(module_active == tool_state)
				inv_tool.icon_state = "inv1"
				module_active = null
				return
	return

//cycle_modules() - Cycles through the list of selected modules.
/mob/living/silicon/robot/mommi/cycle_modules()
	return

// Equip an item to the MoMMI. Currently the only thing you can equip is hats
// Returns a 0 or 1 based on whether or not the equipping worked

/mob/living/silicon/robot/mommi/equip_to_slot(obj/item/W as obj, slot, redraw_mob = 1)
	// If the parameters were given incorrectly, return an error
	if(!slot) return 0
	if(!istype(W)) return 0

	// If this item does not equip to this slot type, return
	if( !(W.slot_flags & ITEM_SLOT_HEAD) )
		return 0
	if(hat)
		to_chat(src, "<span class='warning'>You are already wearing a hat.</span>.")
		return 0

	// If the item is in the MoMMI's claw, we'll handle the removal later
	if(W == tool_state)
		// Don't allow the MoMMI to equip tools to their head. I mean, they cant anyways, but stop them here
		if(is_in_modules(tool_state))
			to_chat(src, "<span class='warning'>You cannot equip a module to your head.")
			return 0

	// For each equipment slot that the MoMMI can equip to
	switch(slot)
		// If equipping to the head
		if(SLOT_HEAD)
			// Grab whatever the MoMMI might already be wearing and cast it

			// If the MoMMI is already wearing a hat, put the active hat back in their claw

			// Put the item on the MoMMI's head
			src.hat = W
			W.equipped(src, slot)
			// Add the item to the MoMMI's hud
			if (client)
				hat.screen_loc = hat_slot.screen_loc
				client.screen += hat
			uneq_module(W, src) //hack, keeps the hat in the mob
		else
			to_chat(src, "<span class='warning'>You are trying to equip this item to an unsupported inventory slot. How the heck did you manage that? Stop it..</span>.")
			return 0
	// Set the item layer and update the MoMMI's icons
	W.layer = ABOVE_HUD_LAYER
	W.plane = ABOVE_HUD_PLANE
	update_icons()
	return 1

/mob/living/silicon/robot/mommi/attack_ui(slot)
	var/obj/item/W = tool_state
	if(istype(W))
		if(equip_to_slot(W, slot))
			if (hud_used)
				hud_used.update_robot_modules_display()
		else
			to_chat(src, "<span class='warning'>You are unable to equip that.</span>")
