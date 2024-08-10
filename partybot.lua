
-- partybot command helper
local function pb(...)
  for i, v in ipairs(arg) do
    SendChatMessage(".partybot " .. v)
  end
end


-- PARTY

-- Create/refresh party when dead
-- in 2 phases to prevent instance reset
-- order is basically random though, wow is a mess
function drsPartybotAdd(opt)
  
  if opt == 1 then
    if UnitName("party1") then UninviteByName(UnitName("party1")) end
    --pb("add paladin healer")
    pb("add druid healer")
    if UnitName("party2") then UninviteByName(UnitName("party2")) end
    --pb("add druid tank")
    pb("add mage rangedps")
    if UnitName("party3") then UninviteByName(UnitName("party3")) end
    pb("add mage rangedps")
    
  elseif opt == 2 then
    SetLootMethod("freeforall")
    if UnitName("party4") then UninviteByName(UnitName("party4")) end
    pb("add mage rangedps")

    -- if UnitName("party1") and UnitIsDead("party1") then 
    --   UninviteByName(UnitName("party1")) 
    -- elseif UnitName("party4") then 
    --   UninviteByName(UnitName("party4")) 
    -- end

    -- pb("add rogue meleedps")
    -- pb("add rogue meleedps")
  end
end



-- RAID

-- first: stay all but tank, second:stay all
-- resets with drsPArtybotCome
local ciclestay = 0
function drsPartybotCiclestay()
  if ciclestay == 0 then
    pb("stayall","movetank")
    ciclestay = 1
  elseif ciclestay == 1 then
    pb("stayall")
    ciclestay = 2
  end
end


function drsPartybotPull()
  pb("movetank","pull")
end


function drsPartybotCome()
  ClearTarget()
  pb("focusmark skull", "ccmark moon","ccmark cross")
  pb("unpause all","moveall","cometome")
  -- stoattack ??
  ciclestay = 0
  --ciclepull = 0
end

-- quiza ya no necesario
-- used in party, similar to 2 clicks in drsCiclestay (+pause)
function drsPartybotPause()
  ClearTarget()
  pb("focusmark skull", "ccmark moon","ccmark cross")
  pb("pause all")
  pb("focusmark skull", "ccmark moon","ccmark cross")
end


-- Everybody free to go
function drsPartybotUnpause()
  pb("unpause all","moveall")
  if UnitIsEnemy("player", "target") then
    pb("attackstart")  
  end
end


function drsPartybotAOE()
  --ClearTarget()
  if not UnitName("target") then TargetNearestEnemy() end
  pb("aoe")
end






-- RAID
-- crear raid 40, empezando solo sin party
-- asociar a macro y pulsar 6 veces, despacio
-- importat each group have a tank and healer to protect, heal, dispell its members, other heals wont dispell bots in othere groups
local raidst = 0
function drsRaid()
  if not (UnitName("party1") or UnitName("raid1")) then
    raidst = 0
  end

  if raidst == 0 then 
    pb("add rogue meleedps")
    raidst = 1
  elseif raidst == 1 then
    ConvertToRaid()
    ToggleFriendsFrame(4)
    SetLootMethod("freeforall")
    -- local party1name = UnitName("party1")
    -- print("raid:" .. party1name)
    raidst = 2
  elseif raidst == 2 then
    
  
    -- grp 1, me and:
    pb("add paladin healer")
    pb("add druid healer")
    pb("add warrior tank")

    raidst = 3

  elseif raidst == 3 then
    -- remove dummy party unit, not as gearead as raid one's 
    UninviteByName(UnitName("raid1"))
    raidst = 4
  elseif raidst == 4 then
    
    -- grp1 last
    --pb("add warrior meleedps")
    pb("add mage rangedps")
    
    -- grp2
    pb("add paladin healer")
    pb("add druid healer")
    pb("add warrior tank")
    pb("add warrior meleedps")
    --pb("add warrior meleedps")
    pb("add mage rangedps")
    
    -- grp rest 1
    pb("add paladin healer")
    pb("add warrior tank")
    pb("add warrior meleedps")
    pb("add warrior meleedps")
    --pb("add warrior meleedps")
    pb("add mage rangedps")
    
    pb("add paladin healer")
    pb("add warrior tank")
    pb("add warrior meleedps")
    pb("add warrior meleedps")
    --pb("add warrior meleedps")
    pb("add mage rangedps")
    
    raidst = 5

  elseif raidst == 5 then

    -- grp rest (another step to avoid  "say" antispam)
    pb("add paladin healer")
    pb("add warrior tank")
    pb("add warrior meleedps")
    pb("add warrior meleedps")
    --pb("add warrior meleedps")
    pb("add mage rangedps")

    pb("add paladin healer")
    pb("add warrior tank")
    pb("add warrior meleedps")
    pb("add warrior meleedps")
    --pb("add warrior meleedps")
    pb("add mage rangedps")

    pb("add paladin healer")
    pb("add warrior tank")
    pb("add warrior meleedps")
    pb("add warrior meleedps")
    --pb("add warrior meleedps")
    pb("add mage rangedps")

    pb("add paladin healer")
    pb("add warrior tank")
    pb("add warrior meleedps")
    pb("add warrior meleedps")
    --pb("add warrior meleedps")
    pb("add mage rangedps")

    raidst = 6
  end
