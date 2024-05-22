local RSGCore = exports['rsg-core']:GetCoreObject()

local isPlaying = false

RSGCore.Functions.CreateUseableItem("hay", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
	local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("rsg_hay:client:placeDJEquipment", source, item.name)
		
    end
end)


RegisterNetEvent('rsg_hay:server:pickedup', function(entity)
    local src = source
    
end)









RegisterNetEvent('rsg_hay:server:pickeupdeckss')
AddEventHandler('rsg_hay:server:pickeupdeckss', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('haybale', 3)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['haybale'], "add")
    
end)