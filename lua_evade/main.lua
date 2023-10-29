---@diagnostic disable: return-type-mismatch
---@type TreeTab
local mainmenu = nil


---@type TreeEntry
local test = nil
---@type evade_skillshot_info[]
local skillshots = {}

function _disable_evade()

end

function _enable_evade()

end

---@return boolean
function _is_evading()
    return false
end

---@return boolean
function _is_evade_disabled()
    return false
end

---@param pos vector4
---@return boolean
function _is_dangerous(pos)
    return false
end

---@param path vector[]
---@param time number
---@param speed number
---@param delay number
function _is_dangerous_path(path, time, speed, delay)
    return false
end

---@return vector
function _evading_pos()
    return vector.zero
end

---@return evade_skillshot_info[]
function _get_skillshots()
    return skillshots
end

---@param speed number
---@param delay number
---@param blink boolean
---@param destination vector
---@return vector[]
function _get_evade_points(speed, delay, blink, destination)
    return { myhero.position, hud.hud_input_logic.game_cursor_position }
end

function on_update()
    --- idk
end

function on_draw()
    if draw_aa.bool then
        draw_manager:add_circle(myhero.position, myhero.attackRange, 0xFFFFFFFF)
    end


    for index, skill in ipairs(evade.skillshots) do
        print(string.format("name %s - start_time %f", skill.spell_data_name, skill.end_time))
        skill.polygon:draw(0xFFFFFFFF, 2)
    end

    local points = evade:get_evade_points(100, 0.25)

    for index, value in ipairs(points) do
        print(string.format("pos %0.1f %0.1f", value.x, value.y))
    end
end

function on_sdk_load(sdk)
    if evade.is_evade_registered then
        print("unload evade first then load XDXD")
        return false
    end


    mainmenu = menu:create_tab("lua_evade", "Lua Evade")
    draw_aa = mainmenu:add_checkbox("lua_evade.test", "Dodge from heaven", true, true)

    evade:register_evade_callbacks(_disable_evade, _enable_evade, _is_evading, _is_evade_disabled, _is_dangerous,
        _is_dangerous_path, _evading_pos, _get_skillshots, _get_evade_points)


    for i = 1, 10, 1 do
        local ezreal_q = evade_skillshot_info()
        ezreal_q.startpos = vector()
        ezreal_q.endpos = hud.hud_input_logic.game_cursor_position
        ezreal_q.start_time = gametime.time
        ezreal_q.polygon = rectangle(ezreal_q.startpos, ezreal_q.endpos, 60):to_polygon()
        ezreal_q.skillshot_type = skillshot_type.skillshot_line
        ezreal_q.slot = spellslot.q
        ezreal_q.unit = myhero
        ezreal_q.spell_data_name = "ezrealq"
        ezreal_q.spell_data_danger_level = 0
        ezreal_q.end_time = gametime.time + (i * 10)
        ezreal_q.spell_data_radius = 60
        ezreal_q.spell_data_range = 1200
        ezreal_q.spell_data_missile_speed = 2000
        table.insert(skillshots, ezreal_q)
    end



    cb.add(events.on_update, on_update)
    cb.add(events.on_draw, on_draw)
    return true
end

function on_sdk_unload(sdk)
    if mainmenu ~= nil then --- so we are loaded
        evade:unregister_evade_callbacks()
        cb.remove(events.on_update, on_update)
        cb.remove(events.on_draw, on_draw)
        menu:delete_tab(mainmenu)
    end
end
