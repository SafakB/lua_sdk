local lua_targetselector_hash = 0

---@type TreeTab
local mainmenu = nil

---@type game_object_script
local selected_target = nil

function is_active()
    return target_selector.active_target_selector_name_hash == lua_targetselector_hash
end

function on_update()
    -- if pred is not active_prediction_name_hash then hide the menu
    mainmenu:set_is_hidden(is_active() ~= true)
end

---@param range number
---@param damage_type damage_type
---@param ignore_invulnerability boolean
---@param is_missile boolean
---@return nil|game_object_script
function get_target_from_range(range, damage_type, ignore_invulnerability, is_missile)
    return nil
end

---@param targets game_object_script[]
---@param damage_type damage_type
---@return nil|game_object_script
function get_target_from_vector(targets, damage_type)
    return nil
end

---@return nil|game_object_script
function _get_selected_target()
    return nil
end

---@param target game_object_script
function _set_selected_target(target)
    selected_target = target
end

---@param target game_object_script
---@return number
function _get_priority(target)
    return 5
end

---@param target game_object_script
---@param priority number
function _set_priority(target, priority)

end

function on_sdk_load(sdk)
    mainmenu = menu:create_tab("luats", "Lua Target Selector")
    mainmenu:add_checkbox("luats.test", "IDK", false, false)
    lua_targetselector_hash = target_selector:add_custom_target_selector("luatargetselector", get_target_from_range,
        get_target_from_vector, _get_selected_target, _set_selected_target, _get_priority, _set_priority)
    cb.add(events.on_update, on_update)
    return true
end

function on_sdk_unload(sdk)
    target_selector:remove_custom_target_selector(lua_targetselector_hash)
    cb.remove(events.on_update, on_update)
    menu:delete_tab(mainmenu)
end
