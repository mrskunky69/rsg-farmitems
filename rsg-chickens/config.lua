Config = Config or {}


Config.chickenCount = 4 --Number 
Config.WaitTimechicken = 6000 --how long
Config.ZoneDist = 01 --how far 
Config.MoneyReward = 10 --how much money the player will receive
Config.Blipchicken = {
    blipName = 'Job: Shepherd', 
    blipSprite = 423351566, 
    blipScale = 0.2 
}

Config.chicken = {
    {name = 'Job: Shepherd', location = 'jobchicken',  coords = vector3(-2426.81, -2364.54, 61.18),  showblip = true},
}

-- counted from these coordinates Config.ZoneDist
Config.chickenZone = {
    vector3(-2426.81, -2364.54, 61.18 - 0.8),

}



