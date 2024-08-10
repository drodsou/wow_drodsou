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
  else
    
    drsEquip("Furious Falchion of the Tiger")
    if s == "dw" then 
      drsEquip("Murphstar of the Tiger")
    elseif s == "sh" then
      drsEquip("Collection Plate")
    end
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


-- charges and immediaty changes to berserker stance
-- pseudo castsequence
local cd_st = 0
local cd_nextTime = 0
function drsChargeDefensive()
  if cd_nextTime > GetTime() then 
    return 
  end
  cd_st = cd_st+1

  if cd_st == 1 and (drsInCombat() or not drsSpellReady("Charge") or not drsIsAttackable("target")) then 
    -- print("reset to def")
    cd_st = 0
    if drsFormActive() ~= 2 then
      CastSpellByName("Defensive Stance()") 
      return
    end
  end

  if cd_st == 1 then 
    CastSpellByName("Battle Stance()") 
  elseif cd_st == 2 then 
    CastSpellByName("Charge()") 
    -- wait global cooldown
    cd_nextTime = GetTime() + 1.6 -- GCD
  elseif cd_st == 3 then 
    CastSpellByName("Hamstring()") 
    cd_st = 0
  end 

end






local ActiveOverpower = false

function drsWarriorOne(prio) 
  drsStartAttack()

  -- if UnitName("target") and drsFormActive() == 1 and drsSpellReady("Charge") then
  --   CastSpellByName("Charge()")  

  if ActiveOverpower and drsFormActive() == 1 then
    CastSpellByName("OverPower()")
    ActiveOverpower = false
  elseif drsSpellReady("Execute") and UnitMana("player") >=15 and UnitHealth("target") <= 20 then
    CastSpellByName("Execute()")   

  elseif drsSpellReady("Bloodrage") then
    CastSpellByName("Bloodrage()")
  elseif not drsHasBuff("player","BattleShout") and UnitMana("player") >=10 then
    CastSpellByName("Battle Shout()") 

  elseif prio=="aoe" and drsFormActive() == 3 and drsSpellReady("Whirlwind") and UnitMana("player")>=25 then
    CastSpellByName("Whirlwind()") 
  
  elseif prio=="aoe" and drsFormActive() == 1 and drsSpellReady("Thunder Clap") and UnitMana("player") >=20 then 
    CastSpellByName("Thunder Clap()")
  elseif prio=="aoe" and drsFormActive() ~= 3 and drsSpellReady("Cleave") and UnitMana("player") >=20 then 
    CastSpellByName("Cleave()")     

  -- elseif prio~="aoe" and GetTime()-SamuelAddon_last_swing<1.5 and UnitMana("player") >=15 then 
    -- CastSpellByName"Slam()" 

  elseif prio=="def" then
    CastSpellByName("Shield Block()")
    CastSpellByName("Revenge()") 
    CastSpellByName("Sunder Armor()")


     
  elseif UnitMana("player") >=45 and drsSpellReady("Bloodthirst") then  -- keep rage for execute
    CastSpellByName("Bloodthirst()")     
  elseif drsFormActive() == 3 and drsSpellReady("Berserker Rage") then 
    CastSpellByName("Berserker Rage()")
  end
end




function drsExecute() 
  drsStartAttack()

  if ActiveOverpower and drsFormActive() == 1 then
    CastSpellByName("OverPower()")
    ActiveOverpower = false
  elseif drsSpellReady("Execute") and UnitMana("player") >=15 and UnitHealth("target") < 21 then
    CastSpellByName"Execute()"     
  elseif not drsHasBuff("player","BattleShout") and UnitMana("player") >=10 then
    CastSpellByName"Battle Shout()" 
  elseif drsSpellReady("Bloodrage") then
    CastSpellByName("Bloodrage()")
  elseif drsFormActive() == 3 and drsSpellReady("Berserker Rage") then 
    CastSpellByName("Berserker Rage()")
  end
end


function drsSlam()
  if GetTime()-SamuelAddon_last_swing<1.5 and UnitMana("player") >=15 then 
    CastSpellByName"Slam()" 
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



