local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterServerEvent('rsg-bulls:server:givemoney')
AddEventHandler('rsg-bulls:server:givemoney', function()
    local Player = RSGCore.Functions.GetPlayer(source)
	local moneyReward = Config.MoneyReward
	Player.Functions.AddMoney('cash', moneyReward)
end)

RegisterServerEvent('rsg-bulls:addmilk')
AddEventHandler('rsg-bulls:addmilk', function() 
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
    local randomNumber = math.random(1, 4)

    if randomNumber > 0 and randomNumber <= 3 then
        -- Player successfully finds milk
        TriggerClientEvent('rsg-bulls:searchAnimation', src)
    else
        -- Player fails to find anything
        TriggerClientEvent('rNotify:NotifyLeft', src, "YOU FAIL", "TO FIND ANYTHING", "generic_textures", "tick", 4000)
    end
end)


	
	
RSGCore.Functions.CreateUseableItem("cow", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
	local firstname = Player.PlayerData.charinfo.firstname
    local lastname = Player.PlayerData.charinfo.lastname
	if Player.Functions.RemoveItem(item.name, 0, item.slot) then
        TriggerClientEvent("rsg-bulls:client:bullspawn", source, item.name)
		
    end
end)

RegisterServerEvent('rsg-bulls:giveMilk')
AddEventHandler('rsg-bulls:giveMilk', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local quantity = math.random(1, 2) -- Random quantity of milk (1 or 2)
    Player.Functions.AddItem('milk', quantity)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items['milk'], "add")
    TriggerClientEvent('rNotify:NotifyLeft', src, "YOU HAVE GATHERED", "MILK", "generic_textures", "tick", 4000)
end)


