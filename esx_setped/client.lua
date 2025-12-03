local ESX = exports["es_extended"]:getSharedObject()

local function PreviewPed(model)
    local playerPed = PlayerPedId()
    lib.requestModel(model)
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, 0.0)

    local preview = CreatePed(4, model, offset.x, offset.y, offset.z, heading + 180.0, false, true)
    FreezeEntityPosition(preview, true)
    SetEntityInvincible(preview, true)

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, offset.x, offset.y - 2.5, offset.z + 1.0)
    PointCamAtEntity(cam, preview, 0, 0, 0, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    local alert = lib.alertDialog({
        header = "Bevestig Ped Verandering",
        content = "Wil je veranderen naar ped?",
        centered = true,
        cancel = true
    })

    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(cam)
    DeleteEntity(preview)

    return alert == "confirm"
end

RegisterNetEvent("esx_staffped:setPed")
AddEventHandler("esx_staffped:setPed", function(pedModel)
    local model = GetHashKey(pedModel)
    lib.requestModel(model)
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    local ped = PlayerPedId()
    SetPedDefaultComponentVariation(ped)
    SetEntityVisible(ped, true, false)
    ESX.ShowNotification("~g~Your ped changed.")
end)

RegisterNetEvent("esx_staffped:openMenu")
AddEventHandler("esx_staffped:openMenu", function()
    local options = {}

    table.insert(options, {
        title = "Return to Original Skin",
        icon = "rotate-left",
        onSelect = function()
            TriggerServerEvent("esx_staffped:resetSkin")
        end
    })

    for _, ped in ipairs(Config.FavoritePeds) do
        table.insert(options, {
            title = ped.label,
            description = ped.model,
            icon = "star",
            onSelect = function()
                local model = GetHashKey(ped.model)
                if PreviewPed(model) then
                    TriggerServerEvent("esx_staffped:trySetPed", ped.model)
                end
            end
        })
    end

    table.insert(options, {
        title = "Peds",
        icon = "mask",
        arrow = true,
        onSelect = function()
            TriggerEvent("esx_staffped:openAllCriminalPeds")
        end
    })

    lib.registerContext({
        id = 'staffped_menu',
        title = 'Valyrix Peds',
        options = options
    })

    lib.showContext('staffped_menu')
end)

RegisterNetEvent("esx_staffped:openAllCriminalPeds")
AddEventHandler("esx_staffped:openAllCriminalPeds", function()
    local input = lib.inputDialog("Search in pedlist", {
        { type = "input", label = "Search (optionel)" }
    })

    local search = input and input[1] and string.lower(input[1]) or ""
    local filtered = {}

    for _, ped in ipairs(Config.AllPeds) do
        if search == "" or string.find(string.lower(ped.label), search) then
            table.insert(filtered, {
                title = ped.label,
                description = ped.model,
                icon = "user",
                onSelect = function()
                    local model = GetHashKey(ped.model)
                    if PreviewPed(model) then
                        TriggerServerEvent("esx_staffped:trySetPed", ped.model)
                    end
                end
            })
        end
    end

    lib.registerContext({
        id = "all_peds_menu",
        title = "Criminal Peds",
        menu = "staffped_menu",
        options = filtered
    })

    lib.showContext("all_peds_menu")
end)

RegisterNetEvent("esx_staffped:loadOriginalSkin")
AddEventHandler("esx_staffped:loadOriginalSkin", function()
    if exports['illenium-appearance']:hasPlayerAppearance() then
        local appearance = exports['illenium-appearance']:getPedAppearance(cache.ped)
        exports['illenium-appearance']:setPlayerAppearance(appearance)
    else
        SetPlayerModel(PlayerId(), GetHashKey("mp_m_freemode_01"))
        SetPedDefaultComponentVariation(PlayerPedId())
    end
    ESX.ShowNotification("~g~Your original Char is back.")
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/setped', 'Set your staff ped', {})
end

