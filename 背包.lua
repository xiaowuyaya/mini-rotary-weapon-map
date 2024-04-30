-- 迷你云服背包表明
MINI_CLOUD_TABLE = "backpack"

-- 当前房间所有玩家的背包数据 例: { uid: { dressed: {}, undressed: {}, items: {} }
PlayerBackpack = {}

--- 玩家背包数据初始化
---@param uid number 玩家迷你号
function PlayerBackpack.init(uid)
    print("PlayerBackpack.init 玩家背包数据初始化开始")

    -- 默认背包数据
    local DEFAULT_BACKPACK_DATA = {
        dressed = {
            weapon1 = 4131,
            weapon2 = 4131,
            weapon3 = 4131,
            weapon4 = 4131,
            hat = 4126,
            clothes = 4128,
            shoes = 4134,
            ring = 4136,
            bracelet = 4138,
            shield = 4144
        },
        undressed = {
            weapon = {4098, 4103, 4130, 4131, 4098, 4103, 4130, 4131, 4098, 4103, 4130, 4131, 4098, 4103, 4130, 4131,
                      4098, 4103, 4130, 4131},
            hat = {},
            clothes = {},
            shoes = {},
            ring = {},
            bracelet = {},
            shield = {}
        },
        items = {{4152, 50}, {4151, 30}, {4149, 20}, {4155, 20}, {4156, 20}, {4157, 20}, {4148, 50}, {4150, 1},
                 {4153, 999}, {4154, 999}}
    }

    -- 云服获取玩家背包数据回调方法
    local callback = function(ret, k, v)
        if ret == ErrorCode.OK then
            print("PlayerBackpack.init callback 云服获取玩家背包数据成功: ", k)
            PlayerBackpack[uid] = CopyTableDeep(v)
        else
            print("PlayerBackpack.init callback 云服获取玩家背包数据失败: ", ret)
            PlayerBackpack[uid] = DEFAULT_BACKPACK_DATA
            if ret == 2 then
                print("PlayerBackpack.init callback 不存在k数据", k)
            else
                print("PlayerBackpack.init callback 云服获取玩家背包数据失败: ", ret)
            end
        end

        PlayerBackpack.calculateAttr(uid)
        PlayerBackpack.changWeaponSkin(uid)
        UIBackpack.handleMainKuaijiejian(uid)
    end

    local cloudRet = CloudSever:getDataListByKeyEx(MINI_CLOUD_TABLE, "player_" .. uid, callback)
    print("PlayerBackpack.init 云服获取玩家背包数据结果: ", cloudRet)

end

--- 玩家背包数据上传保存
---@param uid number 玩家迷你号
function PlayerBackpack.save(uid)
    print("PlayerBackpack.save 云服保存玩家背包数据 ", uid)
    -- local ret = CloudSever:removeDataListByKey(MINI_CLOUD_TABLE, "player_" .. uid)
    -- print("删除玩家数据重新赋值", ret)
    local ret = CloudSever:setDataListBykey(MINI_CLOUD_TABLE, "player_" .. uid, PlayerBackpack[uid])
    print("PlayerBackpack.save 云服保存玩家背包数据结果: ", ret)
end

--- 玩家背包获取装备等对象
---@param uid number 玩家迷你号
---@param itemid number 装备id
function PlayerBackpack.addObject(uid, itemid)
    print("PlayerBackpack.addObject 玩家背包获取装备对象: ", uid, itemid)
    if ALL_BACKPACK_ITEMS[itemid] == nil then
        print("PlayerBackpack.addObject 装备不存在: ", itemid)
        return
    end

    local _, bpLimit = VarLib2:getPlayerVarByName(uid, 3, "背包容量")
    local currentBPNum = #PlayerBackpack[uid]['undressed']['weapon'] + #PlayerBackpack[uid]['undressed']['hat'] +
                             #PlayerBackpack[uid]['undressed']['clothes'] + #PlayerBackpack[uid]['undressed']['shoes'] +
                             #PlayerBackpack[uid]['undressed']['ring'] + #PlayerBackpack[uid]['undressed']['bracelet'] +
                             #PlayerBackpack[uid]['undressed']['shield'] + #PlayerBackpack[uid]['items']

    Backpack:clearAllPack(uid) -- 清空玩家游戏默认背包数据

    local iteminfo = ALL_BACKPACK_ITEMS[itemid]

    if (iteminfo.type == '消耗品' or iteminfo.type == '材料') == false then
        if currentBPNum + 1 > bpLimit then
            print("PlayerBackpack.addObject 背包已满: ", uid)
            Player:notifyGameInfo2Self(uid, "你的背包容量已满，请及时清理背包")
            return
        end

    else
        local isExist = false
        for ti, tarr in ipairs(PlayerBackpack[uid].items) do
            if tarr[1] == itemid then
                isExist = true
            end
        end

        if isExist == false and currentBPNum + 1 > bpLimit then
            print("PlayerBackpack.addObject 背包已满: ", uid)
            Player:notifyGameInfo2Self(uid, "你的背包容量已满，请及时清理背包")
            return
        end
    end

    if iteminfo.type == '消耗品' or iteminfo.type == '材料' then
        local isExist = false
        for ti, tarr in ipairs(PlayerBackpack[uid].items) do
            if tarr[1] == itemid then
                isExist = true
                tarr[2] = tarr[2] + 1
            end
        end
        if isExist == false then
            table.insert(PlayerBackpack[uid].items, {itemid, 1})
        end

    else
        table.insert(PlayerBackpack[uid]["undressed"][ITEM_TYPE_ENUMS[iteminfo.type]], itemid)
    end

    Buff:addBuff(uid, 50000007, 1, 1) -- 通知
end

--- 计算玩家属性
---@param uid number 玩家迷你号
function PlayerBackpack.calculateAttr(uid)
    print("PlayerBackpack.calculateAttr 开始计算玩家属性：", uid)
    local hp = 0
    local atk = 0
    local fangyu = 0
    local yisu = 0
    local baojilv = 0
    local baojishanghai = 0
    local hphuifu = 0
    local shanghaitisheng = 0
    local jinyanshouyi = 0
    local diaobaolv = 0
    local gjlbfb = VarLib2:getPlayerVarByName(uid, 3, "攻击力百分比")
    local fylbfb = VarLib2:getPlayerVarByName(uid, 3, "防御力百分比")
    local smzbfb = VarLib2:getPlayerVarByName(uid, 3, "生命值百分比")
    local smzhfbfb = VarLib2:getPlayerVarByName(uid, 3, "生命恢复百分比")

    local function findQianhuaIndex(itemType)
        for _, v in pairs(UIBackpack.ELEMENT_ID.LEFT_CELLS) do
            if v.type == itemType then
                return v.index
            end
        end
    end

    for dressedType, item in pairs(PlayerBackpack[uid]['dressed']) do
        if item ~= nil then
            local itemInfo = ALL_BACKPACK_ITEMS[item]

            local _, lv = Valuegroup:getValueNoByName(17, "装备槽强化等级", findQianhuaIndex(dressedType), uid)

            hp = hp + itemInfo['hp'] + itemInfo['hp'] * (lv * 0.01)
            atk = atk + itemInfo['atk'] + itemInfo['atk'] * (lv * 0.01)

            if itemInfo['otherAttr'] ~= nil then
                for _, v in ipairs(itemInfo['otherAttr']) do
                    if v[1] == 50001 then
                        atk = atk + v[2]
                    elseif v[1] == 50002 then
                        fangyu = fangyu + v[2]
                    elseif v[1] == 50003 then
                        hp = hp + v[2]
                    elseif v[1] == 50004 then
                        yisu = yisu + v[2]
                    elseif v[1] == 50005 then
                        baojilv = baojilv + v[2]
                    elseif v[1] == 50006 then
                        baojishanghai = baojishanghai + v[2]
                    elseif v[1] == 50007 then
                        hphuifu = hphuifu + v[2]
                    elseif v[1] == 50008 then
                        shanghaitisheng = shanghaitisheng + v[2]
                    elseif v[1] == 50009 then
                        jinyanshouyi = jinyanshouyi + v[2]
                    elseif v[1] == 50010 then
                        diaobaolv = diaobaolv + v[2]

                    elseif v[1] == 50011 then
                        gjlbfb = gjlbfb + v[2]
                    elseif v[1] == 50012 then
                        fylbfb = fylbfb + v[2]
                    elseif v[1] == 50013 then
                        smzbfb = smzbfb + v[2]
                    elseif v[1] == 50014 then
                        smzhfbfb = smzhfbfb + v[2]
                    end

                end
            end

        end
    end

    VarLib2:setPlayerVarByName(uid, 3, "生命值", hp)
    VarLib2:setPlayerVarByName(uid, 3, "攻击", atk)
    VarLib2:setPlayerVarByName(uid, 3, "防御", fangyu)
    VarLib2:setPlayerVarByName(uid, 3, "移速", yisu)
    VarLib2:setPlayerVarByName(uid, 3, "暴击率", baojilv)
    VarLib2:setPlayerVarByName(uid, 3, "暴击伤害", baojishanghai)
    VarLib2:setPlayerVarByName(uid, 3, "生命恢复", hphuifu)
    VarLib2:setPlayerVarByName(uid, 3, "伤害提升", shanghaitisheng)
    VarLib2:setPlayerVarByName(uid, 3, "经验收益", jinyanshouyi)
    VarLib2:setPlayerVarByName(uid, 3, "掉宝率", diaobaolv)
    VarLib2:setPlayerVarByName(uid, 3, "攻击力百分比", gjlbfb)
    VarLib2:setPlayerVarByName(uid, 3, "防御力百分比", fylbfb)
    VarLib2:setPlayerVarByName(uid, 3, "生命值百分比", smzbfb)
    VarLib2:setPlayerVarByName(uid, 3, "生命恢复百分比", smzhfbfb)

    Buff:addBuff(uid, 50000003, 1, 1) -- 刷新面板BUFF
end

--- 更改武器皮肤
---@param uid number 玩家迷你号
function PlayerBackpack.changWeaponSkin(uid)
    for i, weaponId in ipairs(allPlayerAttr[uid].rotaryWeapon) do
        if PlayerBackpack[uid].dressed["weapon" .. i] ~= nil then
            local weaponInfo = ALL_BACKPACK_ITEMS[PlayerBackpack[uid].dressed["weapon" .. i]]
            local imgInfo = Graphics:makeGraphicsImage(weaponInfo.img, 1.1, 100, 1)
            local result = Graphics:createGraphicsImageByActor(weaponId, imgInfo, {
                x = 0,
                y = 0,
                z = 0
            }, 0, 0, 2)
            print("PlayerBackpack.changWeaponSkin 更改武器皮肤结果: ", result, weaponId,
                PlayerBackpack[uid].dressed["weapon" .. i], imgInfo, result)
        else
            local imgInfo = Graphics:makeGraphicsImage(ALL_BACKPACK_ITEMS[4098].img, 1.1, 100, 1)
            local result = Graphics:createGraphicsImageByActor(weaponId, imgInfo, {
                x = 0,
                y = 0,
                z = 0
            }, 0, 0, 2)
            print("PlayerBackpack.changWeaponSkin 更改武器皮肤结果: ", result, weaponId, 4098, imgInfo, result)
        end
    end
end

--- 使用道具
---@param uid number 玩家迷你号
---@param itemid number 道具id
function PlayerBackpack.useItem(uid, itemid)
    for i, itemArr in ipairs(PlayerBackpack[uid].items) do
        if itemArr[1] == itemid then

            local _, playerLv = VarLib2:getPlayerVarByName(uid, 3, "等级")
            if playerLv < ALL_BACKPACK_ITEMS[itemid].lv then
                Player:notifyGameInfo2Self(uid, "你的等级未达到道具使用要求等级")
                return
            end

            -- 处理道具效果
            if ALL_BACKPACK_ITEMS[itemid].effect == 'hp' then -- 生命药水恢复处理
                local code = Actor:hasBuff(uid, 50000014)
                if code ~= 0 then
                    Actor:addHP(uid, ALL_BACKPACK_ITEMS[itemid].value)
                    Actor:addBuff(uid, 50000014, 1, 15 * 24)
                    Actor:playBodyEffectById(uid, 1150, 1)
                    Player:notifyGameInfo2Self(uid, "#W道具使用成功，恢复#G" ..
                        ALL_BACKPACK_ITEMS[itemid].value .. "HP")
                    print("PlayerBackpack.useItem 使用道具恢复生命值: ", uid, itemid,
                        ALL_BACKPACK_ITEMS[itemid].value)
                else
                    local _, ticks = Actor:getBuffLeftTick(uid, 50000014)
                    Player:notifyGameInfo2Self(uid, "药水使用仍在CD冷却中, 剩余时间: " ..
                        math.floor(ticks / 24) .. "秒")
                    return
                end
            end

            -- 移除道具数量
            if itemArr[2] == 1 then
                table.remove(PlayerBackpack[uid].items, i)
                for ki = 1, 4 do
                    local _, kuaijielan = Valuegroup:getValueNoByName(21, "快捷键道具组", ki, uid)
                    if kuaijielan == itemid then
                        Valuegroup:setValueNoByName(21, "快捷键道具组", ki, 101, uid)
                    end
                end

            else
                itemArr[2] = itemArr[2] - 1
            end
            Player:hideUIView(uid, UIBackpack.ELEMENT_ID.MAIN)
            UIBackpack.handleMainKuaijiejian(uid)
        end
    end
end

--- UI 相关
UIBackpack = {
    -- 所有UI元素的ID
    ELEMENT_ID = {
        MAIN = "7346489952599218400",
        -- 背包-右侧-导航栏 { 类型, ID }
        RIGHT_NAV_MENUS = {
            ["7346489952599218400_178"] = {"weapon", "7346489952599218400_179"},
            ["7346489952599218400_647"] = {"hat", "7346489952599218400_648"},
            ["7346489952599218400_649"] = {"clothes", "7346489952599218400_650"},
            ["7346489952599218400_651"] = {"shoes", "7346489952599218400_652"},
            ["7346489952599218400_653"] = {"ring", "7346489952599218400_654"},
            ["7346489952599218400_655"] = {"bracelet", "7346489952599218400_656"},
            ["7346489952599218400_657"] = {"shield", "7346489952599218400_658"},
            ["7346489952599218400_659"] = {"items", "7346489952599218400_660"}
        },
        -- 品质
        QUALITY_BG = {
            ["普通"] = {"8_1118247136_1704453713", "8_1118247136_1710515583"},
            ["精良"] = {"8_1118247136_1705398630", "8_1118247136_1705214792"},
            ["完美"] = {"8_1118247136_1705398618", "8_1118247136_1704451287"},
            ["史诗"] = {"8_1118247136_1705398641", "8_1118247136_1710515556"},
            ["传说"] = {"8_1118247136_1705398636", "8_1118247136_1710515564"},
            ["神话"] = {"8_1118247136_1705398647", "8_1118247136_1710515571"},
            ["至尊"] = {"8_1118247136_1705398625", "8_1118247136_1710515526"}
        },
        -- 背包-右侧-所有单元格
        RIGHT_CELLS = {"7346489952599218400_675", "7346489952599218400_679", "7346489952599218400_683",
                       "7346489952599218400_687", "7346489952599218400_691", "7346489952599218400_695",
                       "7346489952599218400_703", "7346489952599218400_711", "7346489952599218400_715",
                       "7346489952599218400_719", "7346489952599218400_723", "7346489952599218400_727",
                       "7346489952599218400_731", "7346489952599218400_735", "7346489952599218400_739",
                       "7346489952599218400_743", "7346489952599218400_747", "7346489952599218400_751",
                       "7346489952599218400_755", "7346489952599218400_759", "7346489952599218400_763",
                       "7346489952599218400_767", "7346489952599218400_771", "7346489952599218400_775",
                       "7346489952599218400_875", "7346489952599218400_879", "7346489952599218400_883",
                       "7346489952599218400_887", "7346489952599218400_891", "7346489952599218400_895"},
        -- 背包-右侧-穿戴装备
        LEFT_CELLS = {
            -- 帽子
            ["7346489952599218400_32"] = {
                type = 'hat',
                index = 3,
                bg = "7346489952599218400_32",
                icon = "7346489952599218400_34",
                addNum = '7346489952599218400_584',
                addNumBg = "7346489952599218400_583",
                lv = '7346489952599218400_588',
                text = "7346489952599218400_33"
            },
            -- 衣服
            ["7346489952599218400_26"] = {
                type = 'clothes',
                index = 2,
                bg = "7346489952599218400_26",
                icon = "7346489952599218400_28",
                addNum = '7346489952599218400_606',
                addNumBg = "7346489952599218400_605",
                lv = '7346489952599218400_607',
                text = '7346489952599218400_27'
            },
            -- 鞋子
            ["7346489952599218400_40"] = {
                type = 'shoes',
                index = 1,
                bg = "7346489952599218400_40",
                icon = "7346489952599218400_42",
                addNum = '7346489952599218400_609',
                addNumBg = "7346489952599218400_608",
                lv = '7346489952599218400_610',
                text = '7346489952599218400_41'
            },
            -- 武器槽1
            ["7346489952599218400_23"] = {
                type = 'weapon1',
                index = 4,
                bg = "7346489952599218400_23",
                icon = "7346489952599218400_25",
                addNum = '7346489952599218400_590',
                addNumBg = "7346489952599218400_589",
                lv = '7346489952599218400_591',
                text = '7346489952599218400_24'
            },
            -- 武器槽2
            ["7346489952599218400_523"] = {
                type = 'weapon2',
                index = 5,
                bg = "7346489952599218400_523",
                icon = "7346489952599218400_525",
                addNum = '7346489952599218400_593',
                addNumBg = "7346489952599218400_592",
                lv = '7346489952599218400_594',
                text = '7346489952599218400_524'
            },
            -- 武器槽3
            ["7346489952599218400_526"] = {
                type = 'weapon3',
                index = 6,
                bg = "7346489952599218400_526",
                icon = "7346489952599218400_528",
                addNum = '7346489952599218400_596',
                addNumBg = "7346489952599218400_595",
                lv = '7346489952599218400_597',
                text = '7346489952599218400_527'
            },
            -- 武器槽4
            ["7346489952599218400_529"] = {
                type = 'weapon4',
                index = 7,
                bg = "7346489952599218400_529",
                icon = "7346489952599218400_531",
                addNum = '7346489952599218400_599',
                addNumBg = "7346489952599218400_598",
                lv = '7346489952599218400_600',
                text = '7346489952599218400_530'
            },
            -- 戒指
            ["7346489952599218400_536"] = {
                type = 'ring',
                index = 8,
                bg = "7346489952599218400_536",
                icon = "7346489952599218400_538",
                addNum = '7346489952599218400_603',
                addNumBg = "7346489952599218400_602",
                lv = '7346489952599218400_604',
                text = '7346489952599218400_537'
            },
            -- 护腕
            ["7346489952599218400_532"] = {
                type = 'bracelet',
                index = 9,
                bg = "7346489952599218400_532",
                icon = "7346489952599218400_534",
                addNum = '7346489952599218400_612',
                addNumBg = "7346489952599218400_611",
                lv = '7346489952599218400_613',
                text = '7346489952599218400_533'
            },
            -- 盾牌
            ["7346489952599218400_539"] = {
                type = 'shield',
                index = 10,
                bg = "7346489952599218400_539",
                icon = "7346489952599218400_541",
                addNum = '7346489952599218400_615',
                addNumBg = "7346489952599218400_614",
                lv = '7346489952599218400_616',
                text = '7346489952599218400_540'
            }

        },
        DETAIL_PANEL = {
            left = {
                panel = "7346489952599218400_805",
                tran = "7346489952599218400_939",
                panel_title = "7346489952599218400_807",
                panel_bg = "7346489952599218400_806",
                icon_bg = "7346489952599218400_808",
                icon = "7346489952599218400_812",
                type = "7346489952599218400_809",
                pinzhi = "7346489952599218400_810",
                lv = "7346489952599218400_811",
                gonjili = "7346489952599218400_816",
                hp = "7346489952599218400_820",
                qianghua1 = "7346489952599218400_818",
                qianghua2 = "7346489952599218400_822",
                other_attr = {{"7346489952599218400_907", "7346489952599218400_908"},
                              {"7346489952599218400_909", "7346489952599218400_910"},
                              {"7346489952599218400_911", "7346489952599218400_912"}},
                other_effect = "7346489952599218400_923",
                undress = "7346489952599218400_826"
            },
            right = {
                panel = "7346489952599218400_830",
                tran = "7346489952599218400_938",
                icon_bg = "7346489952599218400_833",
                icon = "7346489952599218400_834",
                panel_title = "7346489952599218400_832",
                panel_bg = "7346489952599218400_831",
                type = "7346489952599218400_835",
                pinzhi = "7346489952599218400_836",
                lv = "7346489952599218400_837",
                gonjili = "7346489952599218400_841",
                hp = "7346489952599218400_843",
                other_attr = {{"7346489952599218400_924", "7346489952599218400_925"}, -- 附加属性 { 文本， 数值 }
                              {"7346489952599218400_926", "7346489952599218400_927"},
                              {"7346489952599218400_928", "7346489952599218400_929"}},
                other_effect = "7346489952599218400_932", -- 附加效果
                huishou = "7346489952599218400_852",
                huishou_ok = "7346489952599218400_966",
                dress = "7346489952599218400_850"
            },
            items = {
                panel = "7346489952599218400_1033", -- 总面板
                panel_title = "7346489952599218400_1035", -- 标题
                panel_bg = "7346489952599218400_1034", -- 面板品质背景
                icon_bg = "7346489952599218400_1036", -- 图标背景
                icon = "7346489952599218400_1037", -- 图标
                type = "7346489952599218400_1038", -- 类型
                pinzhi = "7346489952599218400_1039", -- 品质
                lv = "7346489952599218400_1040", -- 等级
                desc = "7346489952599218400_1059", -- 描述
                kuaijiejian = {
                    box = "7346489952599218400_1105",
                    no1 = {"7346489952599218400_1090", "7346489952599218400_1092"},
                    no2 = {"7346489952599218400_1094", "7346489952599218400_1096"},
                    no3 = {"7346489952599218400_1098", "7346489952599218400_1100"},
                    no4 = {"7346489952599218400_1102", "7346489952599218400_1104"}
                },
                ok = "7346489952599218400_1047"
            }
        },
        HUISHOU = {
            MAIN = "7346489952599218400_946",
            QIANBI = "7346489952599218400_955",
            XIANYU = "7346489952599218400_958",
            QIANGHUASHI = "7346489952599218400_961",
            TUPOSHI = "7346489952599218400_963",
            TUPOSHI_ENUMS = {
                ["普通"] = "8_1118247136_1714150832",
                ["精良"] = "8_1118247136_1714150840",
                ["完美"] = "8_1118247136_1714150847",
                ["史诗"] = "8_1118247136_1714150853",
                ["传说"] = "8_1118247136_1714150859",
                ["神话"] = "8_1118247136_1714150866",
                ["至尊"] = "8_1118247136_1714150872"
            }
        },
        FEN_YE = {
            TEXT = "7346489952599218400_104",
            NEXT = "7346489952599218400_102",
            PREV = "7346489952599218400_103"
        },
        BUY_CELL_OK = "7346489952599218400_1018",
        SORT_BTN = "7346489952599218400_778",
        -- 主界面UI
        MAIN_UI = "7346497485971855584",
        MAIN_KUAIJIEJIAN = {
            no1 = {"7346497485971855584_85", "7346497485971855584_87"},
            no2 = {"7346497485971855584_93", "7346497485971855584_95"},
            no3 = {"7346497485971855584_97", "7346497485971855584_99"},
            no4 = {"7346497485971855584_101", "7346497485971855584_103"}
        },
        HUISHOU_UI = {
            btn = {
                ["普通"] = {"7346489952599218400_1131", "7346489952599218400_1132"},
                ["精良"] = {"7346489952599218400_1134", "7346489952599218400_1135"},
                ["完美"] = {"7346489952599218400_1137", "7346489952599218400_1138"},
                ["史诗"] = {"7346489952599218400_1143", "7346489952599218400_1144"},
                ["传说"] = {"7346489952599218400_1146", "7346489952599218400_1147"}
            },
            ok = "7346489952599218400_1125"
        },
        QIANGHUA_OK = "7346489952599218400_1153",
        BLACK_BG = "7346489952599218400_1106"
    },
    currentSelectMenuType = {}, -- 当前玩家选择的背包导航栏类型 如: {uid: weapon}
    currentSelectItemId = {}, -- 当前玩家选择的背包物品ID 如: {uid: 4148},
    currentSelectLeftCell = {}, -- 当前玩家选择的背包左侧单元格 如: {uid: weapon1}
    page = {}, -- 当前玩家背包分页信息 { uid: {current: 1, total: 10} }
    cureentSelectHuishouTypes = {} -- 当前玩家选择的回收类型 {uid: {普通}}
}

--- 右侧菜单栏点击切换事件处理 
---@param uid number 玩家迷你号
---@param uielement string UI元素ID
function UIBackpack.handleNavMenusChange(uid, uielement)
    if UIBackpack.ELEMENT_ID.RIGHT_NAV_MENUS[uielement] == nil then
        return
    end

    for eleId, arr in pairs(UIBackpack.ELEMENT_ID.RIGHT_NAV_MENUS) do
        if eleId ~= uielement then
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, eleId, "8_1118247136_1705214511") -- 未选中效果
            Customui:setColor(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.RIGHT_NAV_MENUS[eleId][2],
                "0xf7f7f7") -- 未选中
        else
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, uielement, "8_1118247136_1704451218") -- 已选中效果
            Customui:setColor(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.RIGHT_NAV_MENUS[uielement][2],
                "0x4e5251") -- 已选中效果
        end
    end
    UIBackpack.page[uid] = {
        current = 1,
        total = 0
    }
    UIBackpack.currentSelectMenuType[uid] = UIBackpack.ELEMENT_ID.RIGHT_NAV_MENUS[uielement][1]

    UIBackpack.handleShowAllRightCell(uid, UIBackpack.currentSelectMenuType[uid])

    print("UIBackpack.handleNavMenusChange 当前选择的背包导航栏类型: ",
        UIBackpack.currentSelectMenuType[uid])

