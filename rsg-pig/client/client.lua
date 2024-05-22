local RSGCore = exports['rsg-core']:GetCoreObject()
local pasturingpig = {}
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







RegisterNetEvent('rsg-pig:client:pigspawn')
AddEventHandler('rsg-pig:client:pigspawn', function()
    if starting then 
        RSGCore.Functions.Notify(Lang:t('error.job_error'), 'error', 3000)
        return
    else    
        starting = true
        local pigCount = Config.pigCount
		local follow = Config.Follow
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local randomChance = math.random(1, 100)
		
        for i = 1, pigCount do
            local hash = 'a_c_pig_01'
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(10)
            end
            local randomX = playerCoords.x + math.random(-5, 5) -- Примерный диапазон по X
            local randomY = playerCoords.y + math.random(-5, 5) -- Примерный диапазон по Y

            pig = CreatePed(hash, randomX, randomY, playerCoords.z, true, true, false)
            Citizen.InvokeNative(0x23f74c2fda6e7c61, -1749618580, pig)
            Citizen.InvokeNative(0x77FF8D35EEC6BBC4, pig, 0, false)
			SetEntityAsMissionEntity(animal, true)
		if follow then
			local pigOffset = vector3(0.0, 7.0, 0.0) 
			TaskFollowToOffsetOfEntity(pig, player, pigOffset.x, pigOffset.y, pigOffset.z, 1.0, -1, 0.0, 1)
		end
            table.insert(pasturingpig, pig) 
			Wait(500)
        end 
		
        for _, pigId in ipairs(pasturingpig) do
            exports['rsg-target']:AddTargetEntity(pigId, {
                options = {
					{
                        type = 'client',
                        label = 'stop moving',
						targeticon = 'fas fa-solid fa-pig',
                        action = function()
                            TriggerEvent('rsg-pig:client:startanim', pigId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'Gather meat',
						targeticon = 'fas fa-solid fa-pig',
                        action = function()
                            TriggerServerEvent('rsg-pig:addmeat', pigId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'return pig',
						targeticon = 'fas fa-solid fa-pig',
                        action = function()
                            TriggerEvent('rsg-pig:client:pigreturn', pigId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'lead pigs',
                        targeticon = 'fas fa-solid fa-pig',
                        action = function()
                            TriggerEvent('rsg-pig:client:lead', pigId)
                        end,
                    },
					{
                        type = 'client',
                        label = 'graze pigs',
						targeticon = 'fas fa-solid fa-pig',
                        action = function()
                            TriggerEvent('rsg-pig:client:pas', pigId)
                        end,
                    },
                },
                distance = 5.5,
            })
		end
		
    end
end)

RegisterNetEvent('rsg-pig:client:lead')
AddEventHandler('rsg-pig:client:lead', function(pig)
if IsPedDeadOrDying(pig, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_pig'), 'error', 3000)
return end
		local player = PlayerPedId()
		local playerCoords = GetEntityCoords(player)
		local pigOffset = vector3(0.0, 2.0, 0.0) 
		ClearPedTasks(pig)
		TaskFollowToOffsetOfEntity(pig, player, pigOffset.x, pigOffset.y, pigOffset.z, 1.0, -1, 0.0, 1)
end)

RegisterNetEvent('rsg-pig:client:startanim')
AddEventHandler('rsg-pig:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_pig'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_PIG_RESTING"
			
		}
		local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
		local anim = randomScenario
		ClearPedTasks(animal)
		TaskStartScenarioInPlace(animal, GetHashKey(anim), -1, true, false, false, false)
	end
end)

RegisterNetEvent('rsg-pig:client:pas')
AddEventHandler('rsg-pig:client:pas', function(animal)
    if isFinish then
        RSGCore.Functions.Notify(Lang:t('success.pig_finish'), 'success', 3000)
        return
    end
    if isPasturing then
        RSGCore.Functions.Notify(Lang:t('error.pig_already'), 'error', 3000)
        return
    end

    for i = 1, #pasturingpig do
        local pig = pasturingpig[i]
        if DoesEntityExist(pig) then
            local availableScenarios = {
                "WORLD_ANIMAL_PIG_RESTING"
               
            }
            local randomScenario = availableScenarios[math.random(1, #availableScenarios)]
            local anim = randomScenario
            TaskStartScenarioInPlace(pig, GetHashKey(anim), -1, true, false, false, false)
        end
    end
    RSGCore.Functions.Notify(Lang:t('success.pig_grazing'), 'success', 3000)
    isPasturing = true
    pasturingStartTime = GetGameTimer()
    startPasturing()
end)


RegisterNetEvent('rsg-pig:client:startanim')
AddEventHandler('rsg-pig:client:startanim', function(animal)
if IsPedDeadOrDying(animal, true) then
	RSGCore.Functions.Notify(Lang:t('error.dead_pig'), 'error', 3000)
return end

    if DoesEntityExist(animal) then
		local availableScenarios = {
			"WORLD_ANIMAL_pig_GRAZING",
			"WORLD_ANIMAL_pig_RESTING",
			"WORLD_ANIMAL_pig_SLEEPING"
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



RegisterNetEvent('rsg-pig:client:pigreturn')

AddEventHandler('rsg-pig:client:pigreturn', function()
    if isPasturing then
        local ispigKilled = false

        for _, pig in ipairs(pasturingpig) do
            if DoesEntityExist(pig) then
                if IsPedDeadOrDying(pig, true) then
                    ispigKilled = true
                    break
                end
            end
        end

        for i, pigInfo in ipairs(pasturingpig) do
            SetEntityInvincible(pigInfo, false)
            ClearPedTasks(pigInfo)
            DeletePed(pigInfo)
        end

        pasturingpig = {}
        starting = false

        if not ispigKilled then
            RSGCore.Functions.Notify(Lang:t('success.success_pig'), 'success', 3000)
            TriggerServerEvent('rsg-pig:server:givemoney')
        else
            RSGCore.Functions.Notify(Lang:t('error.dead_pig'), 'error', 3000)
        end

        isPasturing = true
        isFinish = true
    else
        RSGCore.Functions.Notify(Lang:t('error.error_pig'), 'error', 3000)
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
                local remainingTime = Config.WaitTimepig - elapsedTime
                
                if elapsedTime >= Config.WaitTimepig then
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

RegisterNetEvent('rsg-pig:searchAnimation')
AddEventHandler('rsg-pig:searchAnimation', function()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(6000)
    ClearPedTasks(ped)
    TriggerServerEvent('rsg-pig:givemeat') -- After animation, trigger server event to give milk
end)

