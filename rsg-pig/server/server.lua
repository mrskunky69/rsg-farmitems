local RSGCore = exports['rsg-core']:GetCoreObject()


RegisterServerEvent('rsg-pig:addmeat')
AddEventHandler('rsg-pig:addmeat', function() 
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local randomNumber = math.random(1, 4)

    if randomNumber > 0 and randomNumber <= 3 then
        -- Player successfully finds milk
        TriggerClientEvent('rsg-pig:searchAnimation', src)
    else
        -- Player fails to find anything
        TriggerClientEvent('rNotify:NotifyLeft', src, "YOU FAIL", "TO FIND ANYTHING", "generic_textures", "tick", 4000)
    end
end)
RegisterServerEvent('rsg-pig:server:givemoney')
AddEventHandler('rsg-pig:server:givemoney', function()
    local Player = RSGCore.Functions.GetPlayer(source)
	local moneyReward = Config.MoneyReward
	Player.Functions.AddMoney('cash', moneyReward)
end)

	

	
RSGCore.Functions.CreateUseableItem("pig", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
	local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
	if Player.Functions.RemoveItem(item.name, 0, item.slot) then
        TriggerClientEvent("rsg-pig:client:pigspawn", source, item.name)
		
    end
end)

RegisterServerEvent('rsg-pig:givemeat')
AddEventHandler('rsg-pig:givemeat', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local quantity = math.random(1, 2) -- Random quantity of milk (1 or 2)
    Player.Functions.AddItem('raw_meat', quantity)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['raw_meat'], "add")
    TriggerClientEvent('rNotify:NotifyLeft', src, "YOU HAVE GATHERED", "MEAT", "generic_textures", "tick", 4000)
end)


