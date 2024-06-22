-- 排行榜数据 { uid: {name, lv, source, time, xiaofei, rank}}
RankTableData = {}

function loop_time_save_rank_table(event)
    local current = event.second
    if (current ~= nil and current >= 60 and (current - 60) % 60 == 0) then
        print("loop_time_save_player_backpack: 开始定时保存玩家排行榜数据")

        local ret, players = Valuegroup:getAllGroupItem(7, "所有玩家组", 0)

        if ret ~= ErrorCode.OK then
            return
        end

        local callback = function(ret, k, v)
            if ret == ErrorCode.OK then
                local cloudData = CopyTableDeep(v)

                for i, uid in ipairs(players) do
                    local _, lv = VarLib2:getPlayerVarByName(uid, 3, "等级")
                    local _, source = VarLib2:getPlayerVarByName(uid, 3, "玩家评分")
                    local _, time = VarLib2:getPlayerVarByName(uid, 3, "玩家游戏时长")
                    local _, xiaofei = VarLib2:getPlayerVarByName(uid, 3, "玩家消费")
                    local _, name = Player:getNickname(uid)

                    if source > 10000 then
                        local data = {
                            name = name,
                            lv = lv,
                            source = source,
                            time = time,
                            xiaofei = xiaofei
                        }
                        cloudData["player_"..uid] = data
                    end
                end
                print(cloudData)

                local ret = CloudSever:setDataListBykey("rank", "rank_table", cloudData)
                print("savePlayerRankSource: 已保存排行榜数据")
            end
        end
        local cloudRet = CloudSever:getDataListByKeyEx('rank', "rank_table", callback)
    end

    if (current ~= nil and current >= 60 and (current - 60) % 60 == 0) then
        player_enter_game_rank_table_init()
    end

end
ScriptSupportEvent:registerEvent('Game.RunTime', loop_time_save_rank_table)

-- 玩家进入游戏初始化
function player_enter_game_rank_table_init()
    local callback = function(ret, k, v)
        if ret == ErrorCode.OK then
            RankTableData = {}
            print("getRankTableData callback 云服获取排行榜数据成功: ", k)
            local tempData = CopyTableDeep(v)

            for _, v in pairs(tempData) do
                table.insert(RankTableData, v)
            end

            table.sort(RankTableData, function(a, b)
                return a.source > b.source
            end)

            for i, v in ipairs(RankTableData) do
                v.index = i
            end

        else
            print("getRankTableData callback 云服获取排行榜数据失败: ", ret)
            if ret == 2 then
                print("getRankTableData callback 不存在k数据", k)
                local ret = CloudSever:setDataListBykey("rank", "rank_table", {})
            else
                print("getRankTableData callback 云服获取玩家背包数据失败: ", ret)
            end
        end
    end
    local cloudRet = CloudSever:getDataListByKeyEx('rank', "rank_table", callback)
    print("getRankTableData 云服获取排行榜数据结果: ", cloudRet)
end
ScriptSupportEvent:registerEvent('Game.AnyPlayer.EnterGame', player_enter_game_rank_table_init)

-- UI 相关

RANK_TABLE_ELEMENT_ID = {
    MAIN = "7359881123757234400",
    MY_RANK = "7359881123757234400_12",
    MY_TIME = "7359881123757234400_20",
    MY_XIAOFEI = "7359881123757234400_21",
    MY_LV = "7359881123757234400_115",
    MY_SOURCE = "7359881123757234400_116",
    PREV = "7359881123757234400_90",
    NEXT = "7359881123757234400_89",
    PAGE_INFO = "7359881123757234400_88",
    ROW = {{
        RANK = "7359881123757234400_37",
        NAME = "7359881123757234400_38",
        TIME = "7359881123757234400_39",
        XIAOFEI = "7359881123757234400_40",
        LV = "7359881123757234400_95",
        SOURCE = "7359881123757234400_96"
    }, {
        RANK = "7359881123757234400_42",
        NAME = "7359881123757234400_43",
        TIME = "7359881123757234400_44",
        XIAOFEI = "7359881123757234400_45",
        LV = "7359881123757234400_97",
        SOURCE = "7359881123757234400_98"
    }, {
        RANK = "7359881123757234400_47",
        NAME = "7359881123757234400_48",
        TIME = "7359881123757234400_49",
        XIAOFEI = "7359881123757234400_50",
        LV = "7359881123757234400_99",
        SOURCE = "7359881123757234400_100"
    }, {
        RANK = "7359881123757234400_52",
        NAME = "7359881123757234400_53",
        TIME = "7359881123757234400_54",
        XIAOFEI = "7359881123757234400_55",
        LV = "7359881123757234400_101",
        SOURCE = "7359881123757234400_102"
    }, {
        RANK = "7359881123757234400_58",
        NAME = "7359881123757234400_59",
        TIME = "7359881123757234400_60",
        XIAOFEI = "7359881123757234400_61",
        LV = "7359881123757234400_103",
        SOURCE = "7359881123757234400_104"
    }, {
        RANK = "7359881123757234400_63",
        NAME = "7359881123757234400_64",
        TIME = "7359881123757234400_65",
        XIAOFEI = "7359881123757234400_66",
        LV = "7359881123757234400_105",
        SOURCE = "7359881123757234400_106"
    }, {
        RANK = "7359881123757234400_68",
        NAME = "7359881123757234400_69",
        TIME = "7359881123757234400_70",
        XIAOFEI = "7359881123757234400_71",
        LV = "7359881123757234400_107",
        SOURCE = "7359881123757234400_108"
    }, {
        RANK = "7359881123757234400_73",
        NAME = "7359881123757234400_74",
        TIME = "7359881123757234400_75",
        XIAOFEI = "7359881123757234400_76",
        LV = "7359881123757234400_109",
        SOURCE = "7359881123757234400_110"
    }, {
        RANK = "7359881123757234400_78",
        NAME = "7359881123757234400_79",
        TIME = "7359881123757234400_80",
        XIAOFEI = "7359881123757234400_81",
        LV = "7359881123757234400_111",
        SOURCE = "7359881123757234400_112"
    }, {
        RANK = "7359881123757234400_83",
        NAME = "7359881123757234400_84",
        TIME = "7359881123757234400_85",
        XIAOFEI = "7359881123757234400_86",
        LV = "7359881123757234400_113",
        SOURCE = "7359881123757234400_114"
    }}
}

