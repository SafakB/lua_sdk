---@diagnostic disable: return-type-mismatch
local lua_walker_hash = 0
---@type TreeTab
local mainmenu = nil
---@type TreeEntry
local draw_aa = nil

---@type TreeEntry
local combokey = nil

function is_active()
    return orbwalker.active_orbwalker_name_hash == lua_walker_hash
end

---@return boolean
function _last_hit_mode()
    return false
end

---@return boolean
function _mixed_mode()
    return false
end

---@return boolean
function _lane_clear_mode()
    return false
end

---@return boolean
function _combo_mode()
    return combokey.bool
end

---@return boolean
function _flee_mode()
    return false
end

---@return boolean
function _none_mode()
    return false
end

---@return boolean
function _harass()
    return false
end

function _reset_auto_attack_timer()
    print("--reset auto attack timer")
end

---@return game_object_script
function _get_target()
    return nil
end

---@return game_object_script
function _get_last_target()
    return nil
end

---@return number
function _get_last_aa_time()
    return 0.0
end

---@return number
function _get_last_move_time()
    return 0.0
end

---@return number
function _get_my_projectile_speed()
    return 1337.0
end

---@return boolean
function _can_attack()
    return false
end

---@param extra_windup number
---@return boolean
function _can_move(extra_windup)
    return true
end

---@return boolean
function _should_wait()
    return false
end

---@param pos vector
function _move_to(pos)
    myhero:issue_order(pos)
end

---@param target? game_object_script
---@param pos vector
function _orbwalk(target, pos)
    if target ~= nil then
        myhero:issue_order(target)
    else
        myhero:issue_order(pos)
    end
end

---@param enable boolean
function _set_attack(enable)
end

---@param enable boolean
function _set_movement(enable)
end

---@param target game_object_script
function _set_orbwalking_target(target)

end

---@param pos vector
function _set_orbwalking_point(pos)
end

---@return number
function _get_orb_state()
    return 0
end

function on_update()
    -- if pred is not active_prediction_name_hash then hide the menu
    mainmenu:set_is_hidden(is_active() ~= true)
    if not is_active() then
        return
    end


    if _combo_mode() then
        local target = target_selector:get_target(-1.0, damage_type.physical)
        _orbwalk(target, hud.hud_input_logic.game_cursor_position)
    end
end

function on_draw()
    if not is_active() then
        return
    end
    if draw_aa.bool then
        draw_manager:add_circle(myhero.position, myhero.attackRange, 0xFFFFFFFF)
    end
end

function on_sdk_load(sdk)
    mainmenu = menu:create_tab("luawalker", "Lua Walker")
    draw_aa = mainmenu:add_checkbox("luawalker.test", "Draw AA Range", true, true)
    combokey = mainmenu:add_hotkey("combokey", "Combo", tree_hotkey_mode.Hold, 0x20, false)
    lua_walker_hash = orbwalker:add_orbwalker_callback("LuaWalker",
        _last_hit_mode,
        _mixed_mode,
        _lane_clear_mode,
        _combo_mode,
        _flee_mode,
        _none_mode,
        _harass,
        _reset_auto_attack_timer,
        _get_target,
        _get_last_target,
        _get_last_aa_time,
        _get_last_move_time,
        _get_my_projectile_speed,
        _can_attack,
        _can_move,
        _should_wait,
        _move_to,
        _orbwalk,
        _set_attack,
        _set_movement,
        _set_orbwalking_target,
        _set_orbwalking_point,
        _get_orb_state
    )
    cb.add(events.on_update, on_update)
    cb.add(events.on_draw, on_draw)
    return true
end

function on_sdk_unload(sdk)
    orbwalker:remove_orbwalker_callback(lua_walker_hash)
    cb.remove(events.on_update, on_update)
    cb.remove(events.on_draw, on_draw)
    menu:delete_tab(mainmenu)
end
