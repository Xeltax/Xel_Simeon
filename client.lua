ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

local lastVehicle = nil
local policePresent = 0


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function checkVehicle()
    local chance = math.random(1, 100)
    print('chance: '..chance)
    Citizen.CreateThread(function()

        ESX.TriggerServerCallback('Xel_Simeon:getPolice', function(nbPolice)
            policePresent = nbPolice
        end)

        while true do
            Citizen.Wait(1000)
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if policePresent >= Config.minPoliceOnline then
                if ESX.PlayerData.job.name ~= 'police' then
                    if vehicle ~= 0 then
                        if chance <= Config.missionPercentage then
                            -- 50% de chance de trouver un véhicule
                            if vehicle ~= lastVehicle and lastVehicle ~= nil then
                                -- vérifier si le véhicule différent du dernier véhicule
                                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                                if string.find(vehicleProps.plate, " ") then
                                    -- Vehicle perso donc on ne fais rien
                                else
                                    vehicleFound(vehicle, vehicleProps)
                                    break
                                end
                            elseif vehicle == lastVehicle then
                                -- même véhicule donc on ne fais rien
                            else
                                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                                if string.find(vehicleProps.plate, " ") then
                                    -- Vehicle perso donc on ne fais rien
                                else
                                    vehicleFound(vehicle, vehicleProps)
                                    break
                                end
                            end
                        end
                    end
                end
            end

        end
    end)
end

checkVehicle()

function vehicleFound(vehicle, vehicleProps)
    ESX.ShowAdvancedNotification("Simeon", '', "Sympa cette ~o~"..GetDisplayNameFromVehicleModel(vehicleProps.model).."~s~ tu veux bien me la livrer je t'offrirais une bonne récompense.", 'CHAR_SIMEON', 1, true)
    
    local playerPed = PlayerPedId()

    local accepted = nil

    local wait = true

    SetTimeout(15000, function()
        if accepted == nil then
            ESX.ShowAdvancedNotification("Simeon", '', "Tu n'as pas l'air emballé, je te recontacte plus tard.", 'CHAR_SIMEON', 1)
        end
        accepted = false
        lastVehicle = vehicle
        wait = false
    end)

    while wait do
        Citizen.Wait(0)

        ESX.ShowHelpNotification('Souhaitez-vous effectuer la livraison, ~INPUT_MP_TEXT_CHAT_TEAM~ pour accepter, ~INPUT_REPLAY_ENDPOINT~ pour refuser.', false, true, 14000)

        if IsControlJustPressed(0, 246) then
            ESX.ShowAdvancedNotification("Simeon", '', "Parfait, livre-moi ça au ~b~Garage~s~ je t'ai transmis la position GPS.", 'CHAR_SIMEON', 1)
            accepted = true
            break
        elseif IsControlJustPressed(0, 306) then
            ESX.ShowAdvancedNotification("Simeon", '', "Dommage, je te laisse alors.", 'CHAR_SIMEON', 1)
            accepted = false
            lastVehicle = vehicle
            break
        end
    end

    if accepted then
        local randomCoord = Config.deliveryPoint[math.random(1, #Config.deliveryPoint)]
        -- Clear any old route first
        local blipMission = AddBlipForCoord(randomCoord.x, randomCoord.y, randomCoord.z)

        SetBlipSprite(blipMission, Config.blipSprite)
        SetBlipDisplay(blipMission, 4)
        SetBlipColour(blipMission, Config.blipColor)
        SetBlipAsShortRange(blipMission, true)
        SetBlipRoute(blipMission, true)
        SetBlipRouteColour(blipMission, Config.blipColor)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.blipName)
        EndTextCommandSetBlipName(blipMission)

        local loopWait = 0

        while true do
            Citizen.Wait(loopWait)
            local distance = #(GetEntityCoords(playerPed) - randomCoord)

            if distance <= 10 then
                loopWait = 0
                DrawMarker(36, randomCoord.x, randomCoord.y, randomCoord.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 3, 165, 252, 150, false, true, 2, nil, nil, false)
                if distance <= 2 then
                    ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour livrer le véhicule.', false, true, 14000)
                    if IsControlJustPressed(0, 38) then
                        TriggerEvent('Xel_Simeon:vehicleState', vehicle)
                        TaskLeaveVehicle(playerPed, vehicle, 0)
                        SetVehicleDoorsLocked(vehicle, 2)
                        Citizen.Wait(5000)
                        DeleteVehicle(vehicle)
                        RemoveBlip(blipMission)
                        lastVehicle = vehicle
                        break
                    end
                end
            end
        end

        checkVehicle()
    else
        checkVehicle()
    end
end

RegisterNetEvent('Xel_Simeon:vehicleState')
AddEventHandler('Xel_Simeon:vehicleState', function(vehicle)
    print(GetVehicleBodyHealth(vehicle))
    if GetVehicleBodyHealth(vehicle) <= 1000 and GetVehicleBodyHealth(vehicle) >= 950 then
        ESX.ShowAdvancedNotification("Simeon", '', "En parfait état en plus. Je suis sympa je te donne un bonus.", 'CHAR_SIMEON', 1)
        TriggerServerEvent('Xel_Simeon:reward', Config.perfectBonus)
    elseif GetVehicleBodyHealth(vehicle) < 750 then
        ESX.ShowAdvancedNotification("Simeon", '', "C'est quoi ce véhicule ~r~défoncer~s~ ! Garde le sa me sert à rien.", 'CHAR_SIMEON', 1)
    else
        TriggerServerEvent('Xel_Simeon:reward', 1.0)
    end
end)