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

RegisterCommand('stuck', function()
    if Config.Framework == 'qbcore' then
	    TriggerEvent('cn-stuck:QBCore:PlayerTeleport')
    elseif Config.Framework == 'oldqbcore' then
        TriggerEvent('cn-stuck:QBCore:PlayerTeleport')
    elseif Config.Framework == 'esx' then
        TriggerEvent('cn-stuck:ESX:PlayerTeleport')
    end
end, false)

RegisterNetEvent('cn-stuck:QBCore:PlayerTeleport')
AddEventHandler('cn-stuck:QBCore:PlayerTeleport', function()
  print("^4[CANARY]^0 - QBCore Teleporting Player")
  TriggerServerEvent('cn-stuck:DiscordNotify')
  QBCore.Functions.Progressbar("PlayerTeleport", "Teleporting to Ground...", 85000, false, true, {
       disableMovement = true,
       disableCarMovement = true,
       disableMouse = false,
       disableCombat = true,
   }, {}, {}, {}, function()
       DoScreenFadeOut(650)
       while not IsScreenFadedOut() do
          Wait(0)
       end
       SetEntityCoords(GetPlayerPed(-1), Config.TeleportLocation.x, Config.TeleportLocation.y, Config.TeleportLocation.z)
       QBCore.Functions.Notify("You were teleported to ground!")
       DoScreenFadeIn(650)
       TriggerServerEvent('cn-stuck:SendImage')
   end, function()
       QBCore.Functions.Notify("Canceled!")
   end)
end)

RegisterNetEvent('cn-stuck:ESX:PlayerTeleport')
AddEventHandler('cn-stuck:ESX:PlayerTeleport', function()
    print("^4[CANARY]^0 - ESX Teleporting Player")
    TriggerServerEvent('cn-stuck:DiscordNotify')
    exports['progressBars']:startUI(8500, "Teleporting to Ground...")
    Wait(8500)
    DoScreenFadeOut(650)
    while not IsScreenFadedOut() do
       Wait(0)
    end
    SetEntityCoords(GetPlayerPed(-1), Config.TeleportLocation.x, Config.TeleportLocation.y, Config.TeleportLocation.z)
    ESX.ShowNotification("You were teleported to ground!")
    DoScreenFadeIn(650)
    TriggerServerEvent('cn-stuck:SendImage')
end)