end

--- 显示右侧背包所有单元格
---@param uid number 玩家迷你号
---@param type string 背包类型
function UIBackpack.handleShowAllRightCell(uid, type)
    -- 隐藏所有右侧装备栏
    print("UIBackpack.handleShowAllRightCell 开始显示右侧背包所有单元格: ", type)
    for _, eleId in ipairs(UIBackpack.ELEMENT_ID.RIGHT_CELLS) do
        Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, eleId)
    end

    if UIBackpack.page[uid] == nil then
        UIBackpack.page[uid] = {
            current = 1,
            total = 0
        }
    end

    if type == "items" then
        UIBackpack.page[uid]['total'] = math.floor(#PlayerBackpack[uid]['items'] / 30) + 1
    else
        UIBackpack.page[uid]['total'] = math.floor(#PlayerBackpack[uid]['undressed'][type] / 30) + 1
    end

    local playerObjs = (type == "items") and PlayerBackpack[uid]['items'] or PlayerBackpack[uid]['undressed'][type]

    local start = (UIBackpack.page[uid]['current'] - 1) * 30 + 1
    local endNum = UIBackpack.page[uid]['current'] * 30
    print(start, endNum, UIBackpack.page[uid]['total'])
    for i = start, endNum do
        if playerObjs[i] ~= nil then
            local objid = (type == "items") and playerObjs[i][1] or playerObjs[i]

            local itemInfo = ALL_BACKPACK_ITEMS[objid]
            local cellIdx = (i % 30 == 0) and 30 or i % 30
            local bgElementId = UIBackpack.ELEMENT_ID.RIGHT_CELLS[cellIdx]
            local iconElementId = increment_string(bgElementId)
            local textElementId = increment_string(iconElementId)

            local qualityElementId = UIBackpack.ELEMENT_ID.QUALITY_BG[itemInfo.quality][1]
            local levelText = (type == "items") and tostring(playerObjs[i][2]) or "lv" .. itemInfo.lv

            local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", objid, 0)
            local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, bgElementId, qualityElementId)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, textElementId, levelText)
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, iconElementId, iconid)
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, bgElementId)
        end
    end

