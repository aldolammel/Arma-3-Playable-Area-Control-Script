// PAC v1.7
// File: your_mission\PAC\fn_PAC_globalFunctions.sqf
// Documentation: https://docs.google.com/document/d/1GwwM5lRdo_DGnEd8RmJKIseZ6OEBtFc6tLbaZSnp4BE
// by thy (@aldolammel)


if !PAC_isOnPAC exitWith {};


THY_fnc_PAC_countdown = {
	// This function is responsable to manage the tolerance timer set by the mission editor, as well as to notify the player (or not) that they are out of the playable area.
	// Return nothing.

	params ["_isDrone"];
	private ["_time"];

	// Alerts:
	if PAC_isOnAlerts then { 
		// Sound alert:
		playSound "Alarm";
		// Message:
		if !_isDrone then {
			systemChat format ["%1 You're LEAVING the playable area!", PAC_playerHeader];
		} else {
			systemChat format ["%1 Your drone's LEAVING the playable area!", PAC_playerHeader];
		};
	};
	// Tolerance count down:
	_time = time; waitUntil { sleep 1; time > (_time + PAC_toleranceToReturn) };
	// Return:
	true;
};


THY_fnc_PAC_punishment = {
	// This function executes the pushiment over the unit and their relatives.
	// Return nothing.

	params ["_unit", "_veh", "_drone"];
	//private [""];

	// If player has a drone:
	if ( !isNull _drone ) then {
		// Escape > If returned to playable area:
		if ( _drone inArea PAC_playableArea ) exitWith { if PAC_isOnAlerts then { systemChat format ["%1 Your drone's back in-game!", PAC_playerHeader] } };
		// Destroy the drone:
		_drone setDamage [1, false];
		// Debug message:
		if PAC_isOnDebug then { systemChat format ["%1 REMOVED > Drone: %2", PAC_debugHeader, typeOf _drone] };
		// Breath:
		sleep 0.5;
	};
	
	// If player has a vehicle (with player inside or not):
	if ( !isNull _veh ) then {
		// Escape > If returned to playable area:
		if ( _veh inArea PAC_playableArea ) exitWith {};
		// Destroy the vehicle:
		_veh setDamage [1, false];
		// Debug message:
		if PAC_isOnDebug then { systemChat format ["%1 REMOVED > Original veh: %2", PAC_debugHeader, typeOf _veh] };
		// Breath:
		sleep 0.5;
	};

	// If player's group has at least 1 AI member:
	if ( { alive _x } count ((units group _unit) - allPlayers) > 0 ) then {
		{  // Check each AI group member only:
			// Check if out of playable area:
				if ( !(_x inArea PAC_playableArea)) then {
					// If player gets a vehicle when already out of the playable area:
					if ( !isNull (objectParent _x) ) then {
						// Destroy the current vehicle too:
						(objectParent _x) setDamage [1, false];
					};
					// Kill the unit:
					_x setDamage [1, false];
					// Debug message:
					if PAC_isOnDebug then { systemChat format ["%1 REMOVED > +1 AI member (%2) has been punished!", PAC_debugHeader, name _x] };
					// Break
					sleep 0.5;
				};
		} forEach ((units group _unit) - allPlayers) select { alive _x };
	};
	
	// If the player still exists:
	if ( !isNull _unit ) then {
		// Escape > if player returned during the tolerance time, abort:
		if ( _unit inArea PAC_playableArea ) exitWith { if PAC_isOnAlerts then { systemChat format ["%1 You're back in-game!", PAC_playerHeader] } };
		// If player gets a vehicle when already out of the playable area:
		if ( !isNull (objectParent _unit) ) then {
			// Destroy the current vehicle too:
			(objectParent _unit) setDamage [1, false];
			// Debug message:
			if PAC_isOnDebug then { systemChat format ["%1 REMOVED > Current veh: %2", PAC_debugHeader, typeOf (objectParent _unit)] };
		};
		// Kill the player:
		_unit setDamage [1, false];
		// Debug message:
		if PAC_isOnDebug then { systemChat format ["%1 REMOVED > You: %2", PAC_debugHeader, name _unit] };
	};
	// Return:
	true;
};


