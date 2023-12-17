AddCSLuaFile("shared.lua")
include("shared.lua")

AddCSLuaFile("sh_turret.lua")
include("sh_turret.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_tankview.lua")
AddCSLuaFile("cl_optics.lua")
AddCSLuaFile("cl_attached_playermodels.lua")

function ENT:OnTick()
    self:AimTurret()

    local CommanderSeat = self:GetCommanderSeat()
    local TurretHatch = self.TurretHatchHandler
    if IsValid(TurretHatch) and IsValid(CommanderSeat) then
        local ply = CommanderSeat:GetDriver()
        -- Open hatch
        local PoseValue = IsValid(ply) and 1 or 0
        if PoseValue ~= TurretHatch:GetPoseMin() then
            TurretHatch:SetPoseMin(PoseValue)
        end

        -- Rotate commander turret
        if IsValid(ply) then
            local Ang = self:WorldToLocalAngles( ply:GetAimVector():Angle() ) - Angle(0,self:GetTurretYaw(),0)
            Ang:Normalize()
            self:SetPoseParameter("cupola_yaw", Ang.y )
            self:SetPoseParameter("cupola_pitch", math.Clamp(-Ang.p, -40, 40) )
        end
    end

    local GunnerSeat = self:GetGunnerSeat()
    local GunnerHatch = self.GunnerHatchHandler
    if IsValid(GunnerHatch) and IsValid(GunnerSeat) then
        local ply = GunnerSeat:GetDriver()
        -- Open hatch
        local PoseValue = (IsValid(ply) and (GunnerSeat:GetThirdPersonMode() or self:GetWeaponSeat() ~= GunnerSeat)) and 1 or 0
        if PoseValue ~= GunnerHatch:GetPoseMin() then
            GunnerHatch:SetPoseMin(PoseValue)
        end
    end

    local DriverSeat = self:GetDriverSeat()
    local DriverHatch = self.DriverHatchHandler
    if IsValid(DriverSeat) and IsValid(DriverHatch) then
        local ply = DriverSeat:GetDriver()
        -- Open hatch
        local PoseValue = (IsValid(ply) and DriverSeat:GetThirdPersonMode()) and 1 or 0
        if PoseValue ~= DriverHatch:GetPoseMin() then
            DriverHatch:SetPoseMin(PoseValue)
        end
    end
end

