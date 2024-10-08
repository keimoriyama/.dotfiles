-- 設定ファイル reload
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)

units = {
	-- 半分分割
	right50 = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
	left50 = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
	top50 = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
	bot50 = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
	-- 画面3分割設定
	right33 = { x = 0.66, y = 0.00, w = 0.34, h = 1.00 },
	left33 = { x = 0.00, y = 0.00, w = 0.33, h = 1.00 },
	center33 = { x = 0.33, y = 0.00, w = 0.33, h = 1.00 },
	-- 4分割
	lefttop = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
	righttop = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
	leftbot = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
	rightbot = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },
	-- max
	max = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
	min = { x = 0.33, y = 0.33, w = 0.33, h = 0.33 },
}

-- auto reload
local function reloadConfig(files)
	doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

function getScreenWindowInfo()
	local focusedWindow = hs.window.focusedWindow()
	local focusedScreenFrame = focusedWindow:screen():frame()
	return focusedWindow, focusedScreenFrame
end

function calcNextWindowRatio(windowFrame, focusedScreenFrame, nextScreenFrame)
	local x = (
		(((windowFrame.x - focusedScreenFrame.x) / focusedScreenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x
	)
	local y = (
		(((windowFrame.y - focusedScreenFrame.y) / focusedScreenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y
	)
	local h = ((windowFrame.h / focusedScreenFrame.h) * nextScreenFrame.h)
	local w = ((windowFrame.w / focusedScreenFrame.w) * nextScreenFrame.w)

	return x, y, h, w
end

function moveToNextScreen()
	local focusedWindow, focusedScreenFrame = getScreenWindowInfo()
	local nextScreenFrame = focusedWindow:screen():next():frame()
	local windowFrame = focusedWindow:frame()

	-- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
	x, y, h, w = calcNextWindowRatio(windowFrame, focusedScreenFrame, nextScreenFrame)
	windowFrame.x = x
	windowFrame.y = y
	windowFrame.w = w
	windowFrame.h = h

	-- Set the focused window's new frame dimensions
	focusedWindow:setFrame(windowFrame)
end

function moveToPrevScreen()
	-- Get the focused window, its window frame dimensions, its screen frame dimensions,
	-- and the next screen's frame dimensions.
	local focusedWindow, focusedScreenFrame = getScreenWindowInfo()
	local nextScreenFrame = focusedWindow:screen():previous():frame()
	local windowFrame = focusedWindow:frame()

	-- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
	x, y, h, w = calcNextWindowRatio(windowFrame, focusedScreenFrame, nextScreenFrame)
	windowFrame.x = x
	windowFrame.y = y
	windowFrame.w = w
	windowFrame.h = h

	-- Set the focused window's new frame dimensions
	focusedWindow:setFrame(windowFrame)
end

map = { "ctrl", "option" }
-- 半分に分割する
hs.hotkey.bind(map, "h", function()
	hs.window.focusedWindow():move(units.right50, nil, true)
end)
hs.hotkey.bind(map, "l", function()
	hs.window.focusedWindow():move(units.left50, nil, true)
end)
hs.hotkey.bind(map, "j", function()
	hs.window.focusedWindow():move(units.bot50, nil, true)
end)
hs.hotkey.bind(map, "k", function()
	hs.window.focusedWindow():move(units.top50, nil, true)
end)
hs.hotkey.bind(map, "m", function()
	hs.window.focusedWindow():toggleFullScreen()
end)
--hs.hotkey.bind(map, "f", function() hs.window.focusedWindow():move(units.top50, nil, true) end)
-- 4分割する
hs.hotkey.bind(map, "1", function()
	hs.window.focusedWindow():move(units.lefttop, nil, true)
end)
hs.hotkey.bind(map, "2", function()
	hs.window.focusedWindow():move(units.righttop, nil, true)
end)
hs.hotkey.bind(map, "3", function()
	hs.window.focusedWindow():move(units.leftbot, nil, true)
end)
hs.hotkey.bind(map, "4", function()
	hs.window.focusedWindow():move(units.rightbot, nil, true)
end)
-- ディスプレイの移動
hs.hotkey.bind(map, "n", moveToNextScreen)
hs.hotkey.bind(map, "p", moveToPrevScreen)

-- アプリの起動のためのショートカット
function open(name)
	return function()
		hs.application.launchOrFocus(name)
		if name == "Finder" then
			hs.appfinder.appFromName(name):activate()
		end
	end
end

appHotKey = { "ctrl", "cmd" }
hs.hotkey.bind(appHotKey, "w", open("wezterm"))

switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter({}))
hs.hotkey.bind("alt", "tab", function()
	switcher:nextWindow()
end)
hs.hotkey.bind({ "option", "shift" }, "tab", function()
	switcher:previous()
end)

-- command+Qですぐに閉じないようにする
local qStartTime = 0.0
local qDuration = 1
hs.hotkey.bind({ "cmd" }, "Q", function()
	qStartTime = hs.timer.secondsSinceEpoch()
end, function()
	local qEndTime = hs.timer.secondsSinceEpoch()
	local duration = qEndTime - qStartTime
	if duration >= qDuration then
		hs.application.frontmostApplication():kill()
	end
end)

function ToggleKeymethod()
	if hs.keycodes.currentMethod() == "AquaSKK 統合" then
		hs.keycodes.setLayout("ABC")
		hs.alert.show("ABC", hs.styledtext, hs.screen.mainScreen(), 0.2)
	elseif hs.keycodes.currentLayout() == "ABC" then
		hs.keycodes.setMethod("AquaSKK 統合")
		hs.alert.show("SKK", hs.styledtext, hs.screen.mainScreen(), 0.2)
	end
end

local hotkeys = hs.hotkey.new({ "ctrl" }, "j", ToggleKeymethod, nil, nil)
local function test(appName, event, appObject)
	if appName == "WezTerm" then
		if event == 5 then
			-- disable key binding
			if hs.keycodes.currentMethod() == "AquaSKK 統合" then
				hs.keycodes.setLayout("ABC")
				hs.alert.show("ABC", hs.styledtext, hs.screen.mainScreen(), 0.2)
			end
			hotkeys:disable()
		elseif event == 6 then
			-- enable key binding
			hotkeys:enable()
		end
	end
end

-- hotkeys:enable()
-- watcher = hs.application.watcher.new(test)
-- watcher:start()
