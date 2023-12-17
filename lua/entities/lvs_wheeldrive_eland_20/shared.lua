ENT.Base = "lvs_wheeldrive_eland"

ENT.PrintName = "Eland-20"
ENT.Author = "8Z"
ENT.Information = ""
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Armored"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.TurretAimRate = 50
ENT.TurretPitchMin = -40
ENT.TurretPitchMax = 10

ENT.CannonArmorPenetration = 3900

ENT.MDL_TURRETGIB = "models/8z/lvs/gibs/eland_turret_20.mdl"

ENT.TurretFireSound = "lvs/vehicles/222/cannon_fire.wav"
ENT.TurretFireSoundInterior = "lvs/vehicles/222/cannon_fire_interior.wav"

ENT.TurretBodygroup = 2

function ENT:InitWeapons()

    local COLOR_WHITE = Color(255,255,255,255)

    if GetConVar("lvs_eland_turret_driver"):GetBool() then
        self.TurretSeatIndex = 1
    else
        self.TurretSeatIndex = 2
    end

    self:InitWeaponMG()

    weapon = {}
    weapon.Icon = Material("lvs/weapons/bullet_ap.png")
    weapon.Ammo = 250
    weapon.Delay = 0.225
    weapon.HeatRateUp = 0.2
    weapon.HeatRateDown = 0.22
    weapon.Attack = function( ent )
        local veh = ent:GetVehicle()
        local ID = veh:LookupAttachment( "muzzle_turret" )
        local Muzzle = veh:GetAttachment( ID )

        if not Muzzle then return end

        local bullet = {}
        bullet.Src 	= Muzzle.Pos
        bullet.Dir 	= Muzzle.Ang:Forward()
        local spread = Lerp(ent:GetHeat() ^ 0.75, 0.008, 0.012)
        bullet.Spread = Vector(spread,spread,spread)

        bullet.Force	= veh.CannonArmorPenetration
        bullet.HullSize 	= 0
        bullet.Damage	= 100
        bullet.Velocity = 18000

        bullet.TracerName = "lvs_tracer_autocannon"
        bullet.Attacker 	= veh:GetPassenger(self.TurretSeatIndex)
        veh:LVSFireBullet( bullet )

        local effectdata = EffectData()
        effectdata:SetOrigin( bullet.Src )
        effectdata:SetNormal( bullet.Dir )
        effectdata:SetEntity( veh )
        util.Effect( "lvs_muzzle", effectdata )

        local PhysObj = veh:GetPhysicsObject()
        if IsValid( PhysObj ) then
            PhysObj:ApplyForceOffset( -bullet.Dir * 12000, bullet.Src )
        end
        ent:TakeAmmo(1)
        veh:PlayAnimation( "turret_fire" )

        if not IsValid( veh.SNDTurret ) then return end
        veh.SNDTurret:PlayOnce( 110 + math.cos( CurTime() + veh:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
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
            veh:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
            veh:LVSPaintHitMarker( MuzzlePos2D )
        end
    end
    weapon.OnOverheat = function( ent )
        local veh = ent:GetVehicle()
        veh:EmitSound("lvs/vehicles/222/cannon_overheat.wav")
    end
    self:AddWeapon(weapon, self.TurretSeatIndex)

    self:InitWeaponSmoke()
end