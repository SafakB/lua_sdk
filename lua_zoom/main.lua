---@diagnostic disable: return-type-mismatch

-- Name: Zoom Manager
-- Type: Utility
-- Version: 1.0
-- Date: 5.09.2023
-- Simple zoom


local config =
{
    zoom = {
        enable = nil,
        distance = nil,
        fov = nil
    }
}
function on_update()
    if config.zoom.enable.bool then
        hud:set_max_zoom(config.zoom.distance.int)
        hud.hud_camera_logic:set_zoom_factor(config.zoom.fov.int)
    end
end

function setup_menu()
    mainmenu = menu:create_tab("RTX.ZoomHack", "Zoom Hack")

    --- Settings
    local manager = mainmenu:add_tab("RTX.ZoomManager.Tab", "Zoom Hack")
    config.zoom.enable = manager:add_checkbox("Zoom.Enable", "Enable Zoom Hack", true)
    config.zoom.distance = manager:add_slider("Zoom.Level", "Max Zoom", 2250, 2250, 3800)
    config.zoom.fov = manager:add_slider("Zoom.Fov", "Zoom FOV", 40, 40, 60)

    config.zoom.enable:add_property_change_callback(function(entry)
        if entry.bool ~= true then
            hud:set_max_zoom(2250)
            hud.hud_camera_logic:set_zoom_factor(40)
        end
    end)
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
