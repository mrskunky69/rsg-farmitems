local Translations = {
    error = {
	  error_goat = 'You didn\'t herd goats!',
	  error_dead = 'You were killed by the hunters, you could not return the pigs!',
	  dead_goat = 'The goat is killed!',
	  lead_ranch = 'Get away from the ranch!',
	  job_error = 'You have already animals out!',
	  goat_already = 'The goats are already grazing',
	  error_time = 'You haven\'t been herding the pig enough time!',
	  error_goatback = 'Not all goats are back!',
	  dead_goat = 'One of the goats was killed, you did not receive a reward!'
	  
    },
    success = {
	  time_grazing = 'You can return the goats!',
      success_goat = 'Great job!',
	  goat_grazing = 'The goats are grazing',
	  goat_finish = 'goats have grazed can return to the shed!'
    },
    menu = {
      job_goat = 'Take a job herding pig',
      job_back = 'Bring back the pig',
      job_shepherd = 'Shepherd',
      lead_menu = 'Lead',
	  to_graze = 'To graze',
	  goat_stop = 'Stop',
      close_menu = 'Close'
    },
    primary = {
	minutes_left = 'Minutes left: '
    }
}


Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
