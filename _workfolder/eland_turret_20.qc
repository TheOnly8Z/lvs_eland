// Created by Crowbar 0.74

$modelname "8z/lvs/gibs/eland_turret_20.mdl"

$bodygroup "base"
{
	studio "wreck_turret_20.smd"
}

$surfaceprop "metalvehicle"

$contents "solid"

// $cdmaterials "models\kali\vehicles\BO2\Eland\"
$cdmaterials "models\8z\lvs\eland\"

$texturegroup "skinfamilies"
{
	{ "veh_mil_eland90_wreck" }
	{ "veh_mil_eland90_Flat" }
}

$illumposition 0 -15 85

$sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "wreck_physics_turret_20.smd"
{
	$mass 400
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone ""
	$concave
}


// $collisionjoints "wreck_physics_turret.smd"
// {
// 	$mass 500
// 	$inertia 10
// 	$damping 0.01
// 	$rotdamping 1.5
// 	$rootbone "root"
// 	$concave
// 	$concaveperjoint

// 	$jointconstrain "Turret_Cupola_Rot" x limit -180 180 0
// 	$jointconstrain "Turret_Cupola_Rot" y limit 0 0 0
// 	$jointconstrain "Turret_Cupola_Rot" z limit 0 0 0

// 	$jointconstrain "Gun_Elev" x limit 0 0 0
// 	$jointconstrain "Gun_Elev" y limit -20 5 0
// 	$jointconstrain "Gun_Elev" z limit 0 0 0

// 	$noselfcollisions
// }