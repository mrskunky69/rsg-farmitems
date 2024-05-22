local RSGCore = exports['rsg-core']:GetCoreObject()
local pasturingBulls = {}
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







RegisterNetEvent('rsg-bulls:client:bullspawn')
AddEventHandler('rsg-bulls:client:bullspawn', function()
    if starting then 
        RSGCore.Functions.Notify(Lang:t('error.job_error'), 'error', 3000)
        return
    else    
        starting = true
        local bullCount = Config.BullCount
		local follow = Config.Follow
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local randomChance = math.random(1, 100)
		
        for i = 1, bullCount do
            local hash = 'a_c_cow'
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(10)
            end
            local randomX = playerCoords.x + math.random(-5, 5) -- Примерный диапазон по X
            local randomY = playerCoords.y + math.random(-5, 5) -- Примерный диапазон по Y

            bull = CreatePed(hash, randomX, randomY, playerCoords.z, true, true, false)
            Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, bull)
            Citizen.InvokeNative(0x77FF8D35EEC6BBC4, bull, 0, false)
			SetEntityAsMissionEntity(animal, true)
		if follow then
			local bullOffset = vector3(0.0, 7.0, 0.0) 
			TaskFollowToOffsetOfEntity(bull, player, bullOffset.x, bullOffset.y, bullOffset.z, 1.0, -1, 0.0, 1)
		end
            table.insert(pasturingBulls, bull) 
			Wait(500)
        end 
		
        for _, bullId in ipairs(pasturingBulls) do
            exports['rsg-target']:AddTargetEntity(bullId, {
                options = {
					{
                        type = 'client',
                        label = Lang:t('menu.bull_stop'),
						targeticon = 'fas fa-solid fa-cow',
                        action = function()
                            TriggerEvent('rsg-bulls:client:startanim', bullId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'milk',
						targeticon = 'fas fa-solid fa-cow',
                        action = function()
                            TriggerServerEvent('rsg-bulls:addmilk', bullId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'return cow',
						targeticon = 'fas fa-solid fa-cow',
                        action = function()
                            TriggerEvent('rsg-bulls:client:bullreturn', bullId)
                        end,
                    },
					{
                        type = 'client',
                        label = Lang:t('menu.lead_menu'),
                        targeticon = 'fas fa-solid fa-cow',
                        action = function()
                            TriggerEvent('rsg-bulls:client:lead', bullId)
                        end,
                    },
					{
                        type = 'client',
                        label = Lang:t('menu.to_graze'),
						targeticon = 'fas fa-solid fa-cow',
                        action = function()
                            TriggerEvent('rsg-bulls:client:pas', bullId)
                        end,
                    },
                },
                distance = 5.5,
            })
		end
		
    end
end)

RegisterNetEvent('rsg-bulls:client:lead')
AddEventHandler('rsg-bulls:client:lead', function(bull)
if IsPedDeadOrDying(bull, true) then
	
return end
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local bullOffset = vector3(0.0, 2.0, 0.0) 
		ClearPedTasks(bull)
		TaskFollowToOffsetOfEntity(bull, player, bullOffset.x, bullOffset.y, bullOffset.z, 1.0, -1, 0.0, 1)
end)

RegisterNetEvent('rsg-bulls:client:startanim')
AddEventHandler('rsg-bulls:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_BULL_GRAZING",
			"WORLD_ANIMAL_BULL_RESTING",
			"WORLD_ANIMAL_BULL_SLEEPING"
		}
		local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
		local anim = randomScenario
		ClearPedTasks(animal)
		TaskStartScenarioInPlace(animal, GetHashKey(anim), -1, true, false, false, false)
	end
end)

RegisterNetEvent('rsg-bulls:client:pas')
AddEventHandler('rsg-bulls:client:pas', function(animal)
    if isFinish then
        RSGCore.Functions.Notify(Lang:t('success.bull_finish'), 'success', 3000)
        return
    end
    if isPasturing then
        RSGCore.Functions.Notify(Lang:t('error.bull_already'), 'error', 3000)
        return
    end

    for i = 1, #pasturingBulls do
        local bull = pasturingBulls[i]
        if DoesEntityExist(bull) then
            local availableScenarios = {
                "WORLD_ANIMAL_BULL_GRAZING",
                "WORLD_ANIMAL_BULL_RESTING",
                "WORLD_ANIMAL_BULL_SLEEPING"
            }
            local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
            local anim = randomScenario
            TaskStartScenarioInPlace(bull, GetHashKey(anim), -1, true, false, false, false)
        end
    end
    RSGCore.Functions.Notify(Lang:t('success.bull_grazing'), 'success', 3000)
    isPasturing = true
    pasturingStartTime = GetGameTimer()
    startPasturing()
end)


RegisterNetEvent('rsg-bulls:client:startanim')
AddEventHandler('rsg-bulls:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_bulls'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_BULL_GRAZING",
			"WORLD_ANIMAL_BULL_RESTING",
			"WORLD_ANIMAL_BULL_SLEEPING"
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



RegisterNetEvent('rsg-bulls:client:bullreturn')

AddEventHandler('rsg-bulls:client:bullreturn', function()
    if isPasturing then
        local isBullKilled = false

        for _, bull in ipairs(pasturingBulls) do
            if DoesEntityExist(bull) then
                if IsPedDeadOrDying(bull, true) then
                    isBullKilled = true
                    break
                end
            end
        end

        for i, bullInfo in ipairs(pasturingBulls) do
            SetEntityInvincible(bullInfo, false)
            ClearPedTasks(bullInfo)
            DeletePed(bullInfo)
        end

        pasturingBulls = {}
        starting = false

        if not isBullKilled then
            RSGCore.Functions.Notify(Lang:t('success.success_bull'), 'success', 3000)
            TriggerServerEvent('rsg-bulls:server:givemoney')
        else
            RSGCore.Functions.Notify(Lang:t('error.dead_bull'), 'error', 3000)
        end

        isPasturing = true
        isFinish = true
    else
        RSGCore.Functions.Notify(Lang:t('error.error_bull'), 'error', 3000)
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
                local remainingTime = Config.WaitTimeBull - elapsedTime
                
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

RegisterNetEvent('rsg-bulls:searchAnimation')
AddEventHandler('rsg-bulls:searchAnimation', function()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(6000)
    ClearPedTasks(ped)
    TriggerServerEvent('rsg-bulls:giveMilk') -- After animation, trigger server event to give milk
end)

