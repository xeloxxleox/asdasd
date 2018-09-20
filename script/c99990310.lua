--SAO Halloween Dungeon Party
--Scripted by Raivost
function c99990310.initial_effect(c)
  --(1) Choose 
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990310,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990310+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99990310.chth)
  e1:SetOperation(c99990310.chop)
  c:RegisterEffect(e1)
end
--(1) Choose
function c99990310.chfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99990310.chth(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990310.chfilter,tp,LOCATION_DECK,0,3,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c99990310.chop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99990310.chfilter,tp,LOCATION_DECK,0,nil)
  if g:GetCount()>=3 then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local sg=g:Select(tp,3,3,nil)
  Duel.ConfirmCards(1-tp,sg)
  Duel.ShuffleDeck(tp)
  local tg=sg:Select(1-tp,1,1,nil)
  Duel.SendtoHand(tg,nil,REASON_EFFECT)
  end
end