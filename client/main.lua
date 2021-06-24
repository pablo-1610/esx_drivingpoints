local ESX = nil

Citizen.CreateThread(function()
    print("Coucou")
    TriggerEvent(Config.getESX, function(obj)
        ESX = obj
    end)

    RegisterCommand("points", function()
        TriggerServerEvent("esx_drivingpoints:viewPoints")
    end, false)

    RegisterCommand("points_add", function(source, args)
        if #args ~= 1 then
            ESX.ShowNotification(_U("usage"):format(_U("points_add_cmd")))
            return
        end

        if tonumber(args[1]) == nil and tonumber(args[1]) < 1 then
            ESX.ShowNotification(_U("invalid_ammount"))
            return
        end

        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestPlayerDistance > 3.0 then
            ESX.ShowNotification(_U("no_player_nearby"))
        else
            TriggerServerEvent("esx_drivingpoints:addPoint", GetPlayerServerId(closestPlayer), tonumber(args[1]))
        end
    end, false)

    RegisterCommand("points_remove", function(source, args)
        if #args ~= 1 then
            ESX.ShowNotification(_U("usage"):format(_U("points_remove_cmd")))
            return
        end

        if tonumber(args[1]) == nil and tonumber(args[1]) < 1 then
            ESX.ShowNotification(_U("invalid_ammount"))
            return
        end

        local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestPlayerDistance > 3.0 then
            ESX.ShowNotification(_U("no_player_nearby"))
        else
            TriggerServerEvent("esx_drivingpoints:removePoint", GetPlayerServerId(closestPlayer), tonumber(args[1]))
        end
    end, false)
end)