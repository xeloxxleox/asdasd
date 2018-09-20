--HN Next Purple
--Scripted by Raivost
function c99980340.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),5,2)
  c:EnableReviveLimit()
  --(1) Xyz Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_EXTRA)
  e1:SetCondition(c99980340.xyzcon)
  e1:SetOperation(c99980340.xyzop)
  e1:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e1)
  --(2) Gain ATK 1
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980340,1))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980340.atkcon1)
  e2:SetTarget(c99980340.atktg1)
  e2:SetOperation(c99980340.atkop1)
  c:RegisterEffect(e2)
  --(3) Gain ATK 2
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99980340.atkval2)
  c:RegisterEffect(e3)
  --(4) Cannot be targeted/destroyed
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e4:SetCondition(c99980340.indcon)
  e4:SetValue(aux.tgoval)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99980340.indcon)
  e5:SetValue(c99980340.indval)
  c:RegisterEffect(e5)
  --(5) Gain ATK 3
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99980340,1))
  e6:SetCategory(CATEGORY_ATKCHANGE)
  e6:SetType(EFFECT_TYPE_IGNITION)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCountLimit(1)
  e6:SetCost(c99980340.atkcost3)
  e6:SetTarget(c99980340.atktg3)
  e6:SetOperation(c99980340.atkop3)
  c:RegisterEffect(e6)
  --(6) To hand
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99980340,2))
  e7:SetCategory(CATEGORY_TOHAND)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e7:SetCode(EVENT_TO_GRAVE)
  e7:SetTarget(c99980340.thtg)
  e7:SetOperation(c99980340.thop)
  c:RegisterEffect(e7)
end
--(1) Xyz Summon
function c99980340.ovfilter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and Duel.GetLocationCountFromEx(tp,tp,c)>0 and c:IsType(TYPE_XYZ)
  and c:GetRank()==4 and Duel.IsExistingMatchingCard(c99980340.ovfilter2,tp,LOCATION_MZONE,0,1,c,tp)
end
function c99980340.ovfilter2(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function c99980340.xyzcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local mg=nil
  mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if Duel.GetLocationCountFromEx(tp)<=0 and mg:IsExists(c99980340.ovfilter1,1,nil,tp)  then
    return true
  end
  if Duel.GetLocationCountFromEx(tp)>0 and mg:IsExists(c99980340.ovfilter2,2,nil,tp) then
    return true
  end
end
function c99980340.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local mg=nil
  mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if Duel.GetLocationCountFromEx(tp)<=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    g=mg:FilterSelect(tp,c99980340.ovfilter1,1,1,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    g2=mg:FilterSelect(tp,c99980340.ovfilter2,1,1,g,tp)
    g:Merge(g2)
  elseif Duel.GetLocationCountFromEx(tp)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    g=mg:FilterSelect(tp,c99980340.ovfilter2,1,1,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    g2=mg:FilterSelect(tp,c99980340.ovfilter2,1,1,g,tp)
    g:Merge(g2)
  else return end
  if g then
    local sg2=Group.CreateGroup()
    for tc in aux.Next(g) do
      local sg1=tc:GetOverlayGroup()
      sg2:Merge(sg1)
    end
    Duel.Overlay(c,sg2)
    c:SetMaterial(g)
    Duel.Overlay(c,g)
    g:DeleteGroup()
  end
end
--(2) Gain ATK 1
function c99980340.atkcon1(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c99980340.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980340.atkop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFaceup() and c:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c:GetOverlayCount()*300)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
  end
end
--(3) Gain ATK 2
function c99980340.atkfilter2(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980340.atkval2(e,c)
  return c:GetOverlayGroup():FilterCount(c99980340.atkfilter2,nil)*300
end
--(4) Cannot be targeted/destroyed
function c99980340.indcon(e)
  return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,99980020)
end
function c99980340.indval(e,re,tp)
  return tp~=e:GetHandlerPlayer()
end
--(5) Gain ATK 3
function c99980340.atkcost3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980340.atkfilter3(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980340.atktg3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980340.atkfilter3,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980340.atkop3(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99980340.atkfilter3,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(g:GetCount()*500)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
--(6) To hand
function c99980340.thfilter0(c)
  return (c:IsCode(99980020) or c:IsCode(99980010)) and c:IsAbleToHand()
end
function c99980340.thfilter1(c)
  return c:IsCode(99980010) and c:IsAbleToHand()
end
function c99980340.thfilter2(c)
  return c:IsCode(99980020) and c:IsAbleToHand()
end
function c99980340.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980340.thfilter0,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99980340.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g1=Duel.SelectMatchingCard(tp,c99980340.thfilter0,tp,LOCATION_GRAVE,0,1,1,nil)
  if g1:GetCount()==0 then return end
  local tc=g1:GetFirst()
  if tc:IsCode(99980010) and Duel.IsExistingMatchingCard(c99980340.thfilter2,tp,LOCATION_GRAVE,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99980340,4)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,c99980340.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
    g1:Merge(g2)
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
  elseif tc:IsCode(99980020) and Duel.IsExistingMatchingCard(c99980340.thfilter1,tp,LOCATION_GRAVE,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99980340,3)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,c99980340.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
    g1:Merge(g2)
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
  else
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
  end
end