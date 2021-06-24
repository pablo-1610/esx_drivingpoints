
local ESX = nil

TriggerEvent(Config.getESX, function(obj)
    ESX = obj
end)

local pointsCache = {}

local function checkIsJobAllowed(jobName)
    local allowed = false
    for _,v in pairs(Config.regulatorJobs) do
        if jobName:lower() == v then
            allowed = true
        end
    end 
    return allowed
end

RegisterNetEvent("esx_dmvschool:addLicense")
AddEventHandler('esx_dmvschool:addLicense', function(type)
	local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if type == Config.drivingLicense then
        MySQL.Async.insert("INSERT INTO esx_drivingpoints (identifier, points) VALUES(@a, @b)",{
            ['a'] = xPlayer.identifier,
            ['b'] = Config.basePoint
        }, function()
            pointsCache[_src] = {
                identifier = xPlayer.identifier,
                points = Config.basePoint
            }
        end)
    end
end)

AddEventHandler('esx:playerLoaded', function(_src, xPlayer)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll("SELECT * FROM esx_drivingpoints WHERE identifier = @a",{
        ['a'] = identifier
    }, function(result)
        if result[1] then
            pointsCache[_src] = {identifier = identifier, points = tonumber(result[1].points)}
        end
    end)
end)

AddEventHandler("playerDropped", function(reason)
    local _src = source
    if pointsCache[_src] ~= nil then
        local identifier = pointsCache[_src].identifier
        MySQL.Async.execute("UPDATE esx_drivingpoints SET points = @a WHERE identifier = @b",{
            ['a'] = pointsCache[_src].points,
            ['b'] = identifier
        })
    end
end)

RegisterNetEvent("esx_drivingpoints:viewPoints")
AddEventHandler("esx_drivingpoints:viewPoints", function()
    local _src = source
    if not pointsCache[_src] then
        TriggerClientEvent("esx:showNotification", _src, _U("points_no_points"))
        return
    end
    TriggerClientEvent("esx:showNotification", _src, (_U("points_notify")):format(pointsCache[_src].points))
end)

RegisterNetEvent("esx_drivingpoints:removePoint")
AddEventHandler("esx_drivingpoints:removePoint", function(target, ammount)
    local _src = source
    local ammount = tonumber(ammount)
    if ammount < 1 or ammount > Config.basePoint then 
        TriggerClientEvent("esx:showNotification", _src, _U("invalid_ammount"))
        return
    end
    local targetxPlayer = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(_src)
    if not xPlayer or not targetxPlayer then
        return
    end
    if not checkIsJobAllowed(xPlayer.job.name) then
        TriggerClientEvent("esx:showNotification", _src, _U("not_allowed"))
        return
    end
    if not pointsCache[target] then
        TriggerClientEvent("esx:showNotification", _src, _U("no_driving_license_other"))
        return
    end
    if pointsCache[target].points == 0 then
        TriggerClientEvent("esx:showNotification", _src, _U("no_points_remaining_other"))
        return
    end 
    local fakeFinalPoints = ((pointsCache[target].points)-ammount)
    if fakeFinalPoints < 0 then
        fakeFinalPoints = 0
    end
    pointsCache[target].points = fakeFinalPoints
    TriggerClientEvent("esx:showNotification", _src, _U("points_remove_notify_sender"))
    TriggerClientEvent("esx:showNotification", target, (_U("points_remove_notify_receiver")):format(ammount))
    if fakeFinalPoints == 0 then
        MySQL.Async.execute("DELETE FROM esx_drivingpoints WHERE identifier = @a", {
            ['a'] = targetxPlayer.identifier
        }, function()
            pointsCache[target] = nil
            TriggerEvent("esx_license:removeLicense", target, Config.drivingLicense, function()
                TriggerClientEvent("esx:showNotification", target, _U("license_suspended"))
            end)
        end)
    end
end)

RegisterNetEvent("esx_drivingpoints:addPoint")
AddEventHandler("esx_drivingpoints:addPoint", function(target, ammount)
    local _src = source
    local ammount = tonumber(ammount)
    if ammount < 1 or ammount > 12 then 
        TriggerClientEvent("esx:showNotification", _src, _U("invalid_ammount"))
        return 
    end
    local targetxPlayer = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(_src)
    if not xPlayer or not targetxPlayer then
        return
    end
    if not checkIsJobAllowed(xPlayer.job.name) then
        TriggerClientEvent("esx:showNotification", _src, _U("not_allowed"))
        return
    end
    if not pointsCache[target] then
        TriggerClientEvent("esx:showNotification", _src, _U("no_driving_license_other"))
        return
    end 
    local fakeFinalPoints = ((pointsCache[target].points)+ammount)
    if fakeFinalPoints > Config.basePoint then
        TriggerClientEvent("esx:showNotification", _src, (_U("points_add_exceed_max_points")):format(ammount))
        return
    end
    pointsCache[target].points = fakeFinalPoints
    TriggerClientEvent("esx:showNotification", _src, (_U("points_add_notify_sender")):format(ammount))
    TriggerClientEvent("esx:showNotification", target, (_U("points_add_notify_receiver")):format(ammount))
end)


  