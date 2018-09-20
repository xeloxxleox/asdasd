--HN Orange Heart
--Scripted by Raivost
function c99980430.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --(1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(c99980430.atkval)
  c:RegisterEffect(e1)
  --(2) Attach
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980430,0))
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c99980430.attachcost)
  e2:SetTarget(c99980430.attachtg)
  e2:SetOperation(c99980430.attachop)
  c:RegisterEffect(e2)
  --(3) To hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980430,1))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_TO_GRAVE)
  e3:SetTarget(c99980430.thtg)
  e3:SetOperation(c99980430.thop)
  c:RegisterEffect(e3)
end
--(1) Gain ATK
function c99980430.atkfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980430.atkval(e,c)
  return c:GetOverlayGroup():FilterCount(c99980430.atkfilter,nil)*300
end
--(2) Attach
function c99980430.attachcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980430.attachfilter1(c,e,tp)
  local rk=c:GetRank()
  return rk>1 and c:IsType(TYPE_XYZ) and c:IsSetCard(0x998)
  and Duel.IsExistingMatchingCard(c99980430.attachfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,rk,e,tp)
end
function c99980430.attachfilter2(c,rk,e,tp)
  return c:IsType(TYPE_XYZ) and c:IsSetCard(0x998) and c:IsRankBelow(rk-1)
end
function c99980430.attachtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(c99980430.attachfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99980430.attachfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c99980430.attachop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c99980430.attachfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,tc:GetRank(),e,tp)
    if g:GetCount()>0 then
      local mg=g:GetFirst():GetOverlayGroup()
      if mg:GetCount()>0 then
        Duel.SendtoGrave(mg,REASON_RULE)
      end
      Duel.Overlay(tc,g)
    end
  end
end
--(3) To hand
function c99980430.thfilter(c)
  return c:IsCode(99980420) and c:IsAbleToHand()
end
function c99980430.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980430.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99980430.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980430.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end