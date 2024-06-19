function isInArray(arr, value)
    for i = 1, #arr do
        if arr[i] == value then
            return true
        end
    end
    return false
end

function getRotryWeaponOwner(attrId)
    for playerId, item in pairs(allPlayerAttr) do
        for i = 1, #item['rotaryWeapon'] do
            if item['rotaryWeapon'][i] == attrId then
                return playerId
            end
        end
    end

    return nil
end

function increment_string(str)
    -- 利用下划线分割字符串
    local index = str:find("_")
    if not index then
        return nil -- 如果没有找到下划线，返回nil
    end

    local prefix = str:sub(1, index - 1) -- 获取下划线前面的部分
    local suffix = str:sub(index + 1) -- 获取下划线后面的部分

    -- 将数字部分加一
    local number = tonumber(suffix)
    if not number then
        return nil -- 如果后缀不是数字，返回nil
    end
    number = number + 1

    -- 合并前缀和新的数字部分
    return prefix .. "_" .. tostring(number)
end

function findIndex(tbl, element)
    for index, value in ipairs(tbl) do
        if value == element then
            return index
        end
    end
    return nil
end


function isFloat()
    if num % 1 ~= 0 then
        return print("这是一个浮点数")
    else
        print("这是一个整数")
    end
end

function CopyTableDeep(t)
    if type(t) ~= "table" then
        return t
    end

    local ret = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            ret[k] = CopyTableDeep(v)
        else
            ret[k] = v
        end
    end
    return ret
end

function checkItemExist(uid, itemid)
    for _, itemArr in pairs(PlayerBackpack[uid].undressed) do
        for i, itemArr2 in ipairs(itemArr) do
            if itemArr2 == itemid then
                return true
            end
        end
    end

    return false
end

function formatNumber(num)
    if num >= 100000000 then
        return tostring(math.floor(num / 100000000)) .. "亿"
    elseif num >= 10000 then
        return tostring(math.floor(num / 10000)) .. "万"
    else
        return tostring(num)
    end
end

