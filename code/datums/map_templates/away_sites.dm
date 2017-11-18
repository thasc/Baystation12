// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

/datum/map_template/ruin/away_site // why is this a ruin again? should fix our hierarchy...
	prefix = "maps/away/"
	allow_duplicates = FALSE // duplicating these will probably screw up shuttles etc!

/datum/map_template/ruin/away_site/bearcat_wreck
	name = "Bearcat Wreck"
	id = "awaysite_bearcat_wreck"
	description = "A wrecked light freighter."
	suffixes = list("bearcat/bearcat-1.dmm", "bearcat/bearcat-2.dmm")
	cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/ferry/lift)

/datum/map_template/ruin/away_site/derelict
	name = "Derelict Station"
	id = "awaysite_derelict"
	description = "An abandoned construction project."
	suffixes = list("derelict/derelict-station.dmm")
	cost = 1
	accessibility_weight = 10

/datum/map_template/ruin/away_site/lost_supply_base
	name = "Lost Supply Base"
	id = "awaysite_lost_supply_base"
	description = "An abandoned supply base."
	suffixes = list("lost_supply_base/lost_supply_base.dmm")
	cost = 1

/datum/map_template/ruin/away_site/marooned
	name = "Marooned"
	id = "awaysite_marooned"
	description = "A snowy wasteland."
	suffixes = list("marooned/marooned.dmm")
	cost = 1

/datum/map_template/ruin/away_site/mining_asteroid
	name = "Mining - Asteroid"
	id = "awaysite_mining_asteroid"
	description = "A medium-sized asteroid full of minerals."
	suffixes = list("mining/mining-asteroid.dmm")
	cost = 1
	accessibility_weight = 10

/datum/map_template/ruin/away_site/mining_signal
	name = "Mining - Planetoid"
	id = "awaysite_mining_signal"
	description = "A mineral-rich, formerly-volcanic site on a planetoid."
	suffixes = list("mining/mining-signal.dmm")
	cost = 1
	base_turf_for_zs = /turf/simulated/floor/asteroid

/datum/map_template/ruin/away_site/smugglers
	name = "Smugglers' Base"
	id = "awaysite_smugglers"
	description = "Yarr."
	suffixes = list("smugglers/smugglers.dmm")
	cost = 1
