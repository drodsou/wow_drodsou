

function drsShamanShield(minMana)
  minMana = minMana or 0.35
  if drsMana("player") > minMana and not drsHasBuff("player","LightningShield") then
    CastSpellByName("Lightning Shield()")
    return true
  end
  return false
end

function drsShamanWeaponEnchant(minMana)
  minMana = minMana or 0.35
  if drsMana("player") > minMana and not drsWeaponHasEnchant() then
    CastSpellByName("Rockbiter Weapon()")
    return true
  end
  return false
end

-- ----------------------

function drsShamanBasic()
  local casted = false
  if not casted then casted = drsShamanShield(0.35) end
  if not casted then casted = drsShamanWeaponEnchant(0.35) end
  if not casted then drsStartAttack() end
end

