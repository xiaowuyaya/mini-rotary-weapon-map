TUJIAN_ELEMENT = {
    main = "7361533878712342752",
    tran = "7361533878712342752_232",
    right = {
        panel = "7361533878712342752_202",
        icon_bg = "7361533878712342752_205",
        icon = "7361533878712342752_206",
        panel_title = "7361533878712342752_204",
        panel_bg = "7361533878712342752_203",
        type = "7361533878712342752_207",
        pinzhi = "7361533878712342752_208",
        lv = "7361533878712342752_209",
        gonjili = "7361533878712342752_213",
        hp = "7361533878712342752_215",
        other_attr = {{"7361533878712342752_222", "7361533878712342752_223"}, -- 附加属性 { 文本， 数值 }
        {"7361533878712342752_224", "7361533878712342752_225"}, {"7361533878712342752_226", "7361533878712342752_227"}},
        other_effect = "7361533878712342752_228" -- 附加效果

    },
    items = {
        panel = "7361533878712342752_254", -- 总面板
        panel_title = "7361533878712342752_256", -- 标题
        panel_bg = "7361533878712342752_255", -- 面板品质背景
        icon_bg = "7361533878712342752_257", -- 图标背景
        icon = "7361533878712342752_258", -- 图标
        type = "7361533878712342752_259", -- 类型
        pinzhi = "7361533878712342752_260", -- 品质
        lv = "7361533878712342752_261", -- 等级
        desc = "7361533878712342752_266" -- 描述
    }
}

function handle_player_add_buff(event)
    local buffid = event.buffid
    local uid = event.eventobjid

    if buffid ~= 50000015 then
        return
    end

    local _, itemid = VarLib2:getPlayerVarByName(uid, 9, "图鉴点击类型")
    print("itemid", itemid)
    local iteminfo = ALL_BACKPACK_ITEMS[itemid]
    local isBaifengbiNums = {50004, 50005, 50004, 50006, 50008, 50009, 50010, 50011, 50012, 50013, 50014}
    if (iteminfo.type == "材料" or iteminfo.type == "消耗品") == false then -- 显示装备面板
        Customui:showElement(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.panel)
        Customui:showElement(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.tran)

        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.panel_title, iteminfo.name)
        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.type, "类型: " .. iteminfo.type)
        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.pinzhi, "品质: " .. iteminfo.quality)
        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.lv, "等级: " .. iteminfo.lv)
        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.gonjili, "+" .. iteminfo.atk)
        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.hp, "+" .. iteminfo.hp)
        Customui:setTexture(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.panel_bg,
            UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][2])
        Customui:setTexture(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.icon_bg,
            UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][1])

        local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", itemid, 0)
        local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

        Customui:setTexture(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.icon, iconid)

        for i, v in ipairs(TUJIAN_ELEMENT.right.other_attr) do
            print("i", i, v[1], v[2])
            if iteminfo.otherAttr ~= nil then
                if iteminfo.otherAttr[i] ~= nil then
                    if isInArray(isBaifengbiNums, iteminfo.otherAttr[i][1]) then
                        Customui:setText(uid, TUJIAN_ELEMENT.main, v[1], ITEMS_OTHER_ATTRS[iteminfo.otherAttr[i][1]])
                        Customui:setText(uid, TUJIAN_ELEMENT.main, v[2], tostring(iteminfo.otherAttr[i][2] * 100) .. "%")
                    else
                        Customui:setText(uid, TUJIAN_ELEMENT.main, v[1], ITEMS_OTHER_ATTRS[iteminfo.otherAttr[i][1]])
                        Customui:setText(uid, TUJIAN_ELEMENT.main, v[2], iteminfo.otherAttr[i][2])
                    end

                else
                    Customui:setText(uid, TUJIAN_ELEMENT.main, v[1], "")
                    Customui:setText(uid, TUJIAN_ELEMENT.main, v[2], "")
                end
                Customui:showElement(uid, TUJIAN_ELEMENT.main, v[1])
                Customui:showElement(uid, TUJIAN_ELEMENT.main, v[2])
            else
                Customui:hideElement(uid, TUJIAN_ELEMENT.main, v[1])
                Customui:hideElement(uid, TUJIAN_ELEMENT.main, v[2])
            end
        end

        if iteminfo.otherEffect ~= nil then
            Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.other_effect,
                ITEMS_OTHER_ATTRS[iteminfo.otherEffect[1]])
        else
            Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.other_effect, "")
        end

    else -- 显示道具面板
        Customui:showElement(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.panel)
        Customui:showElement(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.tran)

        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.panel_title, iteminfo.name)
        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.type, "类型: " .. iteminfo.type)
        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.pinzhi, "品质: " .. iteminfo.quality)
        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.lv, "等级: " .. iteminfo.lv)

        Customui:setText(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.desc, iteminfo.desc)

        Customui:setTexture(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.panel_bg,
            UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][2])
        Customui:setTexture(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.icon_bg,
            UIBackpack.ELEMENT_ID.QUALITY_BG[iteminfo['quality']][1])

        local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", itemid, 0)
        local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

        Customui:setTexture(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.icon, iconid)

    end
end
ScriptSupportEvent:registerEvent('Player.AddBuff', handle_player_add_buff)

function handle_backpack_ui_click(event)
    local uid = event.eventobjid
    local uielement = event.uielement
    if uielement == TUJIAN_ELEMENT.tran then
        Customui:hideElement(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.right.panel)
        Customui:hideElement(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.items.panel)
        Customui:hideElement(uid, TUJIAN_ELEMENT.main, TUJIAN_ELEMENT.tran)
    end
end
ScriptSupportEvent:registerEvent('UI.Button.Click', handle_backpack_ui_click)

