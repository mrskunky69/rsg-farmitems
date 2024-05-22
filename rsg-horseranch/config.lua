Config = Config or {}


Config.horseCount = 4 --Number of horse
Config.WaitTimehorse = 60000 --how long do horse need to graze (600000 - 10 minutes)
Config.ZoneDist = 01 --how far should the horse be driven away from the ranch
Config.MoneyReward = 10 --how much money the player will receive
Config.Bliphorse = {
    blipName = 'Job: Shepherd', 
    blipSprite = 423351566, 
    blipScale = 0.2 
}

Config.Bull = {
    {name = 'Job: Shepherd', location = 'jobhorse',  coords = vector3(-2426.81, -2364.54, 61.18),  showblip = true},
}

-- counted from these coordinates Config.ZoneDist
Config.horseZone = {
    vector3(-2426.81, -2364.54, 61.18 - 0.8),

}



