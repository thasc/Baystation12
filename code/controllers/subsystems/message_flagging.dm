SUBSYSTEM_DEF(message_flagging)
	name = "Message Flagging"
	wait = 30 SECONDS
	priority = SS_PRIORITY_MSG_FLAGGING
	flags = SS_NO_INIT
	var/tmp/list/flagged_messages = list()

/datum/flagged_message
	var/list/flaggers
	var/offender
	var/message

/datum/controller/subsystem/message_flagging/fire(resumed = FALSE)
	while(flagged_messages.len)
		var/datum/flagged_message/FM = flagged_messages[flagged_messages.len]
		flagged_messages.len--

		// I guess we want to not spam admins all the time
		// e.g. if five people flag a message, they shouldn't receive five logs
		// if five people flag five different messages, they shouldn't receive five logs either

		// we also need to ensure that nasty users can't hack Topic to flag a fake nasty message from an innocent user
		// how about a check value? generate a long random value here in init, encrypt each message + offender with it
		// then when flagged, do the same encryption here, and if the check values don't match, alert mins

		log_and_message_admins("- [english_list(FM.flaggers)] flagged a message from [FM.offender]: '[FM.message]'")

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/message_flagging/proc/flag(var/flagger, var/offender, var/message)
	for (var/flagged_message in flagged_messages)
		var/datum/flagged_message/FM = flagged_message
		if (FM.offender == offender && FM.message == message)
			add_flagger(flagger, FM)
			return
	flag_new_message(flagger, offender, message)

/datum/controller/subsystem/message_flagging/proc/flag_new_message(var/flagger, var/offender, var/message)
	var/datum/flagged_message/FM = new
	FM.flaggers = list(flagger)
	FM.offender = offender
	FM.message = message
	flagged_messages.Add(FM)
	to_chat(usr, "Message flagged.")

/datum/controller/subsystem/message_flagging/proc/add_flagger(var/flagger, var/datum/flagged_message/FM)
	for (var/existing_flagger in FM.flaggers)
		if (existing_flagger == flagger)
			to_chat(usr, "You've already flagged this message.")
			return
	FM.flaggers |= flagger
	to_chat(usr, "Message flagged. This message has now been flagged [FM.flaggers.len] times.")