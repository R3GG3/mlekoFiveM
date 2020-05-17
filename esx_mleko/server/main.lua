ESX 						   = nil
--local CopsConnected       	   = 0
local PlayersMilk = {}
local PlayersSmietana = {}
local PlayersCheese = {}
local PlayersSellCheese = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--kodeina
local function HarvestMilk(source)

	SetTimeout(Config.TimeToFarm, function()
		if PlayersMilk[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local mleko = xPlayer.getInventoryItem('mleko')

			if mleko.limit ~= -1 and mleko.count >= mleko.limit then
				TriggerClientEvent('esx:showNotification', source, _U('bag_full'))
			else
				xPlayer.addInventoryItem('mleko', Config.HowMuchMilkGet)
				HarvestMilk(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mleko:startMakeMilk')
AddEventHandler('esx_mleko:startMakeMilk', function()
	local _source = source
	if not PlayersMilk[_source] then
		PlayersMilk[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('take_orage'))
		HarvestMilk(_source)
	else
		print(('esx_mleko: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_mleko:stopMakeMilk')
AddEventHandler('esx_mleko:stopMakeMilk', function()
	local _source = source

	PlayersMilk[_source] = false
end)

local function Smietana(source)

	SetTimeout(Config.TimeToProcess, function()
		if PlayersSmietana[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local kodaQuantity = xPlayer.getInventoryItem('mleko').count
			local pooch = xPlayer.getInventoryItem('smietana')

			if pooch.limit ~= -1 and pooch.count >= pooch.limit then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_have_enough_oranges'))
			elseif kodaQuantity < 2 then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_have_any_more_oranges'))
			else
				xPlayer.removeInventoryItem('mleko', Config.HowMuchMilkWithdraw)
				xPlayer.addInventoryItem('smietana', Config.HowMuchSmietanaGet)
				Smietana(source)
			end
		end
	end)
end

RegisterServerEvent('esx_mleko:startMakeSmietana')
AddEventHandler('esx_mleko:startMakeSmietana', function()
	local _source = source

	if not PlayersSmietana[_source] then
		PlayersSmietana[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('transform_juice_orage'))
		Smietana(_source)
	else
		print(('esx_mleko: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_mleko:stopMakeSmietana')
AddEventHandler('esx_mleko:stopMakeSmietana', function()
	local _source = source

	PlayersSmietana[_source] = false
end)

local function SellCheese(source)

	SetTimeout(Config.TimeToSell, function()
		if PlayersSellCheese[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local poochQuantity = xPlayer.getInventoryItem('ser').count

			if poochQuantity == 0 then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_have_cheese'))
			else
				xPlayer.removeInventoryItem('ser', Config.HowMuchSerSell)
				xPlayer.addAccountMoney('bank', Config.Money)
				TriggerClientEvent('esx:showNotification', source, _U('sell_juice'))
			end
				SellCheese(source)
		end
	end)
end

local function Cheese(source)

	SetTimeout(Config.TimeToMakeCheese, function()
		if PlayersCheese[source] then
			local xPlayer = ESX.GetPlayerFromId(source)
			local ile_smietany = xPlayer.getInventoryItem('smietana').count
			local ile_sera = xPlayer.getInventoryItem('ser')

			if ile_sera.limit ~= -1 and ile_sera.count >= ile_sera.limit then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_have_enough_oranges'))
			elseif ile_smietany < 2 then
				TriggerClientEvent('esx:showNotification', source, _U('you_do_not_have_smietana'))
			else
				xPlayer.removeInventoryItem('smietana', Config.HowMuchSmietanaWithdraw)
				xPlayer.addInventoryItem('ser', Config.HowMuchSerGet)
				Cheese(source)
			end
		end
	end)
end


RegisterServerEvent('esx_mleko:startMakeCheese')
AddEventHandler('esx_mleko:startMakeCheese', function()
	local _source = source

	if not PlayersCheese[_source] then
		PlayersCheese[_source] = true
		TriggerClientEvent('esx:showNotification', _source, _U('transform_cheese'))
		Cheese(_source)
	else
		print(('esx_mleko: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_mleko:stopMakeCheese')
AddEventHandler('esx_mleko:stopMakeCheese', function()
	local _source = source
	PlayersCheese[_source] = false
end)

RegisterServerEvent('esx_mleko:startSellCheese')
AddEventHandler('esx_mleko:startSellCheese', function()
	local _source = source

	if not PlayersSellCheese[_source] then
		PlayersSellCheese[_source] = true

		TriggerClientEvent('esx:showNotification', _source, _U('sell_juice_orange'))
		SellCheese(_source)
	else
		print(('esx_mleko: %s attempted to exploit the marker!'):format(GetPlayerIdentifiers(_source)[1]))
	end
end)

RegisterServerEvent('esx_mleko:stopSellCheese')
AddEventHandler('esx_mleko:stopSellCheese', function()
	local _source = source

	PlayersSellCheese[_source] = false
end)

RegisterServerEvent('esx_mleko:GetUserInventory')
AddEventHandler('esx_mleko:GetUserInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_mleko:ReturnInventory',
		_source,
		xPlayer.getInventoryItem('mleko').count,
		xPlayer.getInventoryItem('smietana').count,
		xPlayer.job.name,
		currentZone
	)
end)