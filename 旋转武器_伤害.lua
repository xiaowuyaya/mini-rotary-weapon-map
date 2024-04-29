--- 旋转实体碰撞单位时 伤害处理相关
---@param event any {eventobjid 事件生物,toobjid 攻击对象,actorid 生物类型,targetactorid 攻击对象生物类型}
local function rotryWeaponCollideHandle(event)

    --- 红名检查 开始
    if Actor:isPlayer(event.toobjid) == 0 then -- 如果攻击对象为玩家
        local playerId = getRotryWeaponOwner(event.eventobjid) -- 获取武器归属玩家
        if playerId ~= nil then
            local _, eventobjidFightStatus = VarLib2:getPlayerVarByName(playerId, 5, '战斗状态') -- 事件对象的战斗状态
            local _, toobjidFightStatus = VarLib2:getPlayerVarByName(event.toobjid, 5, '战斗状态') -- 事件对象的战斗状态

            print(playerId .. '正在攻击' .. event.toobjid)

            if eventobjidFightStatus == false and toobjidFightStatus == false then -- 如果有一方不在战斗状态则不处理
                return
            end
        end
    end
    --- 红名检查 结束

    for playerId, playerAttr in pairs(allPlayerAttr) do
        if isInArray(playerAttr['rotaryWeapon'], event.eventobjid) then
            local _, damage = VarLib2:getPlayerVarByName(playerId, 3, "玩家攻击")
            local _, playerdamage = VarLib2:getPlayerVarByName(playerId, 3, "玩家伤害提升")
            local _, playBaojilv = VarLib2:getPlayerVarByName(playerId, 3, "玩家暴击率")
            local _, playBaojiDamage = VarLib2:getPlayerVarByName(playerId, 3, "玩家暴击伤害")

            if Actor:isPlayer(event.toobjid) ~= 0 then -- 对生物攻击
                local _, jinzhanfy = Creature:getAttr(event.toobjid, 19)

                damage = (damage * damage / (damage + jinzhanfy)) * (1 + playerdamage)

                local r = math.random() * 100

                if r <= playBaojilv then
                    damage = damage * (1 + playBaojiDamage)
                end

                Actor:playerHurt(playerId, event.toobjid, math.floor(damage), 1)

            else
                local _, fyu = VarLib2:getPlayerVarByName(event.toobjid, 3, "玩家防御") -- 对方防御
                local _, lv = VarLib2:getPlayerVarByName(event.toobjid, 3, "等级") -- 对方防御

                local fybfb = fyu / (fyu + (20 + lv))
                damage = (damage * (1 - fybfb)) * (1 + playerdamage)

                local r = math.random() * 100

                if r <= playBaojilv then
                    damage = damage * (1 + playBaojiDamage)
                end

                Actor:playerHurt(playerId, event.toobjid, math.floor(damage), 1)
            end

            return

            
        end
    end
end
ScriptSupportEvent:registerEvent('Actor.Collide', rotryWeaponCollideHandle)
