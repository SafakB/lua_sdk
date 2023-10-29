local lua_prediction_hash = 0

---@type TreeTab
local mainmenu = nil

function is_active()
    return prediction.active_prediction_name_hash == lua_prediction_hash
end

---@param input prediction_input
---@return prediction_output
function get_prediction_result(input)
    local output = prediction_output()
    output.raw_cast_position = hud.hud_input_logic.game_cursor_position
    output.raw_unit_position = hud.hud_input_logic.game_cursor_position
    output.raw_aoe_targets_hit_count = 0
    output.input = input
    output.hitchance = hit_chance.very_high
    output:set_aoe_targets_hit({})
    output:set_collision_objects({})
    print(string.format("get_prediction_1 - input: speed %f - radius %f", input.speed, input.radius))
    return output
end

---@param input prediction_input
function get_prediction_collision_units(positions, input)
    local result = {}
    table.insert(result, input.unit)
    table.insert(result, input.unit)
    print(string.format("get_prediction_2 - input: speed %f - radius %f", input.speed, input.radius))
    return result
end

function on_update()
    -- if pred is not active_prediction_name_hash then hide the menu
    mainmenu:set_is_hidden(is_active() ~= true)
    if is_active() then
        local input      = prediction_input()
        input.aoe        = false
        input.delay      = 0.25
        input.radius     = 60
        input.speed      = 2000
        input.spell_slot = spellslot.q
        input.type       = skillshot_type.skillshot_line
        input.raw_from   = hud.hud_input_logic.game_cursor_position
        input:set_collision_objects({})
        input.unit = myhero

        local collision = prediction:get_collision({ myhero.position }, input)

        for index, value in ipairs(collision) do
            print(string.format("name %s - health %f", value.name, value.health))
        end
    end
end

function on_sdk_load(sdk)
    mainmenu = menu:create_tab("luapred", "Lua Prediction")
    mainmenu:add_checkbox("luapred.test", "Add Delay", false, false)
    lua_prediction_hash = prediction:add_prediction_callback("luapred", get_prediction_result,
        get_prediction_collision_units)
    cb.add(events.on_update, on_update)
    return true
end

function on_sdk_unload(sdk)
    prediction:remove_prediction_callback(lua_prediction_hash)
    cb.remove(events.on_update, on_update)
    menu:delete_tab(mainmenu)
end
