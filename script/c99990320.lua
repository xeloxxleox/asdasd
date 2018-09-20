--SAO Bits Of Sorrow
--Scripted by Raivost
function c99990320.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990320,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetCode(EVENT_TO_GRAVE)
  e1:SetCountLimit(1,99990320)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
  e1:SetCondition(c99990320.spcon)
  e1:SetTarget(c99990320.sptg)
  e1:SetOperation(c99990320.spop)
  c:RegisterEffect(e1)
  --(2) Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990320,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_FREE_CHAIN)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCondition(c99990320.tdcon)
  e2:SetCost(aux.bfgcost)
  e2:SetTarget(c99990320.tdtg)
  e2:SetOperation(c99990320.tdop)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c99990320.spconfilter(c,tp)
  return c:IsSetCard(0x999) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp
end
function c99990320.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
  return eg:IsExists(c99990320.spconfilter,1,nil,tp)
end
function c99990320.spfilter(c,e,tp)
  return c:IsSetCard(0x999) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99990320.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99990320.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
  local val=eg:Filter(c99990320.spconfilter,nil,tp):GetFirst():GetBaseAttack()
  e:SetLabel(val/2)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c99990320.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99990320.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e1:SetValue(e:GetLabel())
    tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    tc:RegisterEffect(e2)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e3:SetValue(1)
    tc:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    tc:RegisterEffect(e4)
    Duel.SpecialSummonComplete()
  end
end
--(2) Shuffle
function c99990320.tdcon(e,tp,eg,ep,ev,re,r,rp)
  return aux.exccon(e) and Duel.GetTurnPlayer()==tp
end
function c99990320.tdfilter(c)
  return c:IsSetCard(0x999) and c:IsLevelBelow(4) and c:IsAbleToDeck()
end
function c99990320.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
  and Duel.IsExistingMatchingCard(c99990320.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99990320.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c99990320.tdfilter),tp,LOCATION_GRAVE,0,nil)
  if g:GetCount()<1 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local sg=g:Select(tp,1,1,nil)
  Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
  local og=Duel.GetOperatedGroup()
  if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
  if ct==1 then
    Duel.Draw(tp,1,REASON_EFFECT)
  end
end