/client/proc/map_template_load()
	set category = "Debug"
	set name = "Map Template - Place"

	var/map = input(usr, "Choose a Map Template to place at your CURRENT LOCATION","Place Map Template") as null|anything in SSmapping.map_templates
	if(!map)
		return

	var/datum/map_template/template = SSmapping.map_templates[map]

	var/turf/T = get_turf(mob)
	if(!T)
		return

	var/list/preview = list()
	for(var/S in template.get_affected_turfs(T,centered = TRUE))
		preview += image('icons/turf/overlays.dmi',S,"greenOverlay")
	usr.client.images += preview
	if(alert(usr,"Confirm location.","Template Confirm","Yes","No") == "Yes")
		if(template.load(T, centered = TRUE))
			log_and_message_admins("has placed a map template ([template.name]) at [T.loc].")
		else
			to_chat(usr, "Failed to place map")
	usr.client.images -= preview

/client/proc/map_template_load_new_z()
	set category = "Debug"
	set name = "Map Template - Place In New Z"

	var/map = input(usr, "Choose a Map Template to place on a new zlevel","Place Map Template") as null|anything in SSmapping.map_templates
	if(!map)
		return

	var/datum/map_template/template = SSmapping.map_templates[map]
	var/new_z_centre = template.load_new_z()
	if (new_z_centre)
		log_and_message_admins("has placed a map template ([template.name]) on a new zlevel.", location=new_z_centre)
	else
		to_chat(usr, "Failed to place map")

/client/proc/map_template_upload()
	set category = "Debug"
	set name = "Map Template - Upload"

	var/map = input(usr, "Choose a Map Template to upload to template storage","Upload Map Template") as null|file
	if(!map)
		return
	if(copytext("[map]",-4) != ".dmm")
		to_chat(usr, "Bad map file: [map]")
		return

	var/datum/map_template/M = new(map, "[map]")
	if(M.preload_size(map))
		to_chat(usr, "Map template '[map]' ready to place ([M.width]x[M.height])")
		SSmapping.map_templates[M.name] = M
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has uploaded a map template ([map])</span>")
	else
		to_chat(usr, "Map template '[map]' failed to load properly")
