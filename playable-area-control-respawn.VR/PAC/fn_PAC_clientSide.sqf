// PAC v1.7
// File: your_mission\PAC\fn_PAC_clientSide.sqf
// Documentation: https://docs.google.com/document/d/1GwwM5lRdo_DGnEd8RmJKIseZ6OEBtFc6tLbaZSnp4BE
// by thy (@aldolammel)

if !hasInterface exitWith {};
if !PAC_isOnPAC exitWith {};

params ["_unit"];
//private [""];

// Wait the player is on the map:
waitUntil { sleep 3; !isNull _unit };
// Debug:
[_unit] spawn THY_fnc_PAC_debug;
// Looping:
while { alive _unit } do {
	// Check local player:
	[_unit, objectParent _unit, getConnectedUAV _unit] call THY_fnc_PAC_check_player;
	// Breath:
	sleep PAC_checkTime;
};
// Return:
true;
