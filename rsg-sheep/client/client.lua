local RSGCore = exports['rsg-core']:GetCoreObject()
local pasturingsheep = {}
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







RegisterNetEvent('rsg-sheep:client:sheepspawn')
AddEventHandler('rsg-sheep:client:sheepspawn', function()
    if starting then 
        RSGCore.Functions.Notify(Lang:t('error.job_error'), 'error', 3000)
        return
    else    
        starting = true
        local sheepCount = Config.sheepCount
		local follow = Config.Follow
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local randomChance = math.random(1, 100)
		
        for i = 1, sheepCount do
            local hash = 'a_c_sheep_01'
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(10)
            end
            local randomX = playerCoords.x + math.random(-5, 5) -- Примерный диапазон по X
            local randomY = playerCoords.y + math.random(-5, 5) -- Примерный диапазон по Y

            sheep = CreatePed(hash, randomX, randomY, playerCoords.z, true, true, false)
            Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, sheep)
            Citizen.InvokeNative(0x77FF8D35EEC6BBC4, sheep, 0, false)
			SetEntityAsMissionEntity(animal, true)
		if follow then
			local sheepOffset = vector3(0.0, 7.0, 0.0) 
			TaskFollowToOffsetOfEntity(sheep, player, sheepOffset.x, sheepOffset.y, sheepOffset.z, 1.0, -1, 0.0, 1)
		end
            table.insert(pasturingsheep, sheep) 
			Wait(500)
        end 
		
        for _, sheepId in ipairs(pasturingsheep) do
            exports['rsg-target']:AddTargetEntity(sheepId, {
                options = {
					{
                        type = 'client',
                        label = ('stop'),
						targeticon = 'fas fa-solid fa-sheep',
                        action = function()
                            TriggerEvent('rsg-sheep:client:startanim', sheepId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'wool',
						targeticon = 'fas fa-solid fa-sheep',
                        action = function()
                            TriggerServerEvent('rsg-sheep:addwool', sheepId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'return sheep',
						targeticon = 'fas fa-solid fa-sheep',
                        action = function()
                            TriggerEvent('rsg-sheep:client:sheepreturn', sheepId)
                        end,
                    },
					{
                        type = 'client',
                        label = Lang:t('menu.lead_menu'),
                        targeticon = 'fas fa-solid fa-sheep',
                        action = function()
                            TriggerEvent('rsg-sheep:client:lead', sheepId)
                        end,
                    },
					{
                        type = 'client',
                        label = Lang:t('menu.to_graze'),
						targeticon = 'fas fa-solid fa-sheep',
                        action = function()
                            TriggerEvent('rsg-sheep:client:pas', sheepId)
                        end,
                    },
                },
                distance = 5.5,
            })
		end
		
    end
end)

RegisterNetEvent('rsg-sheep:client:lead')
AddEventHandler('rsg-sheep:client:lead', function(sheep)
if IsPedDeadOrDying(sheep, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_sheep'), 'error', 3000)
return end
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local sheepOffset = vector3(0.0, 2.0, 0.0) 
		ClearPedTasks(sheep)
		TaskFollowToOffsetOfEntity(sheep, player, sheepOffset.x, sheepOffset.y, sheepOffset.z, 1.0, -1, 0.0, 1)
end)

RegisterNetEvent('rsg-sheep:client:startanim')
AddEventHandler('rsg-sheep:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_sheep'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_SHEEP_GRAZING",
			"WORLD_ANIMAL_SHEEP_RESTING",
			"WORLD_ANIMAL_SHEEP_SLEEPING"
		}
		local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
		local anim = randomScenario
		ClearPedTasks(animal)
		TaskStartScenarioInPlace(animal, GetHashKey(anim), -1, true, false, false, false)
	end
end)

RegisterNetEvent('rsg-sheep:client:pas')
AddEventHandler('rsg-sheep:client:pas', function(animal)
    if isFinish then
        RSGCore.Functions.Notify(Lang:t('success.sheep_finish'), 'success', 3000)
        return
    end
    if isPasturing then
        RSGCore.Functions.Notify(Lang:t('error.sheep_already'), 'error', 3000)
        return
    end

    for i = 1, #pasturingsheep do
        local sheep = pasturingsheep[i]
        if DoesEntityExist(sheep) then
            local availableScenarios = {
                "WORLD_ANIMAL_SHEEP_GRAZING",
                "WORLD_ANIMAL_SHEEP_RESTING",
                "WORLD_ANIMAL_SHEEP_SLEEPING"
            }
            local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
            local anim = randomScenario
            TaskStartScenarioInPlace(sheep, GetHashKey(anim), -1, true, false, false, false)
        end
    end
    RSGCore.Functions.Notify(Lang:t('success.sheep_grazing'), 'success', 3000)
    isPasturing = true
    pasturingStartTime = GetGameTimer()
    startPasturing()
end)


RegisterNetEvent('rsg-sheep:client:startanim')
AddEventHandler('rsg-sheep:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_sheep'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_SHEEP_GRAZING",
			"WORLD_ANIMAL_SHEEP_RESTING",
			"WORLD_ANIMAL_SHEEP_SLEEPING"
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



RegisterNetEvent('rsg-sheep:client:sheepreturn')

AddEventHandler('rsg-sheep:client:sheepreturn', function()
    if isPasturing then
        local issheepKilled = false

        for _, sheep in ipairs(pasturingsheep) do
            if DoesEntityExist(sheep) then
                if IsPedDeadOrDying(sheep, true) then
                    issheepKilled = true
                    break
                end
            end
        end

        for i, sheepInfo in ipairs(pasturingsheep) do
            SetEntityInvincible(sheepInfo, false)
            ClearPedTasks(sheepInfo)
            DeletePed(sheepInfo)
        end

        pasturingsheep = {}
        starting = false

        if not issheepKilled then
            RSGCore.Functions.Notify(Lang:t('success.success_sheep'), 'success', 3000)
            TriggerServerEvent('rsg-sheep:server:givemoney')
        else
            RSGCore.Functions.Notify(Lang:t('error.dead_sheep'), 'error', 3000)
        end

        isPasturing = true
        isFinish = true
    else
        RSGCore.Functions.Notify(Lang:t('error.error_sheep'), 'error', 3000)
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
                local remainingTime = Config.WaitTimesheep - elapsedTime
                
                if elapsedTime >= Config.WaitTimesheep then
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

RegisterNetEvent('rsg-sheep:searchAnimation')
AddEventHandler('rsg-sheep:searchAnimation', function()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(6000)
    ClearPedTasks(ped)
    TriggerServerEvent('rsg-sheep:givewool') -- After animation, trigger server event to give milk
end)

