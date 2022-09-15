--[[
  For party of two
  - heal/wand-attack: /run drsDoBasicPriest()
  - escape-protect: /run drsDoEscapePriest()
  - buff: /run drsPriestBuffAssist()

]]

-- ESCAPE
function drsDoEscapePriest()
  FollowUnit("party1")
  local castDone = false
  local tgt1 = "party1"
  local tgt2 = "player"
  if drsHealth("player") < drsHealth("party1") then 
    tgt1 = "player" 
    tgt2 = "party1"
  end
  if not castDone then castDone = drsPriestShield(tgt1, 2) end
  if not castDone then castDone = drsPriestShield(tgt2, 2) end
  if not castDone then castDone = drsPriestRenew(tgt1, 0.85) end
  if not castDone then castDone = drsPriestRenew(tgt2, 0.85) end
  --if not castDone then castDone = FEAR end
  
  if drsMana("player") < 0.2 then
    SendChatMessage("OOM!")
  end
end

--------- HEAL
function drsPriestShield(tgt, lvl)
  local cdShield ,_,_ = GetSpellCooldown(drsGetSpellId("Power Word: Shield"), "spell")
 if cdShield == 0 and drsHealth(tgt) < lvl and not drsHasBuff(tgt,"PowerWordShield") and not drsHasBuff(tgt,"AshesToAshes") then
   TargetUnit(tgt)
   CastSpellByName("Power Word: Shield()")
   return true
 end
 return false
end

function drsPriestRenew(tgt, lvl)
 if drsHealth(tgt) < lvl and not drsHasBuff(tgt,"Holy_Renew") then
   TargetUnit(tgt)
   CastSpellByName("Renew()")
   return true
 end
 return false
end

function drsPriestLesserHeal(tgt, lvl)
 if drsHealth(tgt) < lvl then
   TargetUnit(tgt)
   CastSpellByName("Lesser Heal()")
   return true
 end
 return false
end


-- if shield asume priest is being attacked, use "fade" if possible
function drsPriestFade()
  local cdFade ,_,_ = GetSpellCooldown(drsGetSpellId("Fade"), "spell")
  if cdFade == 0 and drsHasBuff("player","PowerWordShield") then
    CastSpellByName("Fade()")
    return true
  end
  return false
end


function drsPriestPain(minMana)
  if drsMana("player") > minMana and not drsHasBuff("target","ShadowWordPain") then
    CastSpellByName("Shadow Word: Pain()")
    return true
  end
  return false
end



-- MACRO
function drsDoBasicPriest()
 local castDone = false
 local tgt1 = "party1"
 local tgt2 = "player"
 if drsHealth("player") < drsHealth("party1") then 
   tgt1 = "player" 
   tgt2 = "party1"
 end

 -- heal
 if not castDone then castDone = drsPriestShield(tgt1, 0.65) end
 if not castDone then castDone = drsPriestShield(tgt2, 0.65) end
 if not castDone then castDone = drsPriestRenew(tgt1, 0.8) end
 if not castDone then castDone = drsPriestRenew(tgt2, 0.8) end
 if not castDone then castDone = drsPriestFade() end
 if not castDone then castDone = drsPriestLesserHeal(tgt1, 0.65) end     

 if drsIsAttackable("party1target") then
   FollowUnit("party1")
   TargetUnit("party1target")

   -- attack
   if not castDone then castDone = drsPriestPain(0.65) end     
   if not castDone then drsStartShoot() end     

 else
    FollowUnit("party1")
 end

 -- OOM?
 if drsMana("player") < 0.2 then
   SendChatMessage("OOM!")
 end
end

drsSeqPriestBuff = drsSeqCreate({
  {"Power Word: Fortitude()",4},
  {"Inner Fire()",4},
})

function drsPriestBuffAssist()
  if UnitExists("party1target") then TargetUnit("party1target") end
  drsSeqCast(drsSeqPriestBuff)
end



