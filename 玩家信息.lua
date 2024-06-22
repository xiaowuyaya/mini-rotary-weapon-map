local PLAYER_INFO_ELEMENT_ID = {
    MAIN = "7360282986667251936",
    -- 帽子
    INFO = {
        ["7360282986667251936_326"] = {
            type = 'hat',
            index = 3,
            bg = "7360282986667251936_326",
            icon = "7360282986667251936_328",
            lv = '7360282986667251936_331',
            text = "7360282986667251936_327"
        },
        -- 衣服
        ["7360282986667251936_320"] = {
            type = 'clothes',
            index = 2,
            bg = "7360282986667251936_320",
            icon = "7360282986667251936_322",
            lv = '7360282986667251936_325',
            text = "7360282986667251936_321"
        },
        -- 鞋子
        ["7360282986667251936_332"] = {
            type = 'shoes',
            index = 1,
            bg = "7360282986667251936_332",
            icon = "7360282986667251936_334",
            lv = '7360282986667251936_337',
            text = "7360282986667251936_333"
        },
        -- 武器槽1
        ["7360282986667251936_314"] = {
            type = 'weapon1',
            index = 4,
            bg = "7360282986667251936_314",
            icon = "7360282986667251936_316",
            lv = '7360282986667251936_319',
            text = "7360282986667251936_315"
        },
        -- 武器槽2
        ["7360282986667251936_338"] = {
            type = 'weapon2',
            index = 5,
            bg = "7360282986667251936_338",
            icon = "7360282986667251936_340",
            lv = '7360282986667251936_343',
            text = "7360282986667251936_339"
        },
        -- 武器槽3
        ["7360282986667251936_344"] = {
            type = 'weapon3',
            index = 6,
            bg = "7360282986667251936_344",
            icon = "7360282986667251936_346",
            lv = '7360282986667251936_349',
            text = "7360282986667251936_345"
        },
        -- 武器槽4
        ["7360282986667251936_350"] = {
            type = 'weapon4',
            index = 7,
            bg = "7360282986667251936_350",
            icon = "7360282986667251936_352",
            lv = '7360282986667251936_355',
            text = "7360282986667251936_351"
        },
        -- 戒指
        ["7360282986667251936_362"] = {
            type = 'ring',
            index = 8,
            bg = "7360282986667251936_362",
            icon = "7360282986667251936_364",
            lv = '7360282986667251936_367',
            text = "7360282986667251936_363"
        },
        -- 护腕
        ["7360282986667251936_356"] = {
            type = 'bracelet',
            index = 9,
            bg = "7360282986667251936_356",
            icon = "7360282986667251936_358",
            lv = '7360282986667251936_361',
            text = "7360282986667251936_357"
        },
        -- 盾牌
        ["7360282986667251936_368"] = {
            type = 'shield',
            index = 10,
            bg = "7360282986667251936_368",
            icon = "7360282986667251936_370",
            lv = '7360282986667251936_373',
            text = "7360282986667251936_369"
        }
    },
    PANEL = {
        panel = "7360282986667251936_408",
        tran = "7360282986667251936_407",
        panel_title = "7360282986667251936_410",
        panel_bg = "7360282986667251936_409",
        icon_bg = "7360282986667251936_411",
        icon = "7360282986667251936_412",
        type = "7360282986667251936_413",
        pinzhi = "7360282986667251936_414",
        lv = "7360282986667251936_415",
        gonjili = "7360282986667251936_419",
        hp = "7360282986667251936_423",
        qianghua1 = "7360282986667251936_421",
        qianghua2 = "7360282986667251936_425",
        other_attr = {{"7360282986667251936_430", "7360282986667251936_431"},
                      {"7360282986667251936_432", "7360282986667251936_433"},
                      {"7360282986667251936_434", "7360282986667251936_435"}},
        other_effect = "7360282986667251936_436"
    },
    QUALITY_BG = {
        ["普通"] = {"8_1118247136_1704453713", "8_1118247136_1710515583"},
        ["精良"] = {"8_1118247136_1705398630", "8_1118247136_1705214792"},
        ["完美"] = {"8_1118247136_1705398618", "8_1118247136_1704451287"},
        ["史诗"] = {"8_1118247136_1705398641", "8_1118247136_1710515556"},
        ["传说"] = {"8_1118247136_1705398636", "8_1118247136_1710515564"},
        ["神话"] = {"8_1118247136_1705398647", "8_1118247136_1710515571"},
        ["至尊"] = {"8_1118247136_1705398625", "8_1118247136_1710515526"}
    }
}

