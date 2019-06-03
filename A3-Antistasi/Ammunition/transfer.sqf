private ["_camion","_objectsX","_todo","_proceed","_caja","_armas","_ammunition","_items","_mochis","_containers","_cuenta","_exists"];

_camion = vehicle player;
_objectsX = [];
_todo = [];
_proceed = false;

[driver _camion,"remove"] remoteExec ["A3A_fnc_flagaction",driver _camion];

_objectsX = nearestObjects [_camion, ["ReammoBox_F"], 20];

if (count _objectsX == 0) exitWith {};
_caja = _objectsX select 0;

if ((_caja == caja) and (player!=theBoss)) exitWith {hint "Only the Commander can transfer this ammobox content to any truck"; [driver _camion,"camion"] remoteExec ["A3A_fnc_flagaction",driver _camion]};


_armas = weaponCargo _caja;
_ammunition = magazineCargo _caja;
_items = itemCargo _caja;
_mochis = [];
/*
if (count weaponsItemsCargo _camion > 0) then
	{
	{
	_armas pushBack ([(_x select 0)] call BIS_fnc_baseWeapon);
	for "_i" from 1 to (count _x) - 1 do
		{
		_cosa = _x select _i;
		if (typeName _cosa == typeName "") then
			{
			if (_cosa != "") then {_items pushBack _cosa};
			}
		else
			{
			if (typeName (_cosa select 0) == typeName []) then {_ammunition pushBack (_cosa select 0)};
			}
		};
	} forEach weaponsItemsCargo _caja;
	};

if (count backpackCargo _caja > 0) then
	{
	{
	_mochis pushBack (_x call BIS_fnc_basicBackpack);
	} forEach backpackCargo _caja;
	};
_containers = everyContainer _caja;
if (count _containers > 0) then
	{
	for "_i" from 0 to (count _containers - 1) do
		{
		_armas = _armas + weaponCargo ((_containers select _i) select 1);
		_ammunition = _ammunition + magazineCargo ((_containers select _i) select 1);
		_items = _items + itemCargo ((_containers select _i) select 1);
		};
	};
*/
_todo = _armas + _ammunition + _items + _mochis;
_cuenta = count _todo;

if (_cuenta < 1) then
	{
	hint "Closest Ammobox is empty";
	_proceed = true;
	};

if (_cuenta > 0) then
	{
	if (_caja == caja) then
		{
		if (["DEF_HQ"] call BIS_fnc_taskExists) then {_cuenta = round (_cuenta / 10)} else {_cuenta = round (_cuenta / 100)};
		}
	else
		{
		_cuenta = round (_cuenta / 5);
		};
	if (_cuenta < 1) then {_cuenta = 1};
	while {(_camion == vehicle player) and (speed _camion == 0) and (_cuenta > 0)} do
		{
		hint format ["Truck loading. \n\nTime remaining: %1 secs", _cuenta];
		_cuenta = _cuenta -1;
		sleep 1;
		if (_cuenta == 0) then
			{
			[_caja,_camion] remoteExec ["A3A_fnc_ammunitionTransfer",2];
			_proceed = true;
			};
		if ((_camion != vehicle player) or (speed _camion != 0)) then
				{
				hint "Transfer cancelled due to movement of Truck or Player";
				_proceed = true;
				};
		};
	};

if (_proceed) then {[driver _camion,"camion"] remoteExec ["A3A_fnc_flagaction",driver _camion]};