Config              = {}
Config.MarkerType   = 1
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 4.0, y = 4.0, z = 1.0}
Config.MarkerColor  = {r = 0, g = 0, b = 255}
Config.ShowBlips   = true  -- Blip Mapa

Config.TimeToFarm    = 1 * 1000
Config.TimeToProcess = 1 * 1000
Config.TimeToSell    = 1  * 1000
Config.TimeToMakeCheese = 1 * 1000

Config.Money = 100
Config.HowMuchMilkGet = 1
Config.HowMuchMilkWithdraw = 1
Config.HowMuchSmietanaGet = 1
Config.HowMuchSmietanaWithdraw = 1
Config.HowMuchSerGet = 1
Config.HowMuchSerSell = 1

Config.Min = 1

Config.Locale = 'en'

Config.Zones = {
	MakeMilk =		{x = 2488.95, y = 4961.656, z = 43.786,	name = _U('orange_picking'),		sprite = 85,	color = 38},
	MakeSmietana =	{x = 2890.798, y = 4380.823, z = 49.334,	name = _U('turns_from_juice'),	sprite = 85,	color = 38},
	MakeCheese =		{x = 244.62, y = 3113.49, z = 41.487,	name = _U('blip_cheese'),		sprite = 85,	color = 38},
	SellCheese =		{x = 92.409, y = -1742.107, z = 28.305,	name = _U('sell_juice_orage_blip'),		sprite = 85,	color = 38}
}
