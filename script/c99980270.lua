--HN A CPU Valentine
--Scripted by Raivost
function c99980270.initial_effect(c)
  --(1) Normal Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980270,0))
  e1:SetCategory(CATEGORY_SUMMON+CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980270+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980270.nstg)
  e1:SetOperation(c99980270.nsop)
  c:RegisterEffect(e1)
end
--(1) Normal Summon
function c99980270.nsfilter(c)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsSummonable(true,nil)
end
function c99980270.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980270.nsfilter,tp,LOCATION_DECK,0,1,nil) end
  local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,99980270)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000-(300*ct))
end
function c99980270.nsop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980270.nsfilter,tp,LOCATION_DECK,0,1,1,nil)
  local tc=g:GetFirst()
  if tc and Duel.Summon(tp,tc,true,nil)~=0 then
    local ct=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,99980270)
    Duel.Recover(1-tp,1000-(300*ct),REASON_EFFECT)
  end
end