local lua_health_prediction_hash = 0

---@type TreeTab
local mainmenu = nil

function is_active()
    return health_prediction.active_health_prediction_name_hash == lua_health_prediction_hash
end

---@param minion game_object_script
---@return nil|game_object_script
function _get_aggro_turret(minion)
    return nil
end

---@param minion game_object_script
---@return number
function _turret_aggro_start_time(minion)
    return 0
end

---@param minion game_object_script
---@return boolean
function _has_turret_aggro(minion)
    return false
end

---@param minion game_object_script
---@return boolean
function _has_minion_aggro(minion)
    return false
end

---@param unit game_object_script
---@param time number
---@param delay number
---@return number
function _get_health_prediction(unit, time, delay)
    return 0
end

---@param unit game_object_script
---@param time number
---@param delay number
---@return number
function _get_lane_clear_health_prediction(unit, time, delay)
    return 0
end

---@param unit game_object_script
---@param time number
---@param include_skillshot boolean
---@return number
function _get_incoming_damage(unit, time, include_skillshot)
    return 0
end

---@param source game_object_script
---@param target game_object_script
---@return boolean
function _has_agro_on(source, target)
    return false
end

---@param minion game_object_script
---@return number
function _minions_aggro_count(minion)
    return 0
end

function on_update()
    -- if pred is not active_health_prediction_name_hash then hide the menu
    mainmenu:set_is_hidden(is_active() ~= true)
end

function on_sdk_load(sdk)
    mainmenu = menu:create_tab("luahealthpred", "Lua Health Prediction")
    mainmenu:add_checkbox("luahealthpred.test", "Add Delay", false, false)
    lua_health_prediction_hash = health_prediction:add_health_prediction_callback("luahealthpred", _get_aggro_turret,
        _turret_aggro_start_time, _has_turret_aggro, _has_minion_aggro, _get_health_prediction,
        _get_lane_clear_health_prediction, _get_incoming_damage, _has_agro_on, _minions_aggro_count)
    cb.add(events.on_update, on_update)
    return true
end

function on_sdk_unload(sdk)
    health_prediction:remove_health_prediction_callback(lua_health_prediction_hash)
    cb.remove(events.on_update, on_update)
    menu:delete_tab(mainmenu)
end