function ENT:OnSpawn( PObj )

    if GetConVar("lvs_eland_turret_driver"):GetBool() then
        self.TurretSeatIndex = 1
    else
        self.TurretSeatIndex = 2
    end

    self:SetTurretYaw(self.TurretYawOffset + 180) -- ??

    self:SetBodygroup(1, self.TurretBodygroup)

    local DriverSeat = self:AddDriverSeat( Vector(0,20,23), Angle(0,0,0) )
    DriverSeat.HidePlayer = true
    self.DriverHatchHandler = self:AddDoorHandler( "door_driver", Vector(0,35,50), Angle(0,0,-35), Vector(-15,-15,-10), Vector(15,15,10), Vector(-15,-15,-10), Vector(15,15,10))
    self.DriverHatchHandler:LinkToSeat( DriverSeat )
    self.DriverHatchHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
    self.DriverHatchHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

    local GunnerSeat = self:AddPassengerSeat( Vector(18,-9,40), Angle(0,0,0) )
    GunnerSeat.HidePlayer = true
    self:SetGunnerSeat( GunnerSeat )
    self.GunnerHatchHandler = self:AddDoorHandler( "hatch_gunner", Vector(0,0,85), Angle(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0), Vector(0,0,0) )
    -- self.GunnerHatchHandler:LinkToSeat( GunnerSeat )
    self.GunnerHatchHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
    self.GunnerHatchHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

    local CommanderSeat = self:AddPassengerSeat( Vector(-18,-12,40), Angle(0,0,0) )
    CommanderSeat.HidePlayer = true
    self:SetCommanderSeat( CommanderSeat )
    self.TurretHatchHandler = self:AddDoorHandler( "hatch_turret", Vector(0,0,85), Angle(0,0,0), Vector(-25,-45,-5), Vector(25,25,5), Vector(-25,-45,-5), Vector(25,25,5) )
    self.TurretHatchHandler:LinkToSeat( CommanderSeat )
    self.TurretHatchHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
    self.TurretHatchHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

    local LeftDoor = self:AddDoorHandler( "door_left", Vector(-35,0,20), Angle(0,-15,0), Vector(-5,-15,-5), Vector(5,30,40), Vector(-5,-15,-5), Vector(5,30,40) )
    LeftDoor:LinkToSeat( DriverSeat )
    LeftDoor:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
    LeftDoor:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

    local RightDoor = self:AddDoorHandler( "door_right", Vector(35,0,20), Angle(0,15,0), Vector(-5,-15,-5), Vector(5,30,40), Vector(-5,-15,-5), Vector(5,30,40))
    RightDoor:LinkToSeat( GunnerSeat )
    RightDoor:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
    RightDoor:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

    if self.TurretSeatIndex == 1 then
        self:SetWeaponSeat( DriverSeat )
    elseif self.TurretSeatIndex == 2 then
        self:SetWeaponSeat( GunnerSeat )
    elseif self.TurretSeatIndex == 3 then
        self:SetWeaponSeat( CommanderSeat )
    end

    local ID = self:LookupAttachment( "muzzle_mg" )
    local Muzzle = self:GetAttachment( ID )
    self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
    self.SNDTurretMG:SetSoundLevel( 95 )
    self.SNDTurretMG:SetParent( self, ID )

    ID = self:LookupAttachment( "muzzle_turret" )
    Muzzle = self:GetAttachment( ID )
    self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), self.TurretFireSound, self.TurretFireSoundInterior )
    self.SNDTurret:SetSoundLevel( 95 )
    self.SNDTurret:SetParent( self, ID )

    ID = self:LookupAttachment( "muzzle_cupola_mg" )
    Muzzle = self:GetAttachment( ID )
    self.SNDTopMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop.wav" )
    self.SNDTopMG:SetSoundLevel( 95 )
    self.SNDTopMG:SetParent( self, ID )

    self:AddEngine( Vector(0,-64,55) )

    local WheelModel = "models/8z/lvs/eland_wheel.mdl"

    -- Front
    self.FrontAxle = self:DefineAxle( {
        Axle = {
            ForwardAngle = Angle(0,90,0),
            SteerType = LVS.WHEEL_STEER_FRONT,
            SteerAngle = 25,
            TorqueFactor = 0.4,
            BrakeFactor = 1,
            UseHandbrake = false,
        },
        Wheels = {
            self:AddWheel( {
                pos = Vector(-27,53,17.5),
                mdl = WheelModel,
                mdl_ang = Angle(0,0,0),
            } ),

            self:AddWheel( {
                pos = Vector(27,53,17.5),
                mdl = WheelModel,
                mdl_ang = Angle(0,180,0),
            } ),
        },
        Suspension = {
            Height = 5,
            MaxTravel = 7,
            ControlArmLength = 50,
            SpringConstant = 30000,
            SpringDamping = 4000,
            SpringRelativeDamping = 4000,
        },
    } )

    -- Rear
    self.RearAxle = self:DefineAxle( {
        Axle = {
            ForwardAngle = Angle(0,90,0),
            SteerType = LVS.WHEEL_STEER_NONE,
            SteerAngle = 5,
            TorqueFactor = 0.6,
            BrakeFactor = 1,
            UseHandbrake = true,
        },
        Wheels = {
            self:AddWheel( {
                pos = Vector(-27,-54,17.5),
                mdl = WheelModel,
                mdl_ang = Angle(0,0,0),
            } ),

            self:AddWheel( {
                pos = Vector(27,-54,17.5),
                mdl = WheelModel,
                mdl_ang = Angle(0,180,0),
            } ),
        },
        Suspension = {
            Height = 5,
            MaxTravel = 7,
            ControlArmLength = 50,
            SpringConstant = 35000,
            SpringDamping = 4000,
            SpringRelativeDamping = 4000,
        },
    } )

    self:AddFuelTank( Vector(0,-50,32), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-21,-6,-12),Vector(21,6,12) )

    self:AddAmmoRack( Vector(0,-18,24), Vector(0,-12,64), Angle(0,0,0), Vector(-10,-12,-5),Vector(10,12,15) )

    -- self:AddAmmoRack( Vector(14,-24,50), Vector(24,-24,50), Angle(0,0,0), Vector(-6,-16,-8),Vector(8,16,8) )
    -- self:AddAmmoRack( Vector(-14,-24,50), Vector(-24,-24,50), Angle(0,0,0), Vector(-6,-16,-8),Vector(8,16,8) )

    -- if GetConVar("lvs_eland_top_mg"):GetBool() then
    --     self:AddDS( {
    --         pos = Vector(0,0,75),
    --         ang = Angle(0,0,0),
    --         mins = Vector(-20,-40,0),
    --         maxs =  Vector(20,20,40),
    --         Callback = function( tbl, ent, dmginfo )
    --             local ply = ent:GetPassenger(3)
    --             if not IsValid( ply ) then return end
    --             ent:HurtPlayer( ply, dmginfo:GetDamage(), dmginfo:GetAttacker(), dmginfo:GetInflictor() )
    --         end
    --     } )
    -- end

    -- front
    self:AddArmor( Vector(0,35,50), Angle(0,0,-35), Vector(-25,-12,-10), Vector(25,45,5), 500, self.FrontArmor )

    -- front wheel hub
    self:AddArmor( Vector(-26,53,35), Angle(0,0,0), Vector(-15,-20,-15), Vector(5,22,10), 300, self.RearArmor )
    self:AddArmor( Vector(26,53,35), Angle(0,0,0), Vector(-5,-20,-15), Vector(15,22,10), 300, self.RearArmor )

    -- left
    self:AddArmor( Vector(-32,0,20), Angle(0,-15,0), Vector(-5,-20,-5), Vector(15,30,40), 300, self.SideArmor )
    self:AddArmor( Vector(-37,-38,20), Angle(0,0,0), Vector(-5,-45,-5), Vector(15,20,40), 300, self.SideArmor )

    -- right
    self:AddArmor( Vector(32,0,20), Angle(0,15,0), Vector(-15,-20,-5), Vector(5,30,40), 300, self.SideArmor )
    self:AddArmor( Vector(37,-38,20), Angle(0,0,0), Vector(-15,-45,-5), Vector(5,20,40), 300, self.SideArmor )

    -- rear
    self:AddArmor( Vector(0, -73, 20), Angle(0,0,0), Vector(-21.5,-10,-5), Vector(21.5,5,30), 200, self.RearArmor )
    self:AddArmor( Vector(0, -70, 48), Angle(0,0,17.5), Vector(-21.5,-5,-5), Vector(21.5,25,5), 200, self.RearArmor )

    -- turret
    local TurretArmor = self:AddArmor( Vector(0,-10,70), Angle(0,0,0), Vector(-30,-30,-10), Vector(30,30,10), 500, self.TurretArmor )
    TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
    TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
    TurretArmor:SetLabel( "Turret" )
    self:SetTurretArmor( TurretArmor )

    self:AddTrailerHitch( Vector(0,-78,16), LVS.HITCHTYPE_MALE )
