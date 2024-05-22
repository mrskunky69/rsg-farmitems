-- Server-side script

local RSGCore = exports['rsg-core']:GetCoreObject()

local CarriedEntities = {}

RegisterServerEvent('carry:start')
AddEventHandler('carry:start', function(entityId)
    local source = source
    local Player = RSGCore.Functions.GetPlayer(source)
    CarriedEntities[player] = entityId
    TriggerClientEvent('carry:syncStart', -1, source, entityId)
end)

RegisterServerEvent('carry:stop')
AddEventHandler('carry:stop', function(entityId)
    local source = source
    local Player = RSGCore.Functions.GetPlayer(source)
    CarriedEntities[player] = nil
    TriggerClientEvent('carry:syncStop', -1, source, entityId)
end)

AddEventHandler('playerDropped', function()
    local source = source
    local Player = RSGCore.Functions.GetPlayer(source)
    if CarriedEntities[player] then
        TriggerClientEvent('carry:syncStop', -1, source, CarriedEntities[playerServerId])
        CarriedEntities[player] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for playerServerId, entityId in pairs(CarriedEntities) do
            if not DoesEntityExist(entityId) then
                CarriedEntities[player] = nil
            end
        end
    end
end)