end

--- 显示左侧背包所有单元格
---@param uid number 玩家迷你号
function UIBackpack.handleShowAllLeftCell(uid)
    for uiid, uiItem in pairs(UIBackpack.ELEMENT_ID.LEFT_CELLS) do
        local playerDressedItemId = PlayerBackpack[uid]['dressed'][uiItem.type]

        if playerDressedItemId ~= nil then
            local itemInfo = ALL_BACKPACK_ITEMS[playerDressedItemId]
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem['addNumBg'])

            local _, qianghuadengji = Valuegroup:getValueNoByName(17, "装备槽强化等级", uiItem.index, uid)

            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem["addNum"], "+" .. qianghuadengji)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem["lv"], 'Lv' .. itemInfo['lv'])

            local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", playerDressedItemId, 0)
            local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem['icon'], iconid)
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem['bg'],
                UIBackpack.ELEMENT_ID.QUALITY_BG[itemInfo.quality][1])
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem['icon'])

            Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem["text"])
        else
            Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem["addNumBg"])
            Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem['icon'])
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem['bg'],
                UIBackpack.ELEMENT_ID.QUALITY_BG["普通"][1])
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, uiItem['text'])
        end
    end
end

base_qianbi = 10 -- 回收基础钱币
local calXianyuQianghuashi = function(type)
    local setXianyu = 0
    local setQianghuashi = 0
    if type == '普通' then
        setXianyu = 0
        setQianghuashi = 0
    elseif type == '精良' then
        setXianyu = 0
        setQianghuashi = 1
    elseif type == '完美' then
        setXianyu = 0
        setQianghuashi = 3
    elseif type == '史诗' then
        setXianyu = 5
        setQianghuashi = 10
    elseif type == '传说' then
        setXianyu = 100
        setQianghuashi = 50
    elseif type == '神话' then
        setXianyu = 500
        setQianghuashi = 300
    elseif type == '至尊' then
        setXianyu = 2000
        setQianghuashi = 1500
    end

    return setXianyu, setQianghuashi
