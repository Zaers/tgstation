/mob/living/silicon/robot/mommi/gib(var/animation = 1)
	if(generated)
		src.dust()
	if(src.module && istype(src.module))
		if(!is_in_modules(tool_state))
			dropItemToGround(tool_state)

	..()


/mob/living/silicon/robot/mommi/dust(var/animation = 1)
	if(src.module && istype(src.module)) //Drop what it's holding if it isn't a module
		if(!is_in_modules(tool_state))
			dropItemToGround(tool_state)
	if(mmi)
		qdel(mmi)
	..()

/mob/living/silicon/robot/mommi/death(gibbed)
	if(stat == DEAD)	return
	if(!gibbed)
		emote("deathgasp")
	stat = DEAD

	. = ..(gibbed)
	gib() //blows you up