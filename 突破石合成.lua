local ELEMENT_ID_TPHC = {
    MAIN = "7370307216997816544",
    TUPOUSHI_NUM = {"7370307216997816544_280", "7370307216997816544_282", "7370307216997816544_284",
                    "7370307216997816544_286", "7370307216997816544_288", "7370307216997816544_290",
                    "7370307216997816544_292"},
    BTN = {"7370307216997816544_189", "7370307216997816544_207", "7370307216997816544_223", "7370307216997816544_239",
           "7370307216997816544_255", "7370307216997816544_271"}
}

local tuposhi_ids = {4148, 4149, 4150, 4151, 4152, 4153, 4154}
local use_tps_num = {3, 3, 5, 5, 5, 5}
local use_qianbi_num = {100, 300, 1000, 5000, 20000, 100000}
local use_xianyu_num = {0, 0, 0, 50, 200, 1000}

function refresh_showtuposhihecheng_ui(uid)

    for idx, itemid in ipairs(tuposhi_ids) do
        local isOk = false
        for _, itemarr in pairs(PlayerBackpack[uid].items) do
            if itemarr[1] == itemid then
                isOk = true
                Customui:setText(uid, ELEMENT_ID_TPHC.MAIN, ELEMENT_ID_TPHC.TUPOUSHI_NUM[idx], tostring(itemarr[2]))
                break
            end
        end

        if isOk == false then
            Customui:setText(uid, ELEMENT_ID_TPHC.MAIN, ELEMENT_ID_TPHC.TUPOUSHI_NUM[idx], tostring(0))
        end
    end

    -- for _, itemArr in ipairs(PlayerBackpack[uid].items) do
    --     if isInArray(tuposhi_ids, itemArr[1]) then
    --         local idx = findIndex(tuposhi_ids, itemArr[1])
    --         Customui:setText(uid, ELEMENT_ID_TPHC.MAIN, ELEMENT_ID_TPHC.TUPOUSHI_NUM[idx], tostring(itemArr[2]))
    --     else
    --         local idx = findIndex(tuposhi_ids, itemArr[1])
    --         Customui:setText(uid, ELEMENT_ID_TPHC.MAIN, ELEMENT_ID_TPHC.TUPOUSHI_NUM[idx], tostring(0))
    --     end
    -- end
end

function show_showtuposhihecheng_ui(event)
    if event.CustomUI ~= ELEMENT_ID_TPHC.MAIN then
        return
    end

    local uid = event.eventobjid

    refresh_showtuposhihecheng_ui(uid)
end
ScriptSupportEvent:registerEvent('UI.Show', show_showtuposhihecheng_ui)

function show_showtuposhihecheng_ok_ui(event)
    local uid = event.eventobjid
    local uielementid = event.uielement

    local code = Actor:hasBuff(uid, 50000033)
    if code == 0 then
                        Player:notifyGameInfo2Self(uid, "合成台冷却中")
        return
    end

    Actor:addBuff(uid, 50000033, 1, 120)

    if isInArray(ELEMENT_ID_TPHC.BTN, uielementid) ~= true then
        return
    end

    local idx = findIndex(ELEMENT_ID_TPHC.BTN, uielementid)

    local _, tpsInputArr = Valuegroup:getAllGroupItem(17, "突破石合成组", uid)

    local userSelectNum = tpsInputArr[idx]

    if userSelectNum < 1 then
        return
    end

    local _, xianyu = VarLib2:getPlayerVarByName(uid, 3, "仙玉")
        local _, xianyuxiaofei = VarLib2:getPlayerVarByName(uid, 3, "玩家消费")
    local _, qianbi = VarLib2:getPlayerVarByName(uid, 3, "钱币")

    local needAddItem = 0

    local use_item_exist = false

    for bp_idx, itemArr in ipairs(PlayerBackpack[uid].items) do
        if tuposhi_ids[idx] == itemArr[1] then
            if itemArr[2] < use_tps_num[idx] * userSelectNum then
                Player:notifyGameInfo2Self(uid, "突破石数量不足")
                return
            end

            if qianbi < use_qianbi_num[idx] * userSelectNum then
                Player:notifyGameInfo2Self(uid, "钱币数量不足")
                return
            end

            if xianyu < use_xianyu_num[idx] * userSelectNum then
                Player:notifyGameInfo2Self(uid, "仙玉数量不足")
                return
            end

            -- 移除道具数量
            if itemArr[2] - use_tps_num[idx] * userSelectNum == 0 then
                table.remove(PlayerBackpack[uid].items, bp_idx)
            else
                itemArr[2] = itemArr[2] - use_tps_num[idx] * userSelectNum
            end

            VarLib2:setPlayerVarByName(uid, 3, "仙玉", xianyu - use_xianyu_num[idx] * userSelectNum)
              VarLib2:setPlayerVarByName(uid, 3, "玩家消费", xianyuxiaofei + use_xianyu_num[idx] * userSelectNum)
            VarLib2:setPlayerVarByName(uid, 3, "钱币", qianbi - use_qianbi_num[idx] * userSelectNum)

            needAddItem = tuposhi_ids[idx + 1]
            
            use_item_exist = true
            break

        end
    end

    if use_item_exist == false then
        Player:notifyGameInfo2Self(uid, "突破石数量不足")
        return
    end

    local isExist = false

    for bp_idx, itemArr in ipairs(PlayerBackpack[uid].items) do
        if itemArr[1] == needAddItem then
            isExist = true
            itemArr[2] = itemArr[2] + userSelectNum
        end
    end

    if isExist == false then
        table.insert(PlayerBackpack[uid].items, {needAddItem, userSelectNum})
    end

    Player:notifyGameInfo2Self(uid, "合成成功")

    refresh_showtuposhihecheng_ui(uid)

end

ScriptSupportEvent:registerEvent('UI.Button.Click', show_showtuposhihecheng_ok_ui)
