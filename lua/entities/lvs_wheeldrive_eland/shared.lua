
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Eland"
ENT.Author = "8Z"
ENT.Information = ""
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Armored"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.TurretSeatIndex = 1

ENT.SpawnNormalOffset = 20 -- spawn normal offset, raise to prevent spawning into the ground
--ENT.SpawnNormalOffsetSpawner = 0 -- offset for ai vehicle spawner

ENT.MDL = "models/8z/lvs/eland.mdl"
ENT.MDL_DESTROYED = "models/8z/lvs/eland_wreck.mdl"

-- ENT.TurretFireSound = "lvs/vehicles/sherman/cannon_fire.wav"
-- ENT.TurretFireSoundInterior = "lvs/vehicles/sherman/cannon_fire.wav"

ENT.AITEAM = 2

ENT.MaxHealth = 800
ENT.FrontArmor = 800
ENT.SideArmor = 400
ENT.TurretArmor = 1000
ENT.RearArmor = 0

ENT.DSArmorIgnoreForce = 1000

ENT.MaxVelocity = 1300
ENT.EngineCurve = 0.25
ENT.EngineTorque = 200

ENT.TransGears = 6
ENT.TransGearsReverse = 1
ENT.WheelBrakeAutoLockup = false

ENT.FastSteerAngleClamp = 6
ENT.FastSteerDeactivationDriftAngle = 7

ENT.PhysicsWeightScale = 1.5
ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = false

ENT.WheelSideForce = 800
ENT.WheelDownForce = 1000

ENT.TurretBodygroup = 0

function ENT:OnSetupDataTables()
    self:AddDT( "Entity", "WeaponSeat" )
    self:AddDT( "Entity", "GunnerSeat" )
    self:AddDT( "Entity", "CommanderSeat" )

    self:AddDT( "Bool", "UseHighExplosive" )
end

function ENT:InitWeaponMG()
    local COLOR_WHITE = Color(255,255,255,255)

    local weapon = {}
    weapon.Icon = Material("lvs/weapons/mg.png")
    weapon.Ammo = 1200
    weapon.Delay = 0.1
    weapon.HeatRateUp = 0.25
    weapon.HeatRateDown = 0.3
    weapon.Attack = function( ent )
        local veh = ent:GetVehicle()
        local ID = veh:LookupAttachment( "muzzle_mg" )
        local Muzzle = veh:GetAttachment( ID )
        if not Muzzle then return end

        local spread = Lerp(ent:GetHeat() ^ 0.5, 0.01, 0.018)
        local bullet = {}
        bullet.Src = Muzzle.Pos
        bullet.Dir = Muzzle.Ang:Forward()
        bullet.Spread = Vector(spread,spread,spread)
        bullet.TracerName = "lvs_tracer_yellow"
        bullet.Force = 10
        bullet.HullSize = 0
        bullet.Damage = 25
        bullet.Velocity = 30000
        bullet.Attacker = veh:GetPassenger(gun_seat)
        veh:LVSFireBullet( bullet )

        local effectdata = EffectData()
        effectdata:SetOrigin( bullet.Src )
        effectdata:SetNormal( bullet.Dir )
        effectdata:SetEntity( ent )
        util.Effect( "lvs_muzzle", effectdata )

        ent:TakeAmmo( 1 )
    end
    weapon.StartAttack = function( ent )
        local veh = ent:GetVehicle()
        if not IsValid( veh.SNDTurretMG ) then return end
        veh.SNDTurretMG:Play()
    end
    weapon.FinishAttack = function( ent )
        local veh = ent:GetVehicle()
        if not IsValid( veh.SNDTurretMG ) then return end
        veh.SNDTurretMG:Stop()
    end
    weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
    weapon.HudPaint = function( ent, X, Y, ply )
        local veh = ent:GetVehicle()
        local ID = veh:LookupAttachment( "muzzle_mg" )
        local Muzzle = veh:GetAttachment( ID )

        if Muzzle then
            local traceTurret = util.TraceLine( {
                start = Muzzle.Pos,
                endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
                filter = veh:GetCrosshairFilterEnts()
            } )

            local MuzzlePos2D = traceTurret.HitPos:ToScreen()

            veh:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
            veh:LVSPaintHitMarker( MuzzlePos2D )
        end
    end
    weapon.OnOverheat = function( ent )
        local veh = ent:GetVehicle()
        veh:EmitSound("lvs/overheat.wav")
    end
    self:AddWeapon(weapon, self.TurretSeatIndex)

    if GetConVar("lvs_eland_top_mg"):GetBool() then
        weapon = {}
        weapon.Icon = Material("lvs/weapons/mg.png")
        weapon.Ammo = 1500
        weapon.Delay = 0.1
        weapon.HeatRateUp = 0.22
        weapon.HeatRateDown = 0.33
        weapon.Attack = function( ent )
            local veh = ent:GetVehicle()
            local ID = veh:LookupAttachment( "muzzle_cupola_mg" )
            local Muzzle = veh:GetAttachment( ID )
            if not Muzzle then return end

            local spread = Lerp(ent:GetHeat() ^ 0.5, 0.008, 0.015)
            local bullet = {}
            bullet.Src = Muzzle.Pos
            bullet.Dir = Muzzle.Ang:Forward()
            bullet.Spread = Vector(spread,spread,spread)
            bullet.TracerName = "lvs_tracer_yellow"
            bullet.Force = 10
            bullet.HullSize = 0
            bullet.Damage = 25
            bullet.Velocity = 30000
            bullet.Attacker = veh:GetPassenger(3)
            veh:LVSFireBullet( bullet )

            local effectdata = EffectData()
            effectdata:SetOrigin( bullet.Src )
            effectdata:SetNormal( bullet.Dir )
            effectdata:SetEntity( ent )
            util.Effect( "lvs_muzzle", effectdata )

            ent:TakeAmmo( 1 )
            veh:PlayAnimation("cupola_mg_fire")
        end
        weapon.StartAttack = function( ent )
            local veh = ent:GetVehicle()
            if not IsValid( veh.SNDTopMG ) then return end
            veh.SNDTopMG:Play()
        end
        weapon.FinishAttack = function( ent )
            local veh = ent:GetVehicle()
            if not IsValid( veh.SNDTopMG ) then return end
            veh.SNDTopMG:Stop()
        end
        weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
        weapon.HudPaint = function( ent, X, Y, ply )
            local veh = ent:GetVehicle()
            local ID = veh:LookupAttachment( "muzzle_cupola_mg" )
            local Muzzle = veh:GetAttachment( ID )

            if Muzzle then
                local traceTurret = util.TraceLine( {
                    start = Muzzle.Pos,
                    endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
                    filter = veh:GetCrosshairFilterEnts()
                } )

                local MuzzlePos2D = traceTurret.HitPos:ToScreen()

                veh:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
                veh:LVSPaintHitMarker( MuzzlePos2D )
            end
        end
        weapon.OnOverheat = function( ent )
            local veh = ent:GetVehicle()
            veh:EmitSound("lvs/overheat.wav")
        end
        self:AddWeapon(weapon, 3)
    else
        self:SetBodygroup(5, 1)
    end
