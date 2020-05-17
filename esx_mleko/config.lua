Config              = {}
Config.MarkerType   = 1
Config.DrawDistance = 100.0
Config.ZoneSize     = {x = 4.0, y = 4.0, z = 1.0}
Config.MarkerColor  = {r = 0, g = 0, b = 255}
Config.ShowBlips   = true  -- Blip Mapa

Config.TimeToFarm    = 1 * 1000
Config.TimeToProcess = 1 * 1000
Config.TimeToSell    = 1  * 1000

Config.Locale = 'en'

Config.Zones = {
	MakeMilk =		{x = 328.64,	y = 6530.87,	z = 27.69,	name = _U('orange_picking'),		sprite = 500,	color = 44},
	MakeSmietana =	{x = 406.1,	y = 6450.72,	z = 28.81,	name = _U('turns_from_juice'),	sprite = 499,	color = 47},
	MakeCheese =		{x = 104.73,	y = -932.8,	z = 29.82,	name = _U('make_cheese'),		sprite = 500,	color = 47},
	SellCheese =		{x = 130.73,	y = -932.8,	z = 29.82,	name = _U('sell_juice_orage_blip'),		sprite = 500,	color = 47}
}
