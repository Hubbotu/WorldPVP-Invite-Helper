WorldPVP_InviteHelper = LibStub("AceAddon-3.0"):NewAddon("WorldPVP_InviteHelper", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local AceGUI = LibStub("AceGUI-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- 三喵：保存队伍：定义 
-- local groupTable = {}  -- 已弃用，使用 self.db.char.groupTable 替代 - 通过AceDB持久化存储

----------------------------------------------------------------------------------------------

-- 定义本地化表
local locale = {
    zhCN = {
        addonName = "WorldPVP组队助手.",
        autoAdviseHeader = "|cffffa012自动喊话|r",
        autoInviteHeader = "|cffffa012自动邀请|r",
        groupFunctionHeader = "|cffffa012组队功能",
        reInviteHeader = "|cffffa012重组队伍丨|r|cffffffff团长跨位面后一键恢复团队|r",
        autoAdvise_enable = "启用 自动广告",
        autoAdvise_world = "世界频道(报错)",
        autoAdvise_guild = "公会频道",
        autoAdvise_text = "自动广告内容",
        autoNotify_enable = "启用 自动通知",
        autoNotify_text = "自动通知内容（注意避开“yy”等敏感词）",
        autoInvite_enable = "启用 自动邀请",
        autoInvite_whisper = "密语",
        autoInvite_bnetfriend = "战网好友",
        autoInvite_world = "世界频道",
        autoInvite_guild = "公会频道",
        autoInvite_text = "自动邀请关键词 (多词可用中英文逗号或空格分隔)",
        autoInvite_convertRaid = "自动转为团队",
        autoInvite_assignA = "团队自动给A",
        autoInvite_freeforall = "自由拾取",
        autoInvite_lowlevelNotify = "低等级号自动通报",
        raidFrameSwitchButton = "团队界面",
        convertButton = "转为团队",
        promoteAllButton = "全团给A",
        demoteAllButton = "全团收A",
        promoteAllIncomplete = "系统自带全团给A功能不完整",
        demoteAllIncomplete = "系统自带全团收A功能不完整",
        readyCheckButton = "就位确认",
        saveButton = "记忆队伍",
        disbandButton = "解散队伍",
        reInviteButton = "恢复队伍",
        invitehelperUISwitchButton = "组队\n助手",
        lowLevelWarning = "警告！发现小号新成员: %s, %d队, 等级: Lv.%d",
        autoNotifyWarning = "WorldPVPInviteHelper：你开启了“自动通知”功能但你不在队伍或团队中，无法向队伍或团队通知！",
        convertToParty = "转为小队",
        groupListSaved = "已清空并重新保存人员名单",
        convertToRaid = "转为\n团队",
        convertToParty1 = "转为\n小队",
        promoteAllToAssistant = "全团\n给A",
        demoteAllAssistants = "全团\n收A",
        saveGroup = "记忆\n队伍",
        disbandGroup = "解散\n队伍",
        reInviteGroup = "恢复\n队伍",
        inviteHelperTooltip = "开/关组队助手主界面",
        ffaConfirmTitle = "确认启用自由拾取",
        ffaConfirmText = "确定要启用自由拾取吗？",
        ffaConfirmButton = "确定",
        ffaCancelButton = "取消",
        ffaLeaderConfirmText = "你刚成为团队队长。\n是否要将团队拾取方式设置为自由拾取？",
    },
    enUS = {
        addonName = "WorldPVP InviteHelper.",
        autoAdviseHeader = "|cffffa012Auto-Announce|r",
        autoInviteHeader = "|cffffa012Auto-Invite|r",
        groupFunctionHeader = "|cffffa012Group Functions|r",
        reInviteHeader = "|cffffa012Re-Invite Group丨|r|cffffffffReAssemble After Layer Hop|r",
        autoAdvise_enable = "Enable Auto-Advertise",
        autoAdvise_world = "World Channel(Error)",
        autoAdvise_guild = "Guild Channel",
        autoAdvise_text = "Auto-Advertise text",
        autoNotify_enable = "Enable Auto-Notify",
        autoNotify_text = "Auto-Notify text (Avoid sensitive words)",
        autoInvite_enable = "Enable Auto-Invite",
        autoInvite_whisper = "Whisper",
        autoInvite_bnetfriend = "Battle.net Friends",
        autoInvite_world = "World Channel",
        autoInvite_guild = "Guild Channel",
        autoInvite_text = "Auto-Invite Keywords (split by , or space)",
        autoInvite_convertRaid = "Auto Convert to Raid",
        autoInvite_assignA = "Auto Assign Assistant",
        autoInvite_freeforall = "Free for All Loot",
        autoInvite_lowlevelNotify = "Low Level Notification",
        raidFrameSwitchButton = "Raid\nFrame",
        convertButton = "Convert\nTo Raid",
        promoteAllButton = "PromoteAll\nToAssistant",
        demoteAllButton = "DemoteAll\nAssistants",
        promoteAllIncomplete = "The built-in Promote All to Assistant feature is incomplete",
        demoteAllIncomplete = "The built-in Demote All Assistants feature is incomplete",
        readyCheckButton = "Ready\nCheck",
        saveButton = "Save\nGroup",
        disbandButton = "Disband\nGroup",
        reInviteButton = "Re-invite\nGroup",
        invitehelperUISwitchButton = "Invite\nHelper",
        lowLevelWarning = "Warning! Low level member detected: %s, Team %d, Level: Lv.%d",
        autoNotifyWarning = "WorldPVPInviteHelper: You have enabled 'Auto NotifY' but you are not in a group or raid, cannot notify the group or raid!",
        convertToParty = "Convert\nTo Party",
        convertToParty1 = "Conv\nParty",
        groupListSaved = "Group member list has been cleared and saved again",
        convertToRaid = "Conv\nRaid",
        promoteAllToAssistant = "Promt\nAll",
        demoteAllAssistants = "Demt\nAll",
        saveGroup = "Save\nGrp",
        disbandGroup = "Disbd\nGrp",
        reInviteGroup = "ReInv\nGrp",
        inviteHelperTooltip = "Toggle Invite Helper UI",
        ffaConfirmTitle = "Confirm Enable Free for All",
        ffaConfirmText = "Enable Free for All loot?",
        ffaConfirmButton = "Confirm",
        ffaCancelButton = "Cancel",
        ffaLeaderConfirmText = "You have just become the raid leader.\nDo you want to set the raid's loot method to Free for All?",
    },
    ruRU = {
        addonName = "WorldPVP InviteHelper",
        autoAdviseHeader = "|cffffa012Авто-объявление|r",
        autoInviteHeader = "|cffffa012Авто-приглашение|r",
        groupFunctionHeader = "|cffffa012Функции группы|r",
        reInviteHeader = "|cffffa012Переприглашение группы|r|cffffffff丨Восстановление после смены слоя|r",
        autoAdvise_enable = "Включить авто-объявление",
        autoAdvise_world = "Мир (ошибка канала)",
        autoAdvise_guild = "Гильдия",
        autoAdvise_text = "Текст авто-объявления",
        autoNotify_enable = "Включить авто-уведомление группы",
        autoNotify_text = "Текст уведомления (избегайте запрещённых слов)",
        autoInvite_enable = "Включить авто-приглашение",
        autoInvite_whisper = "Личные сообщения",
        autoInvite_bnetfriend = "Друзья Battle.net",
        autoInvite_world = "Мир",
        autoInvite_guild = "Гильдия",
        autoInvite_text = "Ключевые слова для приглашения (через запятую или пробел)",
        autoInvite_convertRaid = "Автоматически переводить в рейд",
        autoInvite_assignA = "Автоматически назначать помощников",
        autoInvite_freeforall = "Свободный лут (Free for All)",
        autoInvite_lowlevelNotify = "Уведомление о низкоуровневых участниках",
        raidFrameSwitchButton = "Рейд\nФрейм",
        convertButton = "Перевод\nв рейд",
        promoteAllButton = "Все в\nпом.",
        demoteAllButton = "Снять всех\nпом.",
        promoteAllIncomplete = "Встроенная функция «Назначить всех помощниками» работает некорректно",
        demoteAllIncomplete = "Встроенная функция «Снять всех помощников» работает некорректно",
        readyCheckButton = "Готовность\nПроверка",
        saveButton = "Сохранить\nгруппу",
        disbandButton = "Расп.\nгруппу",
        reInviteButton = "Переп.\nгруппу",
        invitehelperUISwitchButton = "Invite\nHelper",
        lowLevelWarning = "Внимание! Обнаружен низкоуровневый участник: %s, Команда %d, Уровень: %d",
        autoNotifyWarning = "WorldPVPInviteHelper: Включено «Авто-уведомление», но вы не в группе или рейде — отправка невозможна!",
        convertToParty = "Перевод\nв группу",
        convertToParty1 = "В\nгруппу",
        groupListSaved = "Список участников очищен и сохранён заново",
        convertToRaid = "В\nрейд",
        promoteAllToAssistant = "Все в\nпом.",
        demoteAllAssistants = "Снять\nвсех",
        saveGroup = "Сохр.\nгруп.",
        disbandGroup = "Расп.\nгруп.",
        reInviteGroup = "Переп.\nгруп.",
        inviteHelperTooltip = "Открыть/скрыть интерфейс Invite Helper",
        ffaConfirmTitle = "Подтверждение включения свободного лута",
        ffaConfirmText = "Вы уверены, что хотите включить свободный лут (Free for All)?",
        ffaConfirmButton = "Подтвердить",
        ffaCancelButton = "Отмена",
        ffaLeaderConfirmText = "Вы только что стали лидером рейда.\n\nУстановить метод лута рейда на «Свободный лут»?",
    }
}

-- 获取客户端语言
local clientLocale = GetLocale()

-- 根据客户端语言选择合适的本地化表
local L

if clientLocale == "zhCN" or clientLocale == "zhTW" then
    L = locale.zhCN
elseif clientLocale == "ruRU" then
    L = locale.ruRU
else
    L = locale.enUS
end

----------------------------------------------------------------------------------------------

local function GetAddOnMetadataWrapper(addonName, field)
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        -- Retail 版本使用 C_AddOns.GetAddOnMetadata
        return C_AddOns.GetAddOnMetadata(addonName, field)
    else
        -- 其他版本使用 GetAddOnMetadata
        return GetAddOnMetadata(addonName, field)
    end
end

--三喵：修改菜单顺序，优化界面
local options = {
    name = L.addonName .. GetAddOnMetadataWrapper("WorldPVP_InviteHelper", "Version") .. " - 三喵 x 黯影乄八爷",
    handler = WorldPVP_InviteHelper,
    type = 'group',
    args = {

        introAutoAdvise = {
            name = L.autoAdviseHeader,
            type = "header",
            order = 0.1,
            width = "full"
        },
        autoAdvise_enable = {
            type = "toggle",
            order = 1,
            width = "full",
            name = L.autoAdvise_enable,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoAdvise_world = {
            type = "toggle",
            order = 2,
            name = L.autoAdvise_world,
            get = "GeneralGetter",
            set = "GeneralSetter",
            disabled = true  -- 禁用该复选框
        },
        autoAdvise_guild = {
            type = "toggle",
            order = 2.1,
            name = L.autoAdvise_guild,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoAdvise_text = {
            type = "input",
            --multiline = 5,
            order = 3,
            width = "full",
            name = L.autoAdvise_text,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },


        autoNotify_enable = {
            type = "toggle",
            order = 4,
            width = "full",
            name = L.autoNotify_enable,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoNotify_text = {
            type = "input",
            order = 5,
            width = "full",
            name = L.autoNotify_text,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },


        introAutoInvite = {
            name = L.autoInviteHeader,
            type = "header",
            order = 6.1,
            width = "full"
        },
        autoInvite_enable = {
            type = "toggle",
            order = 7,
            width = "full",
            name = L.autoInvite_enable,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoInvite_world = {
            type = "toggle",
            order = 8,
            name = L.autoInvite_world,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoInvite_guild = {
            type = "toggle",
            order = 8.1,
            name = L.autoInvite_guild,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoInvite_whisper = {
            type = "toggle",
            order = 9,
            name = L.autoInvite_whisper,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoInvite_bnetfriend = {
            type = "toggle",
            order = 9.1,
            name = L.autoInvite_bnetfriend,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoInvite_text = {
            type = "input",
            order = 10,
            width = "full",
            name = L.autoInvite_text,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },

        introGroupFunction = {
            name = L.groupFunctionHeader,
            type = "header",
            order = 10.5,
            width = "full"
        },

        autoInvite_convertRaid = {
            type = "toggle",
            order = 11,
            name = L.autoInvite_convertRaid,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoInvite_assignA = {
            type = "toggle",
            order = 12,
            name = L.autoInvite_assignA,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },
        autoInvite_freeforall = {
            type = "toggle",
            order = 13,
            name = L.autoInvite_freeforall,
            get = "GeneralGetter",
            set = "GeneralSetter",
            hidden = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE  -- 正式服中隐藏此选项
        },
        autoInvite_lowlevelNotify = {
            type = "toggle",
            order = 15,
            name = L.autoInvite_lowlevelNotify,
            get = "GeneralGetter",
            set = "GeneralSetter"
        },


        gap17 = {
            type = "description",
            name = " \n\n\n",
            width = "full",
            order = 17.1
        },

        introReInvite = {
            name = L.reInviteHeader,
            type = "header",
            order = 18,
            width = "full"
        }
    }
}

local defaults = {
    char = {
        autoInvite_enable = false,
        autoInvite_text = "123,998",
        autoInvite_whisper = true,
        autoInvite_bnetfriend = true,
        autoInvite_world = false,
        autoInvite_guild = true,
        autoInvite_convertRaid = false,
        autoInvite_assignA = true,
        autoInvite_freeforall = true,
        autoInvite_lowlevelNotify = true,

        autoAdvise_enable = false,
        autoAdvise_text = "公会活动，打998自动进组！",
        autoAdvise_world = false,
        autoAdvise_guild = true,

        autoNotify_enable = false,
        autoNotify_text = "丫丫123456, 必须上丫丫！",

        groupTable = {},  -- 三喵：持久化存储队伍数据

    }
}

function WorldPVP_InviteHelper:GeneralGetter(info)
    return self.db.char[info[#info]]
end

function WorldPVP_InviteHelper:GeneralSetter(info, newValue)
    self.db.char[info[#info]] = newValue
end

function WorldPVP_InviteHelper:CheckAndApplyFreeForAllLoot()
    -- 检查基本条件
    local isLeader = UnitIsGroupLeader("player")
    local ffaEnabled = self.db.char.autoInvite_freeforall
    local inRaid = UnitInRaid("player")
    
    if not isLeader or not ffaEnabled or not inRaid then
        return
    end
    
    -- 游戏版本判断：如果是正式服，不检查拾取方式，不弹出确认框
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        return
    end
    
    -- 获取当前拾取方式 - 兼容不同版本
    local lm = "group"  -- 默认假设不是自由拾取
    local foundMethod = false
    
    -- 方法1: 直接调用GetLootMethod
    if GetLootMethod and type(GetLootMethod) == "function" then
        local success, result = pcall(GetLootMethod)
        if success then
            lm = result
            foundMethod = true
        end
    end
    
    -- 方法2: 使用C_PartyInfo.GetLootMethod
    if not foundMethod and C_PartyInfo and C_PartyInfo.GetLootMethod then
        local success, result = pcall(C_PartyInfo.GetLootMethod)
        if success then
            -- 根据WoW API文档，拾取方式常量：
            -- LOOT_METHOD_FREEFORALL = 0
            -- LOOT_METHOD_ROUNDROBIN = 1  
            -- LOOT_METHOD_MASTER = 2
            -- LOOT_METHOD_GROUP = 3
            -- LOOT_METHOD_NEEDBEFOREGREED = 4
            -- LOOT_METHOD_PERSONALLOOT = 5
            if result == 0 then
                lm = "freeforall"
            elseif result == 1 then
                lm = "roundrobin"
            elseif result == 2 then
                lm = "master"
            elseif result == 3 then
                lm = "group"
            elseif result == 4 then
                lm = "needbeforegreed"
            elseif result == 5 then
                lm = "personal"
            else
                lm = "unknown"
            end
            foundMethod = true
        end
    end
    
    -- 如果当前不是自由拾取，显示确认对话框
    if lm ~= "freeforall" and not self.ffaConfirmShown then
        self.ffaConfirmShown = true
        
        -- 根据调用场景选择不同的确认对话框
        local dialogName = "WORLD_PVP_INVITEHELPER_FFA_CONFIRM"
        if self.lastLeaderChangeTime and (GetTime() - self.lastLeaderChangeTime) < 2 then
            dialogName = "WORLD_PVP_INVITEHELPER_FFA_LEADER_CONFIRM"
        end
        
        if not StaticPopupDialogs[dialogName] then
            StaticPopupDialogs[dialogName] = {
                text = (dialogName == "WORLD_PVP_INVITEHELPER_FFA_LEADER_CONFIRM") and L.ffaLeaderConfirmText or L.ffaConfirmText,
                button1 = L.ffaConfirmButton,
                button2 = L.ffaCancelButton,
                OnAccept = function()
                    -- 尝试多种API设置自由拾取
                    local success = false
                    
                    -- 方法1: 直接调用SetLootMethod
                    if SetLootMethod and type(SetLootMethod) == "function" then
                        local s, _ = pcall(SetLootMethod, "freeforall")
                        success = s
                    end
                    
                    -- 方法2: 使用C_PartyInfo.SetLootMethod (如果存在)
                    if not success and C_PartyInfo and C_PartyInfo.SetLootMethod then
                        -- 尝试设置为自由拾取 (0 = freeforall)
                        local s, _ = pcall(C_PartyInfo.SetLootMethod, 0)
                        success = s
                    end
                    
                    self.ffaConfirmShown = false
                end,
                OnCancel = function()
                    self.ffaConfirmShown = false
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,
            }
        end
        StaticPopup_Show(dialogName)
    end
end



function WorldPVP_InviteHelper:Debug(...)
    if self.debug then
        self:Print(...)
    end
end

----------------------------------------

function InviteHelperToggleOptions()
   if WorldPVP_InviteHelperConfigFrame:IsShown() then
        WorldPVP_InviteHelperConfigFrame:Hide()
    else
        WorldPVP_InviteHelperConfigFrame:Show()
    end
end

----------------------------------------

WorldPVP_InviteHelper:RegisterChatCommand("winvitehelper", "ChatCommand")
WorldPVP_InviteHelper:RegisterChatCommand("wih", "ChatCommand")
function WorldPVP_InviteHelper:ChatCommand(input)
    if input == "test" then
        self:Print("手动触发自由拾取检查...")
        self:CheckAndApplyFreeForAllLoot()
    elseif input == "debug" then
        self.debug = not self.debug
        self:Print("调试模式: " .. (self.debug and "开启" or "关闭"))
    elseif input == "version" then
        self:Print("=== 版本信息 ===")
        self:Print("WOW_PROJECT_ID: " .. (WOW_PROJECT_ID or "nil"))
        self:Print("BuildInfo: " .. (GetBuildInfo and GetBuildInfo() or "nil"))
        local buildVersion = select(4, GetBuildInfo()) or 0
        self:Print("Build Version: " .. buildVersion)
    elseif input == "testinvite" then
        local playerName = UnitName("player")
        if playerName then
            self:CHAT_MSG_WHISPER("CHAT_MSG_WHISPER", self.db.char.autoInvite_text or "123", playerName)
        else
            self:CHAT_MSG_WHISPER("CHAT_MSG_WHISPER", self.db.char.autoInvite_text or "123", "测试玩家")
        end
    elseif input == "testbn" then
        local playerName = UnitName("player")
        if playerName then
            self:CHAT_MSG_BN_WHISPER("CHAT_MSG_BN_WHISPER", self.db.char.autoInvite_text or "123", playerName, nil, nil, nil, nil, nil, nil, nil, nil, 12345, nil, 123456, false)
        end
    else
        InviteHelperToggleOptions()
    end
end

----------------------------------------

WorldPVP_InviteHelper:RegisterChatCommand("rl", "ReloadUI")
function WorldPVP_InviteHelper:ReloadUI()
    ReloadUI()
end

----------------------------------------
--三喵：先定义一个插件通用的tooltip才能用

InviteHelperTooltip = InviteHelperTooltip or CreateFrame("GameTooltip", "InviteHelperTooltip", UIParent, "GameTooltipTemplate")

----------------------------------------
--双版本参数wrapper区
----------------------------------------

local function ConvertToRaidWrapper()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        -- 正式服使用 C_PartyInfo.ConvertToRaid()
        C_PartyInfo.ConvertToRaid()
    else
        -- 其他版本使用 ConvertToRaid()
        ConvertToRaid()
    end
end

local function ConvertToPartyWrapper()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        -- 正式服使用 C_PartyInfo.ConvertToParty()
        C_PartyInfo.ConvertToParty()
    else
        -- 其他版本使用 ConvertToParty()
        ConvertToParty()
    end
end

-- 判断当前游戏版本并选择正确的 Tab
local function ClickFriendsFrameRaidTab()
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        -- 正式服使用 FriendsFrameTab3
        FriendsFrameTab3:Click()
    else
        -- 其他版本使用 FriendsFrameTab4
        FriendsFrameTab4:Click()
    end
end

-- 定义一个包装函数来兼容不同版本的 InviteUnit
local function InviteUnitWrapper(name)
    -- 泰坦时光服特殊处理
    local buildVersion = select(4, GetBuildInfo()) or 0
    local isTitanServer = (buildVersion == 38000)
    
    if isTitanServer then
        -- 泰坦时光服：优先使用 C_PartyInfo.InviteUnit
        local cleanName = name
        
        -- 移除可能的服务器后缀
        if string.find(cleanName, "-") then
            cleanName = string.match(cleanName, "^([^-]+)")
        end
        
        -- 移除前后空格
        cleanName = string.match(cleanName, "^%s*(.-)%s*$") or cleanName
        
        -- 泰坦时光服：直接使用正确的API
        C_PartyInfo.InviteUnit(cleanName)
        
    elseif WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        -- 正式服使用 C_PartyInfo.InviteUnit
        C_PartyInfo.InviteUnit(name)
    else
        -- 其他版本使用 InviteUnit
        InviteUnit(name)
    end
end

----------------------------------------

function WorldPVP_InviteHelper:OnEnable()

    self.debug = false  -- 恢复正常状态
    
    self.db = LibStub("AceDB-3.0"):New("WorldPVP_InviteHelper", defaults, true)
    
    -- 强制将自动广告下的世界频道一项设置为false
    self.db.char.autoAdvise_world = false
    
    -- 用于跟踪自由拾取确认对话框是否已显示
    self.ffaConfirmShown = false
    
    -- 跟踪团队状态变化
    self.lastInRaidState = UnitInRaid("player")
    self.lastLeaderState = UnitIsGroupLeader("player")

    LibStub("AceConfig-3.0"):RegisterOptionsTable("WorldPVP_InviteHelper", options)
    --self.optionsFrame = LibStub("AceConfigDialog-3.0")--:AddToBlizOptions("WorldPVP_InviteHelper", L["plugin_name"])  --三喵：只作为附属插件，不添加独立菜单

    -- start timers
    self.notifyTimer = self:ScheduleRepeatingTimer("TimerNotify", 10)

    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("CHAT_MSG_GUILD")
    self:RegisterEvent("CHAT_MSG_CHANNEL")
    self:RegisterEvent("CHAT_MSG_BN_WHISPER")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    self:RegisterEvent("UNIT_LEVEL")


--三喵：创建可被主插件识别的窗口

    ---@type AceGUIFrame, AceGUIFrame
    local configFrame = AceGUI:Create("Frame")
    configFrame:Hide()
    AceConfigDialog:SetDefaultSize("WorldPVP_InviteHelper", 400, 605)
    AceConfigDialog:Open("WorldPVP_InviteHelper", configFrame)
    configFrame:SetLayout("Fill")
    configFrame:EnableResize(false)
    configFrame:Hide()

    WorldPVP_InviteHelperConfigFrame = configFrame
    table.insert(UISpecialFrames, "WorldPVP_InviteHelperConfigFrame")

--三喵：创建可被主插件识别的窗口



--三喵：按钮开始

--三喵：RaidFrame开关-UI
    local RaidFrameSwitchButton = CreateFrame("Button", nil, configFrame.frame, "UIPanelButtonTemplate")
    RaidFrameSwitchButton:SetWidth(75)
    RaidFrameSwitchButton:SetHeight(36)
    RaidFrameSwitchButton:SetPoint("TOPLEFT", configFrame.frame, "TOPLEFT", 17, -453)
    RaidFrameSwitchButton:SetText(L.raidFrameSwitchButton)
    RaidFrameSwitchButton:SetScript(
    "OnMouseDown",
        function()
            if FriendsFrame:IsShown() then
                HideUIPanel(FriendsFrame)
            else
                ShowUIPanel(FriendsFrame)
                ClickFriendsFrameRaidTab()
            end
        end
    )

--三喵：转化为团队/小队-UI
    local ConvertButton = CreateFrame("Button", nil, RaidFrameSwitchButton, "UIPanelButtonTemplate")
    ConvertButton:SetWidth(75)
    ConvertButton:SetHeight(36)
    ConvertButton:SetPoint("LEFT", RaidFrameSwitchButton, "RIGHT", -2, 0)
    ConvertButton:SetScript(
    "OnUpdate",
        function()
            if not IsInRaid() then
                ConvertButton:SetText(L.convertButton)
            else ConvertButton:SetText(L.convertToParty)
        end
    end
    )
    ConvertButton:SetScript(
    "OnMouseDown",
        function()
            if not IsInRaid() then
                ConvertToRaidWrapper()
            else ConvertToPartyWrapper()
        end
    end
    )


--三喵：全团给A-UI
    local PromoteAllButton = CreateFrame("Button", nil, ConvertButton, "UIPanelButtonTemplate")
    PromoteAllButton:SetWidth(75)
    PromoteAllButton:SetHeight(36)
    PromoteAllButton:SetPoint("LEFT", ConvertButton, "RIGHT", -2, -0)
    PromoteAllButton:SetText(L.promoteAllButton)
    PromoteAllButton:SetScript(
    "OnMouseDown",
        function()
            local n = GetNumGroupMembers() or 0
            local myname = UnitName("player")
            for j=n,1,-1 do
                local nown = GetNumGroupMembers() or 0
                if nown > 0 then
                    local name, rank = GetRaidRosterInfo(j)
                    if name and myname ~= name then
                        PromoteToAssistant(name)
                    end
                end
            end
        end
    )
    PromoteAllButton:SetScript(
    "OnEnter",
        function()
            InviteHelperTooltip:SetOwner(PromoteAllButton, "ANCHOR_TOPLEFT")
            InviteHelperTooltip:SetText(L.promoteAllIncomplete)
            InviteHelperTooltip:Show()
        end
    )
    PromoteAllButton:SetScript(
    "OnLeave",
        function()
            InviteHelperTooltip:Hide()
        end
    )


--三喵：全团收A-UI
    local DemoteAllButton = CreateFrame("Button", nil, PromoteAllButton, "UIPanelButtonTemplate")
    DemoteAllButton:SetWidth(75)
    DemoteAllButton:SetHeight(36)
    DemoteAllButton:SetPoint("LEFT", PromoteAllButton, "RIGHT", -2, 0)
    DemoteAllButton:SetText(L.demoteAllButton)
    DemoteAllButton:SetScript(
    "OnMouseDown",
        function()
            local n = GetNumGroupMembers() or 0
            local myname = UnitName("player")
            for j=n,1,-1 do
                local nown = GetNumGroupMembers() or 0
                if nown > 0 then
                    local name, rank = GetRaidRosterInfo(j)
                    if name and myname ~= name then
                        DemoteAssistant(name)
                    end
                end
            end
        end
    )
    DemoteAllButton:SetScript(
    "OnEnter",
        function()
            InviteHelperTooltip:SetOwner(DemoteAllButton, "ANCHOR_TOPLEFT")
            InviteHelperTooltip:SetText(L.demoteAllIncomplete)
            InviteHelperTooltip:Show()
        end
    )
    DemoteAllButton:SetScript(
    "OnLeave",
        function()
            InviteHelperTooltip:Hide()
        end
    )


--三喵：就位确认-UI
    local ReadyCheckButton = CreateFrame("Button", nil, DemoteAllButton, "UIPanelButtonTemplate")
    ReadyCheckButton:SetWidth(75)
    ReadyCheckButton:SetHeight(36)
    ReadyCheckButton:SetPoint("LEFT", DemoteAllButton, "RIGHT", -2, 0)
    ReadyCheckButton:SetText(L.readyCheckButton)
    ReadyCheckButton:SetScript(
    "OnMouseDown",
        function()
            DoReadyCheck()
        end
    )



--三喵：重组队伍模块 开始

--三喵：以下为主界面上的按钮

--三喵：保存队伍-UI
    local SaveButton = CreateFrame("Button", nil, configFrame.frame, "UIPanelButtonTemplate")
    SaveButton:SetWidth(90)
    SaveButton:SetHeight(36)
    SaveButton:SetPoint("TOPLEFT", configFrame.frame, "TOPLEFT", 17, -523)
    SaveButton:SetText(L.saveButton)
    SaveButton:SetScript(
    "OnMouseDown",
        function()
            table.wipe(self.db.char.groupTable)
            local n = GetNumGroupMembers() or 0
            for j=1,n do
                local name = GetRaidRosterInfo(j)
                table.insert(self.db.char.groupTable, name)
            end
            print(L.groupListSaved)
        end
    )

--三喵：解散队伍-UI
    local DisbandButton = CreateFrame("Button", nil, SaveButton, "UIPanelButtonTemplate")
    DisbandButton:SetWidth(90)
    DisbandButton:SetHeight(36)
    DisbandButton:SetPoint("LEFT", SaveButton, "RIGHT", 48, 0)
    DisbandButton:SetText(L.disbandButton)
    DisbandButton:SetScript(
    "OnMouseDown",
        function()
            local n = GetNumGroupMembers() or 0
            local myname = UnitName("player")
            for j=n,1,-1 do
                local nown = GetNumGroupMembers() or 0
                if nown > 0 then
                    local name, rank = GetRaidRosterInfo(j)
                    if name and myname ~= name then
                        UninviteUnit(name)
                    end
                end
            end
        end
    )

--三喵：重组队伍-UI
    local ReInviteButton = CreateFrame("Button", nil, DisbandButton, "UIPanelButtonTemplate")
    ReInviteButton:SetWidth(90)
    ReInviteButton:SetHeight(36)
    ReInviteButton:SetPoint("LEFT", DisbandButton, "RIGHT", 48, 0)
    ReInviteButton:SetText(L.reInviteButton)
    ReInviteButton:SetScript(
    "OnMouseDown",
        function()
            for i=1,#self.db.char.groupTable do
            InviteUnitWrapper(self.db.char.groupTable[i])  -- 使用包装函数
            end
        end
    )

--三喵：重组队伍模块 结束
    



--三喵：以下为RaidFrame界面的一排按钮
--按钮的书写顺序要严格遵循生成顺序，不然无效，所以全部收集于此。

--转化为团队/小队-RaidFrame
    local ConvertButton2 = CreateFrame("Button", nil, FriendsFrameCloseButton, "UIPanelButtonTemplate")
    ConvertButton2:SetWidth(42)
    ConvertButton2:SetHeight(42)
    ConvertButton2:SetPoint("BOTTOMLEFT", FriendsFrameCloseButton, "TOPLEFT", -262, -5)
    ConvertButton2:SetScript(
    "OnUpdate",
        function()
            if not IsInRaid() then
                ConvertButton2:SetText(L.convertToRaid)
            else ConvertButton2:SetText(L.convertToParty1)
        end
    end
    )
    ConvertButton2:SetScript(
    "OnMouseDown",
        function()
            if not IsInRaid() then
                ConvertToRaidWrapper()
            else ConvertToPartyWrapper()
        end
    end
    )

--三喵：全团给A-RaidFrame
    local PromoteAllButton2 = CreateFrame("Button", nil, ConvertButton2, "UIPanelButtonTemplate")
    PromoteAllButton2:SetWidth(42)
    PromoteAllButton2:SetHeight(42)
    PromoteAllButton2:SetPoint("LEFT", ConvertButton2, "RIGHT", 2, 0)
    PromoteAllButton2:SetText(L.promoteAllToAssistant)
    PromoteAllButton2:SetScript(
    "OnMouseDown",
        function()
            local n = GetNumGroupMembers() or 0
            local myname = UnitName("player")
            for j=n,1,-1 do
                local nown = GetNumGroupMembers() or 0
                if nown > 0 then
                    local name, rank = GetRaidRosterInfo(j)
                    if name and myname ~= name then
                        PromoteToAssistant(name)
                    end
                end
            end
        end
    )
    PromoteAllButton2:SetScript(
    "OnEnter",
        function()
            InviteHelperTooltip:SetOwner(PromoteAllButton2, "ANCHOR_TOPLEFT")
            InviteHelperTooltip:SetText(L.promoteAllIncomplete)
            InviteHelperTooltip:Show()
        end
    )
    PromoteAllButton2:SetScript(
    "OnLeave",
        function()
            InviteHelperTooltip:Hide()
        end
    )

--三喵：全团收A-RaidFrame
    local DemoteAllButton2 = CreateFrame("Button", nil, PromoteAllButton2, "UIPanelButtonTemplate")
    DemoteAllButton2:SetWidth(42)
    DemoteAllButton2:SetHeight(42)
    DemoteAllButton2:SetPoint("LEFT", PromoteAllButton2, "RIGHT", -4, 0)
    DemoteAllButton2:SetText(L.demoteAllAssistants)
    DemoteAllButton2:SetScript(
    "OnMouseDown",
        function()
            local n = GetNumGroupMembers() or 0
            local myname = UnitName("player")
            for j=n,1,-1 do
                local nown = GetNumGroupMembers() or 0
                if nown > 0 then
                    local name, rank = GetRaidRosterInfo(j)
                    if name and myname ~= name then
                        DemoteAssistant(name)
                    end
                end
            end
        end
    )
    DemoteAllButton2:SetScript(
    "OnEnter",
        function()
            InviteHelperTooltip:SetOwner(DemoteAllButton2, "ANCHOR_TOPLEFT")
            InviteHelperTooltip:SetText(L.demoteAllIncomplete)
            InviteHelperTooltip:Show()
        end
    )
    DemoteAllButton2:SetScript(
    "OnLeave",
        function()
            InviteHelperTooltip:Hide()
        end
    )

--三喵：保存队伍-RaidFrame
    local SaveButton2 = CreateFrame("Button", nil, DemoteAllButton2, "UIPanelButtonTemplate")
    SaveButton2:SetWidth(42)
    SaveButton2:SetHeight(42)
    SaveButton2:SetPoint("LEFT", DemoteAllButton2, "RIGHT", 2, 0)
    SaveButton2:SetText(L.saveGroup)
    SaveButton2:SetScript(
    "OnMouseDown",
        function()
            table.wipe(self.db.char.groupTable)
            local n = GetNumGroupMembers() or 0
            for j=1,n do
                local name = GetRaidRosterInfo(j)
                table.insert(self.db.char.groupTable, name)
            end
            print(L.groupListSaved)
        end
    )

--三喵：解散队伍-RaidFrame
    local DisbandButton2 = CreateFrame("Button", nil, SaveButton2, "UIPanelButtonTemplate")
    DisbandButton2:SetWidth(42)
    DisbandButton2:SetHeight(42)
    DisbandButton2:SetPoint("LEFT", SaveButton2, "RIGHT", -4, 0)
    DisbandButton2:SetText(L.disbandGroup)
    DisbandButton2:SetScript(
    "OnMouseDown",
        function()
            local n = GetNumGroupMembers() or 0
            local myname = UnitName("player")
            for j=n,1,-1 do
                local nown = GetNumGroupMembers() or 0
                if nown > 0 then
                    local name, rank = GetRaidRosterInfo(j)
                    if name and myname ~= name then
                        UninviteUnit(name)
                    end
                end
            end
        end
    )

--三喵：重组队伍-RaidFrame
    local ReInviteButton2 = CreateFrame("Button", nil, DisbandButton2, "UIPanelButtonTemplate")
    ReInviteButton2:SetWidth(42)
    ReInviteButton2:SetHeight(42)
    ReInviteButton2:SetPoint("LEFT", DisbandButton2, "RIGHT", -4, 0)
    ReInviteButton2:SetText(L.reInviteGroup)
    ReInviteButton2:SetScript(
    "OnMouseDown",
        function()
            for i=1,#self.db.char.groupTable do
            InviteUnitWrapper(self.db.char.groupTable[i])  -- 使用包装函数
            end
        end
    )

--三喵：开/关组队助手界面-RaidFrame
    local InvitehelperUISwitchButton = CreateFrame("Button", nil, ReInviteButton2, "UIPanelButtonTemplate")
    InvitehelperUISwitchButton:SetWidth(42)
    InvitehelperUISwitchButton:SetHeight(42)
    InvitehelperUISwitchButton:SetPoint("LEFT", ReInviteButton2, "RIGHT", 2, 0)
    InvitehelperUISwitchButton:SetText(L.invitehelperUISwitchButton)
    InvitehelperUISwitchButton:SetScript(
        "OnEnter",
            function()
                InviteHelperTooltip:SetOwner(InvitehelperUISwitchButton, "ANCHOR_TOPLEFT")
                InviteHelperTooltip:SetText(L.inviteHelperTooltip)
                InviteHelperTooltip:Show()
            end
        )
    InvitehelperUISwitchButton:SetScript(
        "OnLeave",
            function()
                InviteHelperTooltip:Hide()
            end
        )
    InvitehelperUISwitchButton:SetScript(
        "OnMouseDown",
            function()
                InviteHelperToggleOptions()
            end
        )



end


function WorldPVP_InviteHelper:DoAdvise()
    -- 完全避免在TimerNotify中直接调用DoAdvise
    -- 改为在TimerNotify中安全地触发消息发送
end

-- 新的安全消息发送函数
function WorldPVP_InviteHelper:SafeDoAdvise()
    -- 公会消息发送
    if (self.db.char.autoAdvise_guild) then
        -- 使用多重安全检查的延迟执行
        C_Timer.After(1.0, function()
            -- 第一层安全检查
            if InCombatLockdown() then
                -- 如果仍在战斗中，延迟更长时间
                C_Timer.After(3.0, function()
                    -- 第二层安全检查
                    if not InCombatLockdown() then
                        -- 使用pcall安全执行
                        local success, err = pcall(function()
                            -- 最终安全检查
                            if not InCombatLockdown() then
                                SendChatMessage(self.db.char.autoAdvise_text, "GUILD")
                            end
                        end)
                        if not success then
                            -- 记录错误但不重试
                            self:Debug("公会消息发送失败:", err)
                        end
                    end
                end)
            else
                -- 如果不在战斗中，直接安全执行
                local success, err = pcall(function()
                    if not InCombatLockdown() then
                        SendChatMessage(self.db.char.autoAdvise_text, "GUILD")
                    end
                end)
                if not success then
                    self:Debug("公会消息发送失败:", err)
                end
            end
        end)
    end
    
    -- 世界频道消息发送
    if (self.db.char.autoAdvise_world) then
        self:Debug("准备发送世界频道广告...")
        
        -- 使用多重安全检查的延迟执行
        C_Timer.After(1.0, function()
            -- 第一层安全检查
            if InCombatLockdown() then
                -- 如果仍在战斗中，延迟更长时间
                C_Timer.After(3.0, function()
                    -- 第二层安全检查
                    if not InCombatLockdown() then
                        -- 使用pcall安全执行
                        local success, err = pcall(function()
                            -- 最终安全检查
                            if not InCombatLockdown() then
                                -- 精确发送到大脚世界频道
                                local channelNum = 4  -- 大脚世界频道通常是频道4
                                
                                -- 验证频道名称是否匹配
                                local channelName = GetChannelName(channelNum)
                                if channelName and (string.find(string.lower(channelName), "大脚") or string.find(string.lower(channelName), "bigfoot")) then
                                    SendChatMessage(self.db.char.autoAdvise_text, "CHANNEL", nil, channelNum)
                                else
                                    -- 如果频道4不是大脚世界频道，尝试寻找正确的频道
                                    for i = 1, 10 do
                                        local testChannelName = GetChannelName(i)
                                        if testChannelName and (string.find(string.lower(testChannelName), "大脚") or string.find(string.lower(testChannelName), "bigfoot")) then
                                            SendChatMessage(self.db.char.autoAdvise_text, "CHANNEL", nil, i)
                                            return
                                        end
                                    end
                                    -- 如果找不到大脚世界频道，使用默认的频道4
                                    SendChatMessage(self.db.char.autoAdvise_text, "CHANNEL", nil, 4)
                                end
                            end
                        end)
                        if not success then
                            -- 记录错误但不重试
                            self:Debug("世界频道消息发送失败:", err)
                        end
                    end
                end)
            else
                -- 如果不在战斗中，直接安全执行
                local success, err = pcall(function()
                    if not InCombatLockdown() then
                        -- 精确发送到大脚世界频道
                        local channelNum = 4  -- 大脚世界频道通常是频道4
                        
                        -- 验证频道名称是否匹配
                        local channelName = GetChannelName(channelNum)
                        if channelName and (string.find(string.lower(channelName), "大脚") or string.find(string.lower(channelName), "bigfoot")) then
                            SendChatMessage(self.db.char.autoAdvise_text, "CHANNEL", nil, channelNum)
                        else
                            -- 如果频道4不是大脚世界频道，尝试寻找正确的频道
                            for i = 1, 10 do
                                local testChannelName = GetChannelName(i)
                                if testChannelName and (string.find(string.lower(testChannelName), "大脚") or string.find(string.lower(testChannelName), "bigfoot")) then
                                    SendChatMessage(self.db.char.autoAdvise_text, "CHANNEL", nil, i)
                                    return
                                end
                            end
                            -- 如果找不到大脚世界频道，使用默认的频道4
                            SendChatMessage(self.db.char.autoAdvise_text, "CHANNEL", nil, 4)
                        end
                    end
                end)
                if not success then
                    self:Debug("世界频道消息发送失败:", err)
                end
            end
        end)
    end
end

function WorldPVP_InviteHelper:TimerNotify()
    -- print("5 seconds passed")
    
    -- 安全的消息发送函数
    local function safeSendMessages()
        -- 确保不在受保护的环境中
        if InCombatLockdown() then
            return false
        end
        
        -- 使用更安全的发送方式
        local success, err = pcall(function()
            -- 额外的安全检查
            if InCombatLockdown() then
                return false
            end
            
            if (self.db.char.autoNotify_enable) then
                local isInGroup = false

                -- 判断当前游戏版本
                if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
                    -- 正式服（Retail）
                    isInGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid() or IsInGroup()
                else
                    -- 经典旧世或怀旧服
                    isInGroup = IsInGroup() or IsInRaid()
                end

                if isInGroup then
                    -- 再次检查战斗状态
                    if not InCombatLockdown() then
                        SendChatMessage(self.db.char.autoNotify_text,
                            IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
                    end
                else
                    -- 输出自定义提示信息到当前聊天窗口
                    local message = L.autoNotifyWarning
                    local chatFrame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME
                    chatFrame:AddMessage(message)
                end
            end
            
            if (self.db.char.autoAdvise_enable) then
                self:SafeDoAdvise()
            end
            
            return true
        end)
        
        return success and not InCombatLockdown()
    end
    
    -- 多重安全检查：先检查战斗状态，再尝试发送
    if InCombatLockdown() then
        -- 如果在战斗中，延迟更长的时间
        C_Timer.After(5.0, safeSendMessages)
    else
        -- 尝试立即发送，如果失败则延迟重试
        local immediateSuccess = safeSendMessages()
        if not immediateSuccess then
            C_Timer.After(5.0, safeSendMessages)
        end
    end
end

function WorldPVP_InviteHelper:CHAT_MSG_CHANNEL(event, msg, sender, _, _, _, _, _, channelNumber, channelName)
    if (self.db.char.autoInvite_enable and self.db.char.autoInvite_world) then
        -- 世界频道识别逻辑：支持多种世界频道格式
        local isWorldChannel = false
        
        -- 检查频道名称是否包含世界频道关键词
        if channelName then
            -- 常见世界频道关键词（包括英文和中文）
            local worldChannelKeywords = {
                "大脚世界频道", "大脚世界頻道", 
                "世界频道", "世界頻道",
                "General", "综合", "綜合", "Общий",
                "Trade", "交易", 
                "LookingForGroup", "lfg", "寻求组队", "尋求組隊" 
            }
            
            local channelNameLower = string.lower(channelName)
            for _, keyword in ipairs(worldChannelKeywords) do
                if string.find(channelNameLower, string.lower(keyword)) then
                    isWorldChannel = true
                    break
                end
            end
            
            -- 另外检查特定频道编号（世界频道通常是1-4）
            if not isWorldChannel and channelNumber then
                if channelNumber >= 1 and channelNumber <= 4 then
                    isWorldChannel = true
                end
            end
        end
        
        -- 如果是世界频道，处理邀请逻辑
        if isWorldChannel then
            -- 支持中文逗号、英文逗号和空格作为分隔符
            local cleanedText = string.gsub(self.db.char.autoInvite_text, "[，, ]+", ",")
            local tokenArray = {strsplit(",", cleanedText)}
            if #tokenArray >= 1 then
                for idx, token in pairs(tokenArray) do
                    -- 去除关键词前后空格
                    local cleanToken = string.match(token, "^%s*(.-)%s*$")
                    if cleanToken and string.upper(msg) == string.upper(cleanToken) and sender ~= UnitName("player") then
                        self:Debug("在世界频道邀请 " .. sender .. " - 频道: " .. (channelName or "未知"))
                        InviteUnitWrapper(sender)
                        break
                    end
                end
            end
        end
    end
end

function WorldPVP_InviteHelper:CHAT_MSG_WHISPER(event, msg, sender)
    if (self.db.char.autoInvite_enable and self.db.char.autoInvite_whisper) then
        -- 支持中文逗号、英文逗号和空格作为分隔符
        local cleanedText = string.gsub(self.db.char.autoInvite_text, "[，, ]+", ",")
        local tokenArray = {strsplit(",", cleanedText)}
        
        if #tokenArray >= 1 then
            for idx, token in pairs(tokenArray) do
                -- 去除关键词前后空格
                local cleanToken = string.match(token, "^%s*(.-)%s*$")
                
                if cleanToken and string.upper(msg) == string.upper(cleanToken) then
                    InviteUnitWrapper(sender)
                    break
                end
            end
        end
    end
end

function WorldPVP_InviteHelper:CHAT_MSG_BN_WHISPER(event, msg, sender, _, _, _, _, _, _, _, _, lineID, guid, bnSenderID, isMobile)
    -- 防止重复处理同一消息（每个聊天标签都会触发）
    if self.lastBNLineID and self.lastBNLineID == lineID then
        return
    end
    self.lastBNLineID = lineID
    
    if (self.db.char.autoInvite_enable and self.db.char.autoInvite_bnetfriend) then
        -- 支持中文逗号、英文逗号和空格作为分隔符
        local cleanedText = string.gsub(self.db.char.autoInvite_text, "[，, ]+", ",")
        local tokenArray = {strsplit(",", cleanedText)}
        
        if #tokenArray >= 1 then
            for idx, token in pairs(tokenArray) do
                -- 去除关键词前后空格
                local cleanToken = string.match(token, "^%s*(.-)%s*$")
                
                if cleanToken and string.upper(msg) == string.upper(cleanToken) then
                    -- 优先使用C_BattleNet获取准确的角色信息
                    local characterName = nil
                    local realmName = ""
                    
                    -- 方法1: 尝试使用C_BattleNet.GetAccountInfoByID（如果可用）
                    if C_BattleNet and C_BattleNet.GetAccountInfoByID then
                        local accountInfo = C_BattleNet.GetAccountInfoByID(bnSenderID)
                        if accountInfo and accountInfo.gameAccountInfo then
                            -- 确保是WoW客户端
                            if accountInfo.gameAccountInfo.clientProgram and accountInfo.gameAccountInfo.clientProgram ~= "WoW" then
                                return
                            end
                            if accountInfo.gameAccountInfo.characterName then
                                characterName = accountInfo.gameAccountInfo.characterName
                            end
                            if accountInfo.gameAccountInfo.realmName then
                                realmName = accountInfo.gameAccountInfo.realmName
                            end
                        end
                    end
                    
                    -- 方法2: 使用BNGetFriendInfo作为备选
                    if not characterName then
                        local numFriends = BNGetNumFriends()
                        
                        for i = 1, numFriends do
                            local presenceID, givenName, surname, battleTag, isBattleTagFriend, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(i)
                            
                            if presenceID == bnSenderID then
                                -- 优先使用在线角色名
                                if isOnline and toonName and toonName ~= "" then
                                    characterName = toonName
                                    break
                                end
                            end
                        end
                    end
                    
                    -- 方法3: 如果仍然没有角色名，使用发送者名
                    if not characterName and sender and sender ~= "" then
                        characterName = sender
                        
                        -- 如果发送者名包含服务器信息，提取纯角色名
                        if string.find(characterName, "-") then
                            characterName = string.match(characterName, "^([^-]+)")
                        end
                    end
                    
                    -- 构建完整的邀请目标（角色名-服务器名）
                    local inviteTarget = characterName
                    if characterName and realmName and realmName ~= "" then
                        inviteTarget = characterName .. "-" .. realmName
                    elseif characterName then
                        inviteTarget = characterName
                    end
                    
                    -- 执行邀请
                    if inviteTarget and inviteTarget ~= "" then
                        InviteUnitWrapper(inviteTarget)
                    else
                    end
                    
                    return
                end
            end
        end
    end
end

function WorldPVP_InviteHelper:CHAT_MSG_GUILD(event, msg, sender)
    if (self.db.char.autoInvite_enable and self.db.char.autoInvite_guild) then
        -- 支持中文逗号、英文逗号和空格作为分隔符
        local cleanedText = string.gsub(self.db.char.autoInvite_text, "[，, ]+", ",")
        local tokenArray = {strsplit(",", cleanedText)}
        if #tokenArray >= 1 then
            for idx, token in pairs(tokenArray) do
                -- 去除关键词前后空格
                local cleanToken = string.match(token, "^%s*(.-)%s*$")
                if cleanToken and string.upper(msg) == string.upper(cleanToken) and sender ~= UnitName("player") then
                    self:Debug("Invite " .. sender)
                    InviteUnitWrapper(sender)
                    break
                end
            end
        end
    end
end

function WorldPVP_InviteHelper:CheckLowLevelMembers()
    -- 小号检查 - 在队伍成员变化时检查所有成员
    if self.db.char.autoInvite_lowlevelNotify then
        -- 检查是否在副本中 - 在副本中不进行低等级号通报
        local inInstance = false
        local _, instanceType = IsInInstance()
        if instanceType and instanceType ~= "none" then
            inInstance = true
            self:Debug("在副本中，跳过低等级号检查: " .. (instanceType or "unknown"))
        end
        
        -- 额外检查：检测随机副本系统
        -- 经典怀旧服的随机副本可能不会通过IsInInstance正确检测
        local inRandomDungeon = false
        
        -- 方法1：检查是否在LFG队伍中
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            inRandomDungeon = true
            self:Debug("检测到副本队伍，跳过低等级号检查")
        end
        
        -- 方法2：尝试检测LFG状态（如果API可用）
        if LFGParentFrame and LFGParentFrame:IsShown() then
            inRandomDungeon = true
            self:Debug("检测到LFG界面显示，跳过低等级号检查")
        end
        
        -- 方法3：检查队伍状态是否与常规队伍不同
        -- 在随机副本中，常规队伍人数可能为0或1
        local homePartyCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
        local instancePartyCount = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
        
        if instancePartyCount > homePartyCount then
            inRandomDungeon = true
            self:Debug(string.format("副本队伍(%d)多于常规队伍(%d)，可能是随机副本", instancePartyCount, homePartyCount))
        end
        
        -- 如果在任意类型副本中，直接返回，不进行低等级号通报
        if inInstance or inRandomDungeon then
            return
        end
        
        local maxLevel = GetMaxPlayerLevel()
        
        -- 安全检查：确保在队伍中才执行
        local inInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
        local inHomeGroup = IsInGroup(LE_PARTY_CATEGORY_HOME)
        
        -- 检查团队中的成员
        if IsInRaid() then
            -- 使用安全检查，避免在副本队伍中调用团队API
            local numMembers = GetNumGroupMembers()
            if numMembers and numMembers > 0 then
                for i = 1, numMembers do
                    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
                    if name and online and level < maxLevel then
                        local msg = string.format(L.lowLevelWarning, name, subgroup or 1, level)
                        -- 安全发送消息，避免在副本队伍中发送到错误频道
                        if inInstanceGroup then
                            -- 在副本队伍中，发送到副本频道
                            local success = pcall(function()
                                if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
                                    SendChatMessage(msg, 'INSTANCE_CHAT_LEADER')
                                else
                                    SendChatMessage(msg, 'INSTANCE_CHAT')
                                end
                            end)
                            -- 如果发送失败，不重试
                        elseif inHomeGroup then
                            -- 在常规队伍中，发送到团队频道
                            if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
                                SendChatMessage(msg, 'RAID_WARNING')
                            else
                                SendChatMessage(msg, 'RAID')
                            end
                        end
                    end
                end
            end
        -- 检查小队中的成员
        elseif inInstanceGroup or inHomeGroup then
            local numMembers = GetNumGroupMembers()
            if numMembers and numMembers > 0 then
                for i = 1, numMembers do
                    local unitId = (i == 1) and "player" or "party" .. i
                    local name = UnitName(unitId)
                    local level = UnitLevel(unitId)
                    local online = UnitIsConnected(unitId)
                    
                    if name and online and level < maxLevel then
                        local msg = string.format(L.lowLevelWarning, name, 1, level)
                        -- 安全发送消息
                        if inInstanceGroup then
                            -- 在副本队伍中，发送到副本频道
                            pcall(function()
                                SendChatMessage(msg, 'INSTANCE_CHAT')
                            end)
                        elseif inHomeGroup then
                            -- 在常规队伍中，发送到小队频道
                            if UnitIsGroupLeader('player') then
                                SendChatMessage(msg, 'PARTY')
                            else
                                SendChatMessage(msg, 'PARTY')
                            end
                        end
                    end
                end
            end
        end
    end
end

function WorldPVP_InviteHelper:GROUP_ROSTER_UPDATE()
    -- 记录转换前状态
    local wasInRaid = self.lastInRaidState
    local wasLeader = self.lastLeaderState
    self.lastInRaidState = UnitInRaid("player")
    
    -- 执行团队转换
    self:AutoRaid()
    
    -- 检查当前状态
    local isInRaidNow = UnitInRaid("player")
    local isLeader = UnitIsGroupLeader("player")
    local ffaEnabled = self.db.char.autoInvite_freeforall
    
    -- 检测1: 刚从队伍转换为团队
    if not wasInRaid and isInRaidNow and isLeader and ffaEnabled then
        -- 延迟检查，确保团队转换完成
        if not self.ffaTimerScheduled then
            self.ffaTimerScheduled = true
            self:ScheduleTimer(function()
                self:CheckAndApplyFreeForAllLoot()
                self.ffaTimerScheduled = false
            end, 1.0)
        end
    -- 检测2: 刚成为队长（且已在团队中）
    elseif wasLeader ~= isLeader and isLeader and isInRaidNow and ffaEnabled then
        -- 记录团长交接时间
        self.lastLeaderChangeTime = GetTime()
        -- 延迟检查，确保权限交接完成
        if not self.ffaTimerScheduled then
            self.ffaTimerScheduled = true
            self:ScheduleTimer(function()
                self:CheckAndApplyFreeForAllLoot()
                self.ffaTimerScheduled = false
            end, 0.5)
        end
    end
    
    -- 延迟执行低等级号检查，确保队伍信息已经更新
    C_Timer.After(0.5, function()
        self:CheckLowLevelMembers()
    end)
    
    -- 更新团长状态
    self.lastLeaderState = isLeader
end

function WorldPVP_InviteHelper:UNIT_LEVEL(event, unitId)
    
    -- 自动给A
    if UnitIsGroupLeader('player') and self.db.char.autoInvite_assignA then
        self:Debug("promote assistant to ".. unitId)
        PromoteToAssistant(unitId)
    end

    -- 小号检查
    if self.db.char.autoInvite_lowlevelNotify then
        -- 检查是否在副本中 - 在副本中不进行低等级号通报
        local inInstance = false
        local _, instanceType = IsInInstance()
        if instanceType and instanceType ~= "none" then
            inInstance = true
            self:Debug("在副本中，跳过UNIT_LEVEL低等级号检查: " .. (instanceType or "unknown"))
        end
        
        -- 额外检查：检测随机副本系统
        -- 经典怀旧服的随机副本可能不会通过IsInInstance正确检测
        local inRandomDungeon = false
        
        -- 方法1：检查是否在LFG队伍中
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            inRandomDungeon = true
            self:Debug("UNIT_LEVEL检测到副本队伍，跳过低等级号检查")
        end
        
        -- 方法2：尝试检测LFG状态（如果API可用）
        if LFGParentFrame and LFGParentFrame:IsShown() then
            inRandomDungeon = true
            self:Debug("UNIT_LEVEL检测到LFG界面显示，跳过低等级号检查")
        end
        
        -- 方法3：检查队伍状态是否与常规队伍不同
        -- 在随机副本中，常规队伍人数可能为0或1
        local homePartyCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
        local instancePartyCount = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
        
        if instancePartyCount > homePartyCount then
            inRandomDungeon = true
            self:Debug(string.format("UNIT_LEVEL检测：副本队伍(%d)多于常规队伍(%d)，可能是随机副本", instancePartyCount, homePartyCount))
        end
        
        -- 如果在任意类型副本中，直接返回，不进行低等级号通报
        if inInstance or inRandomDungeon then
            return
        end
        
        self:Debug("low level check to ".. unitId)
        if string.sub(unitId, 1, 4) == 'raid' and string.sub(unitId, 1, 7) ~= 'raidpet' then
            local raidIndex = tonumber(string.sub(unitId, 5))
            if raidIndex then
                local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(raidIndex)
                if name then
                    -- 不满级，团队发警告
                    if level < GetMaxPlayerLevel() and online then
                        local msg = string.format(L.lowLevelWarning, name, subgroup, level)
                        if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
                            SendChatMessage(msg, 'RAID_WARNING')
                        else
                            SendChatMessage(msg, 'RAID')
                        end
                    end
                end
            end
        end
    end
end

function WorldPVP_InviteHelper:AutoRaid()
    -- 检查是否在任意类型的队伍中（常规队伍或副本队伍）
    local inHomeParty = UnitInParty("player")
    local inInstanceParty = UnitInParty("player", LE_PARTY_CATEGORY_INSTANCE)
    
    -- 使用统一的队伍类别检查
    if inHomeParty or inInstanceParty then
        -- 优先检查常规队伍，如果没有则检查副本队伍
        local count = 0
        local isLeader = false
        
        if inHomeParty then
            count = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
            isLeader = UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME)
        elseif inInstanceParty then
            count = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
            isLeader = UnitIsGroupLeader("player", LE_PARTY_CATEGORY_INSTANCE)
        end
        
        self:Debug("Group member count: " .. count)
        
        -- 检测是否在随机副本中（副本队伍人数多于常规队伍）
        local homePartyCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
        local instancePartyCount = GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)
        local inRandomDungeon = instancePartyCount > homePartyCount
        
        if inRandomDungeon then
            self:Debug(string.format("检测到随机副本，常规队伍：%d人，副本队伍：%d人，跳过自动转团队", homePartyCount, instancePartyCount))
            return  -- 随机副本中不执行自动转团队
        end
        
        -- 只有在常规队伍中且是队长时才自动转团队（副本队伍和随机副本不应该自动转团队）
        if count > 1 and inHomeParty and isLeader and self.db.char.autoInvite_convertRaid then
            self:Debug("convert to raid.")
            ConvertToRaidWrapper()
        end
    end
    
    -- 检查团队状态（使用统一的检查方式）
    local inHomeRaid = UnitInRaid("player")
    local inInstanceRaid = UnitInRaid("player") -- 经典旧世版本可能不支持队伍类别参数
    
    if inHomeRaid or inInstanceRaid then
        -- 自由拾取检查 - 只在插件需要主动设置时才执行
        -- 这里不再主动检查，避免在手动切换时触发确认框
    end
end
