SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates = list()

	var/list/space_ruins_templates = list()
	var/list/exoplanet_ruins_templates = list()
	var/list/away_site_templates = list()

/datum/controller/subsystem/mapping/Initialize(timeofday)
	preloadTemplates()
	spawnAwaySites()
	..()

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	exoplanet_ruins_templates = SSmapping.exoplanet_ruins_templates
	away_site_templates = SSmapping.away_site_templates

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T
	preloadAutoSpawnTemplates()

/datum/controller/subsystem/mapping/proc/preloadAutoSpawnTemplates()
	// Still supporting bans by filename
	var/list/banned = generateMapList("config/exoplanet_ruin_blacklist.txt")
	banned += generateMapList("config/space_ruin_blacklist.txt")
	banned += generateMapList("config/away_site_blacklist.txt")

	for(var/item in sortList(subtypesof(/datum/map_template/preregistered), /proc/cmp_ruincost_priority))
		var/datum/map_template/preregistered/template_type = item
		// screen out the abstract subtypes
		if(!initial(template_type.id))
			continue
		var/datum/map_template/preregistered/T = new template_type()

		if(banned.Find(T.mappath))
			continue

		map_templates[T.name] = T

		if(istype(T, /datum/map_template/preregistered/ruin/exoplanet))
			exoplanet_ruins_templates[T.name] = T
		else if(istype(T, /datum/map_template/preregistered/ruin/space))
			space_ruins_templates[T.name] = T
		else if(istype(T, /datum/map_template/preregistered/away_site))
			away_site_templates[T.name] = T

/datum/controller/subsystem/mapping/proc/spawnAwaySites()

	var/list/weighted_sites = list()
	for (var/away_site_name in away_site_templates)
		var/datum/map_template/preregistered/AS = away_site_templates[away_site_name]
		weighted_sites[AS] = AS.cost

	if (weighted_sites.len == 0)
		report_progress("No registered away sites to load")
		return

	var/budget = GLOB.using_map.away_site_budget

	while (budget > 0 && weighted_sites.len > 0)
		report_progress("Loading away site...")
		var/datum/map_template/preregistered/AS = pickweight(weighted_sites)
		AS.load_new_z()
		budget -= AS.cost
		weighted_sites -= AS