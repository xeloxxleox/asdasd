--HN Transcending Shares
--Scripted by Raivost
function c99980370.initial_effect(c)
  --(1) Activate effects
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980370+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980370.aetg)
  e1:SetOperation(c99980370.aeop)
  c:RegisterEffect(e1)
end
--(1) Activate effects
function c99980370.tdfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980370.tdfilter2(c)
  return c:IsSetCard(0x998) and c:IsAbleToDeck()
end
function c99980370.drfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ)
end
function c99980370.aetg(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsExistingMatchingCard(c99980370.tdfilter1,tp,LOCATION_MZONE,0,1,nil) 
  and Duel.IsExistingMatchingCard(c99980370.tdfilter2,tp,LOCATION_GRAVE,0,1,nil) 
  local ct=Duel.GetMatchingGroupCount(c99980370.drfilter,tp,LOCATION_GRAVE,0,nil)
  local b2=Duel.IsPlayerCanDraw(tp,1) and ct>0
  if chk==0 then return b1 or b2 end
  local op=0
  if b1 and b2 then
    op=Duel.SelectOption(tp,aux.Stringid(99980370,0),aux.Stringid(99980370,1))
  elseif b1 then
    op=Duel.SelectOption(tp,aux.Stringid(99980370,0))
  else
    op=Duel.SelectOption(tp,aux.Stringid(99980370,1))+1
  end
  e:SetLabel(op)
  if op==0 then
    e:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
    local ct=Duel.GetMatchingGroupCount(c99980370.tdfilter1,tp,LOCATION_MZONE,0,nil)
    local g=Duel.SelectTarget(tp,c99980370.tdfilter2,tp,LOCATION_GRAVE,0,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
  else
    e:SetCategory(CATEGORY_DRAW)
    local ct=Duel.GetMatchingGroupCount(c99980370.drfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
  end
end
function c99980370.aeop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local op=e:GetLabel()
  if op==0 then
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<=0 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local og=Duel.GetOperatedGroup()
    if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
    if ct>0 then
      Duel.Recover(tp,500*ct,REASON_EFFECT)
    end
  else
    local ct=Duel.GetMatchingGroupCount(c99980370.drfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.Draw(tp,ct,REASON_EFFECT)
  end
end