end

--- 回收装备逻辑处理
---@param uid number 玩家迷你号
---@param itemid number 道具id
function UIBackpack.handleObjectHuishou(uid, itemid)
    local iteminfo = ALL_BACKPACK_ITEMS[itemid]

    local _, xianyu = VarLib2:getPlayerVarByName(uid, 3, "仙玉")
    local _, qianbi = VarLib2:getPlayerVarByName(uid, 3, "钱币")
    local _, qianghuashi = VarLib2:getPlayerVarByName(uid, 3, "强化石")

    VarLib2:setPlayerVarByName(uid, 3, "钱币",
        qianbi + iteminfo.lv * base_qianbi * findIndex(QUALITY_ENUM, iteminfo.quality) *
            findIndex(QUALITY_ENUM, iteminfo.quality))

    local setXianyu, setQianghuashi = calXianyuQianghuashi(iteminfo.quality)
    VarLib2:setPlayerVarByName(uid, 3, "仙玉", xianyu + setXianyu)
    VarLib2:setPlayerVarByName(uid, 3, "强化石", qianghuashi + setQianghuashi)

    local TuposhiQualityMap = {
        ["普通"] = 4148,
        ["精良"] = 4149,
        ["完美"] = 4150,
        ["史诗"] = 4151,
        ["传说"] = 4152,
        ["神话"] = 4153,
        ["至尊"] = 4154
    }
    local isExist = false
    for i, itemArr in ipairs(PlayerBackpack[uid]['items']) do
        local needAddItem = TuposhiQualityMap[iteminfo.quality]
        if itemArr[1] == needAddItem then
            itemArr[2] = itemArr[2] + 1
            isExist = true
        end
    end
    if isExist == false then
        table.insert(PlayerBackpack[uid]['items'], {TuposhiQualityMap[iteminfo.quality], 1})
    end

    table.remove(PlayerBackpack[uid]['undressed'][UIBackpack.currentSelectMenuType[uid]],
        findIndex(PlayerBackpack[uid]['undressed'][UIBackpack.currentSelectMenuType[uid]], itemid))

