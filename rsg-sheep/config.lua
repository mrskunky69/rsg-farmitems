Config = Config or {}


Config.sheepCount = 4 --Number 
Config.WaitTimesheep = 60000 --how long do bulls need to graze (600000 - 10 minutes)
Config.ZoneDist = 01 --how far should the bulls be driven away from the ranch

Config.MoneyReward = 10 --how much money the player will receive
Config.Blipsheep = {
    blipName = 'Job: Shepherd', 
    blipSprite = 423351566, 
    blipScale = 0.2 
}

Config.sheep = {
    {name = 'Job: Shepherd', location = 'jobbull',  coords = vector3(-2426.81, -2364.54, 61.18),  showblip = true},
}

-- counted from these coordinates Config.ZoneDist
Config.sheepZone = {
    vector3(-2426.81, -2364.54, 61.18 - 0.8),

}



