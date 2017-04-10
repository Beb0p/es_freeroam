-- DEVELOPER NOTES: THIS IS INCOMPLETE IN THE SENSE OF, ITS'S JUST A GENERAL LOOK AT WHAT IT WOULD BE
-- IT IS UP TO YOU, THE USER OF THIS SCRIPT, TO TAKE THE TIME TO PUT THE WEAPONS IN, THE COSTS IN, THE PAYMENT SYSTEM IN
-- ALL OF THAT GENERAL STUFF.

local an = {
opened = false,
	title = "Gun Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.08,
		width = 0.2,
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
		["selected_weapon"] = { 
			title = "WEAPON", 
			name = "selected_weapon",
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

local gunshop_locations = {
{-662.101,-935.046,21.829-1.15},
local gunshop_blips ={}
local inrangeofgunshop = false

local role = ''

local function LocalPed()
return GetPlayerPed(-1)
end

local function Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

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

local function IsPlayerInRangeOfgunshop()
return inrangeofgunshop
end

local function ShowgunshopBlips(bool)
	if #gunshop_blips > 0 then
		for i,b in ipairs(gunshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		gunshop_blips = {}
	end
		for station,pos in pairs(gunshop_locations) do
			-[[local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip,110)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Ammu-Nation')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(gunshop_blips, {blip = blip, pos = pos})]]
			-- READ THIS:
			-- If you are using ESSENTIAL_FREEROAM, the gunstore blips are already on the map
		end
end

local function f(n)
return n + 0.0001
end

local function LocalPed()
return GetPlayerPed(-1)
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
local function OpenCreator()		
	local ped = LocalPed()
	FreezeEntityPosition(ped,true)
	if role == 'police' then
		an.menu['main'].buttons[1+#an.menu['main'].buttons] = {name = "POLICE Loadout", description = ""}
	end
	an.currentmenu = "main"
	an.opened = true
	an.selectedbutton = 0
end

local function CloseCreator()
	local ped = LocalPed()
	FreezeEntityPosition(ped,false)
	for i,btn in pairs(an.menu['main'].buttons) do
		if btn.name == "POLICE Loadout" then
			table.remove(an.menu['main'].buttons,i)
			break
		end
	end
	--table.sort(an.menu['main'].buttons)
	an.opened = false
	an.menu.from = 1
	an.menu.to = 10
end

local function drawMenuButton(button,x,y,selected)
	local menu = an.menu
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

local function drawMenuInfo(text)
	local menu = an.menu
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

local function drawMenuRight(txt,x,y,selected)
	local menu = an.menu
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

local function drawMenuTitle(txt,x,y)
local menu = an.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)	
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
local function OpenMenu(menu)
	an.lastmenu = an.currentmenu
	if menu == "race" then
		an.lastmenu = "main"
	elseif menu == "weapons"  then
		an.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		an.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		an.lastmenu = "race_create_objects"
	end
	an.menu.from = 1
	an.menu.to = 10
	an.selectedbutton = 0
	an.currentmenu = menu	
end
local function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = an.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Weapons" then
			OpenMenu("weapons")
		elseif btn == "Armor" then
			OpenMenu("armor")
	elseif this == "weapons" then
		if HasPedGotWeapon(LocalPed(),GetHashKey(button.model),false) then
			AddAmmoToPed(LocalPed(),GetHashKey(button.model),GetMaxAmmoInClip(GetPlayerPed(-1),GetHashKey(button.model),1))
			-- Needs to have the money system hooked up
		else
			--TriggerServerEvent('es_freeroam:pay', btn,GetHashKey(button.model),button.costs)
			GiveWeaponToPed(LocalPed(), GetHashKey(button.model), 500, true, true)
			-- Needs to have the money system hooked up
		end
		if GetMaxAmmoInClip(GetPlayerPed(-1),GetHashKey(button.model),1) ~= false then
		table.insert(an.menu['selected_weapon'].buttons,{name = "Ammo", costs = 50, description = "", model = button.model})
		OpenMenu('selected_weapon')
		end
	elseif this == "selected_weapon" then
		if btn == "Ammo" and Citizen.InvokeNative(0xDC16122C7A20C933,LocalPed(),GetHashKey(button.model),Citizen.PointerValueInt()) ~= GetAmmoInPedWeapon(LocalPed(),GetHashKey(button.model)) then
			-- Needs to have the money system hooked up
		end
	elseif this == "armor" then
		if btn == "Armor" then
			-- Needs to have the money system hooked up
		end
	end
end

local backlock = false

local function Back()
	if backlock then
		return
	end
	backlock = true
	if an.currentmenu == "main" then
		CloseCreator()
	elseif an.currentmenu == "selected_weapon" then
		an.menu['selected_weapon'].buttons = {}
		DisplayAmmoThisFrame(false)
		OpenMenu(an.lastmenu)
	else
		OpenMenu(an.lastmenu)
	end
	
end
local function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end


Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		local inrange = false
		for i,b in ipairs(gunshop_locations) do
			if IsPlayerWantedLevelGreater(GetPlayerIndex(),0) == false and  an.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and GetDistanceBetweenCoords(b[1],b[2],b[3],GetEntityCoords(LocalPed())) < 2 then
				DrawMarker(1,b[1],b[2],b[3],0,0,0,0,0,0,1.501,1.5001,0.5001,0,155,255,200,0,0,0,0)
				drawTxt('Press ~y~ENTER~s~ to ~g~purchase ~b~weapons',0,1,0.5,0.8,0.6,255,255,255,255)
				inrange = true
			end
		end
		inrangeofgunshop = inrange
		if IsControlJustPressed(1,201) and IsPlayerInRangeOfgunshop() then
			if an.opened then
				
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if an.opened then
			local ped = LocalPed()
			local menu = an.menu[an.currentmenu]
			drawTxt(an.title,1,1,an.menu.x,an.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, an.menu.x,an.menu.y + 0.08)
			drawTxt(an.selectedbutton.."/"..tablelength(menu.buttons),0,0,an.menu.x + an.menu.width/2 - 0.0385,an.menu.y + 0.067,0.4, 255,255,255,255)
			local y = an.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false
			
			for i,button in pairs(menu.buttons) do
				if i >= an.menu.from and i <= an.menu.to then
					
					if i == an.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,an.menu.x,y,selected)
					if button.costs ~= nil then
						if an.currentmenu == "weapons" then
							if HasPedGotWeapon(LocalPed(),GetHashKey(button.model),false) then
								drawMenuRight("OWNED",an.menu.x,y,selected)
							else
								drawMenuRight(button.costs.."$",an.menu.x,y,selected)
							end
						elseif an.currentmenu == "selected_weapon" then
							if Citizen.InvokeNative(0xDC16122C7A20C933,LocalPed(),GetHashKey(button.model),Citizen.PointerValueInt()) == GetAmmoInPedWeapon(LocalPed(),GetHashKey(button.model)) then
								drawMenuRight("FULL",an.menu.x,y,selected)
							else
								drawMenuRight(button.costs.."$",an.menu.x,y,selected)
							end
						else
							drawMenuRight(button.costs.."$",an.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,201) then
						ButtonSelected(button)
					end
				end
			end	
		end
		if an.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if an.selectedbutton > 1 then
					an.selectedbutton = an.selectedbutton -1
					if buttoncount > 10 and an.selectedbutton < an.menu.from then
						an.menu.from = an.menu.from -1
						an.menu.to = an.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if an.selectedbutton < buttoncount then
					an.selectedbutton = an.selectedbutton +1
					if buttoncount > 10 and an.selectedbutton > an.menu.to then
						an.menu.to = an.menu.to + 1
						an.menu.from = an.menu.from + 1
					end
				end	
			end
		end
		
	end
end)