ESX.RegisterServerCallback("apx-pmenu:havePermissions", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'admin' then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('apx-pmenu:getInformation', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    local info = {
        money = xPlayer.getMoney(),
        bankmoney = xPlayer.getAccount('bank').money,
        blackmoney = xPlayer.getAccount('black_money').money
    }
    cb(info)
end)