local ESX = exports["es_extended"]:getSharedObject()


RegisterNetEvent("esx_staffped:setPed")
AddEventHandler("esx_staffped:setPed", function(pedModel)
    local model = GetHashKey(pedModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(50)
    end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    ESX.ShowNotification("~g~Je ped is veranderd naar: ~b~" .. pedModel)
end)


RegisterNetEvent("esx_staffped:openMenu")
AddEventHandler("esx_staffped:openMenu", function()
    local options = {}

    for _, ped in ipairs(Config.Peds) do
        table.insert(options, {
            title = ped.label,
            description = "Verander naar ped: " .. ped.model,
            icon = "user",
            arrow = true,
            onSelect = function()
                local preview = lib.requestModel(ped.model)
                local playerPed = PlayerPedId()


                local coords = GetEntityCoords(playerPed)
                local heading = GetEntityHeading(playerPed)
                local previewPed = CreatePed(4, GetHashKey(ped.model), coords.x, coords.y, coords.z, heading, false, true)
                FreezeEntityPosition(previewPed, true)
                SetEntityInvincible(previewPed, true)
                SetEntityVisible(previewPed, true)

  
                local alert = lib.alertDialog({
                    header = "Bevestig Ped Verandering",
                    content = "Wil je veranderen naar **" .. ped.label .. "**?",
                    centered = true,
                    cancel = true
                })

                DeleteEntity(previewPed)

                if alert == "confirm" then
                    TriggerServerEvent("esx_staffped:trySetPed", ped.model)
                else
                    ESX.ShowNotification("~r~Actie geannuleerd.")
                end
            end
        })
    end

    lib.registerContext({
        id = 'staffped_menu',
        title = 'Staff Ped Menu',
        options = options
    })

    lib.showContext('staffped_menu')
end)
