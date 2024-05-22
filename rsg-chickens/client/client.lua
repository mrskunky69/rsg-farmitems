local RSGCore = exports['rsg-core']:GetCoreObject()
local pasturingchicken = {}
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







RegisterNetEvent('rsg-chicken:client:chickenspawn')
AddEventHandler('rsg-chicken:client:chickenspawn', function()
    if starting then 
        RSGCore.Functions.Notify(Lang:t('error.job_error'), 'error', 3000)
        return
    else    
        starting = true
        local chickenCount = Config.chickenCount
		local follow = Config.Follow
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local randomChance = math.random(1, 100)
		
        for i = 1, chickenCount do
            local hash = 'a_c_chicken_01'
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(10)
            end
            local randomX = playerCoords.x + math.random(-5, 5) -- Примерный диапазон по X
            local randomY = playerCoords.y + math.random(-5, 5) -- Примерный диапазон по Y

            chicken = CreatePed(hash, randomX, randomY, playerCoords.z, true, true, false)
            Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, chicken)
            Citizen.InvokeNative(0x77FF8D35EEC6BBC4, chicken, 0, false)
			SetEntityAsMissionEntity(animal, true)
		if follow then
			local chickenOffset = vector3(0.0, 7.0, 0.0) 
			TaskFollowToOffsetOfEntity(chicken, player, chickenOffset.x, chickenOffset.y, chickenOffset.z, 1.0, -1, 0.0, 1)
		end
            table.insert(pasturingchicken, chicken) 
			Wait(500)
        end 
		
        for _, chickenId in ipairs(pasturingchicken) do
            exports['rsg-target']:AddTargetEntity(chickenId, {
                options = {
					{
                        type = 'client',
                        label = 'stop moving',
						targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerEvent('rsg-chicken:client:startanim', chickenId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'Gather eggs',
						targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerServerEvent('rsg-chicken:addeggs', chickenId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'return chicken',
						targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerEvent('rsg-chicken:client:chickenreturn', chickenId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'lead chicken',
                        targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerEvent('rsg-chicken:client:lead', chickenId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'graze chicken',
						targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerEvent('rsg-chicken:client:pas', chickenId)
                        end,
                    },
                },
                distance = 5.5,
            })
		end
		
    end
end)

RegisterNetEvent('rsg-chicken:client:lead')
AddEventHandler('rsg-chicken:client:lead', function(chicken)
if IsPedDeadOrDying(chicken, true) then
	
return end
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local chickenOffset = vector3(0.0, 2.0, 0.0) 
		ClearPedTasks(chicken)
		TaskFollowToOffsetOfEntity(chicken, player, chickenOffset.x, chickenOffset.y, chickenOffset.z, 1.0, -1, 0.0, 1)
end)

RegisterNetEvent('rsg-chicken:client:startanim')
AddEventHandler('rsg-chicken:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_chicken'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_chicken_RESTING"
			
		}
		local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
		local anim = randomScenario
		ClearPedTasks(animal)
		TaskStartScenarioInPlace(animal, GetHashKey(anim), -1, true, false, false, false)
	end
end)

RegisterNetEvent('rsg-chicken:client:pas')
AddEventHandler('rsg-chicken:client:pas', function(animal)
    if isFinish then
        RSGCore.Functions.Notify(Lang:t('success.chicken_finish'), 'success', 3000)
        return
    end
    if isPasturing then
        RSGCore.Functions.Notify(Lang:t('error.chicken_already'), 'error', 3000)
        return
    end

    for i = 1, #pasturingchicken do
        local chicken = pasturingchicken[i]
        if DoesEntityExist(chicken) then
            local availableScenarios = {
                "WORLD_ANIMAL_CHICKEN_RESTING"
               
            }
            local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
            local anim = randomScenario
            TaskStartScenarioInPlace(chicken, GetHashKey(anim), -1, true, false, false, false)
        end
    end
    RSGCore.Functions.Notify(Lang:t('success.chicken_grazing'), 'success', 3000)
    isPasturing = true
    pasturingStartTime = GetGameTimer()
    startPasturing()
end)


RegisterNetEvent('rsg-chicken:client:startanim')
AddEventHandler('rsg-chicken:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_chicken'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_chicken_GRAZING"
			
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



RegisterNetEvent('rsg-chicken:client:chickenreturn')

AddEventHandler('rsg-chicken:client:chickenreturn', function()
    if isPasturing then
        local ischickenKilled = false

        for _, chicken in ipairs(pasturingchicken) do
            if DoesEntityExist(chicken) then
                if IsPedDeadOrDying(chicken, true) then
                    ischickenKilled = true
                    break
                end
            end
        end

        for i, chickenInfo in ipairs(pasturingchicken) do
            SetEntityInvincible(chickenInfo, false)
            ClearPedTasks(chickenInfo)
            DeletePed(chickenInfo)
        end

        pasturingchicken = {}
        starting = false

        if not ischickenKilled then
            RSGCore.Functions.Notify(Lang:t('success.success_chicken'), 'success', 3000)
            TriggerServerEvent('rsg-chicken:server:givemoney')
        else
            RSGCore.Functions.Notify(Lang:t('error.dead_chicken'), 'error', 3000)
        end

        isPasturing = true
        isFinish = true
    else
        RSGCore.Functions.Notify(Lang:t('error.error_chicken'), 'error', 3000)
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
                local remainingTime = Config.WaitTimechicken - elapsedTime
                
                if elapsedTime >= Config.WaitTimechicken then
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

RegisterNetEvent('rsg-chicken:searchAnimation')
AddEventHandler('rsg-chicken:searchAnimation', function()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(6000)
    ClearPedTasks(ped)
    TriggerServerEvent('rsg-chicken:giveeggs') -- After animation, trigger server event to give milk
end)

