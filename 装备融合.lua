RH_TABLE = {
    [4395] = {
        bp = {4381, 4386, 4391},
        item = {4154, 1},
        qianbi = 100 * 10000
    }
}

RH_ELEMENT = {
    MAIN = "7371543639298087136",
    RH_NAME = "7371543639298087136_53",
    RH_ICON = "7371543639298087136_48",
    ITEMS = {{
        NAME = "7371543639298087136_21",
        ICON = "7371543639298087136_41",
        STS = "7371543639298087136_38"
    }, {
        NAME = "7371543639298087136_22",
        ICON = "7371543639298087136_42",
        STS = "7371543639298087136_39"
    }, {
        NAME = "7371543639298087136_23",
        ICON = "7371543639298087136_43",
        STS = "7371543639298087136_40"
    }, {
        NAME = "7371543639298087136_52",
        ICON = "7371543639298087136_50",
        STS = "7371543639298087136_51"
    }},
    TUPOSHI = {
        ICON = "7371543639298087136_54",
        NUM = "7371543639298087136_55"
    },
    QIANBI_TEXT = "7371543639298087136_205",
    QIANBI_ICON = "7371543639298087136_204",
    USE_BTN = "7371543639298087136_44",
    SHOW_PANEL_BTN = "7371543639298087136_142",
    PANEL = {
        panel = "7371543639298087136_85",
        tran = "7371543639298087136_112",
        panel_title = "7371543639298087136_87",
        panel_bg = "7371543639298087136_86",
        icon_bg = "7371543639298087136_88",
        icon = "7371543639298087136_89",
        type = "7371543639298087136_90",
        pinzhi = "7371543639298087136_91",
        lv = "7371543639298087136_92",
        gonjili = "7371543639298087136_96",
        hp = "7371543639298087136_98",
        other_attr = {{"7371543639298087136_101", "7371543639298087136_102"},
                      {"7371543639298087136_103", "7371543639298087136_104"},
                      {"7371543639298087136_105", "7371543639298087136_106"}},
        other_effect = "7371543639298087136_107"
    }
}

local function checkItemExist(uid, itemid)
    for _, itemArr in pairs(PlayerBackpack[uid].undressed) do
        for i, itemArr2 in ipairs(itemArr) do
            if itemArr2 == itemid then
                return true
            end
        end
    end

    return false
end

function showRHUI(event)
    local uid = event.eventobjid
    if event.CustomUI ~= RH_ELEMENT.MAIN then
        return
    end

    for i, uiArr in ipairs(RH_ELEMENT.ITEMS) do
        Customui:hideElement(uid, RH_ELEMENT.MAIN, uiArr.NAME)
        Customui:hideElement(uid, RH_ELEMENT.MAIN, uiArr.ICON)
        Customui:hideElement(uid, RH_ELEMENT.MAIN, uiArr.STS)
    end
    Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.QIANBI_ICON)
    Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.QIANBI_TEXT)
    Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.TUPOSHI.ICON)
    Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.TUPOSHI.NUM)
    Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.RH_ICON)
    Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.RH_NAME)
    Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.USE_BTN)
    Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.SHOW_PANEL_BTN)
end
ScriptSupportEvent:registerEvent('UI.Show', showRHUI)

