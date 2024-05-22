local RSGCore = exports['rsg-core']:GetCoreObject()
local pasturinggoat = {}
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







RegisterNetEvent('rsg-goat:client:goatspawn')
AddEventHandler('rsg-goat:client:goatspawn', function()
    if starting then 
        RSGCore.Functions.Notify(Lang:t('error.job_error'), 'error', 3000)
        return
    else    
        starting = true
        local goatCount = Config.goatCount
		local follow = Config.Follow
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local randomChance = math.random(1, 100)
		
        for i = 1, goatCount do
            local hash = 'a_c_goat_01'
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(10)
            end
            local randomX = playerCoords.x + math.random(-5, 5) -- Примерный диапазон по X
            local randomY = playerCoords.y + math.random(-5, 5) -- Примерный диапазон по Y

            goat = CreatePed(hash, randomX, randomY, playerCoords.z, true, true, false)
            Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, goat)
            Citizen.InvokeNative(0x77FF8D35EEC6BBC4, goat, 0, false)
			SetEntityAsMissionEntity(animal, true)
		if follow then
			local goatOffset = vector3(0.0, 7.0, 0.0) 
			TaskFollowToOffsetOfEntity(goat, player, goatOffset.x, goatOffset.y, goatOffset.z, 1.0, -1, 0.0, 1)
		end
            table.insert(pasturinggoat, goat) 
			Wait(500)
        end 
		
        for _, goatId in ipairs(pasturinggoat) do
            exports['rsg-target']:AddTargetEntity(goatId, {
                options = {
					{
                        type = 'client',
                        label = 'stop moving',
						targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerEvent('rsg-goat:client:startanim', goatId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'Gather milk',
						targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerServerEvent('rsg-goat:addmilk', goatId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'return goat',
						targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerEvent('rsg-goat:client:goatreturn', goatId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'lead goats',
                        targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerEvent('rsg-goat:client:lead', goatId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'graze goats',
						targeticon = 'fas fa-solid fa-magnifying-glass',
                        action = function()
                            TriggerEvent('rsg-goat:client:pas', goatId)
                        end,
                    },
                },
                distance = 5.5,
            })
		end
		
    end
end)

RegisterNetEvent('rsg-goat:client:lead')
AddEventHandler('rsg-goat:client:lead', function(goat)
if IsPedDeadOrDying(goat, true) then
	
return end
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local goatOffset = vector3(0.0, 2.0, 0.0) 
		ClearPedTasks(goat)
		TaskFollowToOffsetOfEntity(goat, player, goatOffset.x, goatOffset.y, goatOffset.z, 1.0, -1, 0.0, 1)
end)

RegisterNetEvent('rsg-goat:client:startanim')
AddEventHandler('rsg-goat:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_goat'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_GOAT_RESTING"
			
		}
		local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
		local anim = randomScenario
		ClearPedTasks(animal)
		TaskStartScenarioInPlace(animal, GetHashKey(anim), -1, true, false, false, false)
	end
end)

RegisterNetEvent('rsg-goat:client:pas')
AddEventHandler('rsg-goat:client:pas', function(animal)
    if isFinish then
        RSGCore.Functions.Notify(Lang:t('success.goat_finish'), 'success', 3000)
        return
    end
    if isPasturing then
        RSGCore.Functions.Notify(Lang:t('error.goat_already'), 'error', 3000)
        return
    end

    for i = 1, #pasturinggoat do
        local goat = pasturinggoat[i]
        if DoesEntityExist(goat) then
            local availableScenarios = {
                "WORLD_ANIMAL_GOAT_RESTING"
               
            }
            local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
            local anim = randomScenario
            TaskStartScenarioInPlace(goat, GetHashKey(anim), -1, true, false, false, false)
        end
    end
    RSGCore.Functions.Notify(Lang:t('success.goat_grazing'), 'success', 3000)
    isPasturing = true
    pasturingStartTime = GetGameTimer()
    startPasturing()
end)


RegisterNetEvent('rsg-goat:client:startanim')
AddEventHandler('rsg-goat:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_goat'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_GOAT_GRAZING"
			
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



RegisterNetEvent('rsg-goat:client:goatreturn')

AddEventHandler('rsg-goat:client:goatreturn', function()
    if isPasturing then
        local isgoatKilled = false

        for _, goat in ipairs(pasturinggoat) do
            if DoesEntityExist(goat) then
                if IsPedDeadOrDying(goat, true) then
                    isgoatKilled = true
                    break
                end
            end
        end

        for i, goatInfo in ipairs(pasturinggoat) do
            SetEntityInvincible(goatInfo, false)
            ClearPedTasks(goatInfo)
            DeletePed(goatInfo)
        end

        pasturinggoat = {}
        starting = false

        if not isgoatKilled then
            RSGCore.Functions.Notify(Lang:t('success.success_goat'), 'success', 3000)
            TriggerServerEvent('rsg-goat:server:givemoney')
        else
            RSGCore.Functions.Notify(Lang:t('error.dead_goat'), 'error', 3000)
        end

        isPasturing = true
        isFinish = true
    else
        RSGCore.Functions.Notify(Lang:t('error.error_goat'), 'error', 3000)
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
                local remainingTime = Config.WaitTimegoat - elapsedTime
                
                if elapsedTime >= Config.WaitTimegoat then
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

RegisterNetEvent('rsg-goat:searchAnimation')
AddEventHandler('rsg-goat:searchAnimation', function()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(6000)
    ClearPedTasks(ped)
    TriggerServerEvent('rsg-goat:givemilk') -- After animation, trigger server event to give milk
end)

