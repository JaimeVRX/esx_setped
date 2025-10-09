ESX = exports["es_extended"]:getSharedObject()
local DiscordAPI = exports["Badger_Discord_API"]


local discordWebhook = "😉"


RegisterCommand(Config.Command, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if not HasPermission(source) then
        TriggerClientEvent('esx:showNotification', source, '~r~Je hebt geen toestemming om dit te doen.')
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
        TriggerClientEvent('esx:showNotification', src, '~r~Geen toestemming.')
        return
    end

    TriggerClientEvent("esx_staffped:setPed", src, model)
    SendToDiscord("Staff Ped Veranderd", "**" .. xPlayer.getName() .. "** heeft ped veranderd naar `" .. model .. "`", 3447003)
end)


function HasPermission(source)
    local hasPerm = false


    for _, role in ipairs(Config.AllowedRoles) do
        if DiscordAPI:IsRolePresent(source, role) then
            hasPerm = true
            break
        end
    end


    if IsPlayerAceAllowed(source, "staffped.use") then
        hasPerm = true
    end

    return hasPerm
end


function SendToDiscord(title, message, color)
    if discordWebhook == "" then return end
    local embed = {{
        ["title"] = title,
        ["description"] = message,
        ["color"] = color,
        ["footer"] = { ["text"] = os.date("%Y-%m-%d %H:%M:%S") }
    }}

    PerformHttpRequest(discordWebhook, function() end, 'POST', json.encode({
        username = "Staff Logs",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

