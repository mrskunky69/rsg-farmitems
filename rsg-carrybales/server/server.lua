local RSGCore = exports['rsg-core']:GetCoreObject()

local CarriedEntities = {}
local PlayerStartCoords = {}

RegisterServerEvent('hay:start')
AddEventHandler('hay:start', function(entityId, startCoords)
    local source = source
    CarriedEntities[source] = entityId
    PlayerStartCoords[source] = startCoords
    
end)

RegisterNetEvent('hay:stop')
AddEventHandler('hay:stop', function(entityId, endCoords)
    local source = source
    local startCoords = PlayerStartCoords[source]
    local distance = 0
    local payment = 0

    
    if startCoords and endCoords then
        distance = #(endCoords - startCoords)
        payment = math.floor(distance * Config.PaymentPerMeter)
    else
        
        return
    end

    if payment > 0 then
        local Player = RSGCore.Functions.GetPlayer(source)
        Player.Functions.AddMoney("cash", payment, "Carrying Payment")
        TriggerClientEvent('rNotify:NotifyLeft', source, "YOU EARNED $" .. payment, "CARRYING PAYMENT", "generic_textures", "tick", 4000)
    else
        
    end

    -- Clear data after processing
    CarriedEntities[source] = nil
    PlayerStartCoords[source] = nil
end)
RegisterNetEvent('hay:stop')
AddEventHandler('hay:stop', function(entityId)
    local source = source
    local payment = math.random(Config.MinPayment, Config.MaxPayment) -- Generate a random payment amount
    
    local Player = RSGCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.AddMoney("cash", payment, "Carrying Payment")
        print("Cash added: $" .. payment)  -- Debug print
        TriggerClientEvent('rNotify:NotifyLeft', source, "YOU EARNED $" .. payment, "CARRYING PAYMENT", "generic_textures", "tick", 4000)
    else
        print("Failed to find player with source ID: " .. tostring(source))
    end
end)













AddEventHandler('playerDropped', function()
    local source = source
    if CarriedEntities[source] then
        TriggerClientEvent('hay:syncStop', -1, source, CarriedEntities[source])
        local startCoords = PlayerStartCoords[source]
        local endCoords = GetEntityCoords(PlayerPedId()) -- Assuming this gets the end coordinates when the player drops the item
        local distance = 0
        if startCoords and endCoords then
            distance = #(endCoords - startCoords)
        else
            
            return
        end

        local payment = math.floor(distance * Config.PaymentPerMeter)
        if payment > 0 then
            TriggerEvent('hay:addCash', source, payment) -- Trigger the event to add cash
        else
            
        end

        CarriedEntities[source] = nil
        PlayerStartCoords[source] = nil
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for source, entityId in pairs(CarriedEntities) do
            if not DoesEntityExist(entityId) then
                CarriedEntities[source] = nil
                PlayerStartCoords[source] = nil
            end
        end
    end
end)
