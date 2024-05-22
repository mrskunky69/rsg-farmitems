local RSGCore = exports['rsg-core']:GetCoreObject()
local EntityInHands
local CarriedEntities = {}
local TargetModels = {}
local PlayerStartCoords = nil
local PlayerendCoords = nil

RegisterNetEvent('hay:syncStart')
AddEventHandler('hay:syncStart', function(source, entityId)
    local entityToAttach = NetworkGetEntityFromNetworkId(entityId)
    AttachEntityToEntity(entityToAttach, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.6, -0.3, 0.0, 0.0, 0.0, false, false, true, false, 0, true, false, false)
    CarriedEntities[source] = entityId
end)

RegisterNetEvent('hay:syncStop')
AddEventHandler('hay:syncStop', function(source, entityId)
    local entityToDetach = NetworkGetEntityFromNetworkId(entityId)
    DetachEntity(entityToDetach, false, true)
    CarriedEntities[source] = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 0xCEFD9220) then -- E key
            Drop()
        end
    end
end)

function Drop()
    if EntityInHands then
        local endCoords = GetEntityCoords(PlayerPedId())
        print("End Coords: " .. tostring(endCoords))  -- Debug statement
        TriggerServerEvent('hay:stop', NetworkGetNetworkIdFromEntity(EntityInHands), endCoords)
        StopCarrying(EntityInHands)
        EntityInHands = nil
		

    end
end



for i = 1, #Config.ModelList do
    table.insert(TargetModels, {
        model = Config.ModelList[i][1],
        distance = Config.ModelList[i][2]
    })
end

for _, targetData in ipairs(TargetModels) do
    exports['rsg-target']:AddTargetModel(targetData.model, {
        options = {
            {
                type = "client",
                event = "hay:toggle",
                icon = "fas fa-undo",
                label = "Pick up",
                args = targetData.model
            },
        },
        distance = targetData.distance
    })
end

RegisterNetEvent('hay:toggle')
RegisterNetEvent('hay:drop')

function GetNearbyEntities(entityType, coords)
    local itemset = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, Config.MaxDistance, itemset, entityType, Citizen.ResultAsInteger())

    local entities = {}

    if size > 0 then
        for i = 0, size - 1 do
            table.insert(entities, GetIndexedItemInItemset(i, itemset))
        end
    end

    if IsItemsetValid(itemset) then
        DestroyItemset(itemset)
    end

    return entities
end

function GetClosestNetworkedEntity()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestEntity
    local minDistance

    for _, targetData in ipairs(TargetModels) do
        local objects = GetNearbyEntities(3, playerCoords)
        
        for _, object in ipairs(objects) do
            if GetEntityModel(object) == GetHashKey(targetData.model) then
                local objectCoords = GetEntityCoords(object)
                local distance = #(playerCoords - objectCoords)

                if (not minDistance or distance < minDistance) and distance <= targetData.distance then
                    minDistance = distance
                    closestEntity = object
                end
            end
        end
    end

    return closestEntity
end

function StartCarrying(entity)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local handBoneIndex = GetPedBoneIndex(playerPed, 28422)
    PlayerStartCoords = playerCoords
    NetworkRequestControlOfEntity(entity)
    FreezeEntityPosition(entity, true)
    AttachEntityToEntity(entity, playerPed, handBoneIndex, 0.0, 0.6, -0.3, 0.0, 0.0, 0.0, false, false, true, false, 0, true, false, false)
    TriggerServerEvent('hay:start', NetworkGetNetworkIdFromEntity(entity), playerCoords)
    TriggerEvent('rNotify:NotifyLeft', "PRESS E TO", "DROP", "generic_textures", "tick", 4000)
end

function Drop()
    if EntityInHands then
        local endCoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('hay:stop', NetworkGetNetworkIdFromEntity(EntityInHands), endCoords)
        StopCarrying(EntityInHands)
        EntityInHands = nil
    end
end



RegisterCommand("dropitem", function(source, args, rawCommand)
    Drop()
end, false)

