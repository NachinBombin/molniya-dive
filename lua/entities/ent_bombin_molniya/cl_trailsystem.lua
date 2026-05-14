-- ============================================================
-- CONTRAIL SYSTEM  --  ent_bombin_molniya
-- Three persistent beam trails: tail + left/right wingtips.
-- Unique hook names to avoid collision with AC-130 / TB2 / tomahawk.
-- ============================================================
-- Source Engine local-space axes:
--   X = forward   (nose direction)
--   Y = right     (starboard = +Y, port = -Y)
--   Z = up
--
-- Emission points:
--   [1] Tail        : centre-line rear of the fuselage
--   [2] Left  wing  : port wingtip trailing edge
--   [3] Right wing  : starboard wingtip trailing edge
-- ============================================================

local TRAIL_MATERIAL = Material( "trails/smoke" )
local SAMPLE_RATE    = 0.025   -- 40 fps sampling

local TRAIL_POSITIONS = {
    Vector(  0, -45,   0 ),   -- [1] tail / rear fuselage
    Vector( -8, -10,   2 ),   -- [2] left  wingtip  (-Y port)
    Vector(  8, -10,   2 ),   -- [3] right wingtip  (+Y starboard)
}

-- Contrail config: thin near drone, widens behind it.
local CONTRAIL_CFG = {
    r         = 255,
    g         = 255,
    b         = 255,
    a         = 130,
    startSize = 4,
    endSize   = 22,
    lifetime  = 6,
}

local MolniyaTrails = {}

local function EnsureRegistered( entIndex )
    if MolniyaTrails[entIndex] then return end
    local trails = {}
    for i = 1, #TRAIL_POSITIONS do
        trails[i] = { positions = {} }
    end
    MolniyaTrails[entIndex] = {
        nextSample = 0,
        trails     = trails,
    }
end

local function DrawBeam( positions, cfg )
    local n = #positions
    if n < 2 then return end

    local Time = CurTime()
    local lt   = cfg.lifetime

    for i = n, 1, -1 do
        if Time - positions[i].time > lt then
            table.remove( positions, i )
        end
    end

    n = #positions
    if n < 2 then return end

    render.SetMaterial( TRAIL_MATERIAL )
    render.StartBeam( n )
    for _, pd in ipairs( positions ) do
        local Scale = math.Clamp( (pd.time + lt - Time) / lt, 0, 1 )
        local size  = cfg.startSize * Scale + cfg.endSize * (1 - Scale)
        render.AddBeam( pd.pos, size, pd.time * 50,
            Color( cfg.r, cfg.g, cfg.b, cfg.a * Scale * Scale ) )
    end
    render.EndBeam()
end

hook.Add( "Think", "bombin_molniya_contrail_update", function()
    local Time = CurTime()

    for _, ent in ipairs( ents.FindByClass( "ent_bombin_molniya" ) ) do
        EnsureRegistered( ent:EntIndex() )
    end

    for entIndex, state in pairs( MolniyaTrails ) do
        local ent = Entity( entIndex )
        if not IsValid( ent ) then
            MolniyaTrails[entIndex] = nil
            continue
        end

        if Time < state.nextSample then continue end
        state.nextSample = Time + SAMPLE_RATE

        local pos = ent:GetPos()
        local ang = ent:GetAngles()

        for i, trail in ipairs( state.trails ) do
            local wpos = LocalToWorld( TRAIL_POSITIONS[i], Angle(0,0,0), pos, ang )
            table.insert( trail.positions, { time = Time, pos = wpos } )
            table.sort( trail.positions, function( a, b ) return a.time > b.time end )
        end
    end
end )

hook.Add( "PostDrawTranslucentRenderables", "bombin_molniya_contrail_draw", function( bDepth, bSkybox )
    if bSkybox then return end
    for _, state in pairs( MolniyaTrails ) do
        for _, trail in ipairs( state.trails ) do
            DrawBeam( trail.positions, CONTRAIL_CFG )
        end
    end
end )
