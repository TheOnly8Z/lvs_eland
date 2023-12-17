// Created by Crowbar 0.74

$modelname "8z/lvs/eland.mdl"

$bodygroup "base"
{
	studio "base.smd"
}
$bodygroup "turret"
{
	studio "turret_90.smd"
	studio "turret_60.smd"
	studio "turret_20.smd"
	blank
}
$bodygroup "Sand Ladder Rack"
{
	studio "FrontRack.smd"
	studio "FrontRack_Empty.smd"
}
// $bodygroup "Side Box"
// {
// 	studio "Box_Side.smd"
// 	blank
// }
// $bodygroup "Rear Box"
// {
// 	studio "Box_Rear.smd"
// 	blank
// }
$bodygroup "Turret Front Antenna"
{
	studio "Antenna_Front.smd"
	blank
}
$bodygroup "Turret Rear Antenna"
{
	studio "Antenna_Back.smd"
	blank
}
$bodygroup "cupola_mg"
{
	studio "cupola_mg.smd"
	blank
}

$surfaceprop "metalvehicle"

$contents "solid"

$illumposition 1.165 0 34.294

// $cdmaterials "models\kali\vehicles\BO2\Eland\"
$cdmaterials "models\8z\lvs\eland\"
$cdmaterials "models\8z\lvs\weapons\"

$texturegroup "skinfamilies"
{
	{ "veh_mil_eland90" }
	{ "veh_mil_eland90_Flat" }
}

$attachment "muzzle_turret" "Gun_Elev" 86 0 0 rotate 0 0 0
$attachment "muzzle_turret_60" "Gun_Elev" 36 0 0 rotate 0 0 0
$attachment "muzzle_mg" "Gun_Elev" 18 6.4 0 rotate 0 0 0
$attachment "smoke_left" "Turret_Rot" 20 36 28 rotate 45 15 0
$attachment "smoke_right" "Turret_Rot" 20 -36 28 rotate 45 -15 0
$attachment "hatch_turret" "Turret_Cupola_Rot" 0 0 0 rotate 0 0 0
$attachment "hatch_gunner" "Turret_Rot" 12 -18.5 0 rotate 0 0 0
$attachment "gunner_viewport" "Turret_Rot" 20 -16 -16 rotate 90 0 0
$attachment "muzzle_cupola_mg" "Turret_Cupola_MG_Elev" 28.00 1.00 0.00 rotate 0 -0 -90

$poseparameter "turret_pitch" -10 40 loop 0
$poseparameter "turret_yaw" 0 360 loop 360
$poseparameter "cupola_yaw" 0 360 loop 360
$poseparameter "cupola_pitch" -45 40 loop 0

$poseparameter "door_left" 0 1 loop 0
$poseparameter "door_right" 0 1 loop 0
$poseparameter "door_driver" 0 1 loop 0
$poseparameter "hatch_turret" 0 1 loop 0
$poseparameter "hatch_gunner" 0 1 loop 0

$weightlist "weights_turret_pitch" { "Gun_Elev" 1 }
$weightlist "weights_turret_yaw" { "Turret_Rot" 1 }

$weightlist "weights_door_left" {
	"Hatch_L_Joint" 1
	"Hatch_L_Handle_Joint" 1
}

$weightlist "weights_door_right" {
	"Hatch_R_Joint" 1
	"Hatch_R_Handle_Joint" 1
}

$weightlist "weights_door_driver" {
	"Hatch_Driver_Joint" 1
}

$weightlist "weights_hatch_turret" {
	"Hatch_Commander_Joint" 1
}

$weightlist "weights_hatch_gunner" {
	"Hatch_Gunner_Joint" 1
}

$weightlist "weights_cupola_yaw" {
	"Turret_Cupola_Rot" 1
}

$weightlist "weights_cupola_pitch" {
	"Turret_Cupola_MG_Elev" 1
}

$sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}
$animation neutral "anims/idle.smd" frames 0 0

$sequence "turret_fire" {
	"anims\turret_fire.smd"
	fadein 0.1
	fadeout 0.2
	fps 30
}

$sequence "cupola_mg_fire" {
	"anims\cupola_mg_fire.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}


$animation "turret_pitch1" "anims\turret_pitch1.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_turret_pitch"
}
$animation "turret_pitch2" "anims\turret_pitch2.smd" {
	frame 0 0
	weightlist "weights_turret_pitch"
	subtract neutral 0
}
$sequence "turret_pitch" {
	"turret_pitch1"
	"turret_pitch2"
	autoplay
	blend "turret_pitch" -10 40
	blendwidth 2
	fadein 0.2
	fadeout 0.2
	delta
}

