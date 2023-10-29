local utils = require("utils")

local mainmenu = {}
local menutest = {}
---@type TreeEntry
local showdrawings = nil
---@type TreeEntry
local showpath = nil

---@type TreeEntry
local showbuffs = nil

---@type TreeEntry
local showitems = nil
---@type TreeEntry
local showspellw = nil
---@type TreeEntry
local castspells = nil

---@type TreeEntry
local showprediction = nil
---@type TreeEntry
local showgeometry = nil

local spells =
{
    ---@type script_spell
    q = nil,
    ---@type script_spell
    w = nil
}
---@type loaded_texture
local texture_test = nil

local colors = {
    RED = MAKE_COLOR(255, 0, 0, 255),
    GREEN = MAKE_COLOR(0, 255, 0, 255),
    BLUE = MAKE_COLOR(0, 0, 255, 255),
    ORANGE = MAKE_COLOR(255, 99, 71, 255)
}

function setup_menu()
    mainmenu = menu:create_tab("RTXLua", "RTXLua")
    menutest = mainmenu:add_tab("RTX.MenuTest", "Lua Menu Test")
    mainmenu:set_assigned_texture(texture_test.texture)
    showdrawings = mainmenu:add_checkbox("lua.drawings", "Show Drawings", false, false)
    showpath = mainmenu:add_checkbox("lua.showpath", "Show Path", false, false)
    showgeometry = mainmenu:add_checkbox("lua.showgeometry", "Show Geometry", false, false)
    showbuffs = mainmenu:add_checkbox("lua.showbuffs", "Show Buffs", false, false)
    showitems = mainmenu:add_checkbox("lua.showitems", "Show Items", false, false)
    showspellw = mainmenu:add_checkbox("lua.showspellw", "Show Spell [W]", false, false)
    showprediction = mainmenu:add_checkbox("lua.showprediction", "Show Prediction", false, false)
    castspells = mainmenu:add_hotkey("lua.castspells", "Cast Spell", tree_hotkey_mode.Hold, char_key("C"), false, false)


    menutest:add_combobox("LUA.Combobox", "ComboBox",
        { { name = "test", texture = texture_test.texture }, { name = "test2" } }, 0, false)

    local hotkey = menutest:add_hotkey("LUA.Hotkey", "Hotkey", tree_hotkey_mode.Toggle, char_key("A"), false, false)

    if hotkey.hotkey_type == tree_hotkey_mode.Toggle then
        print("mode is toggle")
    end

    ---@param entry TreeEntry
    hotkey:add_property_change_callback(function(entry)
        print("prop changed" .. entry.key .. " " .. entry.display_name)
    end)

    menutest:add_colorpick("LUA.Colorpick", "Color picker", { 1.0, 0.0, 0.0, 1.0 }, false)
    local priority = menutest:add_prority_list("LUA.Priority", "Display Priority",
        {
            ProrityCheckItem(0, "test 0", true, texture_test.texture),
            ProrityCheckItem(34, "test 1", false, 0)
        }, false, false)

    local prio, active = priority:get_prority(34)

    print(string.format("prio %d - active %s", prio, tostring(active)))

    menutest:add_slider("Lua.Slider", "Slider", 10, 1, 100, false)

    local button = menutest:add_button("testbutton", "Test Button")

    button:add_property_change_callback(function(entry)
        print("button clicked")
    end)
end

---@param sender game_object_script
function on_create(sender)
    if sender.is_missile then
        if sender.missile_is_targeted and sender.owner and sender.owner.is_me then
            print(string.format("missileName %s - ownerId %x - targetId %x", sender.name, sender.missile_get_sender_id,
                sender.missile_get_target_id))
        end
    end
end

function on_update()
    --utils.print_hello()



    if orbwalker.combo_mode then
        --print("combo mode")
    elseif orbwalker.harass then
        --print("flee mode")
    end

    if castspells.bool and spells.w:is_ready() then
        spells.w:cast(hud.hud_input_logic.game_cursor_position)
    end
end