function handleRhUIShow(event)
    local uid = event.eventobjid
    if event.buffid ~= 50000037 then
        return
    end

    local _, itemid = VarLib2:getPlayerVarByName(uid, 9, "融合装备类型")

    Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.RH_NAME, ALL_BACKPACK_ITEMS[itemid].name)
    local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", itemid, 0)
    local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

    print(itemid, index, iconid)
    Customui:setTexture(uid, RH_ELEMENT.MAIN, RH_ELEMENT.RH_ICON, iconid)
    Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.RH_ICON)
    Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.RH_ICON)
    Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.RH_NAME)

    for i, uiArr in ipairs(RH_ELEMENT.ITEMS) do
        if RH_TABLE[itemid].bp[i] ~= nil then
            Customui:setText(uid, RH_ELEMENT.MAIN, uiArr.NAME, ALL_BACKPACK_ITEMS[RH_TABLE[itemid].bp[i]].name)
            local _, bpidx = Valuegroup:getGroupNoByValue(21, "道具类型组", bpid, 0)
            local _, bpiconid = Valuegroup:getValueNoByName(18, "道具图片组", bpidx, 0)
            Customui:setTexture(uid, RH_ELEMENT.MAIN, uiArr.ICON, bpiconid)

            local isExist = checkItemExist(uid, RH_TABLE[itemid].bp[i])
            if isExist then
                Customui:setText(uid, RH_ELEMENT.MAIN, uiArr.STS, "已拥有")
            else
                Customui:setText(uid, RH_ELEMENT.MAIN, uiArr.STS, "未拥有")
            end

            Customui:showElement(uid, RH_ELEMENT.MAIN, uiArr.NAME)
            Customui:showElement(uid, RH_ELEMENT.MAIN, uiArr.ICON)
            Customui:showElement(uid, RH_ELEMENT.MAIN, uiArr.STS)
        else
            Customui:hideElement(uid, RH_ELEMENT.MAIN, uiArr.NAME)
            Customui:hideElement(uid, RH_ELEMENT.MAIN, uiArr.ICON)
            Customui:hideElement(uid, RH_ELEMENT.MAIN, uiArr.STS)
        end
    end

    if RH_TABLE[itemid].qianbi ~= nil then
        Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.QIANBI_TEXT, formatNumber(RH_TABLE[itemid].qianbi))

        local _, bpidx = Valuegroup:getGroupNoByValue(21, "道具类型组", RH_TABLE[itemid].item[1], 0)
        local _, bpiconid = Valuegroup:getValueNoByName(18, "道具图片组", bpidx, 0)
        Customui:setTexture(uid, RH_ELEMENT.MAIN, RH_ELEMENT.TUPOSHI.ICON, bpiconid)

        Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.QIANBI_ICON)
        Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.QIANBI_TEXT)
    else
        Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.QIANBI_ICON)
        Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.QIANBI_TEXT)
    end

    if RH_TABLE[itemid].item ~= nil then

        Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.TUPOSHI.NUM, "×" + RH_TABLE[itemid].item[2])

        Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.TUPOSHI.ICON)
        Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.TUPOSHI.NUM)
    else
        Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.TUPOSHI.ICON)
        Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.TUPOSHI.NUM)
    end

    Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.USE_BTN)
    Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.SHOW_PANEL_BTN)

end
ScriptSupportEvent:registerEvent('Player.AddBuff', handleRhUIShow)

function handle_rh_btn(event)
    local uid = event.eventobjid
    local uielement = event.uielement
    if event.uielement ~= RH_ELEMENT.USE_BTN then
        return
    end

    local code = Actor:hasBuff(uid, 50000012)
    if code == 0 then
        Player:notifyGameInfo2Self(uid, "融合CD中")
        return
    end

    Actor:addBuff(uid, 50000012, 1, 7)


    local _, itemid = VarLib2:getPlayerVarByName(uid, 9, "融合装备类型")

    for i, needItemId in ipairs(RH_TABLE[itemid].bp) do
        if checkItemExist(uid, needItemId) == false then
            Player:notifyGameInfo2Self(uid, "你还没有" + ALL_BACKPACK_ITEMS[needItemId].name)
            return
        end
    end

    local _, qianbi = VarLib2:getPlayerVarByName(uid, 3, "钱币")

    if qianbi < RH_TABLE[itemid].qianbi then
        Player:notifyGameInfo2Self(uid, "你的钱币不足")
        return
    end

    local checkUseItemExist = false
    for i, itemArr in ipairs(PlayerBackpack[uid].items) do
        if itemArr[1] == RH_TABLE[itemid].item[1] then
            checkUseItemExist = true
            if itemArr[2] < RH_TABLE[itemid].item[2] then
                Player:notifyGameInfo2Self(uid, "你的突破石数量不足")
                return
            end
        end
    end

    if checkUseItemExist == false then
        Player:notifyGameInfo2Self(uid, "你的突破石数量不足")
        return
    end

    for i, itemArr in ipairs(PlayerBackpack[uid].items) do
        if itemArr[1] == RH_TABLE[itemid].item[1] then
            if itemArr[2] == 1 then
                table.remove(PlayerBackpack[uid].items, i)
            else
                itemArr[2] = itemArr[2] - 1
            end
        end
    end

    for i, needItemId in ipairs(RH_TABLE[itemid].bp) do
        removeItemFromPlayerBP(uid, needItemId)
    end

    VarLib2:setPlayerVarByName(uid, 3, "钱币", qianbi - RH_TABLE[itemid].qianbi)

    table.insert(PlayerBackpack[uid]['undressed'][ITEM_TYPE_ENUMS[ALL_BACKPACK_ITEMS[itemid].type]], itemid)
    Player:notifyGameInfo2Self(uid, "融合成功")


