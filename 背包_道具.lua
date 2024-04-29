-- 道具回收奖励：仙玉＝普通0 精良0 完美0 史诗5 传说100 神话500 至尊2000  
--             钱币＝（装备等级*100）* 品质*品质
--             强化石＝普通0 精良1 完美3 史诗10 传说50 神话300 至尊1500
--             突破石＝普通 1普通突破石   精良 1精良突破石 .....
--   otherAttr = {},
--  otherEffect = {},
-- 品质
QUALITY_ENUM = {"普通", "精良", "完美", "史诗", "传说", "神话", "至尊"}

ITEM_TYPE_ENUMS = {
    ["武器"] = "weapon",
    ["帽子"] = "hat",
    ["衣服"] = "clothes",
    ["鞋履"] = "shoes",
    ["饰品"] = "ring",
    ["护臂"] = "bracelet",
    ["盾牌"] = "shield"
}

-- 装备附加属性
ITEMS_OTHER_ATTRS = {
    [10001] = "此武器攻击命中时可附加XX点真实伤害",
    [10002] = "此武器可穿透目标XX的防御",
    [10003] = "此武器可额外造成XX的伤害",
    [10004] = "此武器攻击命中怪物时, 降低目标XX点防御力",
    [10005] = "此武器攻击命中怪物时, 降低目标XX点攻击力",
    [20001] = "所有武器 攻击命中时可附加XX点真实伤害",
    [20002] = "所有武器 可穿透目标XX的防御",
    [20003] = "所有武器 可额外造成XX的伤害",
    [20004] = "所有武器旋转速度提升XX",
    [20005] = "所有武器 攻击命中怪物时, 降低目标XX点防御力",
    [20006] = "所有武器攻击命中怪物时, 降低目标XX点攻击力",
    [30001] = "降低受到的伤害XX点",
    [30002] = "降低受到的伤害XX",
    [30003] = "XX概率躲避对方的攻击",
    [30004] = "受到伤害时，反伤XX自身攻击的伤害",
    [30005] = "受到伤害时，反伤XX点伤害",
    [30006] = "死亡时可原地复活,CD:15分钟",
    [30007] = "每隔10秒对自身范围10格内的所有怪物造成XX攻击的伤害",
    [30008] = "每隔10秒对自身范围10格内的所有怪物造成XX点伤害",
    -- [40001] = "周围5格范围内的玩家获得BUFF,生命恢复+XX 持续30秒",
    -- [40002] = "周围5格范围内的玩家获得BUFF,提升XX防御力 持续30秒",
    -- [40003] = "周围5格范围内的玩家获得BUFF,提升XX攻击力 持续30秒",
    -- [40004] = "周围5格范围内的玩家获得BUFF,移动速度提升XX 持续30秒",
    -- [40005] = "周围5格范围内的玩家获得BUFF,提升XX最终伤害 持续30秒",
    -- [40006] = "周围5格范围内的玩家获得BUFF,提升XX防御穿透 持续30秒",
    -- [40007] = "周围5格范围内的玩家获得BUFF,降低XX点受到的伤害 持续30秒",
    -- [40008] = "周围5格范围内的玩家获得BUFF,武器旋转速度提升XX 持续30秒",
    [50001] = "攻击力",
    [50002] = "防御力",
    [50003] = "生命值",
    [50004] = "移动速度", -- 带%
    [50005] = "暴击率", -- 带%
    [50006] = "暴击伤害", -- 带%
    [50007] = "生命恢复",
    [50008] = "伤害提升", -- 带%
    [50009] = "经验收益", -- 带%
    [50010] = "掉宝率", -- 带%
    [50011] = "攻击力", -- 带%
    [50012] = "防御力", -- 带%
    [50013] = "生命值", -- 带%
    [50014] = "生命恢复" -- 带%
}

