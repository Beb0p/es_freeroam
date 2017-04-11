-- DEVELOPER NOTES: THIS IS INCOMPLETE IN THE SENSE OF, ITS'S JUST A GENERAL LOOK AT WHAT IT WOULD BE
-- IT IS UP TO YOU, THE USER OF THIS SCRIPT, TO TAKE THE TIME TO PUT THE WEAPONS IN, THE COSTS IN, THE PAYMENT SYSTEM IN
-- ALL OF THAT GENERAL STUFF.

-- var

local gunshop_locations = {
	{-660.101,-935.046,21.829-1.15}, -- puts the marker infront of the cash register
	{840.091,-1033.650,28.194-1.15},
	{-1300.800,-394.393,36.695-1.15},
	{250.110,-50.097,69.941-1.15},
	{2560.920,294.322,108.735-1.15},
	{-3170.810,1087.820,20.838-1.15},
	{-1110.640,2698.440,18.554-1.15},
	{1690.670,3759.930,34.705-1.15},
	{-320.156,6083.840,31.454-1.15},
	{21.840,-1107.430,29.2797-0.50}
}

local inrangeofgunshop = false

local backlock = false

-- menu

local an = {
opened = false,
	title = "Gun Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 0, b = 155, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.08,
		width = 0.4,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = { 
			title = "CATEGORIES", 
			name = "main",
			buttons = { 
				{name = "Weapons", description = ""},
				{name = "Armor", description = ""},
			}
		},
		["weapons"] = { 
			title = "Weapons", 
			name = "weapons",
			buttons = { 
				-- Melee
				{name = "Hatchet", costs = 100, description = "", model = "WEAPON_HATCHET"},
				{name = "Knife", costs = 100, description = "", model = "WEAPON_KNIFE"},
				{name = "Baseball Bat", costs = 100, description = "", model = "WEAPON_BAT"},
				{name = "Pistol", costs = 600, description = "", model = "WEAPON_PISTOL"},
			}
		},
		["IGNORE THIS"] = { 
			title = "IGNORE THIS", 
			name = "IGNORE THIS",
			buttons = { 
			}
		},
		["armor"] = { 
			title = "armor", 
			name = "armor",
			buttons = { 
				{name = "", costs = 999999, description = ""},
			}
		},
	}
}

local function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)	
end

local function OpenCreator()		
	local ped = CurrentPed()
	FreezeEntityPosition(ped,true)
	gshp.currentmenu = "main"
	gshp.opened = true
	gshp.selectedbutton = 0
end

local function CloseCreator()
	local ped = CurrentPed()
	FreezeEntityPosition(ped,false)
	--table.sort(gshp.menu['main'].buttons)
	gshp.opened = false
	gshp.menu.from = 1
	gshp.menu.to = 10
end

local function drawMenuButton(button,x,y,selected)
	local menu = gshp.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)	
end

local function drwMUI(text)
	local menu = gshp.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)	
end

local function drwMUIR(txt,x,y,selected)
	local menu = gshp.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)	
end

local function drwMUITit(txt,x,y)
local menu = gshp.menu
	--SetTextFont(2)
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(0, 255, 100, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)	
end

local function initMenu(menu)
	gshp.lastmenu = gshp.currentmenu
	if menu == "race" then
		gshp.lastmenu = "main"
	elseif menu == "weapons"  then
		gshp.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		gshp.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		gshp.lastmenu = "race_create_objects"
	end
	gshp.menu.from = 1
	gshp.menu.to = 10
	gshp.selectedbutton = 0
	gshp.currentmenu = menu	
end
local function menuSelection(button)
	local ped = GetPlayerPed(-1)
	local this = gshp.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Weapons" then
			initMenu("weapons")
		elseif btn == "Armor" then
			initMenu("armor")
	elseif this == "weapons" then
		if HasPedGotWeapon(CurrentPed(),GetHashKey(button.model),false) then
			AddAmmoToPed(CurrentPed(),GetHashKey(button.model),GetMaxAmmoInClip(GetPlayerPed(-1),GetHashKey(button.model),1))
			-- Needs to have the money system hooked up
		else
			GiveWeaponToPed(CurrentPed(), GetHashKey(button.model), 500, true, true)
			-- Needs to have the money system hooked up
		end
		if GetMaxAmmoInClip(GetPlayerPed(-1),GetHashKey(button.model),1) ~= false then
		table.insert(gshp.menu['selected_weapon'].buttons,{name = "Ammo", costs = 50, description = "", model = button.model})
		initMenu('selected_weapon')
		end
	elseif this == "selected_weapon" then
		if btn == "Ammo" and Citizen.InvokeNative(0xDC16122C7A20C933,CurrentPed(),GetHashKey(button.model),Citizen.PointerValueInt()) ~= GetAmmoInPedWeapon(CurrentPed(),GetHashKey(button.model)) then
			-- Needs to have the money system hooked up
		end
	elseif this == "armor" then
		if btn == "Armor" then
			-- Needs to have the money system hooked up
		end
	end
