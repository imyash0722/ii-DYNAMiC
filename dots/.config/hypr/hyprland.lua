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
    local monitors_conf = HOME .. "/.config/hypr/monitors.conf"
    local loaded_from_conf = false

    if is_file_exists(monitors_conf) then
        local f = io.open(monitors_conf, "r")
        if f then
            for line in f:lines() do
                local m = line:match("^%s*monitor%s*=%s*(.+)")
                if m then
                    local parts = {}
                    local s = m .. ","
                    for field in s:gmatch("([^,]*),") do
                        table.insert(parts, field:match("^%s*(.-)%s*$"))
                    end
                    local out = parts[1] or ""
                    local mode = parts[2] or "preferred"
                    local pos = parts[3] or "auto"
                    local scale = parts[4] or "1"
                    local spec = { output = out }

                    if mode == "disable" or mode == "disabled" then
                        spec.disabled = true
                    else
                        spec.mode = mode ~= "" and mode or "preferred"
                        spec.position = pos ~= "" and pos or "auto"
                        spec.scale = scale ~= "" and scale or "1"
                        local i = 5
                        while i <= #parts do
                            local k = parts[i] and parts[i]:lower() or ""
                            local v = parts[i+1] or ""
                            if k == "transform" then spec.transform = tonumber(v) or 0
                            elseif k == "vrr" then spec.vrr = tonumber(v) or 0
                            elseif k == "mirror" then spec.mirror = v
                            elseif k == "bitdepth" then spec.bitdepth = tonumber(v) or 8
                            end
                            i = i + 2
                        end
                    end
                    hl.monitor(spec)
                    loaded_from_conf = true
                end
            end
            f:close()
        end
    end

    if loaded_from_conf then return end

    local hyprmon_lua = HOME .. "/.config/hypr/hyprmon.lua"
    if is_file_exists(hyprmon_lua) then
        pcall(dofile, hyprmon_lua)
    end
end
load_monitors()

-- Shell overrides --
safe_require("hyprland.shellOverrides.main")

