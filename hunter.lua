function drsHunterMark()
  if not drsHasBuff("target","SniperShot") then
    CastSpellByName("Hunter's Mark()")
    return true
  end
  return false
end


