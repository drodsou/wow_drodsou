--[[ 
MACROS

Defense
/cast Defensive Stance
/script WeaponSwap("Crescent of Forlorn Spirits","Crest of Darkshire");

--]]


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

