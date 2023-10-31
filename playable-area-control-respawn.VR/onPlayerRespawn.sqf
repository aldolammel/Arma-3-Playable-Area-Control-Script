// File: your_mission_folder\onPlayerRespawn.sqf
// About the file: executed locally when player respawns in a multiplayer mission. This event script will also fire (from description.ext) at the beginning of a mission if respawnOnStart is 0 or 1, where oldUnit will be objNull in this instance. This script will not fire at mission start if respawnOnStart equals -1. More in https://community.bistudio.com/wiki/Event_Scripts#onPlayerRespawn.sqf

// BOHEMIA ON-PLAYER-RESPAWN SYSTEM:
params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];  // Do not change these parameters!!!





	// When applicatebla, drop here all your respawn codes, etc...





// PAC, PLAYABLE AREA CONTROL (v1.7):
// Documentaion: https://docs.google.com/document/d/1GwwM5lRdo_DGnEd8RmJKIseZ6OEBtFc6tLbaZSnp4BE
[_newUnit] execVM "PAC\fn_PAC_clientSide.sqf";