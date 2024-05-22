local Translations = {
    error = {
	  error_horse = 'You didn\'t herd horse!',
	  error_dead = 'You were killed by the hunters, you could not return the horse!',
	  dead_horse = 'The horse is killed!',
	  lead_ranch = 'Get away from the ranch!',
	  job_error = 'You have already taken the job!',
	  horse_already = 'The horse are already grazing',
	  error_time = 'You haven\'t been herding the horse enough time!',
	  error_horseback = 'Not all horse are back!',
	  dead_horse = 'One of the horse was killed, you did not receive a reward!'
	  
    },
    success = {
	  time_grazing = 'horses have grazed can return to the shed!',
      success_horse = 'Great job!',
	  horse_grazing = 'The horse is grazing',
	  horse_finish = 'The horses can be returned!'
    },
    menu = {
      job_horse = 'Take a job herding horses',
      job_back = 'Bring back the horses',
      job_shepherd = 'Shepherd',
      lead_menu = 'Lead',
	  to_graze = 'To graze',
	  horse_stop = 'Stop',
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
