/datum/map_template/preregistered
	name = null
	var/id = null // For blacklisting purposes, all ruins need an id
	var/description = "it looks suspiciously generic"
	var/prefix = null
	var/suffix = null

	var/cost = null //negative numbers will always be placed, with lower (negative) numbers being placed first; positive and 0 numbers will be placed randomly
	var/allow_duplicates = TRUE

/datum/map_template/preregistered/New()
	if(!name && id)
		name = id

	mappath = prefix + suffix
	..(path = mappath)
