--HN Fragment Reaction
--Scripted by Raivost
function c99980400.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980400,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980400+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980400.sptg)
  e1:SetOperation(c99980400.spop)
  c:RegisterEffect(e1)
end
--(1) Special Summon
function c99980400.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980400.thfilter(c)
  return  c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL and not c:IsCode(99980400) and c:IsAbleToHand() 
end
function c99980400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
  and Duel.IsExistingMatchingCard(c99980400.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
  and Duel.IsExistingMatchingCard(c99980400.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980400.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g1=Duel.SelectMatchingCard(tp,c99980400.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g1:GetCount()>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,c99980400.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g2:GetCount()>0 then
      Duel.SendtoHand(g2,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g2)
      Duel.BreakEffect()
      Duel.Damage(tp,800,REASON_EFFECT)
    end
  end
end