ALL_BACKPACK_ITEMS = {
    [4098] = {
        name = "下品木剑",
        type = "武器",
        lv = 1,
        quality = QUALITY_ENUM[1],
        atk = 20,
        img = "8_1118247136_1714210141",
        hp = 50

    },
    [4103] = {
        name = "下品铁剑",
        type = "武器",
        lv = 10,
        quality = QUALITY_ENUM[1],
        atk = 50,
        img = "8_1118247136_1714210146",
        hp = 100
    },
    [4100] = {
        name = "下品布衣",
        type = "衣服",
        lv = 1,
        quality = QUALITY_ENUM[1],
        atk = 5,
        hp = 150
    },
    [4099] = {
        name = "下品头巾",
        type = "帽子",
        lv = 1,
        quality = QUALITY_ENUM[1],
        atk = 5,
        hp = 150
    },
    [4126] = {
        name = "中品头巾",
        type = "帽子",
        lv = 5,
        quality = QUALITY_ENUM[2],
        atk = 10,
        hp = 300,
        otherAttr = {{50002, 5}}

    },
    [4127] = {
        name = "上品头巾",
        type = "帽子",
        lv = 10,
        quality = QUALITY_ENUM[3],
        atk = 15,
        hp = 450,
        otherAttr = {{50002, 10}}
    },
    [4128] = {
        name = "中品布衣",
        type = "衣服",
        lv = 5,
        quality = QUALITY_ENUM[2],
        atk = 10,
        hp = 300,
        otherAttr = {{50002, 5}}
    },
    [4129] = {
        name = "上品布衣",
        type = "衣服",
        lv = 10,
        quality = QUALITY_ENUM[3],
        atk = 15,
        hp = 450,
        otherAttr = {{50002, 10}}
    },
    [4130] = {
        name = "中品木剑",
        type = "武器",
        lv = 5,
        img = "8_1118247136_1714210141",
        quality = QUALITY_ENUM[2],
        atk = 40,
        hp = 100,
        otherAttr = {{50011, 0.01}}
    },
    [4131] = {
        name = "上品木剑",
        type = "武器",
        img = "8_1118247136_1714210141",
        lv = 10,
        quality = QUALITY_ENUM[3],
        atk = 60,
        hp = 150,
        otherAttr = {{50011, 0.02}}
    },
    [4132] = {
        name = "下品铃鞋",
        type = "鞋履",
        lv = 1,
        quality = QUALITY_ENUM[1],
        atk = 10,
        hp = 100,
        otherAttr = {{50004, 0.05}}
    },
    [4133] = {
        name = "中品铃鞋",
        type = "鞋履",
        lv = 5,
        quality = QUALITY_ENUM[2],
        atk = 20,
        hp = 200,
        otherAttr = {{50004, 0.05}}
    },
    [4134] = {
        name = "上品铃鞋",
        type = "鞋履",
        lv = 10,
        quality = QUALITY_ENUM[3],
        atk = 30,
        hp = 300,
        otherAttr = {{50004, 0.1}}
    },
    [4135] = {
        name = "下品青铜手镯",
        type = "饰品",
        lv = 1,
        quality = QUALITY_ENUM[1],
        atk = 30,
        hp = 30,
        otherAttr = {{50007, 1}}
    },
    [4136] = {
        name = "中品青铜手镯",
        type = "饰品",
        lv = 5,
        quality = QUALITY_ENUM[2],
        atk = 60,
        hp = 60,
        otherAttr = {{50007, 2}}
    },
    [4137] = {
        name = "上品青铜手镯",
        type = "饰品",
        lv = 10,
        quality = QUALITY_ENUM[3],
        atk = 90,
        hp = 90,
        otherAttr = {{50007, 3}}
    },
    [4138] = {
        name = "下品破布护臂",
        type = "护臂",
        lv = 1,
        quality = QUALITY_ENUM[1],
        atk = 30,
        hp = 30
    },
    [4139] = {
        name = "中品破布护臂",
        type = "护臂",
        lv = 5,
        quality = QUALITY_ENUM[2],
        atk = 60,
        hp = 60,
        otherAttr = {{50001, 5}}
    },
    [4140] = {
        name = "上品破布护臂",
        type = "护臂",
        lv = 10,
        quality = QUALITY_ENUM[3],
        atk = 90,
        hp = 90,
        otherAttr = {{50001, 10}}
    },
    [4141] = {
        name = "中品铁剑",
        img = "8_1118247136_1714210146",
        type = "武器",
        lv = 20,
        quality = QUALITY_ENUM[2],
        atk = 100,
        hp = 200,
        otherAttr = {{50011, 0.02}}
    },
    [4142] = {
        name = "上品铁剑",
        img = "8_1118247136_1714210146",
        type = "武器",
        lv = 30,
        quality = QUALITY_ENUM[3],
        atk = 150,
        hp = 300,
        otherAttr = {{50011, 0.03}}
    },
    [4143] = {
        name = "下品木盾",
        type = "盾牌",
        lv = 1,
        quality = QUALITY_ENUM[1],
        atk = 5,
        hp = 150,
        otherAttr = {{50002, 5}}

    },
    [4144] = {
        name = "中品木盾",
        type = "盾牌",
        lv = 5,
        quality = QUALITY_ENUM[2],
        atk = 10,
        hp = 300,
        otherAttr = {{50002, 10}}
    },
    [4145] = {
        name = "上品木盾",
        type = "盾牌",
        lv = 10,
        quality = QUALITY_ENUM[3],
        atk = 15,
        hp = 450,
        otherAttr = {{50002, 15}}
    },
    [4146] = {
        name = "卓越秘银剑",
        img = "8_1118247136_1714214652",
        type = "武器",
        lv = 20,
        quality = QUALITY_ENUM[3],
        atk = 150,
        hp = 300,
        otherAttr = {{50001, 20}}
    },
    [4147] = {
        name = "传奇秘银剑",
        img = "8_1118247136_1714214652",
        type = "武器",
        lv = 30,
        quality = QUALITY_ENUM[4],
        atk = 300,
        hp = 600,
        otherAttr = {{50001, 40}, {50011, 0.05}}
    },
    [4148] = {
        name = "普通突破石",
        type = "材料",
        lv = 1,
        quality = QUALITY_ENUM[1],
        desc = "通过回收[普通]品质的装备获得，可用于突破装备槽的强化上限。"
    },
    [4149] = {
        name = "精良突破石",
        type = "材料",
        lv = 1,
        quality = QUALITY_ENUM[2],
        desc = "通过回收[精良]品质的装备获得，可用于突破装备槽的强化上限。"
    },
    [4150] = {
        name = "完美突破石",
        type = "材料",
        lv = 1,
        quality = QUALITY_ENUM[3],
        desc = "通过回收[完美]品质的装备获得，可用于突破装备槽的强化上限。"
    },
    [4151] = {
        name = "史诗突破石",
        type = "材料",
        lv = 1,
        quality = QUALITY_ENUM[4],
        desc = "通过回收[史诗]品质的装备获得，可用于突破装备槽的强化上限。"
    },
    [4152] = {
        name = "传说突破石",
        type = "材料",
        lv = 1,
        quality = QUALITY_ENUM[5],
        desc = "通过回收[传说]品质的装备获得，可用于突破装备槽的强化上限。"
    },
    [4153] = {
        name = "神话突破石",
        type = "材料",
        lv = 1,
        quality = QUALITY_ENUM[6],
        desc = "通过回收[神话]品质的装备获得，可用于突破装备槽的强化上限。"
    },
    [4154] = {
        name = "至尊突破石",
        type = "材料",
        lv = 1,
        quality = QUALITY_ENUM[7],
        desc = "通过回收[至尊]品质的装备获得，可用于突破装备槽的强化上限。"
    },
    [4155] = {
        name = "1级生命药水",
        type = "消耗品",
        lv = 1,
        effect = "hp",
        value = 100,
        quality = QUALITY_ENUM[1],
        desc = "使用后可恢复100点生命值, CD: 15秒。"
    },
    [4156] = {
        name = "2级生命药水",
        type = "消耗品",
        lv = 5,
        effect = "hp",
        value = 250,
        quality = QUALITY_ENUM[1],
        desc = "使用后可恢复250点生命值, CD: 15秒。"
    },
    [4157] = {
        name = "3级生命药水",
        type = "消耗品",
        lv = 10,
        effect = "hp",
        value = 500,
        quality = QUALITY_ENUM[1],
        desc = "使用后可恢复500点生命值, CD: 15秒。"
    },
    [4158] = {
        name = "4级生命药水",
        type = "消耗品",
        lv = 20,
        effect = "hp",
        value = 1000,
        quality = QUALITY_ENUM[1],
        desc = "使用后可恢复1000点生命值, CD: 15秒。"
    }
}
