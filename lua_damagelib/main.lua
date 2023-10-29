local lua_damagelib_hash = 0

---@type TreeTab
local mainmenu = nil

function is_active()
    return damagelib.active_damagelib_name_hash == lua_damagelib_hash
end

---@param source game_object_script
---@param target game_object_script
---@param respect_passives boolean
---@return number
function _get_auto_attack_damage(source, target, respect_passives)
    return 666
end

---@param source game_object_script
---@param target game_object_script
---@param input damage_input
---@return number
function _calculate_damage_on_unit(source, target, input)
    return 666
end

---@param source game_object_script
---@param target game_object_script
---@param damage_type damage_type
---@param raw_damage number
---@return number
function _calculate_damage_on_unit2(source, target, damage_type, raw_damage)
    return 666
end

---@param source game_object_script
---@param target game_object_script
---@param slot spellslot
---@param return_raw_damage boolean
---@return number
function _get_spell_damage(source, target, slot, return_raw_damage)
    return 444
end

function on_update()
    mainmenu:set_is_hidden(is_active() ~= true)
end

function on_sdk_load(sdk)
    mainmenu = menu:create_tab("luadamagelib", "Lua DamageLib")
    mainmenu:add_checkbox("luadamagelib.test", "Calculate items", false, false)

    lua_damagelib_hash = damagelib:add_damagelib_callback("luadamagelib", _get_auto_attack_damage,
        _calculate_damage_on_unit,
        _calculate_damage_on_unit2, _get_spell_damage)
    cb.add(events.on_update, on_update)
    return true
end

function on_sdk_unload(sdk)
    damagelib:remove_damagelib_callback(lua_damagelib_hash)
    cb.remove(events.on_update, on_update)
    menu:delete_tab(mainmenu)
end
