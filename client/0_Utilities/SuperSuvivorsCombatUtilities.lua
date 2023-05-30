-- this file has methods related to npc combat

-- this file has methods related to npc combat

SuperSurvivorsAmmoBoxes = {   -- for the loot stores that are spawned with preset spawns.
  "Base.223Box",
  "Base.308Box",
  "Base.Bullets9mm",
  "Base.Bullets9mm",
  "Base.Bullets9mm",
  "Base.ShotgunShellsBox",
  "Base.ShotgunShellsBox",
  "Base.ShotgunShellsBox",
}

local ammoBoxMap = {
  BB177 = "BB177Box",
  Bullets22 = "Bullets22Box",
  Bullets57 = "Bullets57Box",
  Bullets380 = "Bullets380Box",
  Bullets9mm = "Bullets9mmBox",
  Bullets38 = "Bullets38Box",
  Bullets357 = "Bullets357Box",
  Bullets45 = "Bullets45Box",
  Bullets45LC = "Bullets45LCBox",
  Bullets44 = "Bullets44Box",
  Bullets4570 = "Bullets4570Box",
  -- Add the rest of the mappings here...
}

local boxCountMap = {
  BB177Box = 500,
  Bullets22Box = 100,
  Bullets57Box = 50,
  Bullets380Box = 50,
  Bullets9mmBox = 50,
  Bullets38Box = 50,
  Bullets357Box = 50,
  Bullets45Box = 50,
  Bullets45LCBox = 50,
  Bullets44Box = 50,
  Bullets4570Box = 20,
  -- Add the rest of the mappings here...
}

--- Gets a ammo box of an ammo type
---@param bullets string any ammo type
---@return string returns the ammo box name
function getAmmoBox(bullets)
  if isModEnabled("ORGM") then 
    return bullets.."_Box" 
  end
  return ammoBoxMap[bullets] or ""
end

--- func desc
---@param box string ammo box name
---@return integer returns the amount of bullets inside of the ammo box
function getBoxCount(box)
  if isModEnabled("ORGM") then 
    return 50 
  end
  return boxCountMap[box] or 0
end

function SurvivorTogglePVP()

	if(IsoPlayer.getCoopPVP() == true) then
		getSpecificPlayer(0):Say("PVP Disabled");
		IsoPlayer.setCoopPVP(false);
		getSpecificPlayer(0):getModData().PVP = false;
		PVPDefault = false;
		PVPButton:setImage(PVPTextureOff)
	elseif(IsoPlayer.getCoopPVP() == false) then

		IsoPlayer.setCoopPVP(true);
		if(ForcePVPOn ~= true) then
			getSpecificPlayer(0):getModData().PVP = true;
			PVPDefault = true;
			getSpecificPlayer(0):Say("PVP Enabled");
		else
			getSpecificPlayer(0):Say("PVP Forced On");
		end
		ForcePVPOn = false;
		PVPButton:setImage(PVPTextureOn)
	end
end

---	gets in the database the ammo type for the weapon 'weapon' 
---@param weapon any weapon to have the ammo searched
---@param incModule any (not being used)
---@return any returns the ammo type of the gun or nil if not found
function getAmmoType(weapon,incModule)

	if(weapon == nil) or (weapon:getAmmoType() == nil) then 
    return nil 
  end

	local modulename ='Base';
	local wepType = weapon:getType();
	local out = weapon:getAmmoType()

  -- search for a magazine
	if(out == nil) then
		local s = weapon:getMagazineType();
		i, j = string.find(s, "Clip")
		out = s:sub( i )
	end

	if(out == nil) then
		print("no bullets found for weapon: " .. wepType)
		return nil
	end

	out = out:sub( 6 )
	--[[
	print("weapong type: "..wepType);
	local wepdata = ReloadUtil:getWeaponData(wepType);
	if(not wepdata or not wepdata.ammoType) then
		--if(wepdata) then print("no weapon data for:"..tostring(weapon:getType()) .. "["..tostring(wepdata.ammoType).."]");
		--else print("no weapon data for:"..tostring(weapon:getType())); end
		return nil
	end
	local clipdata = ReloadUtil:getClipData(wepdata.ammoType);

	if(clipdata) then
		if(clipdata.ammoType) then
			--print("ifif"..tostring(clipdata.ammoType));
			out = tostring(clipdata.ammoType);
			modulename = clipdata.moduleName;
		else
			--print("if-else"..tostring(wepdata.ammoType));
			out = tostring(wepdata.ammoType);
			modulename = wepdata.moduleName;
		end
	elseif(wepdata.ammoType) then
		--print("else"..tostring(wepdata.ammoType));
		out = tostring(wepdata.ammoType);
		modulename = wepdata.moduleName;
	else
		--print("else?");
	end
	--]]


	--if(incModule) then out = modulename .. "." .. out; end
	return out;

end

--- gets in the database bullets for the weapon 'weapon' 
---@param weapon any a HandWeapon
---@param incModule any
function getAmmoBullets(weapon,incModule)

	if(weapon == nil) then 
    return nil 
  end

	if (instanceof(weapon,"HandWeapon")) and (weapon:isAimedFirearm()) then
		local bullets = {}

		if(isModEnabled("ORGM")) then
		  local ammoTbl = ORGM.AlternateAmmoTable[getAmmoType(weapon,false)]
		  if (ammoTbl) then
		   --for _, name in ipairs(ammoTbl) do
		    for k=1, #ammoTbl do
          local name = ammoTbl[k]

          if(incModule) then 
            table.insert(bullets,"ORGM."..name)
          else 
            table.insert(bullets,name) 
          end

		    end
		  end

		  return bullets
		end

		if(incModule) then
			table.insert(bullets,getAmmoType(weapon,incModule))
		else
			table.insert(bullets,getAmmoType(weapon,incModule))
		end

		return bullets;
	end

	return nil
end