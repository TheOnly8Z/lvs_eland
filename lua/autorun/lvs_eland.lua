AddCSLuaFile()

CreateConVar("lvs_eland_turret_driver", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "[Eland] Enable to give turret and weapon controls to the driver instead of the gunner.", 0, 1)
CreateConVar("lvs_eland_top_mg", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE, "[Eland] Enable to mount a machine gun for the commander (seat 3) .", 0, 1)

hook.Add("LVS.8Z.AddVehicleSettings", "lvs_eland", function(panel, node)
    local label = vgui.Create("ContentHeader", panel)
    label:SetText("Eland Armored Car")
    panel:Add(label)

    local turret_driver = vgui.Create("DCheckBoxLabel", panel)
    turret_driver:SetText("Driver Controls Turret")
    turret_driver:SetConVar("lvs_eland_turret_driver")
    turret_driver:SizeToContents()
    turret_driver:SetTextColor(color_white)
    panel:Add(turret_driver)

    local top_mg = vgui.Create("DCheckBoxLabel", panel)
    top_mg:SetText("Add Top-Mounted Machine Gun")
    top_mg:SetConVar("lvs_eland_top_mg")
    top_mg:SizeToContents()
    top_mg:SetTextColor(color_white)
    panel:Add(top_mg)
end)