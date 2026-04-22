-- ============================================================
--  Molniya-1 Loiter Munition Control Panel
--  lua/autorun/client/cl_bombin_molniya_menu.lua
-- ============================================================

if not CLIENT then return end

local col_bg_panel      = Color(0,   0,   0,   255)
local col_section_title = Color(210, 210, 210, 255)
local col_accent        = Color(220, 140, 0,   255)  -- amber

local SECTION_COLORS = {
    ["NPC Call Settings"]  = Color(60,  120, 200, 120),
    ["Munition Behaviour"] = Color(80,  180, 120, 120),
    ["Dive Attack"]        = Color(200, 60,  40,  120),
    ["Debug"]              = Color(100, 100, 110, 120),
    ["Manual Spawn"]       = Color(140, 80,  200, 120),
}

local function AddColoredCategory(panel, text)
    local bgColor = SECTION_COLORS[text]
    if not bgColor then
        panel:Help(text)
        return
    end

    local cat = vgui.Create("DPanel", panel)
    cat:SetTall(24)
    cat:Dock(TOP)
    cat:DockMargin(0, 8, 0, 4)
    cat.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, bgColor)
        surface.SetDrawColor(0, 0, 0, 35)
        surface.DrawOutlinedRect(0, 0, w, h)
        local textColor = (bgColor.r + bgColor.g + bgColor.b < 200)
            and Color(255, 255, 255, 255)
            or  Color(0,   0,   0,   255)
        draw.SimpleText(
            text, "DermaDefaultBold",
            8, h / 2,
            textColor,
            TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
        )
    end
    panel:AddItem(cat)
end

concommand.Add("bombin_spawnmolniya", function()
    if not IsValid(LocalPlayer()) then return end
    net.Start("BombinMolniya_ManualSpawn")
    net.SendToServer()
end)

hook.Add("AddToolMenuTabs", "BombinMolniya_Tab", function()
    spawnmenu.AddToolTab("Bombin Support", "Bombin Support", "icon16/bomb.png")
end)

hook.Add("AddToolMenuCategories", "BombinMolniya_Categories", function()
    spawnmenu.AddToolCategory("Bombin Support", "Molniya-1", "Molniya-1")
end)

hook.Add("PopulateToolMenu", "BombinMolniya_ToolMenu", function()
    spawnmenu.AddToolMenuOption(
        "Bombin Support",
        "Molniya-1",
        "bombin_molniya_settings",
        "Molniya-1 Settings",
        "", "",
        function(panel)
            panel:ClearControls()

            local header = vgui.Create("DPanel", panel)
            header:SetTall(32)
            header:Dock(TOP)
            header:DockMargin(0, 0, 0, 8)
            header.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, col_bg_panel)
                surface.SetDrawColor(col_accent)
                surface.DrawRect(0, h - 2, w, 2)
                draw.SimpleText(
                    "Molniya-1 Loiter Munition Controller",
                    "DermaLarge",
                    8, h / 2,
                    col_section_title,
                    TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
                )
            end
            panel:AddItem(header)

            AddColoredCategory(panel, "NPC Call Settings")
            panel:CheckBox("Enable NPC calls",           "npc_bombinmolniya_enabled")
            panel:NumSlider("Call chance (per check)",   "npc_bombinmolniya_chance",   0,   1,    2)
            panel:NumSlider("Check interval (seconds)",  "npc_bombinmolniya_interval", 1,   60,   0)
            panel:NumSlider("NPC cooldown (seconds)",    "npc_bombinmolniya_cooldown", 10,  300,  0)
            panel:NumSlider("Min call distance (HU)",    "npc_bombinmolniya_min_dist", 100, 1000, 0)
            panel:NumSlider("Max call distance (HU)",    "npc_bombinmolniya_max_dist", 500, 8000, 0)
            panel:NumSlider("Flare → arrival delay (s)", "npc_bombinmolniya_delay",    1,   30,   0)

            AddColoredCategory(panel, "Munition Behaviour")
            panel:NumSlider("Lifetime (seconds)",         "npc_bombinmolniya_lifetime", 10,  120,  0)
            panel:NumSlider("Orbit speed (HU/s)",         "npc_bombinmolniya_speed",    50,  800,  0)
            panel:NumSlider("Orbit radius (HU)",          "npc_bombinmolniya_radius",   500, 6000, 0)
            panel:NumSlider("Altitude above ground (HU)", "npc_bombinmolniya_height",   500, 8000, 0)

            AddColoredCategory(panel, "Dive Attack")
            panel:NumSlider("Explosion damage",      "npc_bombinmolniya_dive_damage", 10,  500,  0)
            panel:NumSlider("Explosion radius (HU)", "npc_bombinmolniya_dive_radius", 50,  1000, 0)

            AddColoredCategory(panel, "Debug")
            panel:CheckBox("Enable debug prints", "npc_bombinmolniya_announce")

            AddColoredCategory(panel, "Manual Spawn")
            panel:Button("Spawn Molniya-1 now", "bombin_spawnmolniya")
        end
    )
end)
