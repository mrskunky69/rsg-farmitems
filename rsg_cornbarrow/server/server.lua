local RSGCore = exports['rsg-core']:GetCoreObject()

local isPlaying = false

RSGCore.Functions.CreateUseableItem("barrow", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
	local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("rsg_barrow:client:placebarrow", source, item.name)
		
    end
end)


RegisterNetEvent('rsg_barrow:server:addcornToInventory')
AddEventHandler('rsg_barrow:server:addcornToInventory', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('corn', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['corn'], "add")
    
end)











RegisterNetEvent('rsg_barrow:server:pickup')
AddEventHandler('rsg_barrow:server:pickup', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    -- Add barrow to player's inventory
    Player.Functions.AddItem('barrow', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['barrow'], "add")
end)
