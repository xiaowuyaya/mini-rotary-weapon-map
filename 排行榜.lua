
--[[ 
    等级，玩家评分，玩家游戏时长，玩家消费
 ]]

-- 每30秒保存一次玩家背包数据
function loop_time_save_rank_table(event)
    local current = event.second
    if (current ~= nil and current >= 60 and (current - 60) % 60 == 0) then
        print("loop_time_save_player_backpack: 开始定时保存玩家排行榜数据")
        for uid, _ in pairs(PlayerBackpack) do

            local lv = VarLib2:getPlayerVarByName(uid, 3, "等级")
            local source = VarLib2:getPlayerVarByName(uid, 3, "玩家评分")
            local time = VarLib2:getPlayerVarByName(uid, 3, "玩家游戏时长")
            local xiaofei = VarLib2:getPlayerVarByName(uid, 3, "玩家消费")

            local data = {
                lv = lv,
                source = source,
                time = time,
                xiaofei = xiaofei
            }

            local ret = CloudSever:setDataListBykey("rank", "player_" .. uid, data)
        end
    end

end
ScriptSupportEvent:registerEvent('Game.RunTime', loop_time_save_rank_table)

function getRankTableData()
    local callback = function(data)
        if data then
            for k, v in pairs(data) do
                print("getRankTableData 云服获取排行榜数据: ", k, v)
            end
        end
    end
    local cloudRet = CloudSever:getDataListByKeyEx('rank', "player_" .. uid, callback)
    print("getRankTableData 云服获取排行榜数据结果: ", cloudRet)
end