function LoadAnimDict(dict)
    if DoesAnimDictExist(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(0)
        end
    end
end

function PlayPickUpAnimation()
    LoadAnimDict(Config.PickUpAnimDict)
    TaskPlayAnim(PlayerPedId(), Config.PickUpAnimDict, Config.PickUpAnimName, 1.0, 1.0, -1, 0, 0, false, false, false, '', false)
    RemoveAnimDict(Config.PickUpAnimDict)
end

function StartCarryingClosestEntity()
    local entity = GetClosestNetworkedEntity()

    if entity then
        PlayPickUpAnimation()

        Citizen.Wait(750)

        StartCarrying(entity)

        return entity
    end
end

function PlayPutDownAnimation()
    LoadAnimDict(Config.PutDownAnimDict)
    TaskPlayAnim(PlayerPedId(), Config.PutDownAnimDict, Config.PutDownAnimName, 1.0, 1.0, -1, 0, 0, false, false, false, '', false)
    RemoveAnimDict(Config.PutDownAnimDict)
end

function PlacePedOnGroundProperly(ped)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local found, groundz, normal = GetGroundZAndNormalFor_3dCoord(x, y, z)
    if found then
        SetEntityCoordsNoOffset(ped, x, y, groundz + normal.z, true)
    end
end

function PlaceOnGroundProperly(entity)
    local entityType = GetEntityType(entity)

    if entityType == 1 then
        PlacePedOnGroundProperly(entity)
    elseif entityType == 2 then
        SetVehicleOnGroundProperly(entity)
    elseif entityType == 3 then
        PlaceObjectOnGroundProperly(entity)
    end
end

function StopCarrying(entity)
    local heading = GetEntityHeading(entity)

    ClearPedTasks(PlayerPedId())

    PlayPutDownAnimation()

    Citizen.Wait(500)

    NetworkRequestControlOfEntity(entity)
    FreezeEntityPosition(entity, false)
    DetachEntity(entity, false, true)
    PlaceOnGroundProperly(entity)
    SetEntityHeading(entity, heading)
	TriggerEvent('hay:addCash', source, amount)
end

function ToggleCarry()
    if EntityInHands then
        Stop()
    else
        Start()
    end
end

function Start()
    local entity = StartCarryingClosestEntity()
    if entity then
        EntityInHands = entity
    end
end

function Stop()
    if EntityInHands then
        StopCarrying(EntityInHands)
        EntityInHands = nil
    end
end

function Drop()
    if EntityInHands then
        local endCoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('hay:stop', NetworkGetNetworkIdFromEntity(EntityInHands), endCoords)
        StopCarrying(EntityInHands)
        EntityInHands = nil
    end
end



function PlayPickUpAnimation()
    LoadAnimDict(Config.PickUpAnimDict)
    TaskPlayAnim(PlayerPedId(), Config.PickUpAnimDict, Config.PickUpAnimName, 1.0, 1.0, -1, 0, 0, false, false, false, '', false)
    RemoveAnimDict(Config.PickUpAnimDict)
end

function PlayPutDownAnimation()
    LoadAnimDict(Config.PutDownAnimDict)
    TaskPlayAnim(PlayerPedId(), Config.PutDownAnimDict, Config.PutDownAnimName, 1.0, 1.0, -1, 0, 0, false, false, false, '', false)
    RemoveAnimDict(Config.PutDownAnimDict)
end

AddEventHandler('hay:toggle', ToggleCarry)
AddEventHandler('hay:drop', Drop)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if EntityInHands then
            DisableControlAction(0, 0x07CE1E61, true)
            DisableControlAction(0, 0xB2F377E8, true)
            DisableControlAction(0, 0x018C47CF, true)
            DisableControlAction(0, 0x2277FAE9, true)

            if not IsEntityAttachedToEntity(EntityInHands, PlayerPedId()) or GetEntityHealth(EntityInHands) == 0 then
                Stop()
            elseif not IsEntityPlayingAnim(PlayerPedId(), Config.CarryAnimDict, Config.CarryAnimName, 25) then
                
            end
        end
    end
end)
