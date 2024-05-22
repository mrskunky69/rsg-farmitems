local Translations = {
    error = {
	  error_pig = 'You didn\'t herd pig!',
	  error_dead = 'You were killed by the hunters, you could not return the pigs!',
	  dead_pig = 'The pig is killed!',
	  lead_ranch = 'Get away from the ranch!',
	  job_error = 'You have already taken the job!',
	  pig_already = 'The pig are already grazing',
	  error_time = 'You haven\'t been herding the pig enough time!',
	  error_pigback = 'Not all pig are back!',
	  dead_pig = 'One of the pig was killed, you did not receive a reward!'
	  
    },
    success = {
	  time_grazing = 'You can return the pig!',
      success_pig = 'Great job!',
	  pig_grazing = 'The pig are grazing',
	  pig_finish = 'pigs have grazed can return to the shed!'
    },
    menu = {
      job_pig = 'Take a job herding pig',
      job_back = 'Bring back the pig',
      job_shepherd = 'Shepherd',
      lead_menu = 'Lead',
	  to_graze = 'To graze',
	  pig_stop = 'Stop',
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
