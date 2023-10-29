---@diagnostic disable: return-type-mismatch

-- Name: Safak GALIO
-- Champion: Galio
-- Version: 1.0



local linq = require("lazylualinq")

---@type TreeTab
local mainmenu = nil



local spells = {
    ---@type script_spell
    q = nil,
    ---@type script_spell
    w = nil,
    ---@type script_spell
    e = nil,
}


local config = {
    q = {
        combo = nil,
        harass = nil,
        laneclear = nil,
        laneclear_minions = nil,
        lane_clear_mana_limit = nil,
        jungleclear = nil,
        killsteal = nil,
        maxrange = nil
    },
    w = {
        combo = nil,
        harass = nil,
        laneclear = nil,
        laneclear_minions = nil,
        lane_clear_mana_limit = nil,
        jungleclear = nil,
        killsteal = nil,
        maxrange = nil
    },
    e = {
        combo = nil,
        has_passive_combo = nil,
        harass = nil,
        laneclear = nil,
        laneclear_minions = nil,
        lane_clear_mana_limit = nil,
        jungleclear = nil,
        killsteal = nil,
        maxrange = nil
    },
    draw = {
        has_ready = nil,
        q = nil,
        qcolor = nil,
        qcolor2 = nil,
        w = nil,
        wcolor = nil,
        e = nil,
        ecolor = nil,
    },
    shorcuts = {
        use_skill_farming = nil,
    }
}



function combo_mode()
    local target = target_selector:get_target_spell(spells.q, damage_type.magical)
    local has_passive = myhero:has_buff(buff_hash("galiopassivebuff"))
    if target and target:is_valid_target() then
        if config.q.combo.bool and spells.q:is_ready() and target:get_distance(myhero) < spells.q.range then
            spells.q:cast(target, hit_chance.high)
        end
        if config.w.combo.bool and spells.w:is_ready() and target:get_distance(myhero) < spells.w.range and not spells.e:is_ready() then
            spells.w:start_charging(myhero.position)
        end
        if config.e.combo.bool and spells.e:is_ready() and target:get_distance(myhero) < spells.e.range then
            if config.e.has_passive_combo.bool and not has_passive then
                return
            else
                spells.e:cast(target, hit_chance.high)
            end
        end
    else
    end
end

function harass_mode()
end

function lane_clear_mode()
    if config.q.laneclear and config.shorcuts.use_skill_farming.bool and spells.q:is_ready() and myhero.mana_percent > config.q.lane_clear_mana_limit.int then
        spells.q:cast_on_best_farm_position(config.q.laneclear_minions.int, false)
    end
end

function jungle_clear_mode()
end

function checkBehind()
    local afterEPosition = myhero.position - (myhero.direction) * 200
    local target = target_selector:get_target(700, damage_type.magical)
    if target and target:is_valid() then
        if target:get_distance(afterEPosition) < 480 or target:get_distance(myhero) < 150 then
            return false
        else
            return true
        end
    else
        myhero:print_chat(0, "Not Valid Target")
        return true
    end
end

function flee_mode()
    -- local target = target_selector:get_target_spell(spells.e, damage_type.magical)

    -- if not target and not target:is_valid_target() then
    --     spells.e:cast(myhero.position + myhero.direction * 300)
    -- end


    local flee_block = checkBehind()
    if spells.e:is_ready() then
        if flee_block then
            spells.e:cast(myhero.position + myhero.direction * 300)
        else
            return
        end
    end
end

function on_update()
    if orbwalker:can_move(0.07) then
        if orbwalker.combo_mode then
            combo_mode()
        elseif orbwalker.lane_clear_mode then
            lane_clear_mode()
        elseif orbwalker.flee_mode then
            flee_mode()
        end
    end
end

function on_env_draw()
    if config.draw.q.bool then
        if config.draw.has_ready.bool and spells.q:is_ready() then
            draw_manager:add_circle(myhero.position, spells.q.range, config.draw.qcolor.color)
            draw_manager:add_circle(myhero.position, spells.q.range + 200, config.draw.qcolor2.color)
        end
    end
    if config.draw.w.bool then
        if config.draw.has_ready.bool and spells.w:is_ready() then
            draw_manager:add_circle(myhero.position, spells.w.range, config.draw.wcolor.color)
        end
    end
    if config.draw.e.bool then
        if config.draw.has_ready.bool and spells.e:is_ready() then
            draw_manager:add_circle(myhero.position, spells.e.range, config.draw.ecolor.color)
        end
    end
