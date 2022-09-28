
print("-- drodsou started")

function drsVersion()
  print("wow_drodsou v1.01")
end

function drsStartAttack()
  -- right bar, 1st from bottom
  if not IsCurrentAction(36) then 
    UseAction(36)
  end
end

-- right bar, 2nd from bottom
function drsStartShoot()
  if IsAutoRepeatAction(35) == nil then 
    UseAction(35)
  end
end

function drsIsAttackable(t)
  -- yellow mobs are not "enemies"
 return UnitExists(t) and not UnitIsFriend("player",t) and not UnitIsDead(t)
end

function drsHealth(who)
  return UnitHealth(who)  / UnitHealthMax(who)
end

function drsMana(who)
  return UnitMana(who)  / UnitManaMax(who)
end

function drsHasBuff(t,buf)
  for i=1,40 do 
    local b,_,_,_,_,_,_,_,_ = UnitBuff(t,i)
    if b and string.find(b, buf) then return true end
    local db,_,_,_,_,_,_,_,_ = UnitDebuff(t,i)
    if db and string.find(db, buf) then return true end
    if not b and not db then break end
  end
  return false
end

function drsPrintBuff()
  for i=1,40 do 
    local b,_,_,_,_,_,_,_,_ = UnitBuff("target",i)
    if b then print(b) end
    local db,_,_,_,_,_,_,_,_ = UnitDebuff("target",i)
    if db then print(db) end
    if not b and not db then break end
  end
end

function drsGetSpellId(spellName)
  -- remove () at the end of the spellName if passed
  local spName = string.gsub(spellName, "[()]","")
	local i = 1
	while true do
	   local iName, iRank = GetSpellName(i, BOOKTYPE_SPELL)
	   if not iName then break end
       if string.find(iName, spName) then return i end
	   i = i + 1
	end
	return 0
end


function drsSpellReady(spellName)
  local spellId = drsGetSpellId(spellName)
  if spellId == 0 then
    print("> ERROR drodsou drsGetSpellId: spellName not found " .. spellName)
    return false
  end
  local cooldown ,_, enabled = GetSpellCooldown(spellId, "spell")
  if cooldown == 0 then return true end
  return false
end


-- 
--   example spells: {{"spellname()", timeoutInSeconds}, ... }
-- {
--   {"Shadow Word: Pain()", 18},
--   {"Smite()", 0},
-- }
-- 
-- create spell sequence
function drsSeqCreate(spells)
  for i,spell in ipairs(spells) do 
    spell[3] = time() - 3600
  end
  return spells
end

-- cast next sequence spell
-- macro ex: /run drsSeqCast(drsSeqDruidBuff)
function drsSeqCast(seq)
  for i,spell in ipairs(seq) do 
    if spell[3] < time() and drsSpellReady(spell[1]) then
      spell[3] = time() + spell[2]
      CastSpellByName(spell[1])
      return true
    end
  end
  return false
end

-- pet attack selected target only, in no target selected no attack
function drsPetAttackSecure()
  if drsIsAttackable("target") then
    PetAttack()
  end
end
