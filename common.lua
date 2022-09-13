

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

function drsGetSpellId(spellName)
	local i = 1
	while true do
	   local iName, iRank = GetSpellName(i, BOOKTYPE_SPELL)
	   if not iName then break end
       if string.find(iName, spellName) then return i end
	   i = i + 1
	end
	return 0
end

