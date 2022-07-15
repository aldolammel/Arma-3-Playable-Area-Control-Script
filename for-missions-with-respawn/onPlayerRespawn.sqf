// File: your_mission_folder\onPlayerRespawn.sqf
// About the file: executed locally when player respawns in a multiplayer mission. This event script will also fire (from description.ext) at the beginning of a mission if respawnOnStart is 0 or 1, where oldUnit will be objNull in this instance. This script will not fire at mission start if respawnOnStart equals -1. More in https://community.bistudio.com/wiki/Event_Scripts#onPlayerRespawn.sqf


// BOHEMIA ON-PLAYER-RESPAWN SYSTEM:
params [ "_newUnit", "_oldUnit", "_respawn", "_respawnDelay" ];  // Do not change these parameters!!!



// When applicatebla, drop here all your respawn codes, etc...



// PAC, PLAYABLE AREA CONTROL, COMPATIBLE WITH RESPAWN POINTS (v1.1):
// Important: it must be the last code block of onPlayerRespawn.sqf file.
private _pacTolerance = 10;    // in seconds, tolerance time to the player return to playable area. Default 10.

while { alive _newUnit } do 
{
	// Regular players:
	if ( !(_newUnit inArea PAC_playableAreaControl) ) then  // setting the trigger (dropped by Eden Editor and named as "PAC_playableAreaControl")
	{
		systemChat "YOU'RE LEAVING THE PLAYABLE AREA!";
		sleep _pacTolerance;
		if ( _newUnit inArea PAC_playableAreaControl ) exitWith { systemChat "You've just returned." };  // if returned, receive forgiveness
		if !(isNull objectParent _newUnit) then  // checking if the player is in vehicle
		{
			vehicle _newUnit setDamage [1, false];
		};
		_newUnit setDamage [1, false];
	};
	
	// Players with drones:
	private _connected =  getConnectedUAV _newUnit;
	if ( (isUAVConnected _connected) AND !(_connected inArea PAC_playableAreaControl) ) then  // setting the trigger (dropped by Eden Editor and named as "PAC_playableAreaControl")
	{
		systemChat "THE DRONE IS LEAVING THE PLAYABLE AREA!";
		sleep _pacTolerance;
		if ( _connected inArea PAC_playableAreaControl ) exitWith { systemChat "The drone has just returned." };  // if returned, receive forgiveness
		_connected setDamage [1, false];
	};
	
	sleep 10;  // looping breathe
};