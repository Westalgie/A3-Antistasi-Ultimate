private ["_tiempo","_tsk"];

_tiempo = _this select 0;
_tsk = _this select 1;
if (isNil "_tsk") exitWith {};
if (_tiempo > 0) then {sleep ((_tiempo/2) + random _tiempo)};

if (count missionsX > 0) then
	{
	for "_i" from 0 to (count missionsX -1) do
		{
		_mision = (missionsX select _i) select 0;
		if (_mision == _tsk) exitWith {missionsX deleteAt _i; publicVariable "missionsX"};
		};
	};

_nul = [_tsk] call BIS_fnc_deleteTask;
