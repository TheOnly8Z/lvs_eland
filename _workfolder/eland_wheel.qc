// Created by Crowbar 0.74

$modelname "8z/lvs/eland_wheel.mdl"

$bodygroup "Body"
{
	studio "eland_wheel.smd"
}

$surfaceprop "rubbertire"

$contents "solid"

// $cdmaterials "models\kali\vehicles\BO2\Eland\"
$cdmaterials "models\8z\lvs\eland\"

$texturegroup "skinfamilies"
{
	{ "veh_mil_eland90_Wheel" }
	{ "veh_mil_eland90_Wheel_Flat" }
	{ "veh_mil_eland90_Wheel_Wreck" }
}

$hboxset "default"

$sequence "idle" {
	"eland_wheel_anims\idle.smd"
	activity "ACT_IDLE" -1
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$collisionmodel "eland_wheel.smd"
{
	$mass 75
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
