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