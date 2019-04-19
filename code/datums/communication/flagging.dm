/datum/proc/extra_flag_message_link(var/prefix, var/suffix, var/short_links)
	return list()

/atom/movable/extra_flag_message_link(var/atom/user, var/prefix, var/suffix, var/short_links)
	//if(src == user)
		//return list()
	return list(create_flag_message_link(user, src, short_links ? "!" : "Flag", prefix, suffix))

/client/extra_flag_message_link(var/atom/user, var/prefix, var/suffix, var/short_links)
	return mob.extra_flag_message_link(user, prefix, suffix, short_links)

/proc/create_flag_message_link(var/user, var/target, var/text, var/prefix, var/suffix)
	return "<a href='byond://?src=\ref[user];flagmessagetarget=\ref[target]'>[prefix][text][suffix]</a>"

/datum/proc/get_flag_message_link(var/atom/target, var/delimiter, var/prefix, var/suffix)
	return

/client/get_flag_message_link(var/atom/target, var/delimiter, var/prefix, var/suffix)
	return mob.get_flag_message_link(target, delimiter, prefix, suffix)

/mob/get_flag_message_link(var/atom/target, var/delimiter, var/prefix, var/suffix)
	var/short_links = get_preference_value(/datum/client_preference/ghost_follow_link_length) == GLOB.PREF_SHORT
	return flag_message_link(target, src, delimiter, prefix, suffix, short_links)

/proc/flag_message_link(var/atom/target, var/atom/user, var/delimiter = "|", var/prefix = "", var/suffix = "", var/short_links = TRUE)
	if((!target) || (!user)) return
	return jointext(target.extra_flag_message_link(user, prefix, suffix, short_links),delimiter)
