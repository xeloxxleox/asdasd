--SAO Game Master
--Scripted by Raivost
function c99990040.initial_effect(c)
  c:SetUniqueOnField(1,0,99990040)
  --(1) Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990040,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99990040.activatetg)
  c:RegisterEffect(e1)
  --(2) Negate 1
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990040,0))
  e2:SetCategory(CATEGORY_NEGATE)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_CHAINING)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(c99990040.negcon1)
  e2:SetCost(c99990040.negcost1)
  e2:SetTarget(c99990040.negtg1)
  e2:SetOperation(c99990040.negop1)
  c:RegisterEffect(e2)
  --(3) Negate 2
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990040,0))
  e3:SetCategory(CATEGORY_DISABLE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCondition(aux.exccon)
  e3:SetCost(aux.bfgcost)
  e3:SetTarget(c99990040.negtg2)
  e3:SetOperation(c99990040.negop2)
  c:RegisterEffect(e3)
end
--(1) Activate
function c99990040.activatetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
  if chk==0 then return true end
  if c99990040.accost(e,tp,eg,ep,ev,re,r,rp,0) and c99990040.actg(e,tp,eg,ep,ev,re,r,rp,0) then
    e:SetCategory(CATEGORY_NEGATE)
    e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    c99990040.accost(e,tp,eg,ep,ev,re,r,rp,1)
    c99990040.actg(e,tp,eg,ep,ev,re,r,rp,1)
    e:SetOperation(c99990040.acop)
  else
    e:SetCategory(0)
    e:SetProperty(0)
    e:SetOperation(nil)
  end
end
function c99990040.banfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c99990040.negconfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990040.accost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  e:SetLabel(0)
  if not Duel.IsExistingMatchingCard(c99990040.banfilter,tp,LOCATION_GRAVE,0,2,nil) or
  not Duel.IsExistingMatchingCard(c99990040.negconfilter1,tp,LOCATION_MZONE,0,1,nil) then return end
  local ct=Duel.GetCurrentChain()
  local re=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
  local rc=re:GetHandler()
  if ct==1 then return end
  if not Duel.IsChainNegatable(ct-1) or not (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return end
  if Duel.SelectYesNo(tp,94) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c99990040.banfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:SetLabel(1)
  end
end
function c99990040.actg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  if e:GetLabel()~=1 then return end
  local ct=Duel.GetCurrentChain()
  local re=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
  local rc=re:GetHandler()
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,rc,1,0,0)
end
function c99990040.acop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if e:GetLabel()~=1 then return end
  local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
  local re=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
  local rc=re:GetHandler()
  if Duel.NegateActivation(ct-1) and re:IsHasType(EFFECT_TYPE_ACTIVATE)  and rc:IsRelateToEffect(te) then
    Duel.SendtoGrave(rc,REASON_EFFECT)
  end
end
--(2) Negate 1
function c99990040.negcon1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) 
  and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c99990040.negconfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99990040.negcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990040.banfilter,tp,LOCATION_GRAVE,0,2,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990040.banfilter,tp,LOCATION_GRAVE,0,2,2,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99990040.negtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99990040.negop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
    Duel.SendtoGrave(eg,REASON_EFFECT)
  end
end
--(3) Negate 2
function c99990040.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990040.negop2(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    if tc:IsType(TYPE_TRAPMONSTER) then
      local e3=Effect.CreateEffect(e:GetHandler())
      e3:SetType(EFFECT_TYPE_SINGLE)
      e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
      e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e3)
    end
  end
end