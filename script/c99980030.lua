--HN Planeptune
--Scripted by Raivost
function c99980030.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99980030.atkcon)
  e1:SetOperation(c99980030.atkop)
  c:RegisterEffect(e1)
  --(2) To hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980030,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetCountLimit(1,99980030)
  e2:SetTarget(c99980030.thtg)
  e2:SetOperation(c99980030.thop)
  c:RegisterEffect(e2)
end
--(1) Gain ATK
function c99980030.atkconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c99980030.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) 
end
function c99980030.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980030.atkconfilter,1,nil,tp)
end
function c99980030.atkop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99980030)
  local g=Duel.GetMatchingGroup(c99980030.atkfilter,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(200)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
  end
end
--(2) To hand
function c99980030.thfilter(c)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99980030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980030.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980030.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980030.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
   Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end