end

-- Also adds the disable turret weapon
function ENT:InitWeaponSmoke()
    local weapon = {}
    weapon.Icon = Material("lvs/weapons/smoke_launcher.png")
    weapon.Ammo = 2
    weapon.Delay = 1
    weapon.HeatRateUp = 1
    weapon.HeatRateDown = 0.5
    weapon.Attack = function( ent )
        local veh = ent:GetVehicle()
        ent:TakeAmmo( 1 )

        local ID1 = veh:LookupAttachment( "smoke_right" )
        local ID2 = veh:LookupAttachment( "smoke_left" )

        local Muzzle1 = veh:GetAttachment( ID1 )
        local Muzzle2 = veh:GetAttachment( ID2 )

        if not Muzzle1 or not Muzzle2 then return end

        veh:EmitSound("lvs/smokegrenade.wav")

        local Ang1 = Muzzle1.Ang
        -- Ang1:RotateAroundAxis( Up, -5 )
        local grenade = ents.Create( "lvs_item_smoke" )
        grenade:SetPos( Muzzle1.Pos )
        grenade:SetAngles( Ang1 )
        grenade:Spawn()
        grenade:Activate()
        grenade:GetPhysicsObject():SetVelocity( Ang1:Forward() * 750 + veh:GetVelocity() )

        local Ang2 = Muzzle2.Ang
        -- Ang2:RotateAroundAxis( Up, 5 )
        grenade = ents.Create( "lvs_item_smoke" )
        grenade:SetPos( Muzzle2.Pos )
        grenade:SetAngles( Ang2 )
        grenade:Spawn()
        grenade:Activate()
        grenade:GetPhysicsObject():SetVelocity( Ang2:Forward() * 750 + veh:GetVelocity() )
    end
    self:AddWeapon(weapon, self.TurretSeatIndex)

    weapon = {}
    weapon.Icon = Material("lvs/weapons/tank_noturret.png")
    weapon.Ammo = -1
    weapon.Delay = 0
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0
    weapon.OnSelect = function( ent )
        local veh = ent:GetVehicle()
        if veh.SetTurretEnabled then
            veh:SetTurretEnabled( false )
        end
    end
    weapon.OnDeselect = function( ent )
        local veh = ent:GetVehicle()
        if veh.SetTurretEnabled then
            veh:SetTurretEnabled( true )
        end
    end
    self:AddWeapon(weapon, self.TurretSeatIndex)
