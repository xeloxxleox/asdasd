--SAO Edge of The World
--Scripted by Raivost
function c99990360.initial_effect(c)
  --(1) Discard
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990360,0))
  e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990360+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99990360.distg)
  e1:SetOperation(c99990360.disop)
  c:RegisterEffect(e1)
  --(2) Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990360,1))
  e2:SetCategory(CATEGORY_TODECK)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99990360.tdtg)
  e2:SetOperation(c99990360.tdop)
  c:RegisterEffect(e2)
end
--(1) Discard
function c99990360.thfilter(c)
  return c:IsSetCard(0x999) and c:IsAbleToHand()
end
function c99990360.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local hd=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    if e:GetHandler():IsLocation(LOCATION_HAND) then hd=hd-1 end
    return hd>0 and Duel.IsExistingMatchingCard(c99990360.thfilter,tp,LOCATION_DECK,0,hd,nil)
  end
  local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
  local tg=Duel.GetMatchingGroup(c99990360.thfilter,tp,LOCATION_DECK,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,sg:GetCount(),0,0)
end
function c99990360.disop(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
  Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
  local ct=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
  local tg=Duel.GetMatchingGroup(c99990360.thfilter,tp,LOCATION_DECK,0,nil)
  if ct>0 and tg:GetCount()>=ct then
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sel=tg:Select(tp,ct,ct,nil)
    Duel.SendtoHand(sel,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sel)
  end
end
--(2) Shuffle
function c99990360.tdfilter1(c)
  return c:IsSetCard(0x999) and c:IsAbleToDeck()
end
function c99990360.tdfilter2(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990360.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990360.tdfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) 
  and Duel.IsExistingMatchingCard(c99990360.tdfilter2,tp,LOCATION_MZONE,0,1,nil) end
  local ct=Duel.GetMatchingGroupCount(c99990360.tdfilter2,tp,LOCATION_MZONE,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99990360.tdfilter1,tp,LOCATION_GRAVE,0,1,ct,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function c99990360.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
  Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
  local g=Duel.GetOperatedGroup()
  if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then 
    Duel.ShuffleDeck(tp) 
  end
end