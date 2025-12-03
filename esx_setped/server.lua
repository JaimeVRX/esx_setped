ESX = exports["es_extended"]:getSharedObject()


local discordWebhook = "" -- your webhook here

RegisterCommand(Config.Command, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if not HasPermission(source) then
        TriggerClientEvent('esx:showNotification', source, '~r~No permission.')
        return
    end
    TriggerClientEvent("esx_staffped:openMenu", source)
end, false)

RegisterNetEvent("esx_staffped:trySetPed")
AddEventHandler("esx_staffped:trySetPed", function(model)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if not HasPermission(src) then
        TriggerClientEvent('esx:showNotification', src, '~r~No access.')
        return
    end
    TriggerClientEvent("esx_staffped:setPed", src, model)
    SendToDiscord("Staffped", "**" .. xPlayer.getName() .. "** changed to ped `" .. tostring(model) .. "`", 3447003)
end)

RegisterNetEvent("esx_staffped:resetSkin")
AddEventHandler("esx_staffped:resetSkin", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    if not HasPermission(src) then
        TriggerClientEvent("esx:showNotification", src, "~r~No permissions.")
        return
    end
    TriggerClientEvent("esx_staffped:loadOriginalSkin", src)
    SendToDiscord("Skin Reset", "**" .. xPlayer.getName() .. "** returned to his originel char.", 3447003)
end)

function HasPermission(source)
    local has = false
    local roles = exports["Badger_Discord_API"]:GetDiscordRoles(source)
    if roles then
        for _, need in ipairs(Config.AllowedRoles) do
            for _, role in ipairs(roles) do
                if role == need then
                    has = true
                    break
                end
            end
            if has then break end
        end
    end
    if IsPlayerAceAllowed(source, "staffped.use") then
        has = true
    end
    return has
end

function SendToDiscord(title, message, color)
    if discordWebhook == "" then return end
    local embed = {{
        title = title,
        description = message,
        color = color,
        footer = { text = os.date("%Y-%m-%d %H:%M:%S")  }
    }}
    PerformHttpRequest(discordWebhook, function() end, "POST", json.encode({
        username = "Thank you for using Staffped - Jaime🤞",
        embeds = embed
    }), { ["Content-Type"] = "application/json" })
end


