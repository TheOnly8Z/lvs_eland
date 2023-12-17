ENT.Base = "lvs_wheeldrive_eland"

ENT.PrintName = "Eland-90"
ENT.Author = "8Z"
ENT.Information = ""
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Armored"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.TurretAimRate = 45
ENT.TurretPitchMin = -20
ENT.TurretPitchMax = 8

ENT.CannonArmorPenetration = 9200

ENT.MDL_TURRETGIB = "models/8z/lvs/gibs/eland_turret_90.mdl"

ENT.TurretFireSound = "lvs/vehicles/sherman/cannon_fire.wav"
ENT.TurretFireSoundInterior = "lvs/vehicles/sherman/cannon_fire.wav"

ENT.TurretBodygroup = 0

function ENT:InitWeapons()

    self:SetBodygroup(1, 0)

    local COLOR_WHITE = Color(255,255,255,255)

    if GetConVar("lvs_eland_turret_driver"):GetBool() then
        self.TurretSeatIndex = 1
    else
        self.TurretSeatIndex = 2
    end

    self:InitWeaponMG()

    weapon = {}
    weapon.Icon = true
    weapon.Ammo = 30
    weapon.Delay = 2.5
    weapon.HeatRateUp = 1
    weapon.HeatRateDown = 0.333
    weapon.OnThink = function( ent )
        local veh = ent:GetVehicle()
        if ent:GetSelectedWeapon() ~= 2 then return end
        local ply = veh:GetPassenger(self.TurretSeatIndex)

        if not IsValid( ply ) then return end

        local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )

        if veh._oldSwitchType ~= SwitchType then
            veh._oldSwitchType = SwitchType

            if SwitchType then
                veh:SetUseHighExplosive( not veh:GetUseHighExplosive() )
                veh:EmitSound("lvs/vehicles/sherman/cannon_unload.wav", 75, 100, 1, CHAN_WEAPON )
                ent:SetHeat( 1 )
                ent:SetOverheated( true )
            end
        end
    end
    weapon.Attack = function( ent )
        local veh = ent:GetVehicle()
        local ID = veh:LookupAttachment( "muzzle_turret" )
        local Muzzle = veh:GetAttachment( ID )

        if not Muzzle then return end

        local bullet = {}
        bullet.Src 	= Muzzle.Pos
        bullet.Dir 	= Muzzle.Ang:Forward()
        bullet.Spread = Vector(0,0,0)

        if veh:GetUseHighExplosive() then
            bullet.Force	= 500
            bullet.HullSize = 15
            bullet.Damage	= 250
            bullet.SplashDamage = 750
            bullet.SplashDamageRadius = 200
            bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
            bullet.SplashDamageType = DMG_BLAST
            bullet.Velocity = 13000
        else
            bullet.Force	= veh.CannonArmorPenetration
            bullet.HullSize 	= 0
            bullet.Damage	= 1000
            bullet.Velocity = 16000
        end

        bullet.TracerName = "lvs_tracer_cannon"
        bullet.Attacker 	= veh:GetPassenger(self.TurretSeatIndex)
        veh:LVSFireBullet( bullet )

        local effectdata = EffectData()
        effectdata:SetOrigin( bullet.Src )
        effectdata:SetNormal( bullet.Dir )
        effectdata:SetEntity( veh )
        util.Effect( "lvs_muzzle", effectdata )

        local PhysObj = veh:GetPhysicsObject()
        if IsValid( PhysObj ) then
            PhysObj:ApplyForceOffset( -bullet.Dir * 120000, bullet.Src )
        end
        ent:TakeAmmo(1)
        veh:PlayAnimation( "turret_fire" )

        if not IsValid( veh.SNDTurret ) then return end
        veh.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + veh:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
        veh:EmitSound("lvs/vehicles/sherman/cannon_reload.wav", 75, 100, 1, CHAN_WEAPON )
    end
    weapon.HudPaint = function( ent, X, Y, ply )
        local veh = ent:GetVehicle()
        local ID = veh:LookupAttachment("muzzle_turret")
        local Muzzle = veh:GetAttachment( ID )

        if Muzzle then
            local traceTurret = util.TraceLine( {
                start = Muzzle.Pos,
                endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
                filter = veh:GetCrosshairFilterEnts()
            } )

            local MuzzlePos2D = traceTurret.HitPos:ToScreen()

            if veh:GetUseHighExplosive() then
                veh:PaintCrosshairSquare( MuzzlePos2D, COLOR_WHITE )
            else
                veh:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
            end

            veh:LVSPaintHitMarker( MuzzlePos2D )
        end
    end
    self:AddWeapon(weapon, self.TurretSeatIndex)

    self:InitWeaponSmoke()
end