$animation "turret_yaw1" "anims\turret_yaw.smd" {
	frame 0 0
	weightlist "weights_turret_yaw"
	subtract neutral 0
}
$animation "turret_yaw2" "anims\turret_yaw.smd" {
	frame 1 1
	weightlist "weights_turret_yaw"
	subtract neutral 0
}
$animation "turret_yaw3" "anims\turret_yaw.smd" {
	frame 2 2
	weightlist "weights_turret_yaw"
	subtract neutral 0
}
$animation "turret_yaw4" "anims\turret_yaw.smd" {
	frame 3 3
	weightlist "weights_turret_yaw"
	subtract neutral 0
}
$animation "turret_yaw5" "anims\turret_yaw.smd" {
	frame 4 4
	weightlist "weights_turret_yaw"
	subtract neutral 0
}
$sequence "turret_yaw" {
	"turret_yaw1"
	"turret_yaw2"
	"turret_yaw3"
	"turret_yaw4"
	"turret_yaw5"
	autoplay
	delta
	blend "turret_yaw" 0 360
	blendwidth 5
	fadein 0.2
	fadeout 0.2
}

$animation "cupola_yaw1" "anims\idle.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_cupola_yaw"
}
$animation "cupola_yaw2" "anims\cupola_yaw1.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_cupola_yaw"
}
$animation "cupola_yaw3" "anims\cupola_yaw2.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_cupola_yaw"
}
$animation "cupola_yaw4" "anims\cupola_yaw3.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_cupola_yaw"
}
$animation "cupola_yaw5" "anims\idle.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_cupola_yaw"
}
$sequence "cupola_yaw" {
	"cupola_yaw1"
	"cupola_yaw2"
	"cupola_yaw3"
	"cupola_yaw4"
	"cupola_yaw5"
	autoplay
	delta
	blend "cupola_yaw" 0 360
	blendwidth 5
	fadein 0.2
	fadeout 0.2
}

$animation "cupola_pitch1" "anims\cupola_pitch1.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_cupola_pitch"
}
$animation "cupola_pitch2" "anims\cupola_pitch2.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_cupola_pitch"
}
$sequence "cupola_pitch" {
	"cupola_pitch1"
	"cupola_pitch2"
	autoplay
	delta
	blend "cupola_pitch" -45 40
	blendwidth 2
	fadein 0.2
	fadeout 0.2
}

$animation "door_left1" "anims\idle.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_door_left"
}
$animation "door_left2" "anims\door_left.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_door_left"
}
$sequence "door_left" {
	"door_left1"
	"door_left2"
	autoplay
	delta
	blend "door_left" 0 1
	blendwidth 2
	fadein 0.2
	fadeout 0.2
}

$animation "door_right1" "anims\idle.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_door_right"
}
$animation "door_right2" "anims\door_right.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_door_right"
}
$sequence "door_right" {
	"door_right1"
	"door_right2"
	autoplay
	delta
	blend "door_right" 0 1
	blendwidth 2
	fadein 0.2
	fadeout 0.2
}

$animation "door_driver1" "anims\idle.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_door_driver"
}
$animation "door_driver2" "anims\door_driver.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_door_driver"
}
$sequence "door_driver" {
	"door_driver1"
	"door_driver2"
	autoplay
	delta
	blend "door_driver" 0 1
	blendwidth 2
	fadein 0.2
	fadeout 0.2
}

$animation "hatch_turret1" "anims\idle.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_hatch_turret"
}
$animation "hatch_turret2" "anims\hatch_turret.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_hatch_turret"
}
$sequence "hatch_turret" {
	"hatch_turret1"
	"hatch_turret2"
	autoplay
	delta
	blend "hatch_turret" 0 1
	blendwidth 2
	fadein 0.2
	fadeout 0.2
}

$animation "hatch_gunner1" "anims\idle.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_hatch_gunner"
}
$animation "hatch_gunner2" "anims\hatch_gunner.smd" {
	frame 0 0
	subtract neutral 0
	weightlist "weights_hatch_gunner"
}
$sequence "hatch_gunner" {
	"hatch_gunner1"
	"hatch_gunner2"
	autoplay
	delta
	blend "hatch_gunner" 0 1
	blendwidth 2
	fadein 0.2
	fadeout 0.2
}

$collisionmodel "physics.smd"
{
	$mass 1000
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
}
