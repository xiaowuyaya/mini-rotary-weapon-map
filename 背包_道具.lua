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
    -- 附加属性 BEGIN
    [1] = "所有武器 攻击命中时可附加XX点真实伤害",
    [2] = "所有武器 可穿透目标XX%的防御",
    [3] = "所有武器可额外造成XX%的伤害",
    [4] = "所有武器旋转速度提升XX%",
    [5] = "所有武器 攻击命中怪物时, 降低目标XX点防御力",
    [6] = "所有武器攻击命中怪物时, 降低目标XX点攻击力",
    [7] = "所有武器攻击命中恢复XX点生命值",
    [8] = "降低受到的伤害XX点",
    [9] = "降低受到的伤害XX%",
    [10] = "XX%概率躲避对方的攻击",
    [11] = "受到伤害时，反伤XX%自身攻击的伤害",
    [12] = "受到伤害时，反伤XX点伤害",
    [13] = "死亡时可原地复活,CD:15分钟",
    [14] = "每隔10秒对自身范围10格内的所有怪物造成XX%攻击的伤害",
    [15] = "每隔10秒对自身范围10格内的所有怪物造成XX点伤害",
    -- 附加属性 END
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
        otherEffect = {1, 520},
        hp = 50

    },
    [4103] = {
        name = "下品铁剑",
        type = "武器",
        lv = 10,
        quality = QUALITY_ENUM[1],
        atk = 50,
        img = "8_1118247136_1714210146",
        hp = 100,
        otherEffect = {4, 100},
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
    },
    [4180] = {
        name = "下品破衣",
        type = "衣服",
        lv = 10,
        quality = QUALITY_ENUM[1],
        atk = 12,
        hp = 360

    },
    [4181] = {
        name = "中品破衣",
        type = "衣服",
        lv = 20,
        quality = QUALITY_ENUM[2],
        atk = 24,
        hp = 720,
        otherAttr = {{50002, 5}}
    },
    [4182] = {
        name = "上品破衣",
        type = "衣服",
        lv = 30,
        quality = QUALITY_ENUM[3],
        atk = 36,
        hp = 1080,
        otherAttr = {{50002, 10}}
    },
    [4183] = {
        name = "下品布帽",
        type = "帽子",
        lv = 10,
        quality = QUALITY_ENUM[1],
        atk = 12,
        hp = 360

    },
    [4184] = {
        name = "中品布帽",
        type = "帽子",
        lv = 20,
        quality = QUALITY_ENUM[2],
        atk = 24,
        hp = 720,
        otherAttr = {{50002, 5}}
    },
    [4185] = {
        name = "上品布帽",
        type = "帽子",
        lv = 30,
        quality = QUALITY_ENUM[3],
        atk = 36,
        hp = 1080,
        otherAttr = {{50002, 10}}
    },
    [4186] = {
        name = "下品皮质护腕",
        type = "护臂",
        lv = 10,
        quality = QUALITY_ENUM[1],
        atk = 75,
        hp = 75

    },
    [4187] = {
        name = "中品皮质护腕",
        type = "护臂",
        lv = 20,
        quality = QUALITY_ENUM[2],
        atk = 150,
        hp = 150,
        otherAttr = {{50011, 0.02}}
    },
    [4188] = {
        name = "上品皮质护腕",
        type = "护臂",
        lv = 30,
        quality = QUALITY_ENUM[3],
        atk = 225,
        hp = 225,
        otherAttr = {{50011, 0.03}}
    },
    [4189] = {
        name = "下品软麻鞋",
        type = "鞋履",
        lv = 10,
        quality = QUALITY_ENUM[1],
        atk = 25,
        hp = 250,
        otherAttr = {{50004, 0.05}}
    },
    [4190] = {
        name = "中品软麻鞋",
        type = "鞋履",
        lv = 20,
        quality = QUALITY_ENUM[2],
        atk = 50,
        hp = 500,
        otherAttr = {{50004, 0.05}}
    },
    [4191] = {
        name = "上品软麻鞋",
        type = "鞋履",
        lv = 30,
        quality = QUALITY_ENUM[3],
        atk = 75,
        hp = 750,
        otherAttr = {{50004, 0.1}}
    },
    [4192] = {
        name = "下品玄铁剑",
        img = "8_1118247136_1714567746",
        type = "武器",
        lv = 20,
        quality = QUALITY_ENUM[1],
        atk = 75,
        hp = 150
    },
    [4193] = {
        name = "中品玄铁剑",
        img = "8_1118247136_1714567746",
        type = "武器",
        lv = 30,
        quality = QUALITY_ENUM[2],
        atk = 150,
        hp = 300,
        otherAttr = {{50008, 0.03}}
    },
    [4194] = {
        name = "上品玄铁剑",
        img = "8_1118247136_1714567746",
        type = "武器",
        lv = 40,
        quality = QUALITY_ENUM[3],
        atk = 225,
        hp = 450,
        otherAttr = {{50008, 0.05}}
    },
    [4195] = {
        name = "下品圆盾",
        type = "盾牌",
        lv = 10,
        quality = QUALITY_ENUM[1],
        atk = 12,
        hp = 360,
        otherAttr = {{50002, 5}}
    },
    [4196] = {
        name = "中品圆盾",
        type = "盾牌",
        lv = 20,
        quality = QUALITY_ENUM[2],
        atk = 24,
        hp = 720,
        otherAttr = {{50002, 10}}
    },
    [4197] = {
        name = "上品圆盾",
        type = "盾牌",
        lv = 30,
        quality = QUALITY_ENUM[3],
        atk = 36,
        hp = 1080,
        otherAttr = {{50002, 15}}
    },
    [4198] = {
        name = "下品红石戒指",
        type = "饰品",
        lv = 10,
        quality = QUALITY_ENUM[1],
        atk = 75,
        hp = 75,
        otherAttr = {{50007, 2}}
    },
    [4199] = {
        name = "中品红石戒指",
        type = "饰品",
        lv = 20,
        quality = QUALITY_ENUM[2],
        atk = 150,
        hp = 150,
        otherAttr = {{50007, 4}}
    },
    [4200] = {
        name = "上品红石戒指",
        type = "饰品",
        lv = 30,
        quality = QUALITY_ENUM[3],
        atk = 225,
        hp = 225,
        otherAttr = {{50007, 6}}
    },
    [4201] = {
        name = "卓越锁子甲",
        type = "衣服",
        lv = 30,
        quality = QUALITY_ENUM[3],
        atk = 40,
        hp = 1200,
        otherAttr = {{50002, 15}}
    },
    [4202] = {
        name = "传奇锁子甲",
        type = "衣服",
        lv = 45,
        quality = QUALITY_ENUM[4],
        atk = 80,
        hp = 2400,
        otherAttr = {{50002, 20}, {50012, 0.1}}
    },
    [4203] = {
        name = "骑士头盔",
        type = "帽子",
        lv = 55,
        quality = QUALITY_ENUM[4],
        atk = 120,
        hp = 3600,
        otherAttr = {{50002, 20}, {50012, 0.1}}
    },
    [4159] = {
        name = "5级生命药水",
        type = "消耗品",
        lv = 35,
        effect = "hp",
        value = 1500,
        quality = QUALITY_ENUM[1],
        desc = "使用后可恢复1500点生命值, CD: 15秒。"
    },
    [4160] = {
        name = "6级生命药水",
        type = "消耗品",
        lv = 50,
        effect = "hp",
        value = 2500,
        quality = QUALITY_ENUM[1],
        desc = "使用后可恢复2500点生命值, CD: 15秒。"
    },
    [4206] = {
        name = "桃花剑",
        img = "8_1118247136_1714594042",
        type = "武器",
        lv = 40,
        quality = QUALITY_ENUM[4],
        atk = 400,
        hp = 800,
        otherAttr = {{50005, 0.05}, {50011, 0.05}}
    },
    [4207] = {
        name = "桃花戒",
        type = "饰品",
        lv = 45,
        quality = QUALITY_ENUM[4],
        atk = 600,
        hp = 600,
        otherAttr = {{50009, 0.1}, {50007, 10}}
    },
    [4208] = {
        name = "仙女剑",
        img = "8_1118247136_1714594456",
        type = "武器",
        lv = 60,
        quality = QUALITY_ENUM[5],
        atk = 800,
        hp = 1600,
        otherAttr = {{50009, 0.1}, {50011, 0.05}}
    },
    [4209] = {
        name = "通用副本卷轴",
        type = "材料",
        lv = 1,
        quality = QUALITY_ENUM[7],
        desc = "可用于进入所有副本的门票"
    },
    [4210] = {
        name = "小型经验药水",
        type = "消耗品",
        lv = 1,
        effect = "exp",
        value = 1800,
        quality = QUALITY_ENUM[2],
        desc = "使用后获得的经验收益翻倍,持续30分钟 CD: 15秒。    提示:药水的持续时间无法叠加,请勿多次使用。"
    },
    [4211] = {
        name = "中型经验药水",
        type = "消耗品",
        lv = 1,
        effect = "exp",
        value = 10800,
        quality = QUALITY_ENUM[2],
        desc = "使用后获得的经验收益翻倍,持续180分钟 CD: 15秒。    提示:药水的持续时间无法叠加,请勿多次使用。"
    },
    [4212] = {
        name = "大型经验药水",
        type = "消耗品",
        lv = 1,
        effect = "exp",
        value = 28800,
        quality = QUALITY_ENUM[2],
        desc = "使用后获得的经验收益翻倍,持续480分钟 CD: 15秒。    提示:药水的持续时间无法叠加,请勿多次使用。"
    },
    [4219] = {
        name = "人参果",
        type = "消耗品",
        lv = 1,
        effect = "hp%",
        value = 35,
        quality = QUALITY_ENUM[7],
        desc = "使用后可恢复35%生命值, CD: 30秒。  提示:不与生命药水共享CD"
    },
    [4230] = {
        name = "下品神木靴",
        type = "鞋履",
        lv = 30,
        quality = QUALITY_ENUM[1],
        atk = 55,
        hp = 550
    },
    [4231] = {
        name = "中品神木靴",
        type = "鞋履",
        lv = 45,
        quality = QUALITY_ENUM[2],
        atk = 110,
        hp = 1100,
        otherAttr = {{50007, 6}}
    },
    [4232] = {
        name = "上品神木靴",
        type = "鞋履",
        lv = 60,
        quality = QUALITY_ENUM[3],
        atk = 165,
        hp = 1650,
        otherAttr = {{50007, 8}, {50004, 0.05}}
    },
    [4233] = {
        name = "下品神木剑",
        type = "武器",
        img = "8_1118247136_1714927540",
        lv = 30,
        quality = QUALITY_ENUM[1],
        atk = 120,
        hp = 240
    },
    [4234] = {
        name = "中品神木剑",
        type = "武器",
        img = "8_1118247136_1714927540",
        lv = 45,
        quality = QUALITY_ENUM[2],
        atk = 240,
        hp = 360,
        otherAttr = {{50007, 6}}
    },
    [4235] = {
        name = "上品神木剑",
        type = "武器",
        img = "8_1118247136_1714927540",
        lv = 60,
        quality = QUALITY_ENUM[3],
        atk = 360,
        hp = 720,
        otherAttr = {{50007, 8}, {50011, 0.05}}
    },
    [4236] = {
        name = "下品神木冠",
        type = "帽子",
        lv = 30,
        quality = QUALITY_ENUM[1],
        atk = 28,
        hp = 840
    },
    [4237] = {
        name = "中品神木冠",
        type = "帽子",
        lv = 45,
        quality = QUALITY_ENUM[2],
        atk = 56,
        hp = 1680,
        otherAttr = {{50007, 6}}
    },
    [4238] = {
        name = "中品神木冠",
        type = "帽子",
        lv = 60,
        quality = QUALITY_ENUM[3],
        atk = 84,
        hp = 2520,
        otherAttr = {{50007, 8}, {50013, 0.05}}
    },
    [4239] = {
        name = "下品神木护臂",
        type = "护臂",
        lv = 30,
        quality = QUALITY_ENUM[1],
        atk = 180,
        hp = 180
    },
    [4240] = {
        name = "中品神木护臂",
        type = "护臂",
        lv = 45,
        quality = QUALITY_ENUM[2],
        atk = 360,
        hp = 360,
        otherAttr = {{50007, 6}}
    },
    [4241] = {
        name = "上品神木护臂",
        type = "护臂",
        lv = 60,
        quality = QUALITY_ENUM[3],
        atk = 540,
        hp = 540,
        otherAttr = {{50007, 8}, {50006, 0.05}}
    },
    [4242] = {
        name = "下品神木服",
        type = "衣服",
        lv = 30,
        quality = QUALITY_ENUM[1],
        atk = 28,
        hp = 840
    },
    [4243] = {
        name = "中品神木服",
        type = "衣服",
        lv = 45,
        quality = QUALITY_ENUM[2],
        atk = 56,
        hp = 1680,
        otherAttr = {{50007, 6}}
    },
    [4244] = {
        name = "上品神木服",
        type = "衣服",
        lv = 60,
        quality = QUALITY_ENUM[3],
        atk = 84,
        hp = 2520,
        otherAttr = {{50007, 8}, {50013, 0.05}}
    },
    [4245] = {
        name = "下品神木盾",
        type = "盾牌",
        lv = 30,
        quality = QUALITY_ENUM[1],
        atk = 28,
        hp = 840,
        otherAttr = {{50002, 5}}
    },
    [4246] = {
        name = "中品神木盾",
        type = "盾牌",
        lv = 45,
        quality = QUALITY_ENUM[2],
        atk = 56,
        hp = 1680,
        otherAttr = {{50007, 4}, {50002, 10}}
    },
    [4247] = {
        name = "上品神木盾",
        type = "盾牌",
        lv = 60,
        quality = QUALITY_ENUM[3],
        atk = 84,
        hp = 2520,
        otherAttr = {{50007, 6}, {50002, 15}}
    },
    [4248] = {
        name = "下品神木戒",
        type = "饰品",
        lv = 30,
        quality = QUALITY_ENUM[1],
        atk = 180,
        hp = 180
    },
    [4249] = {
        name = "中品神木戒",
        type = "饰品",
        lv = 45,
        quality = QUALITY_ENUM[2],
        atk = 360,
        hp = 360,
        otherAttr = {{50007, 6}}
    },
    [4250] = {
        name = "上品神木戒",
        type = "饰品",
        lv = 60,
        quality = QUALITY_ENUM[3],
        atk = 540,
        hp = 540,
        otherAttr = {{50007, 8}, {50013, 0.05}}
    },
    [4251] = {
        name = "下品长靴",
        type = "鞋履",
        lv = 50,
        quality = QUALITY_ENUM[1],
        atk = 100,
        hp = 1000,
        otherAttr = {{50004, 0.05}}
    },
    [4252] = {
        name = "中品长靴",
        type = "鞋履",
        lv = 65,
        quality = QUALITY_ENUM[2],
        atk = 200,
        hp = 2000,
        otherAttr = {{50004, 0.1}}
    },
    [4253] = {
        name = "上品长靴",
        type = "鞋履",
        lv = 80,
        quality = QUALITY_ENUM[3],
        atk = 300,
        hp = 3000,
        otherAttr = {{50004, 0.15}}
    },
    [4254] = {
        name = "下品空虚戒指",
        type = "饰品",
        lv = 50,
        quality = QUALITY_ENUM[1],
        atk = 320,
        hp = 320
    },
    [4255] = {
        name = "中品空虚戒指",
        type = "饰品",
        lv = 65,
        quality = QUALITY_ENUM[2],
        atk = 640,
        hp = 640,
        otherAttr = {{50008, 0.04}}
    },
    [4256] = {
        name = "上品空虚戒指",
        type = "饰品",
        lv = 80,
        quality = QUALITY_ENUM[3],
        atk = 1280,
        hp = 1280,
        otherAttr = {{50008, 0.06}}
    },
    [4257] = {
        name = "卓越青藤护臂",
        type = "护臂",
        lv = 60,
        quality = QUALITY_ENUM[3],
        atk = 600,
        hp = 600,
        otherAttr = {{50005, 0.05}}
    },
    [4258] = {
        name = "传奇青藤护臂",
        type = "护臂",
        lv = 80,
        quality = QUALITY_ENUM[4],
        atk = 1200,
        hp = 1200,
        otherAttr = {{50005, 0.05}, {50006, 0.1}}
    },
    [4259] = {
        name = "莲花盾",
        type = "盾牌",
        lv = 100,
        quality = QUALITY_ENUM[4],
        atk = 280,
        hp = 8400,
        otherAttr = {{50002, 40}, {50012, 0.1}}
    },
    [4161] = {
        name = "7级生命药水",
        type = "消耗品",
        lv = 70,
        effect = "hp",
        value = 4000,
        quality = QUALITY_ENUM[1],
        desc = "使用后可恢复4000点生命值, CD: 15秒。"
    },
    [4162] = {
        name = "8级生命药水",
        type = "消耗品",
        lv = 90,
        effect = "hp",
        value = 6000,
        quality = QUALITY_ENUM[1],
        desc = "使用后可恢复6000点生命值, CD: 15秒。"
    }
}
