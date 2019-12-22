/obj/item/modular_computer/wrist_comp
	name = "wrist computer"
	icon = 'icons/obj/modular_wrist.dmi'
	icon_state = "wristcomp"
	icon_state_unpowered = "wristcomp"
	icon_state_powered = "wristcomp"
	icon_state_menu = "menu"
	actions_types = list(/datum/action/item_action/compactivate)
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 2 //not as weak as a tablet when it comes to hardware
	w_class = WEIGHT_CLASS_SMALL
	steel_sheet_cost = 1
	slot_flags = ITEM_SLOT_WRIST
	has_light = TRUE
	comp_light_luminosity = 2.3

/obj/item/modular_computer/wrist_comp/update_icon()
	..()

/obj/item/modular_computer/wrist_comp/preset/advanced/Initialize()
	. = ..()
	install_component(new /obj/item/computer_hardware/processor_unit/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/stock_parts/cell/computer))
	install_component(new /obj/item/computer_hardware/hard_drive/small)
	install_component(new /obj/item/computer_hardware/network_card)
	install_component(new /obj/item/computer_hardware/card_slot)
	install_component(new /obj/item/computer_hardware/printer/mini)