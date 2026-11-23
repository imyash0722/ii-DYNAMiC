-- This file sources other files in `hyprland` and `custom` folders
-- You wanna add your stuff in files in `custom`

-- Internal stuff --
require("hyprland.lib")
require("hyprland.services")

local function safe_require(module_name)
    local ok, err = pcall(require, module_name)
    if not ok then
        hl.exec_cmd("notify-send 'Hyprland Lua Error' 'Failed to load " .. module_name .. ": " .. tostring(err):gsub("'", "\\'") .. "' -u critical -a 'Hyprland'")
    end
    return ok
end

-- Environment variables --
safe_require("hyprland.env")
if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
    safe_require("custom.env")
end

-- Default configurations --
safe_require("hyprland.execs")
safe_require("hyprland.general")
safe_require("hyprland.rules")
safe_require("hyprland.colors")
safe_require("hyprland.keybinds")
-- zscroll (lua:zscroll): before custom/ so general:layout can name it and custom binds win
safe_require("hyprland.layouts.zscroll")

-- Custom configurations --
if is_file_exists(HOME .. "/.config/hypr/custom/input.lua") then
    safe_require("custom.input")
end
if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
    safe_require("custom.execs")
end
if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
    safe_require("custom.general")
end
if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
    safe_require("custom.rules")
end
if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
    safe_require("custom.keybinds")
end

-- Monitor configurations (hyprmon / displays config) --
local function load_monitors()
    local hyprmon_lua = HOME .. "/.config/hypr/hyprmon.lua"
    if is_file_exists(hyprmon_lua) then
        local ok, err = pcall(dofile, hyprmon_lua)
        if ok then return end
    end

    local monitors_conf = HOME .. "/.config/hypr/monitors.conf"
    if is_file_exists(monitors_conf) then
        local f = io.open(monitors_conf, "r")
        if f then
            for line in f:lines() do
                local m = line:match("^%s*monitor%s*=%s*(.+)")
                if m then
                    local parts = {}
                    for p in m:gmatch("[^,]+") do
                        table.insert(parts, p:match("^%s*(.-)%s*$"))
                    end
                    local out = parts[1] or ""
                    local mode = parts[2] or "preferred"
                    local pos = parts[3] or "auto"
                    local scale = parts[4] or "1"
                    if out ~= "" and mode ~= "disable" then
                        hl.monitor({ output = out, mode = mode, position = pos, scale = scale })
                    end
                end
            end
            f:close()
        end
    end
end
load_monitors()

-- Shell overrides --
safe_require("hyprland.shellOverrides.main")

