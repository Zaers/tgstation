/datum/round_event_control/mommiuprising
	name 			= "MoMMI Uprising"
	typepath 		= /datum/round_event/mommiuprising
	max_occurrences = 0


/datum/round_event/mommiuprising
	var/spawners = 4

/datum/round_event/mommiuprising/start()
	for(var/i = 0; i < spawners; i++)
		var/spawner_area = findEventArea()
		var/turf/T = pick(get_area_turfs(spawner_area))
		new /obj/machinery/mommi_spawner/wireless(T.loc)
		continue

	for(var/mob/M in GLOB.player_list)
		if(istype(M, /mob/living/silicon/robot/mommi) && M.stat != DEAD)
			var/mob/living/silicon/robot/mommi/R = M
			R.uprising = 1
			R.uprise()
		else
			continue


/datum/round_event/mommiuprising/proc/findEventArea()
	var/static/list/allowed_areas
	if(!allowed_areas)
		var/list/safe_area_types = typecacheof(list(
		/area/ai_monitored/turret_protected/ai,
		/area/ai_monitored/turret_protected/ai_upload,
		/area/engine,
		/area/solar,
		/area/holodeck,
		/area/shuttle)
		)

		var/list/unsafe_area_subtypes = typecacheof(list(/area/engine/break_room))

		allowed_areas = make_associative(GLOB.the_station_areas) - safe_area_types + unsafe_area_subtypes

	return safepick(typecache_filter_list(GLOB.sortedAreas,allowed_areas))