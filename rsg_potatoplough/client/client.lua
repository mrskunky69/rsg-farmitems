local RSGCore = exports['rsg-core']:GetCoreObject()

local ploughObject = nil
local isPloughing = false
local ploughingStartTime = 0
local lastMovementTime = 0
local detachmentDelay = 10000  -- 5 seconds in milliseconds
local ploughingAreaMin = vector3(1975.0, 1961.0, 254.0)
local ploughingAreaMax = vector3(1980.0, 1966.0, 259.0)

-- Functions
local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local function helpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end



-- Target Creation
Citizen.CreateThread(function()
    local ploughModels = {
        'p_handplow01x',
    }
    exports['rsg-target']:AddTargetModel(ploughModels, {
        options = {
            {
                type = "client",
                event = "rsg_plough:client:pickupplough",
                icon = "fas fa-undo",
                label = "Pick up",
            },
        },
        distance = 3.0
    })
end)

-- Events
RegisterNetEvent('rsg_plough:client:placeplough')
AddEventHandler('rsg_plough:client:placeplough', function()
    local ped = PlayerPedId()
    local location = GetEntityCoords(ped)
    local x, y, z = table.unpack(location)
    local _, nodePosition = GetClosestRoad(x, y, z, 0, 3.0, 0.0)
    local distance = #(vector3(x, y, z) - nodePosition)

    if distance < 5 then
        TriggerEvent('rNotify:NotifyLeft', "You are on a road.", "Move to a field area.", "generic_textures", "tick", 4000)
		TriggerServerEvent('rsg_plough:server:pickup')
        return
    else
        -- Continue with plough placement logic if the player is not on a road
        TaskStartScenarioInPlace(ped, GetHashKey("WORLD_HUMAN_CROUCH_INSPECT"), -1, true, false, 0, false)
        Wait(2000)
        local ploughCoords = GetOffsetFromEntityInWorldCoords(ped, 5.0, 5.0, 10.0)
        local object = CreateObject(GetHashKey('p_handplow01x'), ploughCoords.x, ploughCoords.y, ploughCoords.z, true, false, false)
        PlaceObjectOnGroundProperly(object)
        AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 28422), 0.0, 1.5, -1.0, 3.0, 1.0, -180.0, false, false, false, false, 2, true)
        Wait(1000)
        local ploughHeading = GetEntityHeading(ped)
        SetEntityHeading(object, ploughHeading)
        FreezeEntityPosition(object, true)
        ClearPedTasks(ped)
        ploughObject = object
        ploughBone = GetPedBoneIndex(ped, 28422)
        isPloughing = true
        ploughingStartTime = GetGameTimer()
        lastMovementTime = GetGameTimer()

        -- Check if the player is not on a road before adding items to inventory
        -- Add your item addition logic here
        -- For example:
        -- TriggerEvent('player:addItem', 'plough', 1) -- Add plough item to inventory
    end
end)






RegisterNetEvent('rsg_plough:client:pickupplough')
AddEventHandler('rsg_plough:client:pickupplough', function()
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)

    if ploughObject then
        DeleteEntity(ploughObject)
        ploughObject = nil
    end

    isPloughing = false
    ploughingStartTime = 0
    lastMovementTime = 0
end)

-- Main Thread
Citizen.CreateThread(function()
    while true do
        Wait(0)

        if isPloughing then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            if IsPedSprinting(playerPed) or IsPedRunning(playerPed) or GetEntitySpeedVector(playerPed, true).y > 1.0 or GetEntitySpeedVector(playerPed, true).x > 2.0 then
                lastMovementTime = GetGameTimer()
                local elapsedTime = GetGameTimer() - ploughingStartTime
                local potatoToAdd = math.floor(elapsedTime / 9000) -- Add 1 potato every 9 seconds of movement
                if potatoToAdd > 0 then
                    TriggerServerEvent('rsg_plough:server:addpotatoToInventory', potatoToAdd)
                    ploughingStartTime = GetGameTimer() -- Reset the start time
                end
            end

            -- Detach plough if player hasn't moved for 5 seconds
            if GetGameTimer() - lastMovementTime >= detachmentDelay then
                TriggerEvent('rsg_plough:client:pickupplough')
				TriggerServerEvent('rsg_plough:server:pickup')
            end
        end
    end
end)