current_player_rank_page = {}

function show_rank_ui(event)
    if event.CustomUI ~= RANK_TABLE_ELEMENT_ID.MAIN then
        return
    end
    local uid = event.eventobjid

    if current_player_rank_page[uid] == nil then
        current_player_rank_page[uid] = {
            page = 1,
            total = 0
        }
    end

    local _, lv = VarLib2:getPlayerVarByName(uid, 3, "等级")
    local _, source = VarLib2:getPlayerVarByName(uid, 3, "玩家评分")
    local _, time = VarLib2:getPlayerVarByName(uid, 3, "玩家游戏时长")
    local _, xiaofei = VarLib2:getPlayerVarByName(uid, 3, "玩家消费")
    local _, name = Player:getNickname(uid)

    Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.MY_LV, "等级: " .. lv)
    Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.MY_SOURCE, "评分: " .. source)
    Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.MY_TIME, "时长: " .. time)
    Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.MY_XIAOFEI, "消费: " .. xiaofei)

    function findPlayerIndex(name)
        for i, v in ipairs(RankTableData) do
            if v.name == name then
                return i
            end
        end
        return "未上榜"
    end

    local myIndex = findPlayerIndex(name)

    current_player_rank_page[uid].total = math.ceil(#RankTableData / 10)

    Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.MY_RANK, "我的排名: " .. myIndex)
    Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.PAGE_INFO,
        current_player_rank_page[uid].page .. "/" .. current_player_rank_page[uid].total)

    local start = (current_player_rank_page[uid].page - 1) * 10 + 1
    local end_ = current_player_rank_page[uid].page * 10

    for i = start, end_ do
        local rowIdx = i - start + 1
        if RankTableData[i] ~= nil then
            Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].RANK,
                RankTableData[i].index)
            Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].NAME,
                RankTableData[i].name)
            Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].TIME,
                RankTableData[i].time)
            Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].XIAOFEI,
                RankTableData[i].xiaofei)
            Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].LV, RankTableData[i].lv)
            Customui:setText(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].SOURCE,
                RankTableData[i].source)

            Customui:showElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].RANK)
            Customui:showElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].NAME)
            Customui:showElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].TIME)
            Customui:showElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].XIAOFEI)
            Customui:showElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].LV)
            Customui:showElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].SOURCE)
        else
            Customui:hideElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].RANK)
            Customui:hideElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].NAME)
            Customui:hideElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].TIME)
            Customui:hideElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].XIAOFEI)
            Customui:hideElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].LV)
            Customui:hideElement(uid, RANK_TABLE_ELEMENT_ID.MAIN, RANK_TABLE_ELEMENT_ID.ROW[rowIdx].SOURCE)
        end
    end
end
ScriptSupportEvent:registerEvent('UI.Show', show_rank_ui)

function handle_rank_page_ui_click(event)
    local uid = event.eventobjid
    local elementid = event.uielement

    if elementid == RANK_TABLE_ELEMENT_ID.NEXT then
        current_player_rank_page[uid].page = current_player_rank_page[uid].page + 1
        if current_player_rank_page[uid].page > current_player_rank_page[uid].total then
            current_player_rank_page[uid].page = current_player_rank_page[uid].total
        end
        show_rank_ui(event)

    elseif elementid == RANK_TABLE_ELEMENT_ID.PREV then
        current_player_rank_page[uid].page = current_player_rank_page[uid].page - 1
        if current_player_rank_page[uid].page < 1 then
            current_player_rank_page[uid].page = 1
        end
        show_rank_ui(event)
    end
end
ScriptSupportEvent:registerEvent('UI.Button.Click', handle_rank_page_ui_click)
