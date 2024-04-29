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

-- 每30秒保存一次玩家背包数据
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
    UIBackpack.handleNavMenusChange(event.eventobjid, event.uielement)
    UIBackpack.handleAllDetailPanel(event.eventobjid, event.uielement)
    UIBackpack.handlePaginationLogic(event.eventobjid, event.uielement)
    UIBackpack.handleSortCells(event.eventobjid, event.uielement)
    UIBackpack.handleChangeKuaijielan(event.eventobjid, event.uielement)
    UIBackpack.handleHuishouUI(event.eventobjid, event.uielement)
end
ScriptSupportEvent:registerEvent('UI.Button.Click', handle_backpack_ui_click)

function handle_player_add_buff(event)
    if event.buffid == 50000010 then
        UIBackpack.handlePaginationText(event.eventobjid)
    end
end
ScriptSupportEvent:registerEvent('Player.AddBuff', handle_player_add_buff)

