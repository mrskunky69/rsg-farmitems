local RSGCore = exports['rsg-core']:GetCoreObject()
local pasturinghorse = {}
local starting = false
local isPasturing = false
local pasturingStartTime = 0
local isFinish = false
local lastNotificationTime = 0
local active = false
local amount = 0
local cooldown = 0








Citizen.CreateThread(function()
    while true do
        Wait(60000)
        if amount > 0 then
            amount = amount - 1
        end
    end
end)







RegisterNetEvent('rsg-horseranch:client:horsespawn')
AddEventHandler('rsg-horseranch:client:horsespawn', function()
    if starting then 
        RSGCore.Functions.Notify(Lang:t('error.job_error'), 'error', 3000)
        return
    else    
        starting = true
        local horseCount = Config.horseCount
		local follow = Config.Follow
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local randomChance = math.random(1, 100)
		
        for i = 1, horseCount do
            local hash = 'a_c_horse_andalusian_darkbay'
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(10)
            end
            local randomX = playerCoords.x + math.random(-5, 5) -- Примерный диапазон по X
            local randomY = playerCoords.y + math.random(-5, 5) -- Примерный диапазон по Y

            horse = CreatePed(hash, randomX, randomY, playerCoords.z, true, true, false)
            Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, horse)
            Citizen.InvokeNative(0x77FF8D35EEC6BBC4, horse, 0, false)
			SetEntityAsMissionEntity(animal, true)
		if follow then
			local horseOffset = vector3(0.0, 7.0, 0.0) 
			TaskFollowToOffsetOfEntity(horse, player, horseOffset.x, horseOffset.y, horseOffset.z, 1.0, -1, 0.0, 1)
		end
            table.insert(pasturinghorse, horse) 
			Wait(500)
        end 
		
        for _, horseId in ipairs(pasturinghorse) do
            exports['rsg-target']:AddTargetEntity(horseId, {
                options = {
					{
                        type = 'client',
                        label = Lang:t('menu.horse_stop'),
						targeticon = 'fas fa-solid fa-horse',
                        action = function()
                            TriggerEvent('rsg-horseranch:client:startanim', horseId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'fertiliser',
						targeticon = 'fas fa-solid fa-horse',
                        action = function()
                            TriggerServerEvent('rsg-horseranch:addfertiliser', horseId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'return horse',
						targeticon = 'fas fa-solid fa-horse',
                        action = function()
                            TriggerEvent('rsg-horseranch:client:horsereturn', horseId)
                        end,
                    },
					{
                        type = 'client',
                        label = Lang:t('menu.lead_menu'),
                        targeticon = 'fas fa-solid fa-horse',
                        action = function()
                            TriggerEvent('rsg-horseranch:client:lead', horseId)
                        end,
                    },
					{
                        type = 'client',
                        label = Lang:t('menu.to_graze'),
						targeticon = 'fas fa-solid fa-horse',
                        action = function()
                            TriggerEvent('rsg-horseranch:client:pas', horseId)
                        end,
                    },
                },
                distance = 5.5,
            })
		end
		
    end
end)

RegisterNetEvent('rsg-horseranch:client:lead')
AddEventHandler('rsg-horseranch:client:lead', function(horse)
if IsPedDeadOrDying(horse, true) then
	
return end
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local horseOffset = vector3(0.0, 2.0, 0.0) 
		ClearPedTasks(horse)
		TaskFollowToOffsetOfEntity(horse, player, horseOffset.x, horseOffset.y, horseOffset.z, 1.0, -1, 0.0, 1)
end)

RegisterNetEvent('rsg-horseranch:client:startanim')
AddEventHandler('rsg-horseranch:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_horse_GRAZING",
			"WORLD_ANIMAL_horse_RESTING",
			"WORLD_ANIMAL_horse_SLEEPING"
		}
		local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
		local anim = randomScenario
		ClearPedTasks(animal)
		TaskStartScenarioInPlace(animal, GetHashKey(anim), -1, true, false, false, false)
	end
end)

