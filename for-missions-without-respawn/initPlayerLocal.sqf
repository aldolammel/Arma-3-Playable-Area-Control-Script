// File: your_mission_folder\initPlayerLocal.sqf
// About the file: executed locally when player joins mission (includes both mission start and JIP). So, everything in this file will run only in player machine. More about: https://community.bistudio.com/wiki/Event_Scripts#initPlayerLocal.sqf 


// When applicatebla, drop here all your initPlayerLocal.sqf codes, etc...  <------



// PAC, PLAYABLE AREA CONTROL (v1.1):
// Important: it must be the last code block of initPlayerLocal.sqf file.
params [ "_newUnit", "_oldUnit", "_respawn", "_respawnDelay" ];  // BOHEMIA ON-PLAYER-RESPAWN SYSTEM: Do not change these parameters!!!

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