end

local function Back()
	if backlock then
		return
	end
	backlock = true
	if gshp.currentmenu == "main" then
		CloseCreator()
	elseif gshp.currentmenu == "selected_weapon" then
		gshp.menu['selected_weapon'].buttons = {}
		DisplayAmmoThisFrame(false)
		initMenu(gshp.lastmenu)
	else
		initMenu(gshp.lastmenu)
	end
	
end

-- client

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		local inrange = false
		for i,b in ipairs(gunshop_locations) do
			if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and  gshp.opened == false and IsPedInAnyVehicle(CurrentPed(), true) == false and GetDistanceBetweenCoords(b[1],b[2],b[3],GetEntityCoords(CurrentPed())) < 2 then
				DrawMarker(1,b[1],b[2],b[3],0,0,0,0,0,0,1.501,1.5001,0.5001,0,155,255,200,0,0,0,0)
				drawTxt('Press ~y~ENTER~s~ to ~g~purchase ~b~weapons',0,1,0.5,0.8,0.6,255,255,255,255)
				inrange = true
			end
		end
		inrangeofgunshop = inrange
		if IsControlJustPressed(1,201) and playerIsAtGunShop() then
			if gshp.opened then
				
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if gshp.opened then
			local ped = CurrentPed()
			local menu = gshp.menu[gshp.currentmenu]
			drawTxt(gshp.title,1,1,gshp.menu.x,gshp.menu.y,1.0, 255,255,255,255)
			drwMUITit(menu.title, gshp.menu.x,gshp.menu.y + 0.08)
			drawTxt(gshp.selectedbutton.."/"..tablelength(menu.buttons),0,0,gshp.menu.x + gshp.menu.width/2 - 0.0385,gshp.menu.y + 0.067,0.4, 255,255,255,255)
			local y = gshp.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			
			for i,button in pairs(menu.buttons) do
				if i >= gshp.menu.from and i <= gshp.menu.to then
					
					if i == gshp.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,gshp.menu.x,y,selected)
					if button.costs ~= nil then
						if gshp.currentmenu == "weapons" then
							if HasPedGotWeapon(CurrentPed(),GetHashKey(button.model),false) then
								drwMUIR("OWNED",gshp.menu.x,y,selected)
							else
								drwMUIR(button.costs.."$",gshp.menu.x,y,selected)
							end
						elseif gshp.currentmenu == "selected_weapon" then
							if Citizen.InvokeNative(0xDC16122C7A20C933,CurrentPed(),GetHashKey(button.model),Citizen.PointerValueInt()) == GetAmmoInPedWeapon(CurrentPed(),GetHashKey(button.model)) then
								drwMUIR("FULL",gshp.menu.x,y,selected)
							else
								drwMUIR(button.costs.."$",gshp.menu.x,y,selected)
							end
						else
							drwMUIR(button.costs.."$",gshp.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						menuSelection(button)
					end
				end
			end	
		end
		if gshp.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if gshp.selectedbutton > 1 then
					gshp.selectedbutton = gshp.selectedbutton -1
					if buttoncount > 10 and gshp.selectedbutton < gshp.menu.from then
						gshp.menu.from = gshp.menu.from -1
						gshp.menu.to = gshp.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if gshp.selectedbutton < buttoncount then
					gshp.selectedbutton = gshp.selectedbutton +1
					if buttoncount > 10 and gshp.selectedbutton > gshp.menu.to then
						gshp.menu.to = gshp.menu.to + 1
						gshp.menu.from = gshp.menu.from + 1
					end
				end	
			end
		end
		
	end
end)

local function playerIsAtGunShop()
	return inrangeofgunshop
end

-- utilities

local function CurrentPed()
	return GetPlayerPed(-1)
end

local function stringstarts(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end

local function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local function round(num, idp)
	if idp and idp>0 then
	local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end


local function f(n)
	return n + 0.0001
end

local function try(f, catch_f)
	local status, exception = pcall(f)

	if not status then
		catch_f(exception)
	end
end

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end