end

--[[ engine sounds ]]
ENT.EngineSounds = {
    {
        sound = "lvs/vehicles/222/eng_idle_loop.wav",
        Volume = 0.5,
        Pitch = 85,
        PitchMul = 25,
        SoundLevel = 75,
        SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
    },
    {
        sound = "lvs/vehicles/222/eng_loop.wav",
        Volume = 1,
        Pitch = 70,
        PitchMul = 100,
        SoundLevel = 75,
        UseDoppler = true,
    },
}


--[[ exhaust ]]
ENT.ExhaustPositions = {
    {
        pos = Vector(0, -75, 30),
        ang = Angle(0,-90,0),
    },
    {
        pos = Vector(35, -38, 52),
        ang = Angle(-75,90,0),
    },
    {
        pos = Vector(-35, -38, 52),
        ang = Angle(-75,90,0),
    },
}

ENT.RandomColor = {
    {
        Skin = 0,
        Color = Color(255,255,255),
        BodyGroups = {
            [2] = 1,
        },
    },
    {
        Skin = 0,
        Color = Color(255,255,255),
        BodyGroups = {
            [3] = 1,
        },
    },
    {
        Skin = 0,
        Color = Color(255,255,255),
        BodyGroups = {
            [4] = 1,
        },
    },
    {
        Skin = 0,
        Color = Color(255,255,255),
        BodyGroups = {
            [4] = 1,
            [2] = 1,
            [3] = 1,
        },
    },
    {
        Skin = 1,
        Color = Color(255,255,255),
        BodyGroups = {
            [2] = 1,
        },
        Wheels = {
            Skin = 1,
            Color = Color(255,255,255),
        },
    },
    {
        Skin = 1,
        Color = Color(255,255,255),
        BodyGroups = {
            [3] = 1,
        },
        Wheels = {
            Skin = 1,
            Color = Color(255,255,255),
        },
    },
    {
        Skin = 1,
        Color = Color(255,255,255),
        BodyGroups = {
            [4] = 1,
        },
        Wheels = {
            Skin = 1,
            Color = Color(255,255,255),
        },
    },
    {
        Skin = 1,
        Color = Color(255,255,255),
        BodyGroups = {
            [4] = 1,
            [2] = 1,
            [3] = 1,
        },
        Wheels = {
            Skin = 1,
            Color = Color(255,255,255),
        },
    },
}

--[[ lights ]]
ENT.Lights = {
    {
        Trigger = "main",
        -- SubMaterialID = 1,
        Sprites = {
            [1] = {
                pos = Vector(-29.75, 66, 48.5),
                colorB = 200,
                colorA = 150,
            },
            [2] = {
                pos = Vector(29.75, 66, 48.5),
                colorB = 200,
                colorA = 150,
            },
        },
        ProjectedTextures = {
            [1] = {
                pos = Vector(-29.75, 66, 48.5),
                ang = Angle(0, 90, 0),
                colorB = 200,
                colorA = 150,
                shadows = true,
            },
            [2] = {
                pos = Vector(29.75, 66, 48.5),
                ang = Angle(0, 90, 0),
                colorB = 200,
                colorA = 150,
                shadows = true,
            },
        },
    },
    {
        Trigger = "high",
        -- SubMaterialID = 1,
        Sprites = {
            [1] = {
                pos = Vector(-29.75, 66, 48.5),
                colorB = 200,
                colorA = 150,
            },
            [2] = {
                pos = Vector(29.75, 66, 48.5),
                colorB = 200,
                colorA = 150,
            },
        },
        ProjectedTextures = {
            [1] = {
                pos = Vector(-29.75, 66, 48.5),
                ang = Angle(0, 90, 0),
                colorB = 200,
                colorA = 150,
                shadows = true,
            },
            [2] = {
                pos = Vector(29.75, 66, 48.5),
                ang = Angle(0, 90, 0),
                colorB = 200,
                colorA = 200,
                shadows = true,
            },
        },
    },
    {
        Trigger = "brake",
        Sprites = {
            [1] = {
                pos = Vector(-31, -83, 41.5),
                colorG = 120,
                colorB = 0,
                colorA = 150,
            },
            [2] = {
                pos = Vector(31, -83, 41.5),
                colorG = 120,
                colorB = 0,
                colorA = 150,
            },
        },
    },
    {
        Trigger = "turnleft",
        Sprites = {
            [1] = {
                pos = Vector(-36, 66, 44),
                colorG = 90,
                colorB = 0,
                colorA = 50,
            },
        },
    },
    {
        Trigger = "turnright",
        Sprites = {
            [1] = {
                pos = Vector(36, 66, 44),
                colorG = 90,
                colorB = 0,
                colorA = 50,
            },
        },
    },
}