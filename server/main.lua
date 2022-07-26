ESX, QBCore = nil, nil, {}, true

Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        print("^4[CANARY]^0 - ESX Framework Loaded")
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(100)
        end
    elseif Config.Framework == 'qbcore' then
        print("^4[CANARY]^0 - QBCore Framework Loaded")
        local QBCore = exports['qb-core']:GetCoreObject()
    end
    if Config.Framework == 'oldqbcore' then
        print("^4[CANARY]^0 - OLD QBCore Framework Loaded")
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end

local webhook = "Your Discord Webhook"
local message = '**Player used /stuck command in server**'
local color = 1146986

function SendDiscordNotify (source,message,color,identifier)
    local name = GetPlayerName(source)
    if not color then
        color = color_msg
    end
    local sendD = {
        {
            ["color"] = color,
            ["title"] = message,
            ["description"] = "`Player`: **"..name.."**\nSTEAM: **"..identifier.steam.."** \nIP: **"..identifier.ip.."**\nDiscord: **"..identifier.discord.."**\nFiveM: **"..identifier.license.."**",
            ["footer"] = {
                ["text"] = "Canary Development - "..os.date("%x %X %p")
            },
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Canary Development", embeds = sendD}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('cn-stuck:DiscordNotify')
AddEventHandler("cn-stuck:DiscordNotify", function()
    local _source = source
    local identifier = ExtractIdentifiers(_source)
    local identifierDb
    SendDiscordNotify(_source, message, color_msg,identifier)
end)

RegisterServerEvent('cn-stuck:SendImage')
AddEventHandler("cn-stuck:SendImage", function()
    if Config.SendMessages == 'true' then
        exports['screenshot-basic']:requestScreenshotUpload(Config.Webhook, 'files[]', {encoding = 'jpg'}, function(data)
            local resp = json.decode(data)
            table.insert(resp.attachments[1].url)
        end)
    elseif Config.SendMessages == 'false' then
        print("^4[CANARY]^0 - Image sending was disabled in script config so image wasnt sended!")
    end
end)