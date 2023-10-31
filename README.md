# Arma 3 / PAC: Playable Area Control v1.7
>*Dependencies: none.*

PAC is a simple script for ARMA 3 that controls the map limits for players in multiplayer, preventing players from leaving the mission area allowed by the mission editor. Designed for dedicated and hosted servers, doesn't matter what mods are loaded or not.

Creation concept: to be super easy to implement and customize, compatible with any mainstream mod, and functional for all types of servers: coop missions, PvP, and TvT.

## HOW TO INSTALL / DOCUMENTATION

video demo (old): https://www.youtube.com/watch?v=bDq5DH6xwJg

Documentation: https://docs.google.com/document/d/1GwwM5lRdo_DGnEd8RmJKIseZ6OEBtFc6tLbaZSnp4BE

__

## SCRIPT DETAILS

- No dependencies from other mods or scripts;
- PAC functions are in server's side (run once), but the checking (looping) is on the client's side;
- Easy installation: playable area is defined by one named trigger added on the Eden Editor;
- The editor has the option to allow or not air vehicles (including drones and parachuters) to be tolerated when outside the playable area and on air;
- The editor has the option to allow or not minimum speed restriction if there's air-tolerance out of playable area;
- The editor has the option to allow or not to notify the player about rules if they break some;
- Full documentation available.

__

## IDEA AND FIX?

Discussion and known issues: https://forums.bohemia.net/forums/topic/239890-release-pac-playable-area-control-script/

__

## CHANGELOG

**Nov, XXth 2023 | v1.7**
- Added > Air tolerance ON > Parachuters fly out of playable area;
- Added > Air tolerance ON > Jet pilots can eject out of playable area;
- Added > A list of vehicle types that can be enterally ignored by PAC rules;
- Improved > If player has an AI unit under their command and player order it to leave the playable area, the AI will be under the PAC rules if player leaves the area too;
- Improved > Lots of improvements regarding performance;
- Documentation updated. 

**Aug, 24th 2022 | v1.5**
- Added option to exclude air vehicles (plane, helicopters and air drones) from the punishment when out of playable area;
- Added option to hide message and sound alerts;
- Added debug option for Editors;
- Documentation updated.

**Jul, 15th 2022 | v1.0**
- Hello world.
