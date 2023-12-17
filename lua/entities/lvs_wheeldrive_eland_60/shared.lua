ENT.Base = "lvs_wheeldrive_eland"

ENT.PrintName = "Eland-60"
ENT.Author = "8Z"
ENT.Information = ""
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Armored"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.TurretAimRate = 35
ENT.TurretPitchMin = -40
ENT.TurretPitchMax = 10

ENT.MDL_TURRETGIB = "models/8z/lvs/gibs/eland_turret_60.mdl"

ENT.TurretFireSound = "lvs/vehicles/pak40/cannon_fire.wav"
ENT.TurretFireSoundInterior = "lvs/vehicles/pak40/cannon_fire.wav"

ENT.TurretBodygroup = 1

--[[weapons]]
function ENT:InitWeapons()

    if GetConVar("lvs_eland_turret_driver"):GetBool() then
        self.TurretSeatIndex = 1
    else
        self.TurretSeatIndex = 2
    end

    self:InitWeaponMG()

    weapon = {}
    weapon.Icon = Material("lvs/weapons/bomb.png")
    weapon.Ammo = 55
    weapon.Delay = 3
    weapon.HeatRateUp = 0
    weapon.HeatRateDown = 0.25
    weapon.StartAttack = function( ent )

        if self:GetAI() then return end

        self:MakeProjectile(ent)
    end
    weapon.FinishAttack = function( ent )
        if self:GetAI() then return end

        self:FireProjectile(ent)
    end
    weapon.Attack = function( ent )
        if not self:GetAI() then return end

        self:MakeProjectile(ent)
        self:FireProjectile(ent)
    end
    weapon.HudPaint = function( ent, X, Y, ply )
        local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

        ent:GetVehicle():LVSPaintHitMarker( Pos2D )
    end
    self:AddWeapon(weapon, self.TurretSeatIndex)

    self:InitWeaponSmoke()
end