THY_fnc_PAC_check_player = {
	// This function checks if the player is inside the playable area defined by the mission editor on Eden.
	// Return nothing.

	params ["_unit", "_veh", "_drone"];
	//private [];

	// Escape > If player is dead, abort:
	if ( !alive _unit ) exitWith {};
	// Initial values:
		// Reserved space.
	// Player NOT in playable area:
	if ( !(_unit inArea PAC_playableArea) ) then {

		// Immune case:
		if ( count PAC_noAnyRulesForThem > 0 && typeOf (objectParent _unit) in PAC_noAnyRulesForThem ) exitWith {};

		// AIR TOLERANCE FALSE:
		// If there's NO air tolerance out of the playable area:
		if !PAC_isAirTolerated then {
			// Countdown:
			[false] call THY_fnc_PAC_countdown;
			// Executes the punishment:
			[_unit, _veh, _drone] call THY_fnc_PAC_punishment;

		// AIR TOLERANCE TRUE:
		// If there's air tolerance out of the playable area:
		} else {
			// If players's vehicle is NOT air vehicle (parachute is air too):
			if ( !(objectParent _unit isKindOf "Air") ) then {
				// Escape > If out of the playable area, the player ejected or just spawn in the air, abort:
				if ( (getUnitFreefallInfo _unit) # 1 ) exitWith {  // [isFalling, isInFreefallPose, ...]
					if PAC_isOnDebug then { systemChat format ["%1 You're in freefall. Rules free so far...", PAC_debugHeader] };
				};
				// Escape > If out of the playable area, the player is in a seat-ejector, abort:
				if ( (getPos _unit # 1) > 10 && (objectParent _unit call BIS_fnc_objectType) # 1 isEqualTo "Motorcycle" ) exitWith {  // Seat ejectors are Motocycle type.
					// Debug message:
					if PAC_isOnDebug then { systemChat format ["%1 You ejected from your aircraft. Rules free so far...", PAC_debugHeader] };
					// Waiting the player touch the ground:
					waitUntil { sleep PAC_checkTime; getPos _unit # 2 <= PAC_minAlt };
				};
				// Countdown:
				[false] call THY_fnc_PAC_countdown;
				// Executes the punishment:
				[_unit, _veh, _drone] call THY_fnc_PAC_punishment;
			// if player's vehicle is Air class (parachutes are included):
			} else {
				// Check if player is following the rules:
				[_unit, _veh] call THY_fnc_PAC_check_advanced_rules;
			};
		};
	
	// Player IN playable area:
	} else {
		// Player has a drone, and they're connected to it:
		if ( !isNull _drone && isUAVConnected _drone ) then {
			// Player keeps in playable area, but their Drone NOT:
			if ( !(_drone inArea PAC_playableArea) ) then {
				
				// AIR TOLERANCE FALSE:
				if !PAC_isAirTolerated then {
					// Countdown:
					[true] call THY_fnc_PAC_countdown;
					// Executes the punishment:
					[_unit, _veh, _drone] call THY_fnc_PAC_punishment;

				// AIR TOLERANCE TRUE:
				} else {
					// If players's vehicle is NOT air vehicle:
					if ( !(_drone isKindOf "Air") ) then {
						// Countdown:
						[true] call THY_fnc_PAC_countdown;
						// Executes the punishment:
						[_unit, _veh, _drone] call THY_fnc_PAC_punishment;
					//
					} else {
						// Check if player's drone is following the rules:
						[_unit, _drone] call THY_fnc_PAC_check_advanced_rules;
					};
				};
			};
		};
	};
	// Return:
	true;
};


THY_fnc_PAC_check_advanced_rules = {
	// This function runs advanced rules for the mission that's using the PAC_isAirTolerated as TRUE.
	// Return nothing.

	params ["_unit", "_vehOrDrone"];
	private ["_isToPunish"];

	// Escape > If in parachute, abort:
	// Important: this shit is only filled by info when, first, the unit entered in freefall pos. That said, after ejections, no info to detect if unit's in parachute.
	if ( (getUnitFreefallInfo _unit) # 0 ) exitWith {
		// Debug:
		if PAC_isOnDebug then { systemChat format ["%1 You're in parachute. Rules free so far...", PAC_debugHeader] };
	};
	// Initial values:
	_isToPunish = false;
	// If vehicle is NOT respecting the minimal altitude, flag it:
	if ( (getPos _vehOrDrone # 2) < PAC_minAlt ) then { _isToPunish = true };
	// If minimal speed is enable, if the vehicle get too slow, flat it:
	if PAC_isOnSpeedPunish then { if ( abs (speed _vehOrDrone) < PAC_minSpeed) then { _isToPunish = true } };
	// If punishment is needed::
	if _isToPunish then {
		// Call the punishment:
		[_unit, objectParent _unit, getConnectedUAV _unit] call THY_fnc_PAC_punishment;
	// If punishment is not needed:
	} else {
		// If Alerts is true:
		if PAC_isOnAlerts then {
			// If vehicle is flying almost at the minimal altitude:
			if ( (getPos _vehOrDrone # 2) < (PAC_minAlt + 50) ) then {
				// Sound alert:
				playSound "Alarm";
				// Message:
				systemChat "";
				systemChat format ["%1 Don't TOUCH the ground %2 here.", PAC_playerHeader, if (!isUAVConnected _vehOrDrone) then {""} else {"with the drone"}];
			};
			// If vehicle is flying almost at the minimum speed:
			if ( PAC_isOnSpeedPunish && abs (speed _vehOrDrone) < (PAC_minSpeed + 25) ) then {
				// Sound alert:
				playSound "Alarm";
				// Message:
				systemChat "";
				systemChat format ["%1 Don't SLOW down too much %2 here.", PAC_playerHeader, if (!isUAVConnected _vehOrDrone) then {""} else {"with the drone"}];
				systemChat format ["%1 Minimal speed: %2 Km/h.", PAC_playerHeader, PAC_minSpeed];
			};
		};
	};
	// Return:
	true;
};


THY_fnc_PAC_debug = {
	// This function shows a hint monitor to the mission editor make their tests through PAC script settings.
	// Return nothing.

	params ["_unit"];
	private ["_veh", "_drone"];

	// Initial values:
	_veh   = objNull;
	_drone = objNull;

	while { PAC_isOnDebug } do {
		// Declarations:
		_veh   = objectParent _unit;
		_drone = getConnectedUAV _unit;
		// Monitor:
		hintSilent format [
			"\n
			\n--- PAC DEBUG MONITOR ---
			\n
			\nAirVec tolerance: %1
			\n%2
			\nYour vehicle:
			\n%7
			\n%8
			\nConnected to a drone: %5
			\nCurrent drone:
			\n%6
			\n
			\nTolerance to return: %4s
			\n%3
			\n",
			if PAC_isAirTolerated then {"YES"} else {"NO"}, 
			if PAC_isAirTolerated then {if PAC_isOnSpeedPunish then {"AirVec too slow punishment: YES\n"} else {"AirVec too slow punishment: NO\n"}} else {""},
			if (!(_unit inArea PAC_playableArea)) then {"\nYou're OUT of playable area!\n"} else {if (!isNull _drone && !(_drone inArea PAC_playableArea)) then {"\nYour drone's OUT of playable area!\n"} else {"\nYou're IN playable area!\n"}}, 
			PAC_toleranceToReturn, 
			if (isUAVConnected _drone) then {"YES"} else {"NO"},
			if (!isNull _drone) then {str typeOf _drone} else {"None"},
			if (!isNull _veh && !(_veh isKindOf "CAManBase")) then {typeOf _veh} else {"None"},
			if ( count PAC_noAnyRulesForThem > 0 && typeOf (objectParent _unit) in PAC_noAnyRulesForThem ) then {"This veh-type's immune to PAC!\n"} else {""}
		];
		// CPU breath:
		sleep 3;
	};
	// Return:
	true;
};


// Return:
true;