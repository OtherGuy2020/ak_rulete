local slot1 = 35
local slot2 = 36
local slot3 = 0
local slot4 = 1
local slot5 = 2
local stop = false
local selected_ammount = 0
local selection = 1
local global_data = {}
global_data.red = 0
global_data.black = 0
global_data.green = 0
local global_break = false
local selection_label = {
    [1] = "Black",
    [2] = "Green",
    [3] = "Red",

}
local data = {
    [1] = {color = "red" ,label  = "32"},
    [2] = {color = "black" ,label  = "15"},
    [3] = {color = "red" ,label  = "19"},
    [4] = {color = "black" ,label  = "4"},
    [5] = {color = "red" ,label  = "21"},
    [6] = {color = "black" ,label  = "2"},
    [7] = {color = "red" ,label  = "25"},
    [8] = {color = "black" ,label  = "17"},
    [9] = {color = "red" ,label  = "34"},
    [10] = {color = "black" ,label  = "6"},
    [11] = {color = "red" ,label  = "27"},
    [12] = {color = "black" ,label  = "13"},
    [13] = {color = "red" ,label  = "36"},
    [14] = {color = "black" ,label  = "11"},
    [15] = {color = "red" ,label  = "30"},
    [16] = {color = "black" ,label  = "8"},
    [17] = {color = "red" ,label  = "23"},
    [18] = {color = "black" ,label  = "10"},
    [19] = {color = "red" ,label  = "5"},
    [20] = {color = "black" ,label  = "24"},
    [21] = {color = "red" ,label  = "16"},
    [22] = {color = "black" ,label  = "33"},
    [23] = {color = "red" ,label  = "1"},
    [24] = {color = "black" ,label  = "20"},
    [25] = {color = "red" ,label  = "14"},
    [26] = {color = "black" ,label  = "31"},
    [27] = {color = "red" ,label  = "9"},
    [28] = {color = "black" ,label  = "22"},
    [29] = {color = "red" ,label  = "18"},
    [30] = {color = "black" ,label  = "29"},
    [31] = {color = "red" ,label  = "7"},
    [32] = {color = "black" ,label  = "28"},
    [33] = {color = "red" ,label  = "12"},
    [34] = {color = "black" ,label  = "35"},
    [35] = {color = "red" ,label  = "3"},
    [36] = {color = "black" ,label  = "26"},
    [0] = {color = "green" ,label  = "0"},

}

-- PROMPT
local RuleteGroup = GetRandomIntInRange(0, 0xffffff)
local _BetPrompt
function BetPrompt()
    Citizen.CreateThread(function()
        local str = "Bet"
        _BetPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(_BetPrompt, 0xC7B5340A)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(_BetPrompt, str)
        PromptSetEnabled(_BetPrompt, true)
        PromptSetVisible(_BetPrompt, true)
        PromptSetHoldMode(_BetPrompt, false)
        PromptSetGroup(_BetPrompt, RuleteGroup)
        PromptRegisterEnd(_BetPrompt)
    end)
end

local _BetPromptAmmount
function BetPromptAmmount()
    Citizen.CreateThread(function()
        local str = "Amount: " .. selected_ammount.."$"
        _BetPromptAmmount = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(_BetPromptAmmount, 0x6319DB71)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(_BetPromptAmmount, str)
        PromptSetEnabled(_BetPromptAmmount, true)
        PromptSetVisible(_BetPromptAmmount, true)
        PromptSetHoldMode(_BetPromptAmmount, false)
        PromptSetGroup(_BetPromptAmmount, RuleteGroup)
        PromptRegisterEnd(_BetPromptAmmount)
    end)
end

local _ChangeBetPrompt
function ChangeBetPrompt()
    Citizen.CreateThread(function()
        local str = 'On ' .. selection_label[selection]
        _ChangeBetPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(_ChangeBetPrompt, 0xDEB34313)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(_ChangeBetPrompt, str)
        PromptSetEnabled(_ChangeBetPrompt, true)
        PromptSetVisible(_ChangeBetPrompt, true)
        PromptSetHoldMode(_ChangeBetPrompt, false)
        PromptSetGroup(_ChangeBetPrompt, RuleteGroup)
        PromptRegisterEnd(_ChangeBetPrompt)
    end)
end

local coords = {x = -311.04 , y = 797.67 , z =119.0}
Citizen.CreateThread(function()
    ChangeBetPrompt()
    BetPromptAmmount()
    BetPrompt()
    TriggerServerEvent('ak_rulete:Sync')
    while true do
        Wait(1)
        local playerCoords = GetEntityCoords(PlayerPedId())
        if Vdist(playerCoords , coords.x ,coords.y , coords.z) < 2  then

            DrawText3D(coords.x-0.3, coords.y, coords.z, slot1 , slot1)
            DrawText3D(coords.x-0.15, coords.y, coords.z, slot2 , slot2)
            DrawText3D(coords.x, coords.y, coords.z, slot3 ,slot3 , stop)
            DrawText3D(coords.x+0.15, coords.y, coords.z, slot4 , slot4)
            DrawText3D(coords.x+0.30, coords.y, coords.z, slot5 , slot5)
            DrawText3D2(coords.x-0.5, coords.y, coords.z-0.5, "Red: "..global_data.red.."$")
            DrawText3D2(coords.x, coords.y, coords.z-0.5, "Green: "..global_data.green.."$")
            DrawText3D2(coords.x+0.5, coords.y, coords.z-0.5, "Black: "..global_data.black.."$")
            if  not global_break then
                local RuleteGroupName  = CreateVarString(10, 'LITERAL_STRING', "Roulette")
                PromptSetActiveGroupThisFrame(RuleteGroup, RuleteGroupName)
                if IsControlJustReleased(0, 0xC7B5340A) then
                    TriggerServerEvent('ak_rulete:addBet',selected_ammount , selection)
                end


                if IsControlJustReleased(0, 0x6319DB71) then
                    --Wait(100)
                    selected_ammount = selected_ammount + 5
                    if selected_ammount > 50 then
                        selected_ammount = 0
                    end
                    PromptDelete(_BetPromptAmmount)
                    BetPromptAmmount()
                end

                if IsControlJustReleased(0, 0xDEB34313) then
                    --Wait(100)
                    selection = selection + 1
                    if selection > 3 then
                        selection = 1
                    end
                    PromptDelete(_ChangeBetPrompt)
                    ChangeBetPrompt()
                end
            end
        end
    end
end)