function test_drawings()
    local position = myhero.position;

    draw_manager:add_circle(position, 250, 0xFFFFFFFF)
    draw_manager:add_circle_gradient(position, 120, 0xFFFFFFFF, 0xFFFFFFFF)
    draw_manager:add_circle_on_screen(vector(200, 200), 100, 0xFFFFFFFF)
    draw_manager:add_circle_on_screen_ex(vector(500, 500), 120, 0xFFFFFFFF, 0.5)
    draw_manager:add_filled_circle(position, 30, 0xFFFFFFFF)
    draw_manager:add_filled_circle_on_screen(vector(600, 600), 45, 0xFFFFFFFF)
    draw_manager:add_line(position, hud.hud_input_logic.game_cursor_position, 0xFFFFFFFF)
    draw_manager:add_line_on_screen(vector(100, 100), vector(500, 500), 0xFFFFFFFF)
    draw_manager:add_rect(vector(350, 350), vector(500, 500), 0xFFFFFFFF)
    draw_manager:add_rectangle_3d(position, hud.hud_input_logic.game_cursor_position, 0xFFFFFFFF, 40, 20,
        1, 2)
    draw_manager:draw_circle_on_minimap(position, 1000, 0xFFFFFFFF)

    draw_manager:add_image(texture_test.texture, vector(500, 500), vector(32, 32))

    local posScreen = myhero.position:worldtoscreen()

    draw_manager:add_text_on_screen(posScreen, colors.RED, 22, "Text Screen")

    -- local matrix = renderer.view_matrix
    -- for i = 1, 4 do
    --     for j = 1, 4 do
    --         print(string.format("%f", renderer.view_matrix:get(i, j)))
    --     end
    -- end
end

function test_prediction()
    local input      = prediction_input()
    input.aoe        = false
    input.delay      = 0.25
    input.radius     = 60
    input.speed      = 2000
    input.spell_slot = spellslot.q
    input.type       = skillshot_type.skillshot_line
    input.raw_from   = hud.hud_input_logic.game_cursor_position
    input:set_collision_objects({ collisionable_objects.minions, collisionable_objects.yasuo_wall })
    input.unit = myhero

    local output = prediction:get_prediction(input)

    draw_manager:add_circle(output.cast_position, 30, 0xFFFFFFFF)

    if output.hitchance == hit_chance.high then
        spells.q:cast(output.cast_position)
    end

    local output_2 = spells.q:get_prediction(myhero)

    draw_manager:add_circle(output_2.cast_position, 50, 0xFFFFFF00)


    if spells.q.handle then
        local data = spells.q.handle.spell_data
        if data then
            print(string.format("mana %f - cast range %f , mFloatVarsDecimals %d", data.Mana[1], data.CastRange[0],
                data.mFloatVarsDecimals[0]))
        end
    end
end

function test_geometry()
    local cutPath_result = geometry.cut_path(myhero.real_path, 500)
    for i = 1, #cutPath_result - 1 do
        draw_manager:add_circle(cutPath_result[i], 30, 0xFFFFFFFF, 2, -1, 30)
        draw_manager:add_line(cutPath_result[i], cutPath_result[i + 1], colors.ORANGE, 5.0)
    end

    local circle_points = geometry.circle_points(myhero.position, 250, 30)

    for i = 1, #circle_points - 1 do
        draw_manager:add_circle(circle_points[i]:to3d(), 30, colors.ORANGE, 2, -1, 30)
        draw_manager:add_line(circle_points[i]:to3d(), circle_points[i + 1]:to3d(), 0xFFFFFFFF, 2.0)
    end

    local path_len = geometry.path_length(myhero.real_path)
    draw_manager:add_text(myhero.path_controller.end_vec, 0xFFFFFFFF, 22, string.format("Pl %f", path_len))

    local pos_after = geometry.position_after(myhero.real_path, 1.2, 325, 0.25)
    draw_manager:add_circle(pos_after:to3d(), 50, 0xFFFFFFFF, 2, -1, 30)
    draw_manager:add_text(pos_after, 0xFFFFFFFF, 22, string.format("Pos After 1.2s"))

    local circle_polygon = circle(myhero.position, 325):to_polygon()
    local circle_cursor_polygon = circle(hud.hud_input_logic.game_cursor_position, 325):to_polygon()

    for i = 1, #circle_polygon.points - 1 do
        draw_manager:add_circle(circle_polygon.points[i]:to3d(), 30, 0xFFFFFFFF, 2, -1, 30)
        draw_manager:add_line(circle_polygon.points[i]:to3d(), circle_polygon.points[i + 1]:to3d(), 0xFFFFFFFF, 2.0)
    end


    local clip_poly = geometry.clip_polygons({ circle_polygon, circle_cursor_polygon })

    for index, value in ipairs(clip_poly) do
        local result_poly = polygon()
        for index_2, point in ipairs(value) do
            result_poly:add(vector(point.x, point.y))
        end

        ---or you can use :draw method to draw XD
        --result_poly:draw(0xFFFFFFFF, 5, true)

        for i = 1, #result_poly.points - 1 do
            draw_manager:add_circle(result_poly.points[i]:to3d(), 30, 0xFFFFFFFF, 2, -1, 30)
            draw_manager:add_line(result_poly.points[i]:to3d(), result_poly.points[i + 1]:to3d(), 0xFFFFFFFF, 2.0)
        end
    end

    local rectangle_poly = rectangle(vector.zero, hud.hud_input_logic.game_cursor_position, 120):to_polygon()
    rectangle_poly:draw(colors.RED)

    local ring_poly = ring(myhero.position, 300, 400):to_polygon()
    ring_poly:draw(colors.GREEN)

    -- and so on :)
