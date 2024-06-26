-- 玩家进入游戏初始化
function player_enter_game_init(event)
    PlayerBackpack.init(event.eventobjid)
end
ScriptSupportEvent:registerEvent('Game.AnyPlayer.EnterGame', player_enter_game_init)

-- 玩家离开游戏
function player_leave_game(event)
    PlayerBackpack.save(event.eventobjid)
    PlayerBackpack[event.eventobjid] = nil
end
ScriptSupportEvent:registerEvent('Game.AnyPlayer.LeaveGame', player_leave_game)

-- 每30秒保存一次玩家背包数据 、 以及排行榜数据
function loop_time_save_player_backpack(event)
    local current = event.second
    if (current ~= nil and current >= 30 and (current - 30) % 30 == 0) then
        print("loop_time_save_player_backpack: 开始定时保存玩家背包数据")
        for uid, _ in pairs(PlayerBackpack) do
            if type(uid) == 'number' then
                PlayerBackpack.save(uid)
            end
        end
    end

end
ScriptSupportEvent:registerEvent('Game.RunTime', loop_time_save_player_backpack)

-- 玩家获取物品
function player_add_item(event)
    PlayerBackpack.addObject(event.eventobjid, event.itemid)
end
ScriptSupportEvent:registerEvent('Player.AddItem', player_add_item)

function show_backpack_ui(event)
    UIBackpack.handleShowMain(event)
end
ScriptSupportEvent:registerEvent('UI.Show', show_backpack_ui)

function handle_backpack_ui_click(event)
   
    local code = Actor:hasBuff(event.eventobjid, 50000034)
    if code == 0 then
        return
    end
    Actor:addBuff(event.eventobjid, 50000034, 1, 24 * 60)

    UIBackpack.handleNavMenusChange(event.eventobjid, event.uielement)
    UIBackpack.handleAllDetailPanel(event.eventobjid, event.uielement)
    UIBackpack.handlePaginationLogic(event.eventobjid, event.uielement)
    UIBackpack.handleSortCells(event.eventobjid, event.uielement)
    UIBackpack.handleChangeKuaijielan(event.eventobjid, event.uielement)
    UIBackpack.handleHuishouUI(event.eventobjid, event.uielement)
    UIBackpack.handleQianghuaOK(event.eventobjid, event.uielement)

    Actor:addBuff(event.eventobjid, 50000031, 1, 7)
    print("gei buff")

end
ScriptSupportEvent:registerEvent('UI.Button.Click', handle_backpack_ui_click)


function handle_player_add_buff(event)
    if event.buffid == 50000010 then
        UIBackpack.handlePaginationText(event.eventobjid)
    end
end
ScriptSupportEvent:registerEvent('Player.AddBuff', handle_player_add_buff)

function handle_player_remove_buff(event)
    if event.buffid == 50000031 then
        local code = Buff:removeBuff(event.eventobjid, 50000034)
        print("yichu buff")
    end
end

ScriptSupportEvent:registerEvent('Player.RemoveBuff', handle_player_remove_buff)

function handle_player_new_input_content(event)
    if event.content == "清空所有玩家数据1224" then
        local ret = CloudSever:ClearDataList("backpack")
        if ret == ErrorCode.OK then
            print('清空表成功')
        else
            print('清空表失败')
        end
    end
end
ScriptSupportEvent:registerEvent('Player.NewInputContent', handle_player_new_input_content)