RegisterNetEvent('ak_rulete:Data')
AddEventHandler('ak_rulete:Data', function(data)
    global_data = data
end)

RegisterNetEvent('ak_rulete:Block')
AddEventHandler('ak_rulete:Block', function(bool)
    global_break = bool
end)

RegisterNetEvent('ak_rulete:Start')
AddEventHandler('ak_rulete:Start', function(pattern)

    for k,v in pairs(pattern) do
        Wait(v)
        slot1 = slot1 + 1
        if slot1 > 36 then
            slot1 = 0
        end
        slot2 = slot2 + 1
        if slot2 > 36 then
            slot2 = 0
        end
        slot3 = slot3 + 1
        if slot3 > 36 then
            slot3 = 0
        end
        slot4 = slot4 + 1
        if slot4 > 36 then
            slot4 = 0
        end
        slot5 = slot5 + 1
        if slot5 > 36 then
            slot5 = 0
        end
        print(v)
        local playerCoords = GetEntityCoords(PlayerPedId())
        if Vdist(playerCoords , coords.x ,coords.y , coords.z) < 2  then
            PlaySoundFrontend("BET_PROMPT", "HUD_POKER", true, 0)
        end
    end
             print(slot3)
            stop = true
            local playerCoords = GetEntityCoords(PlayerPedId())
            if Vdist(playerCoords , coords.x ,coords.y , coords.z) < 2  then
                PlaySoundFrontend("Gain_Point", "HUD_MP_PITP", true, 0)
            end
			Wait(4000)
			 slot1 = 35
			 slot2 = 36
			 slot3 = 0
			 slot4 = 1
			 slot5 = 2
			  stop = false
			
end)
function DrawText3D(x, y, z, text , color , type)
    local s, sx, sy = GetScreenCoordFromWorldCoord(x, y ,z)
    if (sx > 0 and sx < 1) or (sy > 0 and sy < 1) then
        local s, sx, sy = GetHudScreenPositionFromWorldPosition(x, y, z)


        local str = CreateVarString(10, "LITERAL_STRING", tostring(data[text].label), Citizen.ResultAsLong())

        local p = GetGameplayCamCoord()
        local distance = Vdist(p.x, p.y, p.z, x, y, z)
        local scale = (1 / distance) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = scale * fov *0.7
        if color % 2 == 0 and color ~= 0  then

            if type == true then
                DrawSprite("generic_textures", "medal_gold", sx, sy,  0.04*scale, 0.065*scale, 0.0, 0, 0, 0, 255, 0)
            else
                DrawSprite("generic_textures", "medal_bronze", sx, sy,  0.04*scale, 0.065*scale, 0.0, 0, 0, 0, 255, 0)
            end
        elseif color % 2 ~= 0 and color ~= 0  then
            if type == true then
                DrawSprite("generic_textures", "medal_gold", sx, sy, 0.04*scale, 0.065*scale, 0.0, 153, 10, 0, 255, 0)
            else
                DrawSprite("generic_textures", "medal_bronze", sx, sy, 0.04*scale, 0.065*scale, 0.0, 153, 10, 0, 255, 0)
            end
        elseif color == 0 then
            if type == true then
                DrawSprite("generic_textures", "medal_gold", sx, sy,  0.04*scale, 0.065*scale, 0.0, 19, 194, 0, 255, 0)
            else
                DrawSprite("generic_textures", "medal_bronze", sx, sy,  0.04*scale, 0.065*scale, 0.0, 19, 194, 0, 255, 0)
            end

        end
        SetTextColor(255, 255, 255, 215)
        SetTextScale(0.32*scale, 0.32*scale)
        SetTextFontForCurrentCommand(1)
        SetTextCentre(1)
        DisplayText(str,sx,sy)
    end
end
function DrawText3D2(x, y, z, text , color , type)
    local s, sx, sy = GetScreenCoordFromWorldCoord(x, y ,z)
    if (sx > 0 and sx < 1) or (sy > 0 and sy < 1) then
        local s, sx, sy = GetHudScreenPositionFromWorldPosition(x, y, z)


        local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())

        local p = GetGameplayCamCoord()
        local distance = Vdist(p.x, p.y, p.z, x, y, z)
        local scale = (1 / distance) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = scale * fov *0.7
        SetTextColor(255, 255, 255, 215)
        SetTextScale(0.32*scale, 0.32*scale)
        SetTextFontForCurrentCommand(1)
        SetTextCentre(1)
        DisplayText(str,sx,sy)
    end
end
