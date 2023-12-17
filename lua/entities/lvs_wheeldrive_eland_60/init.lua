AddCSLuaFile("shared.lua")
include("shared.lua")

AddCSLuaFile("cl_init.lua")

local speed = 2800

function ENT:MakeProjectile(ent)
    local ID = self:LookupAttachment( "muzzle_turret_60" )
    local Muzzle = self:GetAttachment( ID )

    if not Muzzle then return end

    local Driver = self:GetWeaponSeat():GetDriver()

    local projectile = ents.Create( "lvs_bomb" )
    projectile:SetPos( Muzzle.Pos )
    projectile:SetAngles( Muzzle.Ang )
    projectile:SetParent( self, ID )
    projectile:Spawn()
    projectile:Activate()
    projectile:SetModel("models/misc/88mm_projectile.mdl")
    projectile:SetAttacker( IsValid( Driver ) and Driver or self )
    projectile:SetEntityFilter( self:GetCrosshairFilterEnts() )
    projectile:SetSpeed( Muzzle.Ang:Forward() * speed )
    projectile:SetDamage( 600 )
    projectile:SetRadius( 400 )
    projectile.UpdateTrajectory = function( bomb )
        bomb:SetSpeed( bomb:GetForward() * speed )
    end

    if projectile.SetMaskSolid then
        projectile:SetMaskSolid( true )
    end

    self._ProjectileEntity = projectile
end

function ENT:FireProjectile(ent)
    local ID = self:LookupAttachment( "muzzle_turret_60" )
    local Muzzle = self:GetAttachment( ID )

    if not Muzzle or not IsValid( self._ProjectileEntity ) then return end

    self._ProjectileEntity:Enable()
    self._ProjectileEntity:SetCollisionGroup( COLLISION_GROUP_NONE )

    local effectdata = EffectData()
        effectdata:SetOrigin( self._ProjectileEntity:GetPos() )
        effectdata:SetEntity( self._ProjectileEntity )
    util.Effect( "lvs_eland_60_trail", effectdata )

    effectdata = EffectData()
    effectdata:SetOrigin( Muzzle.Pos )
    effectdata:SetNormal( Muzzle.Ang:Forward() )
    effectdata:SetEntity( self )
    util.Effect( "lvs_muzzle", effectdata )

    local PhysObj = self:GetPhysicsObject()
    if IsValid( PhysObj ) then
        PhysObj:ApplyForceOffset( -Muzzle.Ang:Forward() * 100000, Muzzle.Pos )
    end

    ent:TakeAmmo(1)
    ent:SetHeat(1)
    ent:SetOverheated(true)

    self._ProjectileEntity = nil

    self:PlayAnimation( "turret_fire" )

    if not IsValid( self.SNDTurret ) then return end

    self.SNDTurret:PlayOnce( 110 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

    self:EmitSound("lvs/vehicles/sherman/cannon_reload.wav", 75, 110, 1, CHAN_WEAPON )
end