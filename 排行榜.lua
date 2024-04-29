
-- 每30秒保存一次玩家背包数据
function loop_time_save_rank_table(event)
    local current = event.second
    if (current ~= nil and current >= 60 and (current - 60) % 60 == 0) then
        print("loop_time_save_player_backpack: 开始定时保存玩家背包数据")
        
        
    end

end
ScriptSupportEvent:registerEvent('Game.RunTime', loop_time_save_rank_table)