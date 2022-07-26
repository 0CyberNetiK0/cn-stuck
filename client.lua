ESX, QBCore = nil, nil, {}, true

-- Citizen.CreateThread(function()
--     if Config.Framework == 'esx' then
--         print("^4[CANARY]^0 - ESX Framework Loaded")
--         while ESX == nil do
--             TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--             Citizen.Wait(100)
--         end
--     elseif Config.Framework == 'qbcore' then
--         print("^4[CANARY]^0 - QBCore Framework Loaded")
--         local QBCore = exports['qb-core']:GetCoreObject()
--     end
-- end)

RegisterCommand('test-stuck', function()
    if Config.Framework == 'qbcore' then
	print("Lesbian")
    elseif Config.Framework == 'esx' then
    print("GAY")
end, false)

RegisterNetEvent('cn-stuck:PlayerTeleport')
AddEventHandler('cn-stuck:PlayerTeleport', function()
  if Config.Framework == 'qbcore' then
  print("^4[CANARY]^0 - Teleporting Player")
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
       SetEntityCoords(GetPlayerPed(-1), 195.19, -933.88, 30.69)
       QBCore.Functions.Notify("You were teleported to ground!", "success")
       DoScreenFadeIn(650)
   end, function()
       QBCore.Functions.Notify("Canceled!", "error")
   end)
end)
