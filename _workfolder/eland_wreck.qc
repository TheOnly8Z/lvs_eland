// Created by Crowbar 0.74

$modelname "8z/lvs/eland_wreck.mdl"

$bodygroup "base"
{
	studio "wreck_base.smd"
}

$surfaceprop "metalvehicle"

$contents "solid"

$illumposition 1.165 0 34.294

// $cdmaterials "models\kali\vehicles\BO2\Eland\"
$cdmaterials "models\8z\lvs\eland\"

$texturegroup "skinfamilies"
{
	{ "veh_mil_eland90_wreck" }
	{ "veh_mil_eland90_Flat" }
}
//	{ "veh_mil_eland90_Wreck" }

$sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "wreck_physics.smd"
{
	$mass 1000
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
}
