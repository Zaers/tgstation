

/mob/living/silicon/robot/mommi/say(message, bubble_type, var/list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null) //>saycode hacks
	if(keeper) //keeper hacks to make it automatically talk in mommitalk
		if(check_emote(message))
			return
		if(sanitize)
			message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
		if(!message || message == "")
			return
		message = ":d [message]" //this really cucks them out of posting in binary chat as keepers, but that
	. = ..()



/mob/living/proc/mommi_talk(var/message)
	var/rendered = "<span class='mommi game say'>Damage Control, <span class='name'>[name]:</span> <span class='message'>[message]</span></span>"
	for(var/mob/M in GLOB.player_list)
		if(ismommi(M))
			to_chat(M, "[rendered]")
		if(isobserver(M))
			var/following = src
			var/link = FOLLOW_LINK(M, following)
			to_chat(M, "span class='linkify'>[link] [rendered]</span>")