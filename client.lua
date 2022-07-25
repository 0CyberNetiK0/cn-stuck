local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('stuck', function()
	TriggerEvent('cn-stuck:PlayerTeleport') 
end, false)

RegisterNetEvent('cn-stuck:PlayerTeleport')
AddEventHandler('cn-stuck:PlayerTeleport', function()
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