end

--- 处理所有面板信息的事件
---@param uid number
---@param uielement string
function UIBackpack.handleAllDetailPanel(uid, uielement)
    local isBaifengbiNums = {50004, 50005, 50004, 50006, 50008, 50009, 50010, 50011, 50012, 50013, 50014}

    if isInArray(UIBackpack.ELEMENT_ID.RIGHT_CELLS, uielement) then -- 显示右侧详细面板
        local idx = findIndex(UIBackpack.ELEMENT_ID.RIGHT_CELLS, uielement)
        local selectObjIdx = (UIBackpack.page[uid]['current'] - 1) * 30 + idx

        local currentSelectItemId = (UIBackpack.currentSelectMenuType[uid] == "items") and
                                        PlayerBackpack[uid]['items'][selectObjIdx][1] or
                                        PlayerBackpack[uid]['undressed'][UIBackpack.currentSelectMenuType[uid]][selectObjIdx]
        UIBackpack.currentSelectItemId[uid] = currentSelectItemId
        local iteminfo = ALL_BACKPACK_ITEMS[currentSelectItemId]

        if UIBackpack.currentSelectMenuType[uid] ~= "items" then -- 显示装备面板
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.panel)
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.tran)

            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.panel_title,
                iteminfo.name)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.type,
                "类型: " .. iteminfo.type)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.pinzhi,
                "品质: " .. iteminfo.quality)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.lv,
                "等级: " .. iteminfo.lv)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.gonjili,
                "+" .. iteminfo.atk)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.hp,
                "+" .. iteminfo.hp)
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.panel_bg,
                UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][2])
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.icon_bg,
                UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][1])

            local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", currentSelectItemId, 0)
            local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.icon, iconid)

            for i, v in ipairs(UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.other_attr) do
                if iteminfo.otherAttr ~= nil then
                    if iteminfo.otherAttr[i] ~= nil then
                        if isInArray(isBaifengbiNums, iteminfo.otherAttr[i][1]) then
                            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[1],
                                ITEMS_OTHER_ATTRS[iteminfo.otherAttr[i][1]])
                            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[2],
                                tostring(iteminfo.otherAttr[i][2] * 100) .. "%")
                        else
                            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[1],
                                ITEMS_OTHER_ATTRS[iteminfo.otherAttr[i][1]])
                            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[2], iteminfo.otherAttr[i][2])
                        end

                    else
                        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[1], "")
                        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[2], "")
                    end
                    Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, v[1])
                    Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, v[2])
                else
                    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, v[1])
                    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, v[2])
                end
            end

            if iteminfo.otherEffect ~= nil then
                Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.other_effect,
                    ITEMS_OTHER_ATTRS[iteminfo.otherEffect[1]])
            else
                Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.other_effect,
                    "")
            end

        else -- 显示道具面板
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.panel)
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.tran)

            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.panel_title,
                iteminfo.name)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.type,
                "类型: " .. iteminfo.type)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.pinzhi,
                "品质: " .. iteminfo.quality)
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.lv,
                "等级: " .. iteminfo.lv)

            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.desc,
                iteminfo.desc)

            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.panel_bg,
                UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][2])
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.icon_bg,
                UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][1])

            if iteminfo.type == "材料" then
                Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN,
                    UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian.box)
                Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.ok)
            else
                -- 快捷栏变量
                local _, kuaijielan_1 = Valuegroup:getValueNoByName(21, "快捷键道具组", 1, uid)
                local _, kuaijielan_2 = Valuegroup:getValueNoByName(21, "快捷键道具组", 2, uid)
                local _, kuaijielan_3 = Valuegroup:getValueNoByName(21, "快捷键道具组", 3, uid)
                local _, kuaijielan_4 = Valuegroup:getValueNoByName(21, "快捷键道具组", 4, uid)
                local valuegroupkuaijielans = {kuaijielan_1, kuaijielan_2, kuaijielan_3, kuaijielan_4}

                for i, v in ipairs(valuegroupkuaijielans) do
                    if v == 101 then
                        Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN,
                            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. i][1], 0)
                        Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN,
                            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. i][2], 0)

                    else

                        local _, temp_index = Valuegroup:getGroupNoByValue(21, "道具类型组", v, 0)
                        local _, temp_iconid = Valuegroup:getValueNoByName(18, "道具图片组", temp_index, 0)

                        Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN,
                            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. i][1], 100)
                        Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN,
                            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. i][2], 100)
                        Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN,
                            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. i][1], temp_iconid)

                        local findItemNum = function(itemid)
                            for findI, findArr in ipairs(PlayerBackpack[uid].items) do
                                if findArr[1] == itemid then
                                    return findArr[2]
                                end
                            end
                        end

                        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN,
                            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. i][2], "" .. findItemNum(v))
                    end
                end

                Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN,
                    UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian.box)
                Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.ok)
            end

            local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", currentSelectItemId, 0)
            local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.icon, iconid)

        end

    elseif UIBackpack.ELEMENT_ID.LEFT_CELLS[uielement] ~= nil then -- 显示左侧详细面板 
        local selectType = UIBackpack.ELEMENT_ID.LEFT_CELLS[uielement].type
        local currentSelectItemId = PlayerBackpack[uid]['dressed'][selectType]

        UIBackpack.currentSelectLeftCell[uid] = selectType

        if currentSelectItemId ~= nil then
            UIBackpack.currentSelectItemId[uid] = currentSelectItemId
            local iteminfo = ALL_BACKPACK_ITEMS[currentSelectItemId]

            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.panel_title,
                iteminfo['name'])
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.type,
                "类型: " .. iteminfo['type'])
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.pinzhi,
                "品质: " .. iteminfo['quality'])
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.lv,
                "等级: " .. iteminfo['lv'])
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.gonjili,
                "+" .. iteminfo['atk'])
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.hp,
                "+" .. iteminfo['hp'])

            local _, lv = Valuegroup:getValueNoByName(17, "装备槽强化等级",
                UIBackpack.ELEMENT_ID.LEFT_CELLS[uielement].index, uid)

            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.qianghua1,
                "+" .. math.floor(iteminfo.atk * lv * 0.01))
            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.qianghua2,
                "+" .. math.floor(iteminfo.hp * lv * 0.01))

            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.panel_bg,
                UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][2])
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.icon_bg,
                UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][1])

            local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", currentSelectItemId, 0)
            local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.icon, iconid)

            for i, v in ipairs(UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.other_attr) do
                if iteminfo['otherAttr'] ~= nil then
                    if iteminfo['otherAttr'][i] ~= nil then

                        if isInArray(isBaifengbiNums, iteminfo['otherAttr'][i][1]) then
                            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[1],
                                ITEMS_OTHER_ATTRS[iteminfo['otherAttr'][i][1]])
                            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[2],
                                tostring(iteminfo['otherAttr'][i][2] * 100) .. "%")
                        else
                            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[1],
                                ITEMS_OTHER_ATTRS[iteminfo['otherAttr'][i][1]])
                            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[2], iteminfo['otherAttr'][i][2])
                        end

                    else
                        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[1], "")
                        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, v[2], "")
                    end
                    Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, v[1])
                    Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, v[2])
                else
                    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, v[1])
                    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, v[2])
                end
            end

            if iteminfo['otherEffect'] ~= nil then
                Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.other_effect,
                    ITEMS_OTHER_ATTRS[iteminfo['otherEffect'][1]])
            else
                Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.other_effect,
                    "")
            end

            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.panel)
            Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.tran)
        end

    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.tran then -- 隐藏左侧详细面板
        Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.tran)
        Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.panel)
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.tran then -- 隐藏左侧详细面板
        Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.tran)
        Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.panel)
        Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.panel)
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.huishou then -- 点击右侧面板回收按钮
        local code = Actor:hasBuff(uid, 50000012)
        if code == 0 then
            return
        end

        Actor:addBuff(uid, 50000012, 1, 7)

        Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.BLACK_BG)
        Customui:showElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.HUISHOU.MAIN)
        local iteminfo = ALL_BACKPACK_ITEMS[UIBackpack.currentSelectItemId[uid]]
        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.HUISHOU.QIANBI, iteminfo.lv *
            base_qianbi * findIndex(QUALITY_ENUM, iteminfo.quality) * findIndex(QUALITY_ENUM, iteminfo.quality))
        Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.HUISHOU.TUPOSHI,
            UIBackpack.ELEMENT_ID.HUISHOU.TUPOSHI_ENUMS[iteminfo.quality])

        local setXianyu, setQianghuashi = calXianyuQianghuashi(iteminfo.quality)

        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.HUISHOU.XIANYU, tostring(setXianyu))
        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.HUISHOU.QIANGHUASHI,
            tostring(setQianghuashi))
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.huishou_ok then -- 处理回收
        local code = Actor:hasBuff(uid, 50000012)
        if code == 0 then
            return
        end

        Actor:addBuff(uid, 50000012, 1, 7)

        UIBackpack.handleObjectHuishou(uid, UIBackpack.currentSelectItemId[uid])

        UIBackpack.handleShowAllRightCell(uid, UIBackpack.currentSelectMenuType[uid])

        UIBackpack.handlePaginationText(uid)
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.undress then -- 脱下装备处理
        local code = Actor:hasBuff(uid, 50000012)
        if code == 0 then
            return
        end

        Actor:addBuff(uid, 50000012, 1, 7)

        local currentSelectLeftCell = UIBackpack.currentSelectLeftCell[uid]
        print("UIBackpack.handleAllDetailPanel 脱下装备处理", currentSelectLeftCell)

        if string.find(currentSelectLeftCell, "weapon") then
            table.insert(PlayerBackpack[uid]['undressed']['weapon'],
                PlayerBackpack[uid]['dressed'][currentSelectLeftCell])
            PlayerBackpack[uid]['dressed'][currentSelectLeftCell] = nil
        else
            table.insert(PlayerBackpack[uid]['undressed'][currentSelectLeftCell],
                PlayerBackpack[uid]['dressed'][currentSelectLeftCell])
            PlayerBackpack[uid]['dressed'][currentSelectLeftCell] = nil
        end

        UIBackpack.handleShowAllLeftCell(uid)
        UIBackpack.handleShowAllRightCell(uid, UIBackpack.currentSelectMenuType[uid])
        UIBackpack.handleHideDetailPanel(uid)
        PlayerBackpack.calculateAttr(uid)
        UIBackpack.handlePaginationText(uid)
        PlayerBackpack.changWeaponSkin(uid)
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.dress then -- 穿上装备处理
        local code = Actor:hasBuff(uid, 50000012)
        if code == 0 then
            return
        end

        Actor:addBuff(uid, 50000012, 1, 7)

        local iteminfo = ALL_BACKPACK_ITEMS[UIBackpack.currentSelectItemId[uid]]
        print("UIBackpack.handleAllDetailPanel 穿上装备处理", iteminfo)
        local _, playerLv = VarLib2:getPlayerVarByName(uid, 3, "等级")
        if playerLv < iteminfo.lv then
            Player:notifyGameInfo2Self(uid, "你的等级未达到装备要求等级")
            return
        end

        local itemType = UIBackpack.currentSelectMenuType[uid]

        local currentSelectItemIdx = findIndex(PlayerBackpack[uid]['undressed'][itemType],
            UIBackpack.currentSelectItemId[uid])

        if itemType == 'weapon' then
            if PlayerBackpack[uid]['dressed']['weapon1'] == nil then
                PlayerBackpack[uid]['dressed']["weapon1"] = UIBackpack.currentSelectItemId[uid]
                table.remove(PlayerBackpack[uid]['undressed'][itemType], currentSelectItemIdx)
            else
                if PlayerBackpack[uid]['dressed']['weapon2'] == nil then
                    PlayerBackpack[uid]['dressed']["weapon2"] = UIBackpack.currentSelectItemId[uid]
                    table.remove(PlayerBackpack[uid]['undressed'][itemType], currentSelectItemIdx)
                else
                    if PlayerBackpack[uid]['dressed']['weapon3'] == nil then
                        PlayerBackpack[uid]['dressed']["weapon3"] = UIBackpack.currentSelectItemId[uid]
                        table.remove(PlayerBackpack[uid]['undressed'][itemType], currentSelectItemIdx)
                    else
                        if PlayerBackpack[uid]['dressed']['weapon4'] == nil then
                            PlayerBackpack[uid]['dressed']["weapon4"] = UIBackpack.currentSelectItemId[uid]
                            table.remove(PlayerBackpack[uid]['undressed'][itemType], currentSelectItemIdx)
                        else
                            table.remove(PlayerBackpack[uid]['undressed'][itemType], currentSelectItemIdx)
                            table.insert(PlayerBackpack[uid]['undressed'][itemType],
                                PlayerBackpack[uid]['dressed']["weapon1"])
                            PlayerBackpack[uid]['dressed']["weapon1"] = UIBackpack.currentSelectItemId[uid]
                        end
                    end
                end
            end

        else
            if PlayerBackpack[uid]['dressed'][itemType] == nil then
                PlayerBackpack[uid]['dressed'][itemType] = UIBackpack.currentSelectItemId[uid]

                table.remove(PlayerBackpack[uid]['undressed'][itemType], currentSelectItemIdx)
            else
                table.remove(PlayerBackpack[uid]['undressed'][itemType], currentSelectItemIdx)
                table.insert(PlayerBackpack[uid]['undressed'][itemType], PlayerBackpack[uid]['dressed'][itemType])
                PlayerBackpack[uid]['dressed'][itemType] = UIBackpack.currentSelectItemId[uid]
            end
        end

        UIBackpack.handleShowAllLeftCell(uid)
        UIBackpack.handleShowAllRightCell(uid, itemType)
        UIBackpack.handleHideDetailPanel(uid)
        PlayerBackpack.calculateAttr(uid)
        UIBackpack.handlePaginationText(uid)
        PlayerBackpack.changWeaponSkin(uid)
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.ok then -- 使用道具
        PlayerBackpack.useItem(uid, UIBackpack.currentSelectItemId[uid])
    end
