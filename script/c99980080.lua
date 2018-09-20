--HN Lastation
--Scripted by Raivost
function c99980080.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Inflict damage
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCondition(c99980080.damcon)
  e1:SetOperation(c99980080.damop)
  c:RegisterEffect(e1)
  --(2) To hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980080,0))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetCountLimit(1,99980080)
  e2:SetTarget(c99980080.thtg)
  e2:SetOperation(c99980080.thop)
  c:RegisterEffect(e2)
end
--(1) Inflict damage
function c99980080.damconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c99980080.damcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980080.damconfilter,1,nil,tp)
end
function c99980080.damfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c99980080.damop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99980080)
  local ct=Duel.GetMatchingGroupCount(c99980080.damfilter,tp,LOCATION_MZONE,0,nil)
  Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end
--(2) To hand
function c99980080.thfilter(c)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99980080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980080.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980080.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980080.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
   Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end