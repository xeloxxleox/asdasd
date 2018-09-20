--SAO Swordland
--Scripted by Raivost
function c99990340.initial_effect(c)
  c:SetUniqueOnField(1,0,99990340)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Search
  local e1=Effect.CreateEffect(c) 
  e1:SetDescription(aux.Stringid(99990340,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetCountLimit(1)
  e1:SetRange(LOCATION_SZONE)
  e1:SetTarget(c99990340.thtg1)
  e1:SetOperation(c99990340.thop1)
  c:RegisterEffect(e1)
  --(2) Shuffle 
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990340,1))
  e2:SetCategory(CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_PHASE+PHASE_END)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetCondition(c99990340.tdcon2)
  e2:SetTarget(c99990340.tdtg2)
  e2:SetOperation(c99990340.tdop2)
  c:RegisterEffect(e2)
end
--(1) Search
function c99990340.thfilter1(c)
  return c:IsSetCard(0x999) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c99990340.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990340.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99990340.thop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99990340.thfilter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Shuffle
function c99990340.tdcon2(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99990340.tdfilter2(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c99990340.tdfilter3(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990340.counterfilter(c)
  return c:GetCounter(0x999)~=0
end
function c99990340.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99990340.tdfilter2,tp,LOCATION_REMOVED,0,1,nil) 
  and Duel.IsExistingTarget(c99990340.tdfilter3,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsCanRemoveCounter(tp,1,0,0x999,1,REASON_EFFECT) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  local g1=Duel.GetMatchingGroup(c99990340.counterfilter,tp,LOCATION_ONFIELD,0,nil)
  local ct1=0
  for tc in aux.Next(g1) do
    ct1=ct1+tc:GetCounter(0x999)
  end
  local ct2=Duel.GetMatchingGroupCount(c99990340.tdfilter3,tp,LOCATION_MZONE,0,nil)
  if ct2>ct1 then ct2=ct1 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=Duel.SelectTarget(tp,c99990340.tdfilter2,tp,LOCATION_REMOVED,0,1,ct2,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,g2:GetCount(),0,0)
end
function c99990340.tdop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  local sg=g:Filter(Card.IsRelateToEffect,nil,e)
  if not Duel.IsCanRemoveCounter(tp,1,0,0x999,sg:GetCount(),REASON_EFFECT) then return end
  if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then
    local og=Duel.GetOperatedGroup()
    if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    Duel.RemoveCounter(tp,1,0,0x999,sg:GetCount(),REASON_EFFECT)
    Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+99990030,e,0,tp,0,0)
  end
end