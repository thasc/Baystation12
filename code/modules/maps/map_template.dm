/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round

/datum/map_template/New(path = null, rename = null)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path)
	var/bounds = maploader.load_map(file(path), 1, 1, 1, cropMap=FALSE, measureOnly=TRUE)
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
	return bounds

/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/atom/atoms = list()

	var/list/turfs = block(	locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
							locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	for(var/L in turfs)
		var/turf/B = L
		atoms += B
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
				continue
			if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A

	SSatoms.InitializeAtoms(atoms)
	SSmachines.setup_powernets_for_cables(cables)

	for(var/obj/machinery/atmospherics/A in atmos_machines)
		A.atmos_init()

	for(var/obj/machinery/atmospherics/unary/U in atmos_machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	for(var/obj/machinery/atmospherics/machine in atmos_machines)
		machine.build_network()

/datum/map_template/proc/load_new_z()
	var/x = round(world.maxx/2)
	var/y = round(world.maxy/2)

	var/list/bounds = maploader.load_map(file(mappath), x, y)
	if(!bounds)
		return FALSE

	//smooth_zlevel(world.maxz) TODO: what's this OwO
	// repopulate_sorted_areas()  TODO: what's this OwO

	// SSlighting.initialize_lighting_objects(block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))) TODO: what's this OwO
	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	log_game("Z-level [name] loaded at at [x],[y],[world.maxz]")

/datum/map_template/proc/load(turf/T, centered = FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	var/list/bounds = maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE)
	if(!bounds)
		return

	// TODO: what's these two OwO
	//if(!SSmapping.loading_ruins) //Will be done manually during mapping ss init
	//	repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+width-1, placement.y+height-1, placement.z))


//for your ever biggening badminnery kevinz000
//❤ - Cyberboss
/proc/load_new_z_level(var/file, var/name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()
