--[[
MACROS
- humanForm: /run drsForm(0)
- bearForm: /run drsForm(1)
- catForm: /run drsForm(2)
- bearRejuv: /run drsFormRejuv(1)

]]


local drsDruidForms = {"Bear Form()", "Aquatic Form()", "Cat Form()", "Travel Form()", "Moonkin Form()" }

function drsFormActive()
  for f=1,5 do
    local t,n,isActive,c = GetShapeshiftFormInfo(f)
    if isActive then 
        return f 
    end
  end
  return 0
end


-- change to desired form (spammable, does not exit form acciedentally)
function drsForm(f)
  local formActive = drsFormActive()

  if f ~= formActive then
    if formActive ~= 0 then 
      -- exit old form
      CastSpellByName(drsDruidForms[formActive]) 
    else
      -- enter new form
      CastSpellByName(drsDruidForms[f]) 
    end
  end
end





-- exit form, rejuvenation, enter form
local drsTimeLastRejuv = time() - 3600
function drsFormRejuv(f)
  local dT = time() - drsTimeLastRejuv
  if dT > 10 then 
    if drsFormActive() == 0 then
      CastSpellByName("Rejuvenation()",1)
      drsTimeLastRejuv = time()
    else
      drsForm(0)
    end
  else
    drsForm(f)
  end
end