end

local function rotatePoint(cx, cy, angle, p)
    local s = math.sin(angle)
    local c = math.cos(angle)

    -- p noktasını merkeze göre taşı
    local x = p.x - cx
    local y = p.y - cy

    -- p noktasını döndür
    local xnew = x * c - y * s
    local ynew = x * s + y * c

    -- p noktasını geri taşı
    return vector(cx + xnew, cy + ynew, p.z)
end

function on_draw()
    --local pos_after = myhero.position - (myhero.direction) * 200
    --
    --local half_width = 300
    --local half_height = 210
    --
    --local topLeft = vector(pos_after.x - half_width, pos_after.y - half_height, pos_after.z)
    --local topRight = vector(pos_after.x + half_width, pos_after.y - half_height, pos_after.z)
    --local bottomLeft = vector(pos_after.x - half_width, pos_after.y + half_height, pos_after.z)
    --local bottomRight = vector(pos_after.x + half_width, pos_after.y + half_height, pos_after.z)
    --
    --local direction_angle = math.atan2(myhero.direction.y, myhero.direction.x)
    --
    --topLeft = rotatePoint(pos_after.x, pos_after.y, direction_angle, topLeft)
    --topRight = rotatePoint(pos_after.x, pos_after.y, direction_angle, topRight)
    --bottomLeft = rotatePoint(pos_after.x, pos_after.y, direction_angle, bottomLeft)
    --bottomRight = rotatePoint(pos_after.x, pos_after.y, direction_angle, bottomRight)
    --
    --draw_manager:add_line(topLeft, topRight, MAKE_COLOR(255, 0, 0, 255), 2)
    --draw_manager:add_line(bottomLeft, bottomRight, MAKE_COLOR(255, 0, 0, 255), 2)
    --draw_manager:add_line(topLeft, bottomLeft, MAKE_COLOR(255, 0, 0, 255), 2)
    --draw_manager:add_line(topRight, bottomRight, MAKE_COLOR(255, 0, 0, 255), 2)



    --local afterEPosition = myhero.position - (myhero.direction) * 200
    --draw_manager:add_circle(afterEPosition, 300, MAKE_COLOR(0, 0, 255, 255), 2)
    --draw_manager:add_circle(afterEPosition, 20, MAKE_COLOR(0, 255, 0, 0), 2)
    --draw_manager:add_circle(myhero.position + myhero.direction * 300, 20, MAKE_COLOR(255, 0, 0, 0), 2)



    local status = string.format("Farm Mode: %s", config.shorcuts.use_skill_farming.bool and "ON" or "OFF")
    local text_w = draw_manager:calc_text_size(10, status).x + 1
    local position = myhero.position:worldtoscreen() + vector(-text_w / 2, 60)

    draw_manager:add_text_on_screen(position,
        config.shorcuts.use_skill_farming.bool and MAKE_COLOR(0, 255, 0, 255) or MAKE_COLOR(255, 0, 0, 255), 22,
        status)
end

function set_menu_icon(spell, entry)
    if spell.handle then
        entry:set_assigned_texture(spell.handle.icon_texture)
    end
end