function show_player_info_ui(event)
    local uid = event.eventobjid
    local uielementid = event.CustomUI

    if uielementid ~= PLAYER_INFO_ELEMENT_ID.MAIN then
        return
    end

    local _, tagetId = VarLib2:getPlayerVarByName(uid, 6, "点击玩家")
    print(tagetId)
    for uiid, uiItem in pairs(PLAYER_INFO_ELEMENT_ID.INFO) do
        local playerDressedItemId = PlayerBackpack[tagetId]['dressed'][uiItem.type]
        print(playerDressedItemId)
        if playerDressedItemId ~= nil then
            local itemInfo = ALL_BACKPACK_ITEMS[playerDressedItemId]
            local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", playerDressedItemId, 0)
            local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)

            Customui:setTexture(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem['icon'], iconid)
            Customui:setTexture(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem['bg'],
                PLAYER_INFO_ELEMENT_ID.QUALITY_BG[itemInfo.quality][1])
            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem["lv"], 'Lv' .. itemInfo['lv'])
            Customui:showElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem['icon'])

            Customui:hideElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem["text"])
        else
            -- Customui:hideElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem["addNumBg"])
            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem["lv"], '')
            Customui:hideElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem['icon'])
            Customui:setTexture(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem['bg'],
                PLAYER_INFO_ELEMENT_ID.QUALITY_BG["普通"][1])
            Customui:showElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, uiItem['text'])
        end
    end

end

ScriptSupportEvent:registerEvent('UI.Show', show_player_info_ui)

function handle_playerinfo_click(event)
    local isBaifengbiNums = {50004, 50005, 50004, 50006, 50008, 50009, 50010, 50011, 50012, 50013, 50014}
    local uid = event.eventobjid
    local uielement = event.uielement

    print(uielement)
    local _, tagetId = VarLib2:getPlayerVarByName(uid, 6, "点击玩家")

    if PLAYER_INFO_ELEMENT_ID.INFO[uielement] ~= nil then
        local selectType = PLAYER_INFO_ELEMENT_ID.INFO[uielement].type
        local currentSelectItemId = PlayerBackpack[tagetId]['dressed'][selectType]

        if currentSelectItemId ~= nil then
            local iteminfo = ALL_BACKPACK_ITEMS[currentSelectItemId]

            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.panel_title,
                iteminfo['name'])
            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.type,
                "类型: " .. iteminfo['type'])
            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.pinzhi,
                "品质: " .. iteminfo['quality'])
            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.lv,
                "等级: " .. iteminfo['lv'])
            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.gonjili,
                "+" .. iteminfo['atk'])
            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.hp,
                "+" .. iteminfo['hp'])

            local _, lv = Valuegroup:getValueNoByName(17, "装备槽强化等级",
                PLAYER_INFO_ELEMENT_ID.INFO[uielement].index, tagetId)
            
            local function calculateEnhancementPercentage(bfblevel)
                if bfblevel < 100 then
                    return bfblevel * 0.01
                elseif bfblevel < 200 then
                    return 1 + (bfblevel - 100) * 0.02
                elseif bfblevel < 300 then
                    return 3 + (bfblevel - 200) * 0.03
                else
                    return 6 + (bfblevel - 300) * 0.03
                end
            end

            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.qianghua1,
                "+" .. math.floor(iteminfo.atk *(calculateEnhancementPercentage(lv))))
            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.qianghua2,
                "+" .. math.floor(iteminfo.hp * (calculateEnhancementPercentage(lv))))

            Customui:setTexture(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.panel_bg,
                PLAYER_INFO_ELEMENT_ID.QUALITY_BG[iteminfo['quality']][2])
            Customui:setTexture(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.icon_bg,
                PLAYER_INFO_ELEMENT_ID.QUALITY_BG[iteminfo['quality']][1])

            local _, index = Valuegroup:getGroupNoByValue(21, "道具类型组", currentSelectItemId, 0)
            local _, iconid = Valuegroup:getValueNoByName(18, "道具图片组", index, 0)
            Customui:setTexture(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.icon, iconid)

            for i, v in ipairs(PLAYER_INFO_ELEMENT_ID.PANEL.other_attr) do
                if iteminfo['otherAttr'] ~= nil then
                    if iteminfo['otherAttr'][i] ~= nil then

                        if isInArray(isBaifengbiNums, iteminfo['otherAttr'][i][1]) then
                            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[1],
                                ITEMS_OTHER_ATTRS[iteminfo['otherAttr'][i][1]])
                            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[2],
                                tostring(iteminfo['otherAttr'][i][2] * 100) .. "%")
                        else
                            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[1],
                                ITEMS_OTHER_ATTRS[iteminfo['otherAttr'][i][1]])
                            Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[2], iteminfo['otherAttr'][i][2])
                        end

                    else
                        Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[1], "")
                        Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[2], "")
                    end
                    Customui:showElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[1])
                    Customui:showElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[2])
                else
                    Customui:hideElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[1])
                    Customui:hideElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, v[2])
                end
            end

            if iteminfo['otherEffect'] ~= nil then
                Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.other_effect,
                string.gsub(ITEMS_OTHER_ATTRS[iteminfo.otherEffect[1]], 'XX', iteminfo.otherEffect[2]))
                    
            else
                Customui:setText(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.other_effect,
                    "")
            end

            Customui:showElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.panel)
            Customui:showElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.tran)
        end

    
    end

    if uielement == PLAYER_INFO_ELEMENT_ID.PANEL.tran then
        Customui:hideElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.tran)
        Customui:hideElement(uid, PLAYER_INFO_ELEMENT_ID.MAIN, PLAYER_INFO_ELEMENT_ID.PANEL.panel)
    end

end
ScriptSupportEvent:registerEvent('UI.Button.Click', handle_playerinfo_click)