end

--- 处理快捷栏物品切换
---@param uid number
---@---@param uielement string
function UIBackpack.handleChangeKuaijielan(uid, uielement)

    local handleService = function(idx)
        local iteminfo = ALL_BACKPACK_ITEMS[UIBackpack.currentSelectItemId[uid]]
        local _, temp_index =
            Valuegroup:getGroupNoByValue(21, "道具类型组", UIBackpack.currentSelectItemId[uid], 0)
        local _, temp_iconid = Valuegroup:getValueNoByName(18, "道具图片组", temp_index, 0)

        Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN,
            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. idx][1], 100)
        Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN,
            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. idx][2], 100)
        Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN,
            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. idx][1], temp_iconid)

        local findItemNum = function(itemid)
            for findI, findArr in ipairs(PlayerBackpack[uid].items) do
                if findArr[1] == itemid then
                    return findArr[2]
                end
            end
        end

        Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN,
            UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian["no" .. idx][2],
            "" .. findItemNum(UIBackpack.currentSelectItemId[uid]))

        Valuegroup:setValueNoByName(21, "快捷键道具组", idx, UIBackpack.currentSelectItemId[uid], uid)
        UIBackpack.handleMainKuaijiejian(uid)
        print("UIBackpack.handleChangeKuaijielan 设置快捷栏", idx, UIBackpack.currentSelectItemId[uid])
    end

    if uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian.no1[1] then
        handleService(1)
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian.no2[1] then
        handleService(2)
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian.no3[1] then
        handleService(3)
    elseif uielement == UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.kuaijiejian.no4[1] then
        handleService(4)
    end