end

function ENT:OnDestroyed()
    self:CreateTurretWreck()
    self:CreateWheelWreck()
end

function ENT:CreateTurretWreck()
    local ent = ents.Create( "prop_physics" )
    if not IsValid( ent ) then return end

    ent:SetPos( self:GetPos() )
    ent:SetAngles( self:GetAngles() + Angle(0, self:GetTurretYaw() + self.TurretYawOffset, 0) )
    ent:SetModel( self.MDL_TURRETGIB )
    ent:Spawn()
    ent:Activate()
    -- ent:SetRenderMode( RENDERMODE_TRANSALPHA )
    ent:SetCollisionGroup( self:GetCollisionGroup() )
    ent:SetSkin(self:GetSkin())
    ent:SetColor(self:GetColor())
    ent:Ignite(30)

    local PhysObj = ent:GetPhysicsObject()
    if IsValid( PhysObj ) then
        local GibDir = Vector( math.Rand(-1,1), math.Rand(-1,1), 2 ):GetNormalized()
        PhysObj:SetVelocityInstantaneous( GibDir * math.random(200,300) + self:GetVelocity() )

        -- PhysObj:AddAngleVelocity(VectorRand() * 500)
        -- PhysObj:EnableDrag(false)

        local effectdata = EffectData()
            effectdata:SetOrigin( self:GetPos() )
            effectdata:SetStart( PhysObj:GetMassCenter() )
            effectdata:SetEntity( ent )
            effectdata:SetScale( math.Rand(0.25,0.5) )
            effectdata:SetMagnitude( math.Rand(4, 7) )
        util.Effect( "lvs_firetrail", effectdata )
    end

    self:DeleteOnRemove(ent)
