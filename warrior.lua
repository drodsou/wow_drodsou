--[[ 
MACROS

Defense
/cast Defensive Stance
/script WeaponSwap("Crescent of Forlorn Spirits","Crest of Darkshire");

DEPENDENCIAS:
Samuel Addon (modify it addin SamuelAddon_last_swing = _last_swing where _last_swing is updated)


--]]


function drsWarriorEquip(s)
  if s == "2h" then 
    drsEquip("Whirlwind Sword") 
  end

  if s == "sh" then 
    drsEquip("Murphstar of the Tiger")
    drsEquip("Collection Plate")
  end
end


-- NOTA: el weapon swap en COMBATE activa global cooldown, fuera de combate no
local drsShieldBash_ChangedShield = false
local drsShieldBash_LastCasted = 0
function drsShieldBash()

  local sLastCasted = GetTime() - drsShieldBash_LastCasted
  -- return to 2h if this function equip shield (3rd use)
  if drsShieldBash_ChangedShield and sLastCasted < 12 then
    drsWarriorEquip("2h")
    drsShieldBash_ChangedShield = false
    return
  end

  -- return if not available spell
  if UnitMana("player") < 10 or drsSpellCooldown("Shield Bash()") > 0 then 
    return 
  end

  -- do shield bash
  if drsHasShield()  then
    -- 1st use without shield, or 2nd use if hand't shield
    CastSpellByName("Shield Bash()")
    drsShieldBash_LastCasted = GetTime()
   else
    -- 1st use if no shield
    drsWarriorEquip("sh")
    drsShieldBash_ChangedShield = true
  end
end



-- charges and immediaty changes to berserker stance
function drsChargeBerserker()

  if UnitAffectingCombat("player") == nil then
    -- not in combat
    if drsFormActive() ~= 1 then 
      CastSpellByName("Battle Stance()")
    else
      CastSpellByName("Charge()")
    end
  else
    -- in combat, ensure berserker
    if drsFormActive() ~= 3 then 
      CastSpellByName("Berserker Stance()")
    else
      -- TODO inrange?
      CastSpellByName("Intercept()")
    end
  end
end


local ActiveOverpower = false


function drsWarriorOne()
  
  drsStartAttack()
  -- Execute usa TODA la rage que te quede, ojo...
  -- Estp bien para bosses, pero para bichos normales, mejor solo whirlwind
  -- if UnitHealth("target") < 21 then
  --   CastSpellByName("Execute()")
  -- else
  if ActiveOverpower and drsFormActive() == 1 then
    CastSpellByName("OverPower()")
    ActiveOverpower = false
  else
    if drsFormActive() == 3 then
      -- berserker: 35 rage = execute + ww
      if UnitMana("player") >= 35 then CastSpellByName("Whirlwind()") end
    else
      -- not berserker: 22 rage = execute+hs
      if UnitMana("player") >= 22 then CastSpellByName("Heroic Strike()") end
    end
  end
end

function drsSlam() 
  drsStartAttack()

  if ActiveOverpower and drsFormActive() == 1 then
    CastSpellByName("OverPower()")
    ActiveOverpower = false
  else
    -- spare rage for execute
    if GetTime()-SamuelAddon_last_swing<1 and UnitMana("player") >=15 then 
      CastSpellByName"Slam()" 
    end
  end
end


-- LISTENER
-- Create a frame to register and handle events
local myFrame = CreateFrame("Frame")
myFrame:RegisterEvent("COMBAT_TEXT_UPDATE")
myFrame:SetScript("OnEvent", function (uno, dos, tres, cuatro)
  local event = arg1
  local subevent = arg2

  if (event == "SPELL_ACTIVE") then
    -- print(subevent)
    if (subevent) == "Overpower" then ActiveOverpower = true end
  end


end)



