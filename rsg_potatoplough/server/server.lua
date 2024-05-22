local RSGCore = exports['rsg-core']:GetCoreObject()

local isPlaying = false

RSGCore.Functions.CreateUseableItem("plough", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
	local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("rsg_plough:client:placeplough", source, item.name)
		
    end
end)


RegisterNetEvent('rsg_plough:server:addpotatoToInventory')
AddEventHandler('rsg_plough:server:addpotatoToInventory', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('potato', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['potato'], "add")
    
end)











RegisterNetEvent('rsg_plough:server:pickup')
AddEventHandler('rsg_plough:server:pickup', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- Add plough to player's inventory
    Player.Functions.AddItem('plough', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['plough'], "add")
end)
