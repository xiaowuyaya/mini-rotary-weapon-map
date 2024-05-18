function handle_backpack_ui_click(event)
    local uid = event.eventobjid
    local uielement = event.uielement
    local tempArr = {UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN.no1[1], UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN.no2[1],
                     UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN.no3[1], UIBackpack.ELEMENT_ID.MAIN_KUAIJIEJIAN.no4[1]}
    for i, eleId in ipairs(tempArr) do
        if eleId == uielement then
            print('UIBackpack.handleUseMainKuaijiejian', eleId, uielement)
            local _, kuaijielan = Valuegroup:getValueNoByName(21, "快捷键道具组", i, uid)
            if kuaijielan ~= 101 then
                PlayerBackpack.useItem(uid, kuaijielan)
            end
        end
    end
end
ScriptSupportEvent:registerEvent('UI.Button.Click', handle_backpack_ui_click)

--- 回城重置武器
function refresh_player_weapon(event)
    local uid = event.eventobjid
    local uielement = event.uielement

    if uielement ~= '7346497485971855584_20' then
        return
    end

    local code = Actor:hasBuff(uid, 50000017)
    if code == 0 then
        return
    end
    
    Actor:addBuff(uid, 50000017, 1, 24 * 60)

    for i = 1, #allPlayerAttr[uid]['rotaryWeapon'] do
        local atorId = allPlayerAttr[uid]['rotaryWeapon'][i]
        Actor:killSelf(atorId)
    end
    allPlayerAttr[uid]['rotaryWeapon'] = {}

    addPlayerRotryWeapon(uid, 2)
    addPlayerRotryWeapon(uid, 2)
    addPlayerRotryWeapon(uid, 2)
    addPlayerRotryWeapon(uid, 2)
    PlayerBackpack.changWeaponSkin(uid)
end

ScriptSupportEvent:registerEvent('UI.Button.Click', refresh_player_weapon)