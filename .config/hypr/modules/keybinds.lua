local vars = require("modules.vars")
local mod = "SUPER"

-- Window management ─────────────────────────────────────────────────
hl.bind(mod .. " + SHIFT + W", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + CTRL + F", hl.dsp.window.fullscreen())

-- hl.bind("ALT + TAB", function()
-- 	hl.dispatch(hl.dsp.window.cycle_next("visible"))
-- 	hl.dispatch(hl.dsp.window.bring_to_top())
-- end)

hl.bind("ALT + TAB", function()
	-- 1. Collect the active workspace ID on each monitor
	local active_workspaces = {}
	for _, m in ipairs(hl.get_monitors()) do
		if m.active_workspace then
			active_workspaces[m.active_workspace.id] = true
		end
	end

	-- 2. Filter windows to only those on an active (visible) workspace
	local windows = {}
	for _, w in ipairs(hl.get_windows()) do
		if w.workspace and active_workspaces[w.workspace.id] then
			table.insert(windows, w)
		end
	end

	if #windows == 0 then
		return
	end

	-- 3. Find current window's position and move to the next one
	local active = hl.get_active_window()
	local idx = 1
	if active then
		for i, w in ipairs(windows) do
			if w.address == active.address then
				idx = i
				break
			end
		end
	end

	local next_idx = (idx % #windows) + 1
	hl.dispatch(hl.dsp.focus({ window = "address:" .. windows[next_idx].address }))
	hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Swap windows (CTRL + WASD)
hl.bind(mod .. " + CTRL + W", hl.dsp.window.swap({ direction = "u" }))
hl.bind(mod .. " + CTRL + A", hl.dsp.window.swap({ direction = "l" }))
hl.bind(mod .. " + CTRL + S", hl.dsp.window.swap({ direction = "d" }))
hl.bind(mod .. " + CTRL + D", hl.dsp.window.swap({ direction = "r" }))

-- Scripts and apps ──────────────────────────────────────────────────
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(vars.menu))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(vars.terminal))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(vars.browser))
hl.bind(mod .. " + L", hl.dsp.exec_cmd(vars.swaylock))
hl.bind(mod .. " + R", hl.dsp.exec_cmd(vars.swaybarToggle))
hl.bind(mod .. " + V", hl.dsp.exec_cmd(vars.cliphistMenu))
hl.bind(mod .. " + period", hl.dsp.exec_cmd(vars.emojiMenu))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(vars.screenshotMenu))
hl.bind(mod .. " + S", hl.dsp.exec_cmd(vars.cycleSpecial))
hl.bind(mod .. " + U", hl.dsp.exec_cmd(vars.handyToggle))

-- Workspaces: switch ────────────────────────────────────────────────
for i = 1, 9 do
	hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Mouse: move / resize ──────────────────────────────────────────────
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Monitor → workspace range map ─────────────────────────────────────
local MONITOR_WS = {
	["HDMI-A-2"] = { min = 1, max = 3 },
	["DP-1"] = { min = 4, max = 6 },
	["HDMI-A-1"] = { min = 7, max = 9 },
}

-- Returns { min, max } for the focused monitor
local function current_range()
	local mon = hl.get_active_monitor()
	local range = mon and MONITOR_WS[mon.name]
	if not range then
		-- fallback: unknown monitor, allow full 1-9 range
		return { min = 1, max = 9 }
	end
	return range
end

-- ── Navigation helpers ────────────────────────────────────────────────

-- Go to next ws, stop at monitor's max
local function ws_next()
	local ws = hl.get_active_workspace()
	local range = current_range()
	if ws and ws.id < range.max then
		hl.dispatch(hl.dsp.focus({ workspace = ws.id + 1 }))
	end
end

-- Go to prev ws, stop at monitor's min
local function ws_prev()
	local ws = hl.get_active_workspace()
	local range = current_range()
	if ws and ws.id > range.min then
		hl.dispatch(hl.dsp.focus({ workspace = ws.id - 1 }))
	end
end

-- Scroll wheel on desktop (SUPER + scroll)
hl.bind(mod .. " + mouse_up", function()
	ws_next()
end)
hl.bind(mod .. " + mouse_down", function()
	ws_prev()
end)

-- Side mouse buttons (no modifier needed)
hl.bind("mouse:275", function()
	ws_prev()
end) -- back button  → prev
hl.bind("mouse:276", function()
	ws_next()
end) -- forward button → next

-- plugin scrolloverview 
hl.bind(mod .. " + TAB", function()
	hl.plugin.scrolloverview.overview("toggle all")
end)
