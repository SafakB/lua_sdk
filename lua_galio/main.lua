---@diagnostic disable: return-type-mismatch

-- Name: Safak GALIO
-- Champion: Galio
-- Version: 1.0



local linq = require("lazylualinq")

---@type TreeTab
local mainmenu = nil



local spells = {
    ---@type script_spell
    q = nil
}


local config = {
    q = {
        combo = nil,
        combo_mana_limit = nil,
        harass = nil,
        laneclear = nil,
        laneclear_minions = nil,
        jungleclear = nil,
        killsteal = nil,
        maxrange = nil
    },
    draw = {
        q = nil,
        qcolor = nil,
        qcolor2 = nil
    }
}



function combo_mode()
    local target = target_selector:get_target_spell(spells.q, damage_type.magical)

    if target and target:is_valid_target() then
        if config.q.combo.bool and spells.q:is_ready() and myhero.mana_percent > config.q.combo_mana_limit and target:get_distance(myhero) < spells.q.range then
            spells.q:cast(target, hit_chance.high)
            myhero:print_chat(0, "Sa1")
        end
    end
end

function harass_mode()
end

function lane_clear_mode()
end

function jungle_clear_mode()
end

function on_update()
    if orbwalker:can_move(0.07) then
        if orbwalker.combo_mode then
            combo_mode()
        end
    end
end

function on_env_draw()
    if config.draw.q.bool then
        draw_manager:add_circle(myhero.position, spells.q.range, config.draw.qcolor.color)
        draw_manager:add_circle(myhero.position, spells.q.range + 200, config.draw.qcolor2.color)
    end
end

function on_draw()

end

function set_menu_icon(spell, entry)
    if spell.handle then
        entry:set_assigned_texture(spell.handle.icon_texture)
    end
end

function setup_menu()
    mainmenu = menu:create_tab("RTX.Galio", "Galio")
    mainmenu:set_assigned_texture(myhero.square_icon_portrait)

    local q_settings = mainmenu:add_tab("Galio.Q", "Winds of War")
    q_settings:add_separator("Galio.Q.Seperator.Combo", "Combo Mode")
    set_menu_icon(spells.q, q_settings)
    config.q.combo = q_settings:add_checkbox("Galio.Q.Combo", "Use in Combo", true)
    config.q.combo_mana_limit = q_settings:add_slider("Galio.Q.ComboManaLimit", "Mana Limit %", 10, 0, 100)

    local draw_settings = mainmenu:add_tab("Naafiri.Draw", "Drawings")
    draw_settings:add_separator("Galio.Draw.Separator.Q", "Winds of War (Q)")
    config.draw.q = draw_settings:add_checkbox("Galio.Draw.Q", "Enabled", true)
    config.draw.qcolor = draw_settings:add_colorpick("Galio.Draw.QColor", "Color", { 0.604, 0.349, 0.722, 1.0 })
    config.draw.qcolor2 = draw_settings:add_colorpick("Galio.Draw.QColor2", "Color Max", { 0.604, 0.349, 0.722, 1.0 })
end

function on_sdk_load(sdk)
    if myhero.champion ~= champion_id.Galio then
        myhero:print_chat(0, "Champion is not supported")
        return false
    end

    spells.q = plugin_sdk:register_spell(spellslot.q, 850.0)
    spells.q:set_skillshot(0.25, 210, 900.0, {}, skillshot_type.skillshot_circle)

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
        menu:delete_tab(mainmenu)
    end
end
