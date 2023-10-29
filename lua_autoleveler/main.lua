---@diagnostic disable: return-type-mismatch

-- Name: Better Auto Leveler
-- Type: Utility
-- Version: 1.0
-- Date: 24.09.2023


local config =
{
    leveler = {
        enable = nil,
        level = nil
    }
}
function on_update()
    if config.leveler.enable.bool then
        if hud.hud_spell_logic.suggested_spell ~= spellslot.invalid and myhero.level >= config.leveler.level.int then
            myhero:levelup_spell(hud.hud_spell_logic.suggested_spell)
        end
    end
end

function setup_menu()
    mainmenu = menu:create_tab("RTX.AutoLeveler", "Better Auto Leveler")

    --- Settings
    config.leveler.enable = mainmenu:add_checkbox("leveler.Enable", "Enable Auto Leveler", true)
    config.leveler.enable:set_tooltip("You need to enable [Show Spell Recommendations] option in your game settings")
    config.leveler.level = mainmenu:add_slider("leveler.Level", "Start leveling after Lvl >=x", 1, 1, 18)
end

function on_sdk_load(sdk)
    setup_menu()
    cb.add(events.on_update, on_update)
    return true
end

function on_sdk_unload(sdk)
    if mainmenu ~= nil then
        --- always remove callbacks
        cb.remove(events.on_update, on_update)
        menu:delete_tab(mainmenu)
    end
end