end


-- RAID: elimina a los muertos
-- necesario en BWL pj, que si no a veces te echa si leaves party
-- en molten core sin embargo solo leave raid y luego usuo drsRaid() para recrearlo
-- OJO: raid de 40 no hay problema en salirte de raid, pero en mazmora normal con raid 10, si te sales (o te desconectas) se resetea la dng
function drsRaidClean()
  for i = 2, 40 do
    local raidid = "raid" .. tostring(i)
    if UnitName(raidid) and (UnitIsDead(raidid) or UnitIsGhost(raidid)) then UninviteByName(UnitName(raidid)) end
  end
end


-- to quickly remove bot from party when it becomes a bomb, eg Velastraz in BWL
function drsRaidKickSkull()
  for i = 1, 40 do
    local raidid = "raid" .. tostring(i)
    if GetRaidTargetIndex(raidid) == 8 then
      local uName = UnitName(raidid)
      if uName ~= UnitName("player") then
        UninviteByName(uName)
      end
    end
  end
end










-- -------------------------------- ESTO YA NO







-- no necesario, creia que los healers estaban pause cuando se hace "pull", pero no los healer están unpause ya cuando haces pull,
-- pulls in firsrt call, then unpauses each npc each time
-- local ciclepull = 0
-- function drsPartybotCiclepull(...)
--   if ciclepull == 0 then
--     -- normal pull
--     pb("movetank","pull")
--     print("--tanks pulling")
--   end
  
--   if ciclepull > 0 and UnitName("target") and not UnitIsEnemy("player","target") then
--     pb("unpause","move")  -- unpauses previously target
--     print("--unpausing" .. UnitName("target"))
--   end

--   for i, v in ipairs(arg) do
--     if i == ciclepull+1 then 
--       TargetByName(v)
--       ciclepull = ciclepull +1
--       return
--     end
--   end
-- end




-- esto ya no
-- local pbState = 1
-- --pb("focusmark skull", "ccmark cross")
-- function drsPartybot(mele, st)
--   if st ~= nil then pbState = st end
  
--   -- reset come to me
--   if pbState == 1 then 
--     ClearTarget()
--     pb("unpause all","moveall","cometome")
--     --SetRaidTarget("party4",4) -- green triangle on healer
--   end

--   -- wait
--   if pbState == 2 then 
--     -- pb("stayall") 
--     if not mele then 
--       pb("pause all")
--       pb("focusmark skull", "ccmark moon","ccmark cross")
--       SetLootMethod("freeforall")
--       pbState = 4 
--     end
--   end

--   -- mele ?
--   if pbState == 3 then pb("movetank","movemelee") end
--   if pbState == 4 then pb("pause all") end

--   -- go!
--   if pbState == 5 then 
--     pb("unpause all","attackstart") 
--     --pb("stayheal") 
--   end
--   -- if pbState == 6 then pb("stayall","movetank","come tank","movemelee", "come melee") end  --during fight to separate healer and range from me


--   if pbState < 5 then pbState = pbState+1 end

-- end





-- esto no funciona porque TargetUnit es async
-- pause/unpause mages only 
-- local drsPartybotMages_paused = false
-- function drsPartybotMages()
--   local partytype = "party"
--   local partymax = 4
--   if UnitInRaid("player") then
--     partytype = "raid"
--     partymax = 40
--   end

--   print("**** mages")
--   print(drsPartybotMages_paused and "paused" or "unpaused")
--   for i = 1, partymax do
--     local unitid = partytype .. tostring(i)
--     if UnitClass(unitid) == "Mage" then
--       TargetUnit(unitid)
--       if drsPartybotMages_paused then 
--         print("--unpausing " .. UnitName(unitid))
--         pb("unpause") 
--       else 
--         pb("pause") 
--         print("--pausing " .. UnitName(unitid))
--       end
--     end
--   end
  
--   drsPartybotMages_paused = not drsPartybotMages_paused
-- end




-- function drsPartybotUnpause()  -- dangerous, selected or not, bad in dangerous situation
--   if not UnitName("target")  then
--     pb("unpause all","moveall")
--   elseif UnitIsEnemy("player", "target") then
--     pb("unpause all","moveall","attackstart")  
--   else
--     pb("unpause","move")
--   end
-- end

