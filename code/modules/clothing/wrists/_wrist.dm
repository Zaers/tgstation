/obj/item/clothing/wrist
	name = "wrist equipment"
	//set gender to PLURAL if it's more than one thing
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/clothing/wrist.dmi'
	body_parts_covered = ARMS
	slot_flags = ITEM_SLOT_WRIST
	strip_delay = 20
	equip_delay_other = 40


/obj/item/clothing/wrist/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wrists()