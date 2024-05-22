Config = Config or {}


Config.goatCount = 2 --Number 
Config.WaitTimegoat = 60000 --how long
Config.ZoneDist = 01 --how far 
Config.MoneyReward = 10 --how much money the player will receive
Config.Blipgoat = {
    blipName = 'Job: Shepherd', 
    blipSprite = 423351566, 
    blipScale = 0.2 
}

Config.goat = {
    {name = 'Job: Shepherd', location = 'jobbull',  coords = vector3(-2426.81, -2364.54, 61.18),  showblip = true},
}

-- counted from these coordinates Config.ZoneDist
Config.goatZone = {
    vector3(-2426.81, -2364.54, 61.18 - 0.8),

}



