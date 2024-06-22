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

            local _, allOtherEffect = Valuegroup:getAllGroupItem(17, '装备附加效果组', playerId)

            if Actor:isPlayer(event.toobjid) ~= 0 then -- 对生物攻击
                local _, jinzhanfy = Creature:getAttr(event.toobjid, 19)

                damage = (damage * damage / (damage + (jinzhanfy - (jinzhanfy * allOtherEffect[2] / 100)))) *
                             (1 + playerdamage)

                -- 附加属性 1 计算
                damage = damage + allOtherEffect[1]

                local r = math.random() * 100

                if r <= (playBaojilv * 100) then
                    damage = damage * playBaojiDamage
                end

                damage = damage + (damage * allOtherEffect[3] / 100)

                if allOtherEffect[6] ~= 0 then
                    local _, gjl = Creature:getAttr(event.toobjid, 1)
                    if gjl > 1 then
                        Creature:setAttr(event.toobjid, 1, math.abs( gjl - allOtherEffect[6]) )
                    end
                end
                
                if allOtherEffect[5] ~= 0 then
                    if jinzhanfy > 1 then
                        Creature:setAttr(event.toobjid, 19, math.abs(jinzhanfy - allOtherEffect[5]) )
                    end
                end

                if allOtherEffect[7] ~= 0 then
                    Actor:addHP(playerId, allOtherEffect[7])
                end

                Actor:playerHurt(playerId, event.toobjid, math.floor(damage), 1)

            else
                local _, fyu = VarLib2:getPlayerVarByName(event.toobjid, 3, "玩家防御") -- 对方防御
                local _, lv = VarLib2:getPlayerVarByName(event.toobjid, 3, "等级") -- 对方防御

                local fybfb = (fyu - fyu * allOtherEffect[2] / 100) / (fyu + (20 + lv))
                damage = (damage * (1 - fybfb)) * (1 + playerdamage)

                -- 附加属性 1 计算
                damage = damage + allOtherEffect[1]

                local r = math.random() * 100

                if r <= (playBaojilv * 100) then
                    damage = damage * playBaojiDamage
                end

                damage = damage + (damage * allOtherEffect[3] / 100)

                if allOtherEffect[7] ~= 0 then
                    Actor:addHP(playerId, allOtherEffect[7])
                end

                if allOtherEffect[9] ~= 0 then
                    damage = damage - damage * allOtherEffect[9] * 0.01
                end

                if allOtherEffect[8] ~= 0 then
                    damage = damage - allOtherEffect[8]
                end

                damage = damage * 0.3

                Actor:playerHurt(playerId, event.toobjid, math.floor(damage), 2)
            end

            return

        end
    end
end
ScriptSupportEvent:registerEvent('Actor.Collide', rotryWeaponCollideHandle)