end

--- 打开背包事件
---@param event any {eventobjid,CustomUI}
function UIBackpack.handleShowMain(event)
    if event.CustomUI == UIBackpack.ELEMENT_ID.MAIN then

        if UIBackpack.currentSelectMenuType[event.eventobjid] == nil then
            UIBackpack.currentSelectMenuType[event.eventobjid] = 'weapon'
        end

        UIBackpack.handleHideDetailPanel(event.eventobjid)
        UIBackpack.handleShowAllLeftCell(event.eventobjid)
        UIBackpack.handleShowAllRightCell(event.eventobjid, UIBackpack.currentSelectMenuType[event.eventobjid])
        UIBackpack.handlePaginationText(event.eventobjid)
    end
end

--- 隐藏所有面板
---@param uid number 玩家迷你号
function UIBackpack.handleHideDetailPanel(uid)
    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.tran)
    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.left.panel)
    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.panel)
    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.right.tran)
    Customui:hideElement(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.DETAIL_PANEL.items.panel)
end

--- 处理分页文本显示
---@param uid number 玩家迷你号
function UIBackpack.handlePaginationText(uid)
    local _, bpLimit = VarLib2:getPlayerVarByName(uid, 3, "背包容量")
    local currentBPNum = #PlayerBackpack[uid]['undressed']['weapon'] + #PlayerBackpack[uid]['undressed']['hat'] +
                             #PlayerBackpack[uid]['undressed']['clothes'] + #PlayerBackpack[uid]['undressed']['shoes'] +
                             #PlayerBackpack[uid]['undressed']['ring'] + #PlayerBackpack[uid]['undressed']['bracelet'] +
                             #PlayerBackpack[uid]['undressed']['shield'] + #PlayerBackpack[uid]['items']

    Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN, UIBackpack.ELEMENT_ID.FEN_YE.TEXT,
        "物品:" .. currentBPNum .. "/" .. bpLimit)

    print("UIBackpack.handlePaginationText 开始处理分页" .. currentBPNum .. "/" .. bpLimit)
end

--- 处理分页文本显示
---@param uid number 玩家迷你号
---@---@param uielement string
function UIBackpack.handlePaginationLogic(uid, ui)
    if ui == UIBackpack.ELEMENT_ID.FEN_YE.NEXT then
        if UIBackpack.page[uid].current < UIBackpack.page[uid].total then
            UIBackpack.page[uid]['current'] = UIBackpack.page[uid]['current'] + 1
            UIBackpack.handleShowAllRightCell(uid, UIBackpack.currentSelectMenuType[uid])
        end
    elseif ui == UIBackpack.ELEMENT_ID.FEN_YE.PREV then
        if UIBackpack.page[uid]['current'] > 1 then
            UIBackpack.page[uid]['current'] = UIBackpack.page[uid]['current'] - 1
            UIBackpack.handleShowAllRightCell(uid, UIBackpack.currentSelectMenuType[uid])
        end
    end
end

--- 处理整理按钮
---@param uid number
---@param uielement string
function UIBackpack.handleSortCells(uid, uielement)
    if uielement ~= UIBackpack.ELEMENT_ID.SORT_BTN then
        return
    end

    local menuType = UIBackpack.currentSelectMenuType[uid]

    if menuType ~= 'items' then
        table.sort(PlayerBackpack[uid]['undressed'][menuType], function(a, b)
            local itemA = ALL_BACKPACK_ITEMS[a]
            local itemB = ALL_BACKPACK_ITEMS[b]
            if itemA.quality == itemB.quality then
                return itemA.lv > itemB.lv
            else
                return findIndex(QUALITY_ENUM, itemA.quality) > findIndex(QUALITY_ENUM, itemB.quality)
            end
        end)

    else
        table.sort(PlayerBackpack[uid]['items'], function(a, b)
            local itemA = ALL_BACKPACK_ITEMS[a[1]]
            local itemB = ALL_BACKPACK_ITEMS[b[1]]
            if itemA.quality == itemB.quality then
                return itemA.lv > itemB.lv
            else
                return findIndex(QUALITY_ENUM, itemA.quality) > findIndex(QUALITY_ENUM, itemB.quality)
            end
        end)
    end

    UIBackpack.handleShowAllRightCell(uid, menuType)
