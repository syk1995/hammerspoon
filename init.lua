----------------------------------------------------------------------------------------------------

-- author: zuorn
-- mail: zuorn@qq.com
-- github: https://github.com/zuorn/hammerspoon_config

----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0



----------------------------------------------------------------------------------------------------
------------------------------------------ 配置设置 -------------------------------------------------
-- 配置文件
-- 使用自定义配置 （如果存在的话）
----------------------------------------------------------------------------------------------------
custom_config = hs.fs.pathToAbsolute(os.getenv("HOME") .. '/.config/hammerspoon/private/config.lua')
if custom_config then
    print("加载自定义配置文件。")
    dofile( os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
    privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
    if privatepath then
        hs.alert("已发现你的私有配置，将优先使用它。")
    end
else
    -- 否则使用默认配置
    if not privatepath then
        privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private')
        -- 如果没有 `~/.hammerspoon/private` 目录，则创建它。
        hs.fs.mkdir(hs.configdir .. '/private')
    end
    privateconf = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
    if privateconf then
        -- 加载自定义配置，如果存在的话
        require('private/config')
    end
end

hsreload_keys = hsreload_keys or {{"cmd", "shift", "ctrl"}, "R"}
if string.len(hsreload_keys[2]) > 0 then
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "重新加载配置!", function() hs.reload() end)
    hs.alert.show("配置文件已经重新加载！ ")
end



----------------------------------------------------------------------------------------------------
---------------------------------------- Spoons 加载项 ----------------------------------------------
----------------------------------------------------------------------------------------------------
-- 加载 Spoon
----------------------------------------------------------------------------------------------------
hs.loadSpoon("ModalMgr")

-- 定义默认加载的 Spoons
if not hspoon_list then
    hspoon_list = {
        "AClock", -- 一个钟
        "ClipShow", -- 剪切板
        "KSheet", -- 快捷键
        "CountDown", -- 倒计时
        "WinWin", -- 窗口管理
        "VolumeScroll", -- 鼠标滚轮调节音量
        -- "PopupTranslateSelection", -- 翻译选中文本
        "SpeedMenu", -- 菜单栏显示网速
        "MountedVolumes", -- 显示已安装卷的饼图
        "HeadphoneAutoPause", -- 断开耳机自动暂停播放
        "HSearch"
    }
end

-- 加载 Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end


----------------------------------------------------------------------------------------------------
-- 定义各种模式快捷键绑定
----------------------------------------------------------------------------------------------------
-- 定义 windowHints 快捷键
----------------------------------------------------------------------------------------------------
hswhints_keys = hswhints_keys or {"alt", "tab"}
local time_window_hints = 5 -- 窗口提示显示时间，单位为秒

if string.len(hswhints_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hswhints_keys[1], hswhints_keys[2], 'WindowHints 快速切换应用', function()
        spoon.ModalMgr:deactivateAll()

        -- 设置提示风格（可用的有 'vimperator', 'emacs', 'default'）
        hs.hints.style = "vimperator"  -- 支持首字母快速匹配
        hs.alert.show("Type APP Abbreviation to switch windows", time_window_hints)
        hs.hints.windowHints()

        -- 2 秒后自动退出（若未选择窗口）
        hs.timer.doAfter(time_window_hints, function()
            hs.eventtap.keyStroke({}, "escape", 0)
        end)
    end)
end



----------------------------------------------------------------------------------------------------
-- 在浏览器中打开 Hammerspoon API 手册
----------------------------------------------------------------------------------------------------
hsman_keys = hsman_keys or {"alt", "H"}
if string.len(hsman_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsman_keys[1], hsman_keys[2], "查看 Hammerspoon 手册和 Notion 页面", function()
        hs.doc.hsdocs.forceExternalBrowser(true)
        hs.doc.hsdocs.moduleEntitiesInSidebar(true)
        hs.doc.hsdocs.help()
        hs.urlevent.openURL("https://bead-confidence-3ce.notion.site/hammer-spoon-23e82dd2955e8028b678ca1439019f55?pvs=74")
    end)
end

----------------------------------------------------------------------------------------------------
-- 锁屏
----------------------------------------------------------------------------------------------------
hslock_keys = hslock_keys or {"alt", "L"}
if string.len(hslock_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], "锁屏", function()
        hs.caffeinate.lockScreen()
    end)
