-- Variables

local RSGCore = exports['rsg-core']:GetCoreObject()
local deployeddecks = nil


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

-- target
Citizen.CreateThread(function()
    local djdecksprop = {
        `p_haypile04x`,
    }
    exports['rsg-target']:AddTargetModel(djdecksprop, {
        options = {
            {
                type = "client",
                event = "rsg_hay:client:placehay",
                icon = "fas fa-undo",
                label = "Rake Haybale",
            },
        },
        distance = 3.0
    })
end)

-- Events

-- place dj equipment
RegisterNetEvent('rsg_hay:client:placeDJEquipment')
AddEventHandler('rsg_hay:client:placeDJEquipment', function()
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local forward = GetEntityForwardVector(PlayerPedId())
    local x, y, z = table.unpack(coords + forward * 2.5)
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey("WORLD_HUMAN_CROUCH_INSPECT"), -1, true, false, 0, false)
    Wait(2000)
    ClearPedTasks(PlayerPedId())
    local object = CreateObject(GetHashKey('p_haypile04x'), x, y, z, true, false, false)
    PlaceObjectOnGroundProperly(object)
    SetEntityHeading(object, heading)
    FreezeEntityPosition(object, true)
    deployeddecks = NetworkGetNetworkIdFromEntity(object)
end)

RegisterNetEvent('rsg_hay:client:placehay')
AddEventHandler('rsg_hay:client:placehay', function()
    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local forward = GetEntityForwardVector(PlayerPedId())
    local x, y, z = table.unpack(coords + forward * 2.5)
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey("WORLD_HUMAN_FARMER_RAKE"), -1, true, false, 0, false)
    Wait(10000)
    ClearPedTasks(PlayerPedId())
	TriggerServerEvent("rsg_hay:server:pickeupdeckss")
	TriggerEvent('rNotify:NotifyLeft', "you got haybales", "nice", "generic_textures", "tick", 4000)

    -- Delete the previously deployed hay bale
    if deployeddecks ~= nil then
        local object = NetworkGetEntityFromNetworkId(deployeddecks)
        if DoesEntityExist(object) then
            DeleteEntity(object)
            deployeddecks = nil
        end
    end
end)