end

--- 处理主界面快捷栏
---@param uid number
function UIBackpack.handleMainKuaijiejian(uid)
    print("UIBackpack.handleMainKuaijiejian 处理主界面快捷栏")
    -- 快捷栏变量
    local _, kuaijielan_1 = Valuegroup:getValueNoByName(21, "快捷键道具组", 1, uid)
    local _, kuaijielan_2 = Valuegroup:getValueNoByName(21, "快捷键道具组", 2, uid)
    local _, kuaijielan_3 = Valuegroup:getValueNoByName(21, "快捷键道具组", 3, uid)
    local _, kuaijielan_4 = Valuegroup:getValueNoByName(21, "快捷键道具组", 4, uid)
    local valuegroupkuaijielans = {kuaijielan_1, kuaijielan_2, kuaijielan_3, kuaijielan_4}
    print(valuegroupkuaijielans)
    for i, v in ipairs(valuegroupkuaijielans) do
        print(i, v)
        if v == 101 then
            Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN_UI, UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN["no" .. i][1],
                0)
            Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN_UI, UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN["no" .. i][2],
                0)

        else
            local _, temp_index = Valuegroup:getGroupNoByValue(21, "道具类型组", v, 0)
            local _, temp_iconid = Valuegroup:getValueNoByName(18, "道具图片组", temp_index, 0)

            Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN_UI, UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN["no" .. i][1],
                100)
            Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN_UI, UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN["no" .. i][2],
                100)
            Customui:setTexture(uid, UIBackpack.ELEMENT_ID.MAIN_UI,
                UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN["no" .. i][1], temp_iconid)

            local findItemNum = function(itemid)
                for findI, findArr in ipairs(PlayerBackpack[uid].items) do
                    if findArr[1] == itemid then
                        return findArr[2]
                    end
                end
            end

            Customui:setText(uid, UIBackpack.ELEMENT_ID.MAIN_UI, UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN["no" .. i][2],
                "" .. findItemNum(v))
        end
    end
end

--- 处理回收窗口所有事件
---@param uid number
---@param uielement string
function UIBackpack.handleHuishouUI(uid, uielement)
    for type, arr in pairs(UIBackpack.ELEMENT_ID.HUISHOU_UI.btn) do
        if arr[1] == uielement then
            if UIBackpack.cureentSelectHuishouTypes[uid] == nil then
                UIBackpack.cureentSelectHuishouTypes[uid] = {
                    ["普通"] = false,
                    ["精良"] = false,
                    ["完美"] = false,
                    ["史诗"] = false,
                    ["传说"] = false
                }
            end

            if UIBackpack.cureentSelectHuishouTypes[uid][type] then
                Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN, arr[2], 0)
                UIBackpack.cureentSelectHuishouTypes[uid][type] = false
            else
                Customui:setAlpha(uid, UIBackpack.ELEMENT_ID.MAIN, arr[2], 100)
                UIBackpack.cureentSelectHuishouTypes[uid][type] = true
            end

            print(UIBackpack.cureentSelectHuishouTypes[uid])
        end
    end

    if uielement == UIBackpack.ELEMENT_ID.HUISHOU_UI.ok then
        local code = Actor:hasBuff(uid, 50000012)
        if code == 0 then
            return
        end

        Actor:addBuff(uid, 50000012, 1, 7)

        local tempArr = {}

        for idx, itemId in ipairs(PlayerBackpack[uid].undressed[UIBackpack.currentSelectMenuType[uid]]) do
            local iteminfo = ALL_BACKPACK_ITEMS[itemId]
            if UIBackpack.cureentSelectHuishouTypes[uid][iteminfo.quality] == true then
                print("UIBackpack.handleHuishouUI 待回收添加", itemId, iteminfo.quality)
                table.insert(tempArr, itemId)
            end
        end

        print("UIBackpack.handleHuishouUI 待回收", tempArr)

        for i, tempId in ipairs(tempArr) do
            UIBackpack.handleObjectHuishou(uid, tempId)
            print("UIBackpack.handleHuishouUI 已处理回收", tempId)
        end

        UIBackpack.handleShowAllRightCell(uid, UIBackpack.currentSelectMenuType[uid])

        UIBackpack.handlePaginationText(uid)
    end
end

--- 处理强化槽
---@param uid number
---@param uielement string
function UIBackpack.handleQianghuaOK(uid, uielement)
    local code = Actor:hasBuff(uid, 50000012)
    if code == 0 then
        return
    end

    Actor:addBuff(uid, 50000012, 1, 7)

    if uielement ~= UIBackpack.ELEMENT_ID.QIANGHUA_OK then
        return
    end
    local _, index = Valuegroup:getValueNoByName(17, "ui翻页组", 4, uid)
    local _, lv = Valuegroup:getValueNoByName(17, "装备槽强化等级", index, uid)
    local _, tupocount = Valuegroup:getValueNoByName(17, "装备槽突破次数", index, uid)

    if lv ~= tupocount * 10 then
        return
    end

    local map = {
        [4148] = 1 * lv,
        [4149] = 0.5 * lv,
        [4150] = 0.1 * lv,
        [4151] = math.floor(0.04 * lv),
        [4152] = math.floor(0.02 * lv),
        [4153] = math.floor(0.01 * lv),
        [4154] = math.floor(0.005 * lv)
    }

    for itemid, needNum in pairs(map) do
        if needNum ~= 0 then
            local iteminfo = ALL_BACKPACK_ITEMS[itemid]

            local isExist = false

            for _, itemArr in ipairs(PlayerBackpack[uid].items) do
                if itemArr[1] == itemid then
                    isExist = true

                    if itemArr[2] < needNum then
                        Player:notifyGameInfo2Self(uid, "突破石材料不足")
                        return
                    end
                end
            end

            if isExist == false then
                Player:notifyGameInfo2Self(uid, "突破石材料不足")
                return
            end
        end
    end

    for itemid, needNum in pairs(map) do
        if needNum ~= 0 then
            for i, itemArr in ipairs(PlayerBackpack[uid].items) do
                if itemArr[1] == itemid then

                    itemArr[2] = itemArr[2] - needNum

                    if itemArr[2] == 0 then
                        PlayerBackpack[uid].items[i] = "空空如也"

                    end
                end
            end
        end
    end

    local newArray = {}
    for i, itemArr in ipairs(PlayerBackpack[uid].items) do
        if itemArr ~= "空空如也" then
            table.insert(newArray, itemArr)
        end
    end

    PlayerBackpack[uid].items = newArray

    Valuegroup:setValueNoByName(17, "装备槽突破次数", index, tupocount + 1, uid)
    Player:notifyGameInfo2Self(uid, "突破成功")

    UIBackpack.handleShowAllRightCell(uid, UIBackpack.currentSelectMenuType[uid])
    PlayerBackpack.calculateAttr(uid)

end