end
ScriptSupportEvent:registerEvent('UI.Button.Click', handle_rh_btn)

function removeItemFromPlayerBP(uid, itemid)
    for type, itemArr in pairs(PlayerBackpack[uid].undressed) do
        for i, itemArr2 in ipairs(itemArr) do
            if itemArr2 == itemid then
                table.remove(PlayerBackpack[uid]['undressed'][type], i)
                return
            end
        end
    end
end

function formatNumber(num)
    if num >= 10000 then
        return tostring(math.floor(num / 10000)) .. "万"
    else
        return tostring(num)
    end
end

local function handle_RH_PANEL_SHOW(event)
    local uid = event.eventobjid
    local uielement = event.uielement

    if uielement == RH_ELEMENT.SHOW_PANEL_BTN then
        local _, itemid = VarLib2:getPlayerVarByName(uid, 9, "融合装备类型")
        local iteminfo = ALL_BACKPACK_ITEMS[itemid]
        local isBaifengbiNums = {50004, 50005, 50004, 50006, 50008, 50009, 50010, 50011, 50012, 50013, 50014}
        if (iteminfo.type == "材料" or iteminfo.type == "消耗品") == false then -- 显示装备面板
            Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.panel)
            Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.tran)

            Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.panel_title, iteminfo.name)
            Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.type, "类型: " .. iteminfo.type)
            Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.pinzhi, "品质: " .. iteminfo.quality)
            Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.lv, "等级: " .. iteminfo.lv)
            Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.gonjili, "+" .. iteminfo.atk)
            Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.hp, "+" .. iteminfo.hp)
            Customui:setTexture(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.panel_bg,
                UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][2])
            Customui:setTexture(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.icon_bg,
                UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][1])

            local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", itemid, 0)
            local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

            Customui:setTexture(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.icon, iconid)

            for i, v in ipairs(RH_ELEMENT.PANEL.other_attr) do
                print("i", i, v[1], v[2])
                if iteminfo.otherAttr ~= nil then
                    if iteminfo.otherAttr[i] ~= nil then
                        if isInArray(isBaifengbiNums, iteminfo.otherAttr[i][1]) then
                            Customui:setText(uid, RH_ELEMENT.MAIN, v[1], ITEMS_OTHER_ATTRS[iteminfo.otherAttr[i][1]])
                            Customui:setText(uid, RH_ELEMENT.MAIN, v[2], tostring(iteminfo.otherAttr[i][2] * 100) .. "%")
                        else
                            Customui:setText(uid, RH_ELEMENT.MAIN, v[1], ITEMS_OTHER_ATTRS[iteminfo.otherAttr[i][1]])
                            Customui:setText(uid, RH_ELEMENT.MAIN, v[2], iteminfo.otherAttr[i][2])
                        end

                    else
                        Customui:setText(uid, RH_ELEMENT.MAIN, v[1], "")
                        Customui:setText(uid, RH_ELEMENT.MAIN, v[2], "")
                    end
                    Customui:showElement(uid, RH_ELEMENT.MAIN, v[1])
                    Customui:showElement(uid, RH_ELEMENT.MAIN, v[2])
                else
                    Customui:hideElement(uid, RH_ELEMENT.MAIN, v[1])
                    Customui:hideElement(uid, RH_ELEMENT.MAIN, v[2])
                end
            end

            if iteminfo.otherEffect ~= nil then
                Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.other_effect,
                    string.gsub(ITEMS_OTHER_ATTRS[iteminfo.otherEffect[1]], 'XX', iteminfo.otherEffect[2]))
            else
                Customui:setText(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.other_effect, "")
            end
            Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.panel)
            Customui:showElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.tran)
        end
    elseif uielement == RH_ELEMENT.PANEL.tran then
        Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.panel)
        Customui:hideElement(uid, RH_ELEMENT.MAIN, RH_ELEMENT.PANEL.tran)
    end

end

ScriptSupportEvent:registerEvent('UI.Button.Click', handle_RH_PANEL_SHOW)

