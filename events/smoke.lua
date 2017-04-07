local thisPed
local pedCoords = {}
local storedPeds = {}
local blips = {
  -- Smoke on the water
  {x=-1171.42, y=-1572.72, z=3.6636},
}

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

local MISSION = {}
MISSION.start = false
MISSION.wanted = false
local playerCoords
local playerPed

showStartText   = false

--blips
local BLIP = {}
Citizen.CreateThread(function()
    while true do
       Wait(0)
       playerPed = GetPlayerPed(-1)
       playerCoords = GetEntityCoords(playerPed, 0)
      tick()
    end
end)

function tick()
    --Show notification, when player is near the weedshop
    if(MISSION.start == false) then
    for _, item in pairs(blips) do
    if(GetDistanceBetweenCoords(playerCoords, item.x, item.y, item.z) < 10) then
            if(showStartText == false) then
                StartText()
            end
                -- Start mission
                if(IsControlPressed(1, Keys["E"])) then
                  TriggerServerEvent("es_freeroam:pay", tonumber(50))
                    Toxicated()
                    Citizen.Wait(120000)
                    reality()
                end
              else
                showStartText = false
              end --if GetDistanceBetweenCoords ...
            end -- end for
          end--if MISSION.start == false


                    if(MISSION.start == true) then
                      Citizen.CreateThread(function()
                        while true do
                          vehCheck = IsPedInAnyVehicle(GetPlayerPed(-1), true)
                            if vehCheck then
                              SetPlayerWantedLevel(PlayerId(), 1, true)
                              SetPlayerWantedLevelNow(PlayerId(), true)
                              Citizen.Wait(59000)
                            end
                        end
                      end)
                    end -- end mission.start
                  end -- end tick

function Toxicated()
  TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, 1)
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  ClearPedTasksImmediately(GetPlayerPed(-1))
  SetTimecycleModifier("spectator5")
  SetPedMotionBlur(GetPlayerPed(-1), true)
  RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
      while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
       Citizen.Wait(0)
      end
    SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
    SetPedIsDrunk(GetPlayerPed(-1), true)
    DoScreenFadeIn(1000)
      MISSION.start = true
      showStartText = true
  end

  function reality()
    Citizen.Wait(50000)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedIsDrunk(GetPlayerPed(-1), false)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    -- Disable wanted level
    SetPlayerWantedLevel(PlayerId(), 0, 0)
    SetPlayerWantedLevelNow(PlayerId(), 0)
    -- Stop the mini mission
    MISSION.start = false
    Citizen.Trace("Going back to reality\n")
    end

function StartText()
  DrawMarker(1, -1171.42, -1572.72, 3.6636, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
  ShowInfo("Press ~INPUT_CONTEXT~ to buy drugs", 0)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawMissionText(m_text, showtime)
  ClearPrints()
  SetTextEntry_2("STRING")
  AddTextComponentString(m_text)
  DrawSubtitleTimed(showtime, 1)
end


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end

function ShowInfo(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end
