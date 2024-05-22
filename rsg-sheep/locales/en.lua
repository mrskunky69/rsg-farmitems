local Translations = {
    error = {
	  error_sheep = 'You didn\'t herd SHEEP!',
	  error_dead = 'You were killed by the hunters, you could not return the bulls!',
	  dead_sheep = 'The bull is killed!',
	  lead_ranch = 'Get away from the ranch!',
	  job_error = 'You have already taken the job!',
	  sheep_already = 'The sheep are already grazing',
	  error_time = 'You haven\'t been herding the sheep enough time!',
	  error_sheepback = 'Not all sheep are back!',
	  dead_sheep = 'One of the sheep was killed, you did not receive a reward!'
	  
    },
    success = {
	  time_grazing = 'You can return the sheep!',
      success_sheep = 'Great job!',
	  sheep_grazing = 'The sheep are grazing',
	  sheep_finish = 'sheep have grazed can return to the shed!'
    },
    menu = {
      job_sheep = 'Take a job herding sheep',
      job_back = 'Bring back the sheep',
      job_shepherd = 'Shepherd',
      lead_menu = 'Lead',
	  to_graze = 'To graze',
	  sheep_stop = 'Stop',
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
