--HN Next White
--Scripted by Raivost
function c99980460.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),5,2)
  c:EnableReviveLimit()
  --(1) Xyz Summon
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_EXTRA)
  e1:SetCondition(c99980460.xyzcon)
  e1:SetOperation(c99980460.xyzop)
  e1:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980460,1))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980460.descon)
  e2:SetTarget(c99980460.destg)
  e2:SetOperation(c99980460.desop)
  c:RegisterEffect(e2)
  --(3) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99980460.atkval)
  c:RegisterEffect(e3)
  --(4) Cannot be targeted/destroyed
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e4:SetCondition(c99980460.indcon)
  e4:SetValue(aux.tgoval)
  c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99980460.indcon)
  e5:SetValue(c99980460.indval)
  c:RegisterEffect(e5)
  --(5) Change to Def position
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99980460,2))
  e6:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
  e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e6:SetType(EFFECT_TYPE_IGNITION)
  e6:SetRange(LOCATION_MZONE)
  e6:SetCountLimit(1)
  e6:SetCost(c99980460.poscost)
  e6:SetTarget(c99980460.postg)
  e6:SetOperation(c99980460.posop)
  c:RegisterEffect(e6)
  --(6) To hand
  local e7=Effect.CreateEffect(c)
  e7:SetDescription(aux.Stringid(99980460,3))
  e7:SetCategory(CATEGORY_TOHAND)
  e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e7:SetCode(EVENT_TO_GRAVE)
  e7:SetTarget(c99980460.thtg)
  e7:SetOperation(c99980460.thop)
  c:RegisterEffect(e7)
end
--(1) Xyz Summon
function c99980460.ovfilter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and Duel.GetLocationCountFromEx(tp,tp,c)>0 and c:IsType(TYPE_XYZ)
  and c:GetRank()==4 and Duel.IsExistingMatchingCard(c99980460.ovfilter2,tp,LOCATION_MZONE,0,1,c,tp)
end
function c99980460.ovfilter2(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function c99980460.xyzcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local mg=nil
  mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if Duel.GetLocationCountFromEx(tp)<=0 and mg:IsExists(c99980460.ovfilter1,1,nil,tp)  then
    return true
  end
  if Duel.GetLocationCountFromEx(tp)>0 and mg:IsExists(c99980460.ovfilter2,2,nil,tp) then
    return true
  end
end
function c99980460.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local mg=nil
  mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  if Duel.GetLocationCountFromEx(tp)<=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    g=mg:FilterSelect(tp,c99980460.ovfilter1,1,1,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    g2=mg:FilterSelect(tp,c99980460.ovfilter2,1,1,g,tp)
    g:Merge(g2)
  elseif Duel.GetLocationCountFromEx(tp)>0 then
    g=mg:FilterSelect(tp,c99980460.ovfilter2,1,1,nil,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    g2=mg:FilterSelect(tp,c99980460.ovfilter2,1,1,g,tp)
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
--(2) Destroy
function c99980460.descon(e,tp,eg,ep,ev,re,r,rp)
  return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c99980460.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99980460.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local g=Duel.GetMatchingGroup(c99980460.desfilter,tp,0,LOCATION_ONFIELD,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99980460.desop(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetHandler():GetOverlayCount()
  local g=Duel.GetMatchingGroup(c99980460.desfilter,tp,0,LOCATION_ONFIELD,nil)
  if ct>0 and g:GetCount()>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=g:Select(tp,1,ct,nil)
    Duel.HintSelection(dg)
    Duel.Destroy(dg,REASON_EFFECT)
  end
end
--(3) Gain ATK
function c99980460.atkfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980460.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(c99980460.atkfilter,nil)*300
end
--(4) Cannot be targeted/destroyed
function c99980460.indcon(e)
  return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,99980120)
end
function c99980460.indval(e,re,tp)
  return tp~=e:GetHandlerPlayer()
end
--(5) Change to Def position
function c99980460.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980460.posfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980460.postg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(c99980460.posfilter,tp,LOCATION_MZONE,0,nil)
  if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) and ct>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,ct,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c99980460.posop(e,tp,eg,ep,ev,re,r,rp)
 local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  if Duel.ChangePosition(g,POS_FACEUP_DEFENSE)~=0 then
  local atk=0
  for tc in aux.Next(g) do
    if tc:IsPosition(POS_FACEUP_DEFENSE) then
      atk=atk+(tc:GetTextDefense()/2)
    end
  end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  e:GetHandler():RegisterEffect(e1)
  end
end
--(6) To hand
function c99980460.thfilter0(c)
  return (c:IsCode(99980120) or c:IsCode(99980110)) and c:IsAbleToHand()
end
function c99980460.thfilter1(c)
  return c:IsCode(99980110) and c:IsAbleToHand()
end
function c99980460.thfilter2(c)
  return c:IsCode(99980120)  and c:IsAbleToHand()
end
function c99980460.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980460.thfilter0,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99980460.thop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g1=Duel.SelectMatchingCard(tp,c99980460.thfilter0,tp,LOCATION_GRAVE,0,1,1,nil)
  if g1:GetCount()==0 then return end
  local tc=g1:GetFirst()
  if tc:IsCode(99980110) and Duel.IsExistingMatchingCard(c99980460.thfilter2,tp,LOCATION_GRAVE,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99980460,5)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,c99980460.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
    g1:Merge(g2)
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
  elseif tc:IsCode(99980120) and Duel.IsExistingMatchingCard(c99980460.thfilter1,tp,LOCATION_GRAVE,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99980460,4)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,c99980460.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
    g1:Merge(g2)
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
  else
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
  end
end