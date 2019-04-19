SUBSYSTEM_DEF(message_flagging)
	name = "Message Flagging"
	wait = 10 SECONDS
	priority = SS_PRIORITY_MSG_FLAGGING
	flags = SS_NO_INIT
	var/tmp/list/flagged_messages = list()
	var/tmp/list/cached_messages = list()
	var/tmp/current_id = 1

/datum/cached_message
	var/message
	var/uncache_at

/datum/flagged_message
	var/message
	var/list/flaggers

/datum/controller/subsystem/message_flagging/fire(resumed = FALSE)

	expire_cache()

	while(flagged_messages.len)
		var/key = flagged_messages[flagged_messages.len]
		var/datum/flagged_message/FM = flagged_messages[key]
		flagged_messages.len--

		// I guess we want to not spam admins all the time
		// e.g. if five people flag a message, they shouldn't receive five logs
		// if five people flag five different messages, they shouldn't receive five logs either

		log_and_message_admins("- [english_list(FM.flaggers)] flagged a message: '[FM.message]'")

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/message_flagging/proc/cache_message(var/message)
	var/datum/cached_message/CM = new
	CM.message = message
	CM.uncache_at = world.time + 1 MINUTES
	cached_messages["[current_id]"] = CM
	current_id++
	return "[current_id - 1]"

/datum/controller/subsystem/message_flagging/proc/expire_cache()
	var/now = world.time
	for (var/i = cached_messages.len; i >= 1; --i)
		var/key = cached_messages[i]
		var/datum/cached_message/CM = cached_messages[key]
		if (CM.uncache_at < now)
			cached_messages.Remove(key)

/datum/controller/subsystem/message_flagging/proc/flag(var/flagger, var/message_id)
	var/datum/cached_message/CM = cached_messages["[message_id]"]
	if (!CM)
		to_chat(usr, "That message is too old to be flagged. Press F1 to adminhelp about the issue.")
		return
	var/datum/flagged_message/FM = flagged_messages["[message_id]"]
	if (!FM)
		flag_new_message(flagger, message_id, CM.message)
	else
		add_flagger(flagger, FM)

/datum/controller/subsystem/message_flagging/proc/flag_new_message(var/flagger, var/message_id, var/message)
	var/datum/flagged_message/FM = new
	FM.flaggers = list(flagger)
	FM.message = message
	flagged_messages[message_id] = FM
	to_chat(usr, "Message flagged.")

/datum/controller/subsystem/message_flagging/proc/add_flagger(var/flagger, var/datum/flagged_message/FM)
	for (var/existing_flagger in FM.flaggers)
		if (existing_flagger == flagger)
			to_chat(usr, "You've already flagged this message.")
			return
	FM.flaggers |= flagger
	to_chat(usr, "Message flagged. This message has now been flagged [FM.flaggers.len] times.")