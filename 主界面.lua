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