function setup_menu()
    mainmenu = menu:create_tab("RTX.Galio", "Galio")
    mainmenu:set_assigned_texture(myhero.square_icon_portrait)

    mainmenu:add_image_item("Galio.Draw.Image", myhero.square_icon_portrait, 100)
    local q_settings = mainmenu:add_tab("Galio.Q", "Winds of War")
    q_settings:add_separator("Galio.Q.Seperator.Combo", "Combo Mode")
    set_menu_icon(spells.q, q_settings)
    config.q.combo = q_settings:add_checkbox("Galio.Q.Combo", "Use in Combo", true)
    q_settings:add_separator("Galio.Q.Seperator.Combo", "Farming")
    config.q.laneclear = q_settings:add_checkbox("Galio.Q.LaneClear", "Use in Farming", true)
    config.q.laneclear_minions = q_settings:add_slider("Galio.Q.LaneClearMinions", "Minions to Hit", 3, 1, 7, true)
    config.q.lane_clear_mana_limit = q_settings:add_slider("Galio.Q.LaneClearManaLimit", "Farm Mana Limit %", 40, 0, 100,
        false)

    local w_settings = mainmenu:add_tab("Galio.W", "Shield of Durand")
    w_settings:add_separator("Galio.W.Seperator.Combo", "Combo Mode")
    set_menu_icon(spells.w, w_settings)
    config.w.combo = w_settings:add_checkbox("Galio.W.Combo", "Use in Combo", true)


    local e_settings = mainmenu:add_tab("Galio.E", "Dash")
    e_settings:add_separator("Galio.E.Seperator.Combo", "Combo Mode")
    set_menu_icon(spells.e, e_settings)
    config.e.combo = e_settings:add_checkbox("Galio.E.Combo", "Use in Combo", true)
    config.e.has_passive_combo = e_settings:add_checkbox("Galio.E.HasPassiveCombo", "Use Has Passive", true)



    local draw_settings = mainmenu:add_tab("Galio.Draw", "Drawings")

    draw_settings:add_separator("Galio.Draw.Separator.Q", "Drawing Settings")
    config.draw.has_ready = draw_settings:add_checkbox("Galio.Draw. ", "Draw Only Ready Spells", true)
    config.draw.q = draw_settings:add_checkbox("Galio.Draw.Q", "Show Q", true)
    config.draw.qcolor = draw_settings:add_colorpick("Galio.Draw.QColor", "Color", { 0.604, 0.349, 0.722, 1.0 }, true)
    config.draw.qcolor2 = draw_settings:add_colorpick("Galio.Draw.QColor2", "Color Max", { 0.604, 0.349, 0.722, 1.0 },
        true)
    config.draw.w = draw_settings:add_checkbox("Galio.Draw.W", "Show W", true)
    config.draw.wcolor = draw_settings:add_colorpick("Galio.Draw.WColor", "Color", { 0.604, 0.349, 0.722, 1.0 }, true)
    config.draw.e = draw_settings:add_checkbox("Galio.Draw.E", "Show E", true)
    config.draw.ecolor = draw_settings:add_colorpick("Galio.Draw.EColor", "Color", { 0.604, 0.349, 0.722, 1.0 }, true)

    config.shorcuts.use_skill_farming = mainmenu:add_hotkey("Galio.SkillFarm", "Use Skill Farming",
        tree_hotkey_mode.Toggle,
        char_key("H"), false)
end

function on_sdk_load(sdk)
    if myhero.champion ~= champion_id.Galio then
        myhero:print_chat(0, "Champion is not supported")
        return false
    end

    spells.q = plugin_sdk:register_spell(spellslot.q, 850.0)
    spells.q:set_skillshot(0.25, 210, 900.0, {}, skillshot_type.skillshot_circle)

    spells.w = plugin_sdk:register_spell(spellslot.w, 460.0)
    spells.w:set_charged(0.25, 460, 4000)
    spells.w:set_skillshot(0.25, 460, 4000.0, {}, skillshot_type.skillshot_circle)

    spells.e = plugin_sdk:register_spell(spellslot.e, 650.0)
    spells.e:set_skillshot(0.25, 210, 900.0, {}, skillshot_type.skillshot_circle)

    setup_menu()

    cb.add(events.on_update, on_update)
    cb.add(events.on_draw, on_draw)
    cb.add(events.on_env_draw, on_env_draw)
    return true
end

function on_sdk_unload()
    myhero:print_chat(0, "Unloaded")
    if mainmenu ~= nil then
        cb.remove(events.on_update, on_update)
        cb.remove(events.on_draw, on_draw)
        cb.remove(events.on_env_draw, on_env_draw)

        plugin_sdk.remove_spell(spells.q)
        plugin_sdk.remove_spell(spells.w)
        plugin_sdk.remove_spell(spells.e)
        menu:delete_tab(mainmenu)
    end
end