end

function draw_heroes()
    for i, entity in pairs(entitylist.heroes.ally) do
        draw_manager:add_circle(entity.position, 60, 0xFF0000, 2, -1, 30)
    end

    for i, entity in pairs(entitylist.heroes.enemy) do
        draw_manager:add_circle(entity.position, 60, 0xFC0000, 2, -1, 30)
    end
end

function draw_minions()

  


    for i, value in pairs(entitylist.minions.all) do
        if value:is_valid(false) and not value.is_dead and not value.is_visible_on_screen then
            local position = value.position
            draw_manager:add_circle(position, 30, 0xFFFFFFFF, 2, -1, 30)
            draw_manager:add_text(position, 0xFFFFFFFF, 20, string.format("%s", value.name))
        end
    end


    for i, value in pairs(entitylist.minions.enemy) do
        if value:is_valid(false) and not value.is_dead then
            draw_manager:add_circle(value.position, 30, 0xFFFFFFFF, 2, -1, 30)

        end
    end

    for i, value in pairs(entitylist.minions.ally) do
        if value:is_valid(false) and not value.is_dead then
            draw_manager:add_circle(value.position, 30, 0xFFFFFFFF, 2, -1, 30)
            draw_manager:add_text(value.position, 0xFFFFFFFF, 20, string.format("%s", value.name))
        end
    end

    for i, value in pairs(entitylist.minions.neutral) do
        if value:is_valid(false) and not value.is_dead then
            draw_manager:add_circle(value.position, 30, 0xFFFFFFFF, 2, -1, 30)
        end
    end

end

function draw_entitylist()
    for i, value in pairs(entitylist.spawnpoints.all) do
        if value:is_valid(false)  then
            draw_manager:add_circle(value.position, 30, colors.ORANGE, 2, -1, 30)
        end
    end
end

function on_draw()
    draw_manager:add_text_on_screen(vector(250, 650), 0xFFFFFFFF, 22,
        string.format("Ping %f - stage %d - gui_is_open %s - mapid %d", ping.ping, state.stage, tostring(gui.gui_is_open),
            missioninfo.map_id))

    if showgeometry.bool then
        test_geometry()
    end
    if showdrawings.bool then
        test_drawings()
        draw_heroes()
        draw_minions()
        draw_entitylist()
    end

    if showprediction.bool then
        test_prediction()
    end


    if showbuffs.bool then
        local i = 0
        for k, buff in pairs(myhero.bufflist) do
            if buff.is_valid then
                i = i + 1
                if buff.texture ~= nil then
                    draw_manager:add_image(buff.texture, vector(450, 100 + (i * 25)), vector(32, 32), 0)
                end

                draw_manager:add_text_on_screen(vector(500, 100 + (i * 25)), 0xFFFFFFFF, 20,
                    string.format("Buff %s - type %d - count %d", buff.name, buff.type, buff.count))
            end
        end
    end



    if showitems.bool then
        local ix = 0
        for i = spellslot.item_1, spellslot.item_6, 1 do
            local item = myhero:get_item(i)
            if item ~= nil then
                ix = ix + 1
                local texture = item:get_texture()
                local uv = item:get_texture_uv()

                draw_manager:add_image(texture, vector(450, 100 + (ix * 25)), vector(32, 32), 0, vector(uv.x, uv.y),
                    vector(uv.z, uv.w))
                draw_manager:add_text_on_screen(vector(500, 100 + (ix * 25)), 0xFFFFFFFF, 20,
                    string.format("itemid %d - count %d", item.item_id, item.item_count))
            end
        end
    end




    if showpath.bool then
        local myPath = myhero.real_path
        for i = 1, #myPath - 1 do
            draw_manager:add_circle(myPath[i], 30, 0xFFFFFFFF, 2, -1, 30)
            draw_manager:add_line(myPath[i], myPath[i + 1], 0xFFFFFFFF, 5.0)
        end

        draw_manager:add_line(myhero.position,
            myhero.position:extend(hud.hud_input_logic.game_cursor_position, myhero.attackRange), 0xFFFFFFFF, 5.0)
    end

    if showspellw.bool then
        draw_manager:add_text_on_screen(vector(500, 100), 0xFFFFFFFF, 22,
            string.format("name %s - hash %x - range %f", spells.w.name, spells.w.name_hash, spells.w.range))
    end
