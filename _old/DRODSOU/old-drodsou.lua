------------------------- UTIL
function DrsTrim (str)
  if str == nil then return nil end
  str = string.gsub(str , "^%s*", "")
  str = string.gsub(str , "*%s$", "")
  return str
end

function DrsSplit(str)
  local div = ","

    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr, DrsTrim(string.sub(str,pos,st-1)) )
        pos = sp + 1
    end
    table.insert(arr, DrsTrim(string.sub(str,pos)))
    return arr
end

function DrsTableContains(table, targetValue)
  for _, value in pairs(table) do
    if value == targetValue then
      return true
    end
  end
  return false
end

function DrsAssert(condition) 
  if condition then
    print "yep"
  else
    print "nop"
  end
end



-------------------------- 

function DrsCurrentDruidForm()
  local i, _, name, active
  local form = 0
  for i=1, GetNumShapeshiftForms() do 
    _, name, active = GetShapeshiftFormInfo(i) 
    if( active ~= nil ) then 
      form = i
      break
    end
  end
  return form
end

function DrsDefaultTarget()
  if UnitName("target") then
    return "target"
  end
  return "player"
end

  


-- worldToo =  nil/false:only mouseover plates;  true:also mouseover 3d characters
function DrsMouseTarget(worldToo)

  if UnitIsPlayer("target") and UnitIsFriend("target","player") then
    return "target"
  end

  local target = "player"
  
  local mousefocus = GetMouseFocus()
  if (worldToo and UnitIsPlayer("mouseover") and UnitIsFriend("mouseover","player")) then 
    target = "mouseover"
  else
    framename = mousefocus:GetName()
    if (framename ~= nill and strsub(framename,1,16) == "PartyMemberFrame") then
      target = "party" .. strsub(framename,17)
    end
  end
  
  return target
 
end

-- Use /run UnitBuff("player",1) to get the buff texture


function DrsGetBuffs(target, doPrint)
  if target == nil then target = "player" end  -- not DefaultTarget

  local buffs={}
  local n = 1
  local buffN

  while true do 
    buffN = UnitBuff(target,n)
    if buffN == nil then break end
    buffs[n] = DrsSplit( string.gsub(buffN,[[\]],",") )[3]
    --buffs[n] = buffN
    if doPrint then print("buff: [" .. buffs[n] .. "]") end
    n = n+1
  end

  return buffs
end

function DrsIsBuffActive(texture, target)
  local buffs = DrsGetBuffs(target)
  if DrsTableContains( buffs, texture ) then
    return true
  end
  return false
end


function DrsCast(spell, target)
  --if condition == false then return end
  if target == nil then target = DrsDefaultTarget() end

  TargetUnit(target);
  CastSpellByName(spell);
  if target ~= "target" then 
    TargetLastTarget() 
  end
end

function DrsCastMouse(spell, worldToo)
  DrsCast(spell, DrsMouseTarget(worldToo))
end

---------------------------- CONSOLE

-- mmm, beter run functions directly, for conditionals, etc
--[[
function DrsConsoleCommand(cmdStr)
  local cmd = DrsSplit(cmdStr)
  if DrsTrim(cmd[1]) == "cast" then
    DrsCast(cmd[2], cmd[3], cmd[4])
  else
    message("drodsou: unknown command " .. cmd[1])
  end
end

function DrsOnLoad()
	SLASH_DRODSOU1 = "/drs"
  --SLASH_DRODSOU2 = "/drscast"
  SlashCmdList["DRODSOU"] = DrsConsoleCommand
end

DrsOnLoad()
]]





-- legacy
--[[
function SmartCastFriend(spell)
  
  local haveTarget = UnitExists("target")
  local target = "player"
 
  local f = GetMouseFocus()

  if (UnitIsVisible("target") and UnitReaction("target", "player") >= 5) then
    target = "target"
  elseif (UnitIsVisible(f.unit) and UnitReaction(f.unit, "player") >= 5) then
   target = f.unit
  elseif (UnitIsVisible("mouseover") and UnitReaction("mouseover", "player") >= 5) then
    target = "mouseover"
  end
 
  if (UnitIsUnit(target, "target")) then

   CastSpellByName(spell)
  else
    TargetUnit(target)
    CastSpellByName(spell)
    if (haveTarget) then
      TargetLastTarget()     
    else
      ClearTarget()
    end
  end
end
]]