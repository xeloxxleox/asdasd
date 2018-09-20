--HN White Sister
--Scripted by Raivost
function c99980150.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),3,2)
  c:EnableReviveLimit()
  --(1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(c99980150.atkval)
  c:RegisterEffect(e1)
  --(2) Attach
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980150,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99980150.attachtg)
  e2:SetOperation(c99980150.attachop)
  c:RegisterEffect(e2)
  --(3) To hand 1
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980150,1))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1)
  e3:SetCondition(c99980150.thcon1)
  e3:SetCost(c99980150.thcost1)
  e3:SetTarget(c99980150.thtg1)
  e3:SetOperation(c99980150.thop1)
  c:RegisterEffect(e3)
  --(4) To hand 2
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980150,2))
  e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetTarget(c99980150.thtg2)
  e4:SetOperation(c99980150.thop2)
  c:RegisterEffect(e4)
end
--(1) Gain ATK
function c99980150.atkfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980150.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(c99980150.atkfilter,nil)*300
end
--(1) Attach
function c99980150.attachfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980150.attachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  if chk==0 then return Duel.IsExistingTarget(c99980150.attachfilter,tp,LOCATION_MZONE,0,1,c) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99980150.attachfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c99980150.attachop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    local mg=c:GetOverlayGroup()
    if mg:GetCount()~=0 then
      Duel.Overlay(tc,mg)
    end
    Duel.Overlay(tc,Group.FromCards(c))
  end
end
--(3) To hand 1
function c99980150.thcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSetCard(0x998)
end
function c99980150.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980150.thfilter1(c)
  return c:IsSetCard(0x998) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToHand()
end
function c99980150.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980150.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99980150.thop1(e,tp,eg,ep,ev,re,r,rp,chk)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980150.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if tg:GetCount()>0 then
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tg)
  end
end
--(3) To hand 2
function c99980150.thfilter2(c)
  return c:IsCode(99980140) and c:IsAbleToHand()
end
function c99980150.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980150.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99980150.thop2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980150.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end