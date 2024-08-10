
-- reload addons:  /console reloadui

print("-- drodsou started")

function drsVersion()
  print("wow_drodsou v1.01")
end

function drsStartAttack()
  -- right bar, 1st from bottom
  if not drsIsAttackable("target") then
    TargetNearestEnemy()
  end
  if not IsCurrentAction(36) then 
    UseAction(36)
  end
end

function drsStopAttack()
  -- right bar, 1st from bottom
  if IsCurrentAction(36) then 
    UseAction(36)
  end
end

-- right bar, 2nd from bottom
function drsStartShoot()
  if IsAutoRepeatAction(35) == nil then 
    UseAction(35)
  end
end

function drsStopShoot()
  if IsAutoRepeatAction(35) ~= nil then 
    UseAction(35)
  end
end

function drsInCombat()
  if UnitAffectingCombat("player") == nil then
    return false
  else
    return true
  end
end

function drsIsAttackable(t)
  -- yellow mobs are not "enemies"
 return UnitExists(t) and not UnitIsFriend("player",t) and not UnitIsDead(t)
end

function drsHealth(who)
  return UnitHealth(who)  / UnitHealthMax(who)
end

-- 0 to 1
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

-- eg shaman Rockbitter on or not
function drsWeaponHasEnchant()
  local mhEnchanted, _, _, ohEnchanted, _, _ = GetWeaponEnchantInfo()
  if (mhEnchanted == 1) then
    return true
  else
    return false
  end
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

-- example: drsSpellReady("Overpower")
-- TODO: maybe it should check if its in range, but needs to be in a bar and check that slot...
function drsSpellReady(spellName)
  local spellId = drsGetSpellId(spellName)
  if spellId == 0 then
    print("> ERROR drodsou drsGetSpellId: spellName not found " .. spellName)
    return false
  end
    local cooldown ,_, enabled = GetSpellCooldown(spellId, "spell")
  if cooldown == 0 and enabled == 1 then return true end
  return false
end

function drsSpellCooldown(spellName)
  local spellId = drsGetSpellId(spellName)
  if spellId == 0 then
    print("> ERROR drodsou drsGetSpellId: spellName not found " .. spellName)
    return 99
  end
  local cooldown = GetSpellCooldown(spellId, "spell")
  if cooldown == 0 then return 0 else return GetTime()-cooldown end
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

function drsFormActive()
  local i,name,isActive,form
  for i=1,GetNumShapeshiftForms() do
    _,name,isActive = GetShapeshiftFormInfo(i)
    if isActive then
      return i
    end
  end
  return 0
end




-- /run print(UnitAttackSpeed("target"))
-- /run print(UnitHealth("target"))
-- /run print(UnitArmor("target"))
-- /run local l,h,ol,oh = UnitDamage("target"); print(string.format("%.2f - %.2f; %.2f - %.2f ",l, h, ol, oh))

function drsPrintUnitInfo(tgt)
  tgt = tgt or "target"
  if not UnitExists(tgt) then 
    print("No target")
    return
  end

  local name = UnitName(tgt)
  local dmgMainLow,dmgMainHigh,dmgOffLow,dmgOffHigh = UnitDamage(tgt)
  local speedMain, speedOff = UnitAttackSpeed(tgt)
  local atkPower = UnitAttackPower(tgt)
  local healthMax = UnitHealthMax(tgt)
  local armor = UnitArmor(tgt)
  local clss = UnitClass(tgt)

  -- expected dps agains mob with 35% armor reduction
  local dpsMain = (((dmgMainHigh + dmgMainLow)/2)  / speedMain) + (atkPower / 14)
  local dpsOff = 0
  if speedOff ~= nil then 
     dpsOff = (((dmgOffHigh + dmgOffLow)/2) / speedOff) + (atkPower / 14)
  end 
  dpsMain = dpsMain * .75   -- armor
  dpsOff = dpsOff * .75 * .50   -- armor and offhand
  
  

  print(string.format("--- %s", name))
  print(string.format("Damage   : %.2f - %.2f; %.2f - %.2f ", dmgMainLow, dmgMainHigh, dmgOffLow, dmgOffHigh))
  print(string.format("Atk.Speed: %.2f; %.2f",speedMain, speedOff or 0))
  print(string.format("Atk.Power: %.2f", atkPower))
  print(string.format("Health   : %.0f", healthMax))
  print(string.format("Armor    : %.0f", armor))
  print(string.format("Class    : %s", clss))
  print(string.format("DPS main : %.0f", dpsMain))
  print(string.format("DPS off  : %.0f", dpsOff))
  print(string.format("-------------------"))
end



function drsHasShield()
  local offhandItemLink = GetInventoryItemLink("player", 17)
  if not offhandItemLink then return false end

  local _, _, itemId = string.find(offhandItemLink, "item:(%d+):")
  local itemName, _, _, _, _, itemType, itemSubType = GetItemInfo(itemId)

  if itemType == "Shields" then return true else return false end
end

function drsEquip(gearName)
    CloseMerchant()
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
              if string.find(itemLink,gearName) then
                UseContainerItem(bag, slot)
                return bag, slot
              end
            end
        end
    end
    print("Gear not found in bags: " .. gearName)
end


-- depencencies Atlas addon
function drsMap()
  if IsInInstance() then
    Atlas_Toggle()
  else
    if WorldMapFrame:IsShown() then
      WorldMapFrame:Hide()
    else
        WorldMapFrame:Show()
    end
  end
end



