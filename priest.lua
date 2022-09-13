--[[

  - heal: /run drsDoBasicPriest()
  - escape-protect: /run drsDoEscapePriest()

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
  if not castDone then castDone = drsPriestHeal1(tgt1, 2) end
  if not castDone then castDone = drsPriestHeal1(tgt2, 2) end
  if not castDone then castDone = drsPriestHeal2(tgt1, 0.85) end
  if not castDone then castDone = drsPriestHeal2(tgt2, 0.85) end
  --if not castDone then castDone = FEAR end
  
  if drsMana("player") < 0.2 then
    SendChatMessage("OOM!")
  end
end

--------- HEAL
function drsPriestHeal1(tgt, lvl)
  local cooldown ,_,_ = GetSpellCooldown(drsGetSpellId("Power Word: Shield"), "spell")
 if cooldown == 0 and drsHealth(tgt) < lvl and not drsHasBuff(tgt,"PowerWordShield") and not drsHasBuff(tgt,"AshesToAshes") then
   TargetUnit(tgt)
   CastSpellByName("Power Word: Shield()")
   return true
 end
 return false
end


function drsPriestHeal2(tgt, lvl)
 if drsHealth(tgt) < lvl and not drsHasBuff(tgt,"Holy_Renew") then
   TargetUnit(tgt)
   CastSpellByName("Renew()")
   return true
 end
 return false
end

function drsPriestHeal3(tgt, lvl)
 if drsHealth(tgt) < lvl then
   TargetUnit(tgt)
   CastSpellByName("Lesser Heal()")
   return true
 end
 return false
end


function drsDoBasicPriest()
 local castDone = false
 local tgt1 = "party1"
 local tgt2 = "player"
 if drsHealth("player") < drsHealth("party1") then 
   tgt1 = "player" 
   tgt2 = "party1"
 end
 
 if not castDone then castDone = drsPriestHeal1(tgt1, 0.65) end
 if not castDone then castDone = drsPriestHeal1(tgt2, 0.65) end
 if not castDone then castDone = drsPriestHeal2(tgt1, 0.8) end
 if not castDone then castDone = drsPriestHeal2(tgt2, 0.8) end
 if not castDone then castDone = drsPriestHeal3(tgt1, 0.65) end      
 if drsIsAttackable("party1target") then
   FollowUnit("party1")
   TargetUnit("party1target")

   if castDone then
     drsStartAttack()
   else 
     drsStartShoot()
   end
 else
   FollowUnit("party1")
 end
 
 if drsMana("player") < 0.2 then
   SendChatMessage("OOM!")
 end
end


-- ATTACK


function drsResetPriestSpell()
  drsPriestSeq = {
      {"Shadow Word: Pain()", 18, time() - 3600},
      {"Smite()", 0, time() - 3600},
  }
end
drsResetPriestSpell()

function drsNextPriestSpell()
  for i,spell in ipairs(drsPriestSeq) do 
      if spell[3] < time() then
          spell[3] = time() + spell[2]
          return spell[1]
      end
  end
  return "none"
end

function drsDoSpellsPriest()
if drsIsAttackable("party1target") then
  TargetUnit("party1target")
  drsStartAttack()
  local nextSpell = drsNextPriestSpell()
  if nextSpell ~= "none" then 
    CastSpellByName(nextSpell)
  end
end

if drsMana("player") < 0.2 then
  CastSpellByName("Shoot()")
  SendChatMessage("OOM!")
end
end