end

----------------------------------------------------------------------------------------------------
-- 窗口管理
----------------------------------------------------------------------------------------------------
hs.hotkey.bind({'cmd', 'alt'}, 'Left', function()
    spoon.WinWin:stash()
    spoon.WinWin:moveAndResize("halfleft")
end)
hs.hotkey.bind({'cmd', 'alt'}, 'Right', function()
    spoon.WinWin:stash()
    spoon.WinWin:moveAndResize("halfright")
end)
hs.hotkey.bind({'cmd', 'alt'}, 'Up', function()
    spoon.WinWin:stash()
    spoon.WinWin:moveAndResize("halfup")
end)
hs.hotkey.bind({'cmd', 'alt'}, 'Down', function()
    spoon.WinWin:stash()
    spoon.WinWin:moveAndResize("halfdown")
end)
hs.hotkey.bind({'cmd', 'alt'}, '=', function()
    spoon.WinWin:stash()
    spoon.WinWin:moveAndResize("fullscreen")
end)
hs.hotkey.bind({'cmd', 'alt'}, 'delete', function()
    spoon.WinWin:undo()
end) 
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'escape', '退出 ', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'Q', '退出', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'tab', '键位提示', function() spoon.ModalMgr:toggleCheatsheet() end)

    cmodal:bind('', 'A', '向左移动', function() spoon.WinWin:stepMove("left") end, nil, function() spoon.WinWin:stepMove("left") end)
    cmodal:bind('', 'D', '向右移动', function() spoon.WinWin:stepMove("right") end, nil, function() spoon.WinWin:stepMove("right") end)
    cmodal:bind('', 'W', '向上移动', function() spoon.WinWin:stepMove("up") end, nil, function() spoon.WinWin:stepMove("up") end)
    cmodal:bind('', 'S', '向下移动', function() spoon.WinWin:stepMove("down") end, nil, function() spoon.WinWin:stepMove("down") end)

    --cmodal:bind('', 'H', '左半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfleft") end)
    --cmodal:bind('', 'L', '右半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfright") end)
    --cmodal:bind('', 'K', '上半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfup") end)
    --cmodal:bind('', 'J', '下半屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfdown") end)


    cmodal:bind('', 'Y', '屏幕左上角', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerNW") end)
    cmodal:bind('', 'O', '屏幕右上角', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerNE") end)
    cmodal:bind('', 'U', '屏幕左下角', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerSW") end)
    cmodal:bind('', 'I', '屏幕右下角', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerSE") end)

    cmodal:bind('', 'F', '全屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("fullscreen") end)
    cmodal:bind('', 'C', '居中', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("center") end)
    cmodal:bind('', 'G', '左三分之二屏居中分屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("centermost") end)
    cmodal:bind('', 'Z', '展示显示', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("show") end)
    cmodal:bind('', 'V', '编辑显示', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("shows") end)

    cmodal:bind('', 'X', '二分之一居中分屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("center-2") end)

    cmodal:bind('', '=', '窗口放大', function() spoon.WinWin:moveAndResize("expand") end, nil, function() spoon.WinWin:moveAndResize("expand") end)
    cmodal:bind('', '-', '窗口缩小', function() spoon.WinWin:moveAndResize("shrink") end, nil, function() spoon.WinWin:moveAndResize("shrink") end)

    cmodal:bind('ctrl', 'H', '向左收缩窗口', function() spoon.WinWin:stepResize("left") end, nil, function() spoon.WinWin:stepResize("left") end)
    cmodal:bind('ctrl', 'L', '向右扩展窗口', function() spoon.WinWin:stepResize("right") end, nil, function() spoon.WinWin:stepResize("right") end)
    cmodal:bind('ctrl', 'K', '向上收缩窗口', function() spoon.WinWin:stepResize("up") end, nil, function() spoon.WinWin:stepResize("up") end)
    cmodal:bind('ctrl', 'J', '向下扩镇窗口', function() spoon.WinWin:stepResize("down") end, nil, function() spoon.WinWin:stepResize("down") end)


    cmodal:bind('', 'left', '窗口移至左边屏幕', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("left") end)
    cmodal:bind('', 'right', '窗口移至右边屏幕', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("right") end)
    cmodal:bind('', 'up', '窗口移至上边屏幕', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("up") end)
    cmodal:bind('', 'down', '窗口移动下边屏幕', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("down") end)
    cmodal:bind('', 'space', '窗口移至下一个屏幕', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("next") end)
    cmodal:bind('', 'B', '撤销最后一个窗口操作', function() spoon.WinWin:undo() end)
    cmodal:bind('', 'R', '重做最后一个窗口操作', function() spoon.WinWin:redo() end)

    cmodal:bind('', '[', '左三分之二屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("mostleft") end)
    cmodal:bind('', ']', '右三分之二屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("mostright") end)
    cmodal:bind('', ',', '左三分之一屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("lesshalfleft") end)
    cmodal:bind('', '.', '中分之一屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("onethird") end)
    cmodal:bind('', '/', '右三分之一屏', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("lesshalfright") end)

    cmodal:bind('', 't', '将光标移至所在窗口中心位置', function() spoon.WinWin:centerCursor() end)

    -- 定义窗口管理模式快捷键
    hsresizeM_keys = hsresizeM_keys or {"alt", "R"}
    if string.len(hsresizeM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "进入窗口管理模式", function()
            spoon.ModalMgr:deactivateAll()
            -- 显示状态指示器，方便查看所处模式
            spoon.ModalMgr:activate({"resizeM"}, "#B22222")
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- 绑定 KSheet 面板 快捷键
----------------------------------------------------------------------------------------------------
if spoon.KSheet then
    spoon.ModalMgr:new("cheatsheetM")
    local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
    cmodal:bind('', 'escape', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)
    cmodal:bind('', 'Q', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)

    -- 定义快捷键
    hscheats_keys = hscheats_keys or {"alt", "S"}
    if string.len(hscheats_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hscheats_keys[1], hscheats_keys[2], "显示应用快捷键", function()
            spoon.KSheet:show()
            spoon.ModalMgr:deactivateAll()
            spoon.ModalMgr:activate({"cheatsheetM"})
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- 快捷显示 Hammerspoon 控制台
----------------------------------------------------------------------------------------------------
hsconsole_keys = hsconsole_keys or {"alt", "Z"}
if string.len(hsconsole_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], "打开 Hammerspoon 控制台", function() hs.toggleConsole() end)
end

----------------------------------------------------------------------------------------------------
-- 延迟 Command + Q 功能，防止误触
----------------------------------------------------------------------------------------------------
local cmdq_time_window = 1.5  -- 保护窗口时间（秒）
local protect_mode_active = false
local quit_times = 0
local keyListener = nil

cmdq_protect_keys = cmdq_protect_keys or {"cmd", "Q"}

if string.len(cmdq_protect_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(cmdq_protect_keys[1], cmdq_protect_keys[2], "Activate Protect mode", function()
        if protect_mode_active then
            hs.alert.show("Already in protect mode")
            return
        end

        protect_mode_active = true
        quit_times = 0
        hs.alert.show("Protect mode active: press Q again to kill app", cmdq_time_window)

        -- 启动按键监听器
        keyListener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
            if quit_times > 0 then
                hs.alert.show("Press Q too quick, please wait a moment", cmdq_time_window)
                keyListener:stop()
                keyListener = nil
                return false                
            end     

            local key = event:getCharacters(true)
            if key == "q" then
                if quit_times == 0 then
                    local frontapp = hs.application.frontmostApplication()
                    if frontapp then
                        frontapp:kill()
                    end
                    quit_times = quit_times + 1
                end
                return true
            end
            return false
        end)
        -- 启动按键监听器 and 在一定时间后停止
        keyListener:start()
        hs.timer.doAfter(cmdq_time_window, function()
            protect_mode_active = false
            quit_times = 0
            if keyListener then
                keyListener:stop()
                keyListener = nil
            end
        end)
    end)
end

----------------------------------------------------------------------------------------------------
-- 初始化 modalMgr
----------------------------------------------------------------------------------------------------

spoon.ModalMgr.supervisor:enter()



----------------------------------------------------------------------------------------------------
-------------------------------------------- End ---------------------------------------------------
----------------------------------------------------------------------------------------------------