RegisterNetEvent('rsg-horseranch:client:pas')
AddEventHandler('rsg-horseranch:client:pas', function(animal)
    if isFinish then
        RSGCore.Functions.Notify(Lang:t('success.horse_finish'), 'success', 3000)
        return
    end
    if isPasturing then
        RSGCore.Functions.Notify(Lang:t('error.horse_already'), 'error', 3000)
        return
    end

    for i = 1, #pasturinghorse do
        local horse = pasturinghorse[i]
        if DoesEntityExist(horse) then
            local availableScenarios = {
                "WORLD_ANIMAL_horse_GRAZING",
                "WORLD_ANIMAL_horse_RESTING",
                "WORLD_ANIMAL_horse_SLEEPING"
            }
            local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
            local anim = randomScenario
            TaskStartScenarioInPlace(bull, GetHashKey(anim), -1, true, false, false, false)
        end
    end
    RSGCore.Functions.Notify(Lang:t('success.horse_grazing'), 'success', 3000)
    isPasturing = true
    pasturingStartTime = GetGameTimer()
    startPasturing()
end)


RegisterNetEvent('rsg-horseranch:client:startanim')
AddEventHandler('rsg-horseranch:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_horse'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_horse_GRAZING",
			"WORLD_ANIMAL_horse_RESTING",
			"WORLD_ANIMAL_horse_SLEEPING"
		}
		local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
		local anim = randomScenario
		ClearPedTasks(animal)
		TaskStartScenarioInPlace(animal, GetHashKey(anim), -1, true, false, false, false)
	end
end)



function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end



RegisterNetEvent('rsg-horseranch:client:horsereturn')

AddEventHandler('rsg-horseranch:client:horsereturn', function()
    if isPasturing then
        local ishorseKilled = false

        for _, horse in ipairs(pasturinghorse) do
            if DoesEntityExist(horse) then
                if IsPedDeadOrDying(horse, true) then
                    ishorseKilled = true
                    break
                end
            end
        end

        for i, horseInfo in ipairs(pasturinghorse) do
            SetEntityInvincible(horseInfo, false)
            ClearPedTasks(horseInfo)
            DeletePed(horseInfo)
        end

        pasturinghorse = {}
        starting = false

        if not ishorseKilled then
            RSGCore.Functions.Notify(Lang:t('success.success_horse'), 'success', 3000)
            TriggerServerEvent('rsg-horseranch:server:givemoney')
        else
            RSGCore.Functions.Notify(Lang:t('error.dead_horse'), 'error', 3000)
        end

        isPasturing = true
        isFinish = true
    else
        RSGCore.Functions.Notify(Lang:t('error.error_horse'), 'error', 3000)
    end
end)

function startPasturing()
    Citizen.CreateThread(function()
        isFinish = false
        RSGCore.Functions.Notify(Lang:t('success.time_grazing'), 'success', 6000)
    end)
end

function startPasturing()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10000)
            
            if isPasturing then
                local currentTime = GetGameTimer()
                local elapsedTime = currentTime - pasturingStartTime
                local remainingTime = Config.WaitTimehorse - elapsedTime
                
                if elapsedTime >= Config.WaitTimeBull then
                    RSGCore.Functions.Notify(Lang:t('success.time_grazing'), 'success', 6000)
					isFinish = true
                    break
                end
                
                local remainingMinutes = math.floor(remainingTime / 60000) 
                
                if remainingMinutes > 0 and currentTime - lastNotificationTime >= 60000 then
                    RSGCore.Functions.Notify(Lang:t('primary.minutes_left') .. remainingMinutes, 'primary', 6000)
                    lastNotificationTime = currentTime
                end
            end
        end
    end)
end

RegisterNetEvent('rsg-horseranch:searchAnimation')
AddEventHandler('rsg-horseranch:searchAnimation', function()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(6000)
    ClearPedTasks(ped)
    TriggerServerEvent('rsg-horseranch:givefertiliser') -- After animation, trigger server event to give milk
end)

