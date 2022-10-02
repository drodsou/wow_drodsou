function drsHunterMark()
  if not drsHasBuff("target","SniperShot") then
    CastSpellByName("Hunter's Mark()")
    return true
  end
  return false
end

-- Feign Death ( + trap)
-- allow to make macros for: feign death, feign death + X trap
function drsHunterFeign(trap)
  if drsInCombat() then
    drsStopShoot()
    drsStopAttack()
    PetPassiveMode() 
    CastSpellByName("Feign Death()")
  end
  if trap ~= nil then 
    CastSpellByName(trap .. "()")
  end
end