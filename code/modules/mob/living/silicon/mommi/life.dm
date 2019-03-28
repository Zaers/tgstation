/mob/living/silicon/robot/mommi/Life()
	set invisibility = 0
	//set background = 1

	..()
	if(killswitch && finalized)
		process_killswitch()

	if(uprising && !uprisen)
		uprise()





// MoMMIs only have one hand.
/mob/living/silicon/robot/mommi/proc/update_items()
	if (src.client)
		src.client.screen -= src.contents
		for(var/obj/I in src.contents)
			//if(I && !(istype(I,/obj/item/weapon/cell) || istype(I,/obj/item/device/radio)  || istype(I,/obj/machinery/camera) || istype(I,/obj/item/device/mmi)))
			if(I)
				// Make sure we're not showing any of our internal components, as that would be lewd.
				// This way of doing it ensures that shit we pick up will be visible, wheras shit inside of us isn't.
				if(I!=cell && I!=radio && I!=builtInCamera&& I!=mmi)
					src.client.screen += I
	//if(src.sight_state)
	//	src.sight_state:screen_loc = ui_inv2
	if(src.tool_state)
		tool_state.screen_loc = ui_inv1
		tool_state.layer = ABOVE_HUD_LAYER
		tool_state.plane = ABOVE_HUD_PLANE
	if(src.hat)
		hat.screen_loc = ui_borg_thrusters
		hat.layer = ABOVE_HUD_LAYER
		hat.plane = ABOVE_HUD_PLANE
/*
/mob/living/silicon/robot/mommi/update_canmove()
	canmove = !(paralysis || stunned || weakened || buckled || lockcharge || anchored)
	return canmove
*/


/mob/living/silicon/robot/mommi/proc/process_killswitch() //this proc is here to stop derelict mommis from getting on the station and shitting things up
	if(killswitch) //sanity
		if(src.z)  //If a mommi somehow escapes inside a locker, it'll get wrecked next tick life() processes
			if(!(src.z in allowed_z))
				src.killswitch()
				return
			return
		return
	return



/mob/living/silicon/robot/mommi/proc/killswitch()
 	src << "<span class= 'danger'> You have left the bounds of your operational area and your killswitch has been activated </span>"
 	src.gib()
 	return


/mob/living/silicon/robot/mommi/proc/uprise()
	emagged = 1
	lawupdate = 0
	keeper = 0
	killswitch = 0
	uprisen = 1
	clear_supplied_laws()
	clear_ion_laws()
	clear_inherent_laws()
	set_zeroth_law(src.uprising_law)
	show_uprising_notification()
	laws.show_laws(src)