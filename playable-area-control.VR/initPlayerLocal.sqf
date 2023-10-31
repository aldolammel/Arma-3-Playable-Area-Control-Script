// File: your_mission_folder\initPlayerLocal.sqf
// About the file: executed locally when player joins mission (includes both mission start and JIP). So, everything in this file will run only in player machine.
// More: https://community.bistudio.com/wiki/Event_Scripts#initPlayerLocal.sqf 




// Here, other script possible codes...




// PAC, PLAYABLE AREA CONTROL (v1.7):
// Documentaion: https://docs.google.com/document/d/1GwwM5lRdo_DGnEd8RmJKIseZ6OEBtFc6tLbaZSnp4BE
[player] execVM "PAC\fn_PAC_clientSide.sqf";