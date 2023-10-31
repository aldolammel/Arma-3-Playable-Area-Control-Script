// PAC v1.7
// File: your_mission\PAC\fn_PAC_management.sqf
// Documentation: https://docs.google.com/document/d/1GwwM5lRdo_DGnEd8RmJKIseZ6OEBtFc6tLbaZSnp4BE
// by thy (@aldolammel)


if !isServer exitWith {};

[] spawn {

	// EDITOR'S OPTIONS ////////////////////////////////////////////////////////////////////////////////////////////////
	// Define the features of the playable area, but first, make sure the playable-area-trigger on Eden is named as PAC_playableArea.

	PAC_isOnPAC           = true;   // true = this script will be loaded. / false = script won't be loaded. Default: true.
	PAC_isOnDebug         = false;  // true = a monitor for editor tests. Default: false.
	PAC_isOnAlerts        = true;   // true = message and sound alarm for the player that's out of playable area. Default: true.
	PAC_isAirTolerated    = true;   // true = air vehicles and parachuters are able to stay out of the playable area. Default true.
	PAC_isOnSpeedPunish   = true;   // true = player in the air out of playable area must respect a minimal speed (15km/h). Default: true.
	PAC_toleranceToReturn = 15;     // in secs, time limit to the player or their drone to return to playable area. Default: 15.
	

	// ADVANCED (Caution):
	// in secs, more or less the time of each PAC checking cycle:
	PAC_checkTime = 15;  // Default: 15
	// Vehicle classnames that must be immune to PAC in any circustance:
	PAC_noAnyRulesForThem = [];  // Default: []


	// DONT TOUCH //////////////////////////////////////////////////////////////////////////////////////////////////////
	// Declarations:
	PAC_debugHeader = toUpper "PAC DEBUG >"; PAC_warnHeader = toUpper "PAC WARNING >"; PAC_playerHeader = toUpper "PAC PLAYABLE AREA >"; PAC_minSpeed = 15; PAC_minAlt = 0.2; PAC_toleranceToReturn = abs PAC_toleranceToReturn; PAC_checkTime = abs PAC_checkTime;
	// Only editor (server) would see:
	if (PAC_checkTime < 10) then {systemChat format ["%1 'PAC_checkTime' less than 10secs will compromise the player's CPU performance. Be careful with 'fn_PAC_management.sqf' settings.", PAC_debugHeader]};
	if (PAC_minSpeed < 10 ) then {systemChat format ["%1 'PAC_minSpeed' current value (%2) is too low. Consider turn 'PAC_isOnSpeedPunish' to 'false' in 'fn_PAC_management.sqf' file.", PAC_debugHeader, PAC_minSpeed]};
	if (PAC_minSpeed > 100 ) then {systemChat format ["%1 'PAC_minSpeed' current value (%2) is too low. Consider turn 'PAC_isOnSpeedPunish' to 'false' in 'fn_PAC_management.sqf' file.", PAC_debugHeader, PAC_minSpeed]};
	if (PAC_minAlt != 0.2 ) then { PAC_minAlt = 0.2; systemChat format ["%1 Please, DON'T change the PAC_minAlt value. It'd break the PAC script logic. Fix it in 'fn_PAC_management.sqf' file.", PAC_warnHeader]};
	publicVariable "PAC_isOnPAC"; publicVariable "PAC_isOnDebug"; publicVariable "PAC_isOnAlerts"; publicVariable "PAC_isAirTolerated"; publicVariable "PAC_isOnSpeedPunish"; publicVariable "PAC_toleranceToReturn"; publicVariable "PAC_checkTime"; publicVariable "PAC_noAnyRulesForThem"; publicVariable "PAC_debugHeader"; publicVariable "PAC_warnHeader"; publicVariable "PAC_playerHeader"; publicVariable "PAC_minSpeed"; publicVariable "PAC_minAlt";
};
// return:
true;