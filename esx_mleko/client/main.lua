local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local kodaQTE       			= 0
ESX 			    			= nil
local koda_poochQTE 			= 0
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_mleko:hasEnteredMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	--CatchOrange, OrangeJuice, SellOrangeJuice
	if zone == 'MakeMilk' then
		CurrentAction     = zone
		CurrentActionMsg  = _U('make_milk')
		CurrentActionData = {}
	elseif zone == 'MakeSmietana' then
	  CurrentAction     = zone
	  CurrentActionMsg  = _U('make_smietana')
	  CurrentActionData = {}
	elseif zone == 'MakeCheese' then
    CurrentAction     = zone
	  CurrentActionMsg  = _U('make_cheese')
	  CurrentActionData = {}
	elseif zone == 'SellCheese' then
    CurrentAction     = zone
		CurrentActionMsg  = _U('sell_cheese')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_mleko:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()

	if zone == 'MakeMilk' then
		TriggerServerEvent('esx_mleko:stopMakeMilk')
	elseif zone == 'MakeSmietana' then
		TriggerServerEvent('esx_mleko:stopMakeSmietana')
	elseif zone == 'MakeCheese' then
		TriggerServerEvent('esx_mleko:stopMakeCheese')
	elseif zone == 'SellCheese' then
		TriggerServerEvent('esx_mleko:stopSellCheese')
	end
end)

-- marker
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

if Config.ShowBlips then
	-- oznaczenie
	Citizen.CreateThread(function()
		for k,v in pairs(Config.Zones) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)

			SetBlipSprite (blip, v.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.5)
			SetBlipColour (blip, v.color)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(blip)
		end
	end)
end

-- itemsy
RegisterNetEvent('esx_mleko:ReturnInventory')
AddEventHandler('esx_mleko:ReturnInventory', function(kodaNbr, kodapNbr, jobName, currentZone)
	kodaQTE			= kodaNbr
	koda_poochQTE	= kodapNbr
	myJob			= jobName
	TriggerEvent('esx_mleko:hasEnteredMarker', currentZone)
end)

-- menu w markerze
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('esx_mleko:GetUserInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_mleko:hasExitedMarker', lastZone)
		end
	end
end)

-- klawisze
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, Keys['E']) and IsPedOnFoot(PlayerPedId()) then
				if CurrentAction == 'MakeMilk' then
					TriggerServerEvent('esx_mleko:startMakeMilk')
				elseif CurrentAction == 'MakeSmietana' then
					TriggerServerEvent('esx_mleko:startMakeSmietana')
				elseif CurrentAction == 'MakeCheese' then
					TriggerServerEvent('esx_mleko:startMakeCheese')
				elseif CurrentAction == 'SellCheese' then
					TriggerServerEvent('esx_mleko:startSellCheese')
				end
				
				CurrentAction = nil
			end
		end
	end
end)
