
--[[ 
    等级，玩家评分，玩家游戏时长，玩家消费
 ]]

RankTableData = {}

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

            local ret = CloudSever:setDataListBykey("rank", "data.player_" .. uid, data)
        end
    end

    if (current ~= nil and current >= 10 and (current - 10) % 10 == 0) then
        getRankTableData()
    end

end
ScriptSupportEvent:registerEvent('Game.RunTime', loop_time_save_rank_table)

function getRankTableData()
    local callback = function(ret, k, v)
        if ret == ErrorCode.OK then
            print("getRankTableData callback 云服获取排行榜数据成功: ", k)
            RankTableData = CopyTableDeep(v)
        else
            print("getRankTableData callback 云服获取排行榜数据失败: ", ret)
            if ret == 2 then
                print("getRankTableData callback 不存在k数据", k)
            else
                print("getRankTableData callback 云服获取玩家背包数据失败: ", ret)
            end
        end
    end
    local cloudRet = CloudSever:getDataListByKeyEx('rank', "data", callback)
    print("getRankTableData 云服获取排行榜数据结果: ", cloudRet)
end