include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

local cmdr = "commander"
function ENT:TopDrawCommander()
    local pod = self:GetCommanderSeat()

    if not IsValid( pod ) then self:RemovePlayerModel(cmdr) return end

    local plyL = LocalPlayer()
    local ply = pod:GetDriver()

    if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel(cmdr) return end

    local ID = self:LookupAttachment( "hatch_turret" )
    local Att = self:GetAttachment( ID )

    if not Att then self:RemovePlayerModel(cmdr) return end

    if IsValid(ply:lvsGetWeaponHandler()) then -- MG is mounted
        local param = self:GetPoseParameter("cupola_pitch")
        local Pos, Ang = LocalToWorld( Vector(Lerp(param, -12, -32),0,Lerp(param, 2, -2)), Angle(90,0,0), Att.Pos, Att.Ang )
        local model = self:CreatePlayerModel(ply, cmdr)
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(-20, 30, 0))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, -75, 0))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, Lerp(param, -25, 15), 0))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(-30, 0, 0))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(10, 0, 0))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, -75, 0))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, Lerp(param, -25, -45), 0))

        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_L_Thigh"), Angle(15, 25, 0))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(-15, 0, 0))

        model:SetPoseParameter("aim_pitch", math.Remap(param, 0, 1, 30, -60) )
        model:SetPoseParameter("head_pitch", math.Remap(param, 0, 1, 30, -60) )

        model:SetSequence( "idle_slam" )
        model:SetRenderOrigin( Pos )
        model:SetRenderAngles( Ang )
        model:DrawModel()
    else
        local Pos, Ang = LocalToWorld( Vector(-32,0,-1), Angle(90,0,0), Att.Pos, Att.Ang )

        local model = self:CreatePlayerModel(ply, cmdr)
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_L_Clavicle"), Angle(0, 10, 45))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_Clavicle"), Angle(0, 15, -55))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, -30, 0))
        model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, -45, 0))

        model:SetSequence( "idle_dual" )
        model:SetRenderOrigin( Pos )
        model:SetRenderAngles( Ang )
        model:DrawModel()
    end

end

local gunner = "gunner"
function ENT:TopDrawGunner()
    local pod = self:GetGunnerSeat()

    if not IsValid(pod) or (self:GetWeaponSeat() == pod and not pod:GetThirdPersonMode()) then self:RemovePlayerModel(gunner) return end

    local plyL = LocalPlayer()
    local ply = pod:GetDriver()

    if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel(gunner) return end

    local ID = self:LookupAttachment( "hatch_gunner" )
    local Att = self:GetAttachment( ID )

    if not Att then self:RemovePlayerModel(gunner) return end

    local Pos, Ang = LocalToWorld( Vector(-55,0.5,0), Angle(90,0,0), Att.Pos, Att.Ang )

    local model = self:CreatePlayerModel(ply, gunner)
    model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 5, 0))
    model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 8, 0))

    model:SetSequence( "idle_revolver" )
    model:SetRenderOrigin( Pos )
    model:SetRenderAngles( Ang )
    model:DrawModel()
end


local driver = "driver"
function ENT:DrawDriver()
    local pod = self:GetDriverSeat()

    if not IsValid(pod) then self:RemovePlayerModel(driver) return end

    local plyL = LocalPlayer()
    local ply = pod:GetDriver()

    if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel(driver) return end

    local Pos, Ang = LocalToWorld( Vector(0,0,-3), Angle(0,90,0), pod:GetPos(), pod:GetAngles() )

    local model = self:CreatePlayerModel(ply, driver)
    model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_L_Thigh"), Angle(0, -20, 0))
    model:ManipulateBoneAngles(model:LookupBone("ValveBiped.Bip01_R_Thigh"), Angle(0, -18, 0))

    model:SetSequence( "drive_airboat" )
    model:SetRenderOrigin( Pos )
    model:SetRenderAngles( Ang )
    model:DrawModel()
end

function ENT:PreDraw()
    self:TopDrawCommander()
    self:TopDrawGunner()
    self:DrawDriver()
    return true
end