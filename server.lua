ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Xel_Simeon:reward')
AddEventHandler('Xel_Simeon:reward', function(bonus)
    local xPlayer = ESX.GetPlayerFromId(source)
    local reward = math.random(Config.reward.min, Config.reward.max)
    xPlayer.addMoney(math.floor(reward*bonus))
    TriggerClientEvent('esx:showAdvancedNotification', source, 'Simeon', '', 'Merci pour la livraison. Voilà ~g~'.. math.floor(reward*bonus) ..'~s~$ pour te remercier.', 'CHAR_SIMEON', 3)
end)


ESX.RegisterServerCallback('Xel_Simeon:getPolice', function(src, cb)
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')

    cb(#xPlayers)
end)

-- Please don't remove this line the script is free but i need credits <3
print("^3Xel_Simeon ^7by ^3Xeltax_^7 ^1made with love <3^7 - ^4Discord :^7 Xeltax#6455 - ^6Github :^7 https://github.com/Xeltax")