end

function setup_spells()
    spells.q = plugin_sdk:register_spell(spellslot.q, 1200)
    spells.w = plugin_sdk:register_spell(spellslot.w, 1000)

    spells.q:set_skillshot(0.25, 60, 2000,
        { collisionable_objects.heroes, collisionable_objects.minions, collisionable_objects.yasuo_wall },
        skillshot_type.skillshot_line)

    spells.w:set_skillshot(0.25, 60, 20000, {}, skillshot_type.skillshot_line)
end

---- events_test

function on_send_chat(message, type, process)
    print("chat message " .. string.format("type %d - message %s", type, message))
    --- return false,"blocked"
    --- return true,"" -- default



    return true, "modified message on_send_chat"
end

function on_env_draw()
    draw_manager:add_circle(myhero.position, 250, colors.RED)
end

---@param sender game_object_script
---@param spell spell_instance_script
function on_process_spell_cast(sender, spell)
    if sender and sender.is_me then
        print("on_process_spell_cast " .. string.format("spell_name %s - slot %d", spell.spell_data.name, spell
            .spellslot))
    end
end

---@param hash_name number
---@param name string
---@param params global_event_params_script
function on_global_event(hash_name, name, params)
    if params:get_argument(1) == myhero.network_id then
        print("on_global_event " ..
        string.format("hash %x - name %s arg[0] %x - arg[1] %x", hash_name, name, params:get_argument(0),
            params:get_argument(1)))
    end
  
end

---@param target game_object_script
---@param process boolean
function on_before_attack_orbwalker(target, process)
    --- prevent attack if target below 80 health_percent
    if target and target.health_percent < 80 then
        return false
    end
    return true
end

---@param target game_object_script
---@param pos vector
---@param type _issue_order_type
---@param process boolean
function on_issue_order(target, pos, type, process)
    if type == _issue_order_type.MoveTo and myhero.health_percent < 80 then
        print("blocked order because we're low health - you can disabe this callback events.on_issue_order")
        return false;
    end
    return true
end

function on_sdk_load(sdk)
    print("loaded lua")
    texture_test = draw_manager:load_texture_from_file("aurora.png")
    setup_menu()
    setup_spells()

    myhero:print_chat(0, "Lua SDK Test Loaded")


    cb.add(events.on_create_object, on_create)
    cb.add(events.on_update, on_update)
    cb.add(events.on_draw, on_draw)
    cb.add(events.on_send_chat, on_send_chat)
    cb.add(events.on_env_draw, on_env_draw)
    cb.add(events.on_process_spell_cast, on_process_spell_cast)
    cb.add(events.on_global_event, on_global_event)
    cb.add(events.on_before_attack_orbwalker, on_before_attack_orbwalker)
    cb.add(events.on_issue_order, on_issue_order)
    return true
end

function on_sdk_unload(sdk)
    cb.remove(events.on_create_object, on_create)
    cb.remove(events.on_update, on_update)
    cb.remove(events.on_draw, on_draw)
    cb.remove(events.on_send_chat, on_send_chat)
    cb.remove(events.on_env_draw, on_env_draw)
    cb.remove(events.on_process_spell_cast, on_process_spell_cast)
    cb.remove(events.on_global_event, on_global_event)
    cb.remove(events.on_before_attack_orbwalker, on_before_attack_orbwalker)
    cb.remove(events.on_issue_order, on_issue_order)


    plugin_sdk:remove_spell(spells.q)
    plugin_sdk:remove_spell(spells.w)

    menu:delete_tab(mainmenu)
end
