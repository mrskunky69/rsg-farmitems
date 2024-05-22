local RSGCore = exports['rsg-core']:GetCoreObject()

local barrowObject = nil
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
    local barrow = {
        'p_wheelbarrow03x',
    }
    exports['rsg-target']:AddTargetModel(barrow, {
        options = {
            {
                type = "client",
                event = "rsg_barrow:client:pickupbarrow",
                icon = "fas fa-undo",
                label = "Pick up",
            },
        },
        distance = 3.0
    })
end)

-- Events
RegisterNetEvent('rsg_barrow:client:placebarrow')
AddEventHandler('rsg_barrow:client:placebarrow', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local _, nodePosition = GetClosestRoad(coords.x, coords.y, coords.z, 0, 3.0, 0.0)
    local distance = #(vector3(coords.x, coords.y, coords.z) - nodePosition)

    if distance < 5 then
        TriggerEvent('rNotify:NotifyLeft', "You are on a road.", "Move to a field.", "generic_textures", "tick", 4000)
		TriggerServerEvent('rsg_barrow:server:pickup')
        return
    end

    TaskStartScenarioInPlace(playerPed, GetHashKey("WORLD_HUMAN_CROUCH_INSPECT"), -1, true, false, 0, false)
    Wait(2000)
    local barrowCoords = GetOffsetFromEntityInWorldCoords(playerPed, 5.0, 5.0, 10.0)
    local object = CreateObject(GetHashKey('p_wheelbarrow03x'), barrowCoords.x, barrowCoords.y, barrowCoords.z, true, false, false)
    PlaceObjectOnGroundProperly(object)
    AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, 28422), 0.2, 1.0, -1.0, 3.0, 1.0, -100.0, false, false, false, false, 2, true)
    Wait(1000)
    local barrowHeading = heading
    SetEntityHeading(object, barrowHeading)
    FreezeEntityPosition(object, true) -- Freeze the position of the barrow
    ClearPedTasks(playerPed)
    barrowObject = object
    barrowBone = GetPedBoneIndex(playerPed, 28422) -- Store the bone index
    isPloughing = true
    ploughingStartTime = GetGameTimer()
    lastMovementTime = GetGameTimer()
end)


RegisterNetEvent('rsg_barrow:client:pickupbarrow')
AddEventHandler('rsg_barrow:client:pickupbarrow', function()
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)

    if barrowObject then
        DeleteEntity(barrowObject)
        barrowObject = nil
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
                local cornToAdd = math.floor(elapsedTime / 9000) -- Add 1 corn every 9 seconds of movement
                if cornToAdd > 0 then
                    TriggerServerEvent('rsg_barrow:server:addcornToInventory', cornToAdd)
                    ploughingStartTime = GetGameTimer() -- Reset the start time
                end
            end

            -- Detach plough if player hasn't moved for 5 seconds
            if GetGameTimer() - lastMovementTime >= detachmentDelay then
                TriggerEvent('rsg_barrow:client:pickupbarrow')
				TriggerServerEvent('rsg_barrow:server:pickup')
            end
        end
    end
end)
