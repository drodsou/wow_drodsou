function drsPaladinBasic()
  drsStartAttack()
  if not drsHasBuff("player","FistOfJustice") then
    CastSpellByName("Blessing of Might()")
    return true
  end
  if not drsHasBuff("player","ThunderBolt") then
    CastSpellByName("Seal of Righteousness()")
    return true
  end
  if drsSpellReady("Judgement") then
    CastSpellByName("Judgement()")
    return true
  end
  if drsSpellReady("Holy Strike") then
    CastSpellByName("Holy Strike()")
    return true
  end
  return false
end