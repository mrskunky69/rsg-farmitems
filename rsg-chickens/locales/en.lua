local Translations = {
    error = {
	  error_chicken = 'You didn\'t herd chickens!',
	  error_dead = 'You were killed by the hunters, you could not return the pigs!',
	  dead_chicken = 'The chicken is killed!',
	  lead_ranch = 'Get away from the ranch!',
	  job_error = 'You have already animals out!',
	  chicken_already = 'The chicken are already grazing',
	  error_time = 'You haven\'t been herding the chicken enough time!',
	  error_chickenback = 'Not all chicken are back!',
	  dead_chicken = 'One of the chicken was killed, you did not receive a reward!'
	  
    },
    success = {
	  time_grazing = 'You can return the chickens!',
      success_chicken = 'Great job!',
	  chicken_grazing = 'The chicken are grazing',
	  chicken_finish = 'chicken have grazed can return to the shed!'
    },
    menu = {
      job_chicken = 'Take a job herding chicken',
      job_back = 'Bring back the chicken',
      job_chicken = 'Shepherd',
      lead_menu = 'Lead',
	  to_graze = 'To graze',
	  chicken_stop = 'Stop',
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
