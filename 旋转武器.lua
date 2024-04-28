--- 房间内所有玩家属性 {uid: { rotaryWeapon: [actorId, actorId, actorId], curAngle: 0, angleRadius: 3, speed: 0.17 }}
allPlayerAttr = {}

-- 各个数量武器旋转角度枚举
INTERVAL_ANGLE_ENUMS = {0, 91, 90, 11}


--- 给玩家添加一个旋转武器
---@param uid number 用户编号
---@param actorId number 实体ID
function addPlayerRotryWeapon(uid, actorId)
    if allPlayerAttr[uid] ~= nil and #allPlayerAttr[uid]['rotaryWeapon'] == 4 then
        print("玩家: " .. uid .. "旋转武器装备已满")
        return
    end

    local _, x, y, z = Actor:getPosition(uid)
    local _, objids = World:spawnCreature(x, y, z, actorId, 1)

    if allPlayerAttr[uid] == nil then
        allPlayerAttr[uid]['rotaryWeapon'] = {}
    end

    Actor:setImmuneType(actorId, 1, true) -- 免疫伤害类型为1的伤害 防止武器对武器的伤害

    table.insert(allPlayerAttr[uid]['rotaryWeapon'], objids[1])

    print("玩家: " .. uid .. " 装备了一个旋转实体: " .. actorId)
end

--- 从玩家身上移除一个旋转武器
---@param uid number 用户编号
---@param actorId number 实体ID
function removePlayerRotryWeapon(uid, actorId)
    for i, v in ipairs(allPlayerAttr[uid]['rotaryWeapon']) do
        if v == actorId then
            table.remove(allPlayerAttr[uid]['rotaryWeapon'], i)
            return
        end
    end
end

--- 玩家进入游戏/复活时初始化旋转武器
---@param event any {eventobjid,shortix,x,y,z}
local function playerRotaryWeaponInit(event)
    allPlayerAttr[event.eventobjid] = {
        rotaryWeapon = {},
        curAngle = 0,
        angleRadius = 3,
        speed = 0.17
    }

    addPlayerRotryWeapon(event.eventobjid, 2)
    addPlayerRotryWeapon(event.eventobjid, 2)
    addPlayerRotryWeapon(event.eventobjid, 2)
    addPlayerRotryWeapon(event.eventobjid, 2)
end

ScriptSupportEvent:registerEvent('Game.AnyPlayer.EnterGame', playerRotaryWeaponInit)
ScriptSupportEvent:registerEvent('Player.Revive', playerRotaryWeaponInit)

-- 玩家死亡/离开移除所有武器
function playerDieHandle(event)
    for i = 1, #allPlayerAttr[event.eventobjid]['rotaryWeapon'] do
        local atorId = allPlayerAttr[event.eventobjid]['rotaryWeapon'][i]
        Actor:killSelf(atorId)
    end
    allPlayerAttr[event.eventobjid] = nil
end
ScriptSupportEvent:registerEvent('Player.Die', playerDieHandle)
ScriptSupportEvent:registerEvent('Game.AnyPlayer.LeaveGame', playerDieHandle)


--- 旋转实体运行时
function rotaryWeaponRuntime()
    for uid, playerAttr in pairs(allPlayerAttr) do
        local _, x, y, z = Actor:getPosition(uid)
        local intervalAngle = INTERVAL_ANGLE_ENUMS[#playerAttr['rotaryWeapon']]

        for i, actorId in ipairs(playerAttr['rotaryWeapon']) do
            local actorX = x + playerAttr['angleRadius'] * math.sin(playerAttr['curAngle'] + i * intervalAngle)
            local actorY = y + 0
            local actorZ = z + playerAttr['angleRadius'] * math.cos(playerAttr['curAngle'] + i * intervalAngle)
            Actor:setPosition(actorId, actorX, actorY, actorZ)
        end
        playerAttr['curAngle'] = playerAttr['curAngle'] + playerAttr['speed']
    end
end

ScriptSupportEvent:registerEvent('Game.RunTime', rotaryWeaponRuntime)