end

function ENT:CreateWheelWreck()
    for _, wheel in pairs(self:GetWheels()) do
        local ent = ents.Create( "prop_physics" )
        if not IsValid( ent ) then return end

        ent:SetPos( wheel:GetPos() )
        ent:SetAngles( wheel:GetAngles() )
        ent:SetModel( wheel:GetModel() )
        ent:Spawn()
        ent:Activate()
        -- ent:SetRenderMode(RENDERMODE_TRANSALPHA)
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD) -- self:GetCollisionGroup()
        ent:SetSkin(wheel:GetSkin() == 0 and 2 or wheel:GetSkin())
        ent:SetColor(wheel:GetColor())

        local PhysObj = ent:GetPhysicsObject()
        if IsValid( PhysObj ) then
            PhysObj:SetVelocityInstantaneous( wheel:GetAlignmentAngle():Forward() * math.Rand(100, 300) + Vector(0, 0, math.Rand(0, 200)) + self:GetVelocity() )
            PhysObj:AddAngleVelocity(VectorRand() * 500)
            -- PhysObj:EnableDrag(false)

            local effectdata = EffectData()
                effectdata:SetOrigin( self:GetPos() )
                effectdata:SetStart( PhysObj:GetMassCenter() )
                effectdata:SetEntity( ent )
                effectdata:SetScale( math.Rand(0.1,0.3) )
                effectdata:SetMagnitude( math.Rand(1,3) )
            util.Effect( "lvs_firetrail", effectdata )
        end

        timer.Simple( 15 + math.Rand(0, 1), function()
            if not IsValid( ent ) then return end
            ent:SetRenderMode(RENDERMODE_TRANSALPHA)
            ent:SetRenderFX( kRenderFxFadeFast )
            SafeRemoveEntityDelayed(ent, 3)
        end)
    end
end

function ENT:AddAmmoRack( pos, fxpos, ang, mins, maxs )
    local AmmoRack = ents.Create( "lvs_wheeldrive_ammorack" )

    if not IsValid( AmmoRack ) then
        self:Remove()

        print("LVS: Failed to create fueltank entity. Vehicle terminated.")

        return
    end

    AmmoRack:SetPos( self:LocalToWorld( pos ) )
    AmmoRack:SetAngles( self:GetAngles() )
    AmmoRack:Spawn()
    AmmoRack:Activate()
    AmmoRack:SetParent( self )
    AmmoRack:SetBase( self )
    AmmoRack:SetEffectPosition( fxpos )

    self:DeleteOnRemove( AmmoRack )

    self:TransferCPPI( AmmoRack )

    mins = mins or Vector(-30,-30,-30)
    maxs = maxs or Vector(30,30,30)

    debugoverlay.BoxAngles( self:LocalToWorld( pos ), mins, maxs, self:LocalToWorldAngles( ang ), 15, Color( 255, 0, 0, 255 ) )

    self:AddDS( {
        pos = pos,
        ang = ang,
        mins = mins,
        maxs =  maxs,
        Callback = function( tbl, ent, dmginfo )
            if not IsValid( AmmoRack ) then return end

            AmmoRack:TakeTransmittedDamage( dmginfo )

            if AmmoRack:GetDestroyed() then return end

            local OriginalDamage = dmginfo:GetDamage()

            dmginfo:SetDamage( math.min( 2, OriginalDamage ) )
        end
    } )

    return AmmoRack
end