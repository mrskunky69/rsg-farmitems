local RSGCore = exports['rsg-core']:GetCoreObject()

local isPlaying = false

RSGCore.Functions.CreateUseableItem("pooppile", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
	local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("rsg_poo:client:placeDJEquipment", source, item.name)
		
    end
end)


RegisterNetEvent('rsg_hay:server:pickedup', function(entity)
    local src = source
    
end)









RegisterNetEvent('rsg_poo:server:pickeupdeckss')
AddEventHandler('rsg_poo:server:pickeupdeckss', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('fertilizer', 3)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['fertilizer'], "add")
    
end)