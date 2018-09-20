--HN Golden Faith Black Heart
--Scripted by Raivost
function c99980520.initial_effect(c)
  c:EnableReviveLimit()
  --Xyz Summon
  aux.AddXyzProcedure(c,c99980520.xyzfilter,nil,99,c99980520.ovfilter,aux.Stringid(99980520,1),nil,nil,false,c99980520.xyzcheck)
  aux.EnablePendulumAttribute(c,false)
  --Pendulum Effects
  --(1) Negate 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980520,0))
  e1:SetCategory(CATEGORY_DISABLE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCondition(c99980520.negcon1)
  e1:SetTarget(c99980520.negtg1)
  e1:SetOperation(c99980520.negop1)
  c:RegisterEffect(e1)
  --(2) Pendulum set
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980520,1))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99980520.psettg)
  e2:SetOperation(c99980520.psetop)
  c:RegisterEffect(e2)
  --Monster Effects
  --(1) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99980520.atkval1)
  c:RegisterEffect(e3)
  --(2) Piercing
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_PIERCE)
  c:RegisterEffect(e4)
  --(3) Lose ATK
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99980520,2))
  e5:SetCategory(CATEGORY_ATKCHANGE)
  e5:SetType(EFFECT_TYPE_IGNITION)
  e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCountLimit(1,99980520)
  e5:SetCost(c99980520.atkcost2)
  e5:SetTarget(c99980520.atktg2)
  e5:SetOperation(c99980520.atkop2)
  c:RegisterEffect(e5)
  --(4) Negate 2
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99980520,0))
  e6:SetCategory(CATEGORY_DISABLE)
  e6:SetProperty(EFFECT_FLAG2_XMDETACH)
  e6:SetType(EFFECT_TYPE_IGNITION)
  e6:SetCountLimit(1,99980521)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCost(c99980520.negcost2)
  e6:SetTarget(c99980520.negtg2)
  e6:SetOperation(c99980520.negop2)
  c:RegisterEffect(e6)
  --(5) Place in PZone
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99980520,1))
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e7:SetCode(EVENT_DESTROYED)
  e7:SetProperty(EFFECT_FLAG_DELAY)
  e7:SetCondition(c99980520.pzcon)
  e7:SetTarget(c99980520.pztg)
  e7:SetOperation(c99980520.pzop)
  c:RegisterEffect(e7)
end
--Pendulum Effects
--(1) Negate 1
function c99980520.negconfilter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99980520.negcon1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980520.negconfilter1,1,nil,tp)
end
function c99980520.negtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c99980520.negop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
    Duel.NegateRelatedChain(tc,RESET_TURN_SET)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetValue(RESET_TURN_SET)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    if tc:IsType(TYPE_TRAPMONSTER) then
      local e3=Effect.CreateEffect(e:GetHandler())
      e3:SetType(EFFECT_TYPE_SINGLE)
      e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
      e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e3)
    end
  end
end
--(2) Pendulum set
function c99980520.psetfilter(c)
  return (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and c:IsSetCard(0x998) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c99980520.psettg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
  and Duel.IsExistingMatchingCard(c99980520.psetfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980520.psetop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectMatchingCard(tp,c99980520.psetfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end
--Monster Effects
c99980520.pendulum_level=5
--Xyz Summon
function c99980520.xyzfilter(c,xyz,sumtype,tp)
  return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and not c:IsSetCard(0x998)
end
function c99980520.xyzcheck(g,tp,xyz)
  local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
  return mg:GetClassCount(Card.GetRank)==1
end
function c99980520.ovfilter(c)
  return c:IsFaceup() and c:IsCode(99980070) and c:IsType(TYPE_XYZ)
end
--(1) Gain ATK
function c99980520.atkfilter1(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980520.atkval1(e,c)
  return c:GetOverlayGroup():FilterCount(c99980520.atkfilter1,nil)*300
end
--(3) Lose ATK
function c99980520.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980520.atkfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980520.atktg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local ct=Duel.GetMatchingGroupCount(c99980520.atkfilter2,tp,LOCATION_MZONE,0,nil)
  Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,ct,nil)
end
function c99980520.atkop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  local tc=g:GetFirst()
  local atk1=0
  while tc and tc:IsFaceup() and not tc:IsImmuneToEffect(e) do
    local atk2=tc:GetAttack()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    e1:SetValue(math.ceil(atk2/2))
    tc:RegisterEffect(e1)
    atk1=atk1+math.ceil(atk2/2)
    tc=g:GetNext()
  end
  if c:IsRelateToEffect(e) and c:IsFaceup() then
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    e2:SetValue(atk1)
    c:RegisterEffect(e2)
  end
end
--(4) Negate 2
function c99980520.negcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980520.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980520.negop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
  end
end
--(5) Place in PZone
function c99980520.pzcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c99980520.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980520.pzop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end