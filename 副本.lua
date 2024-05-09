UI_ELEMENT_ID = {
    USE_NUM = "7365179786255603936_187",
    LEFT_OK = "7365179786255603936_175",
    LEFT_NUM = "7365179786255603936_177",
    RIGHT_OK = "7365179786255603936_183",
    RIGHT_NUM = "7365179786255603936_181",
    TIAOZHAN_COUNT = "7365179786255603936_57",
    SHOW_BTN = "7365179786255603936_58"
}

function handle_fuben_click(event)
    local uid = event.eventobjid
    local uielement = event.uielement

    local code = Actor:hasBuff(uid, 50000012)
    if code == 0 then
        return
    end

    Actor:addBuff(uid, 50000012, 1, 7)

    if uielement == UI_ELEMENT_ID.LEFT_OK then
        local _, idx = VarLib2:getPlayerVarByName(uid, 3, "选择的副本类型")
        local _, count = Valuegroup:getValueNoByName(17, "副本卷轴次数", idx, uid)

        if count <= 0 then
            Player:notifyGameInfo2Self(uid, "你今日的通用副本卷轴兑换次数已耗尽")
            return
        end

        local itemIdx = nil
        for i, playerItemsArr in pairs(PlayerBackpack[uid].items) do
            if playerItemsArr[1] == 4209 then
                itemIdx = i
            end
        end

        if itemIdx == nil then
            Player:notifyGameInfo2Self(uid, "你的通用副本卷轴数量不足")
            return
        end

        if PlayerBackpack[uid].items[itemIdx][2] == 0 then
            Player:notifyGameInfo2Self(uid, "你的通用副本卷轴数量不足")
            return
        end

        PlayerBackpack.useItem(uid, 4209)

        Valuegroup:setValueNoByName(17, "副本卷轴次数", idx, count - 1, uid)

        local _, fubencount = Valuegroup:getValueNoByName(17, "副本次数", idx, uid)
        Valuegroup:setValueNoByName(17, "副本次数", idx, fubencount + 1, uid)

        reload_fuben_num_ui(uid)

    elseif uielement == UI_ELEMENT_ID.RIGHT_OK then
        local _, idx = VarLib2:getPlayerVarByName(uid, 3, "选择的副本类型")
        local _, rightitemid = Valuegroup:getValueNoByName(21, "副本卷轴类型", idx, 0)

        local rightItemInfo = ALL_BACKPACK_ITEMS[rightitemid]

        local itemIdx = nil
        for i, playerItemsArr in pairs(PlayerBackpack[uid].items) do
            if playerItemsArr[1] == rightitemid then
                itemIdx = i
            end
        end

        if itemIdx == nil then
            Player:notifyGameInfo2Self(uid, "你的" + rightItemInfo.name + "数量不足")
            return
        end

        if PlayerBackpack[uid].items[itemIdx][2] == 0 then
            Player:notifyGameInfo2Self(uid, "你的" + rightItemInfo.name + "数量不足")
            return
        end

        PlayerBackpack.useItem(uid, rightitemid)

        local _, fubencount = Valuegroup:getValueNoByName(17, "副本次数", idx, uid)
        Valuegroup:setValueNoByName(17, "副本次数", idx, fubencount + 1, uid)

        reload_fuben_num_ui(uid)

    else
        if uielement == UI_ELEMENT_ID.SHOW_BTN then
            reload_fuben_num_ui(uid)
        end
    end

    Actor:addBuff(uid, 50000027, 1, 7)
end
ScriptSupportEvent:registerEvent('UI.Button.Click', handle_fuben_click)

function reload_fuben_num_ui(uid)
    local left_num = 0
    local right_num = 0

    local _, idx = VarLib2:getPlayerVarByName(uid, 3, "选择的副本类型")
    local _, rightitemid = Valuegroup:getValueNoByName(21, "副本卷轴类型", idx, 0)

    for i, itemarr in ipairs(PlayerBackpack[uid].items) do
        if itemarr[1] == 4209 then
            left_num = itemarr[2]
        end
    end

    for i, itemarr in ipairs(PlayerBackpack[uid].items) do
        if itemarr[1] == rightitemid then
            right_num = itemarr[2]
        end
    end

    Customui:setText(uid, "7365179786255603936", UI_ELEMENT_ID.LEFT_NUM, left_num + "")
    Customui:setText(uid, "7365179786255603936", UI_ELEMENT_ID.RIGHT_NUM, right_num + "")

end

