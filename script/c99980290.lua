--HN Pudding Buddies
--Scripted by Raivost
function c99980290.initial_effect(c)
  --(1) Excavate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980290,0))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980290+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99980290.excatg)
  e1:SetOperation(c99980290.excaop)
  c:RegisterEffect(e1)
end
--(1) Excavate
function c99980290.excafilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980290.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(c99980290.excafilter,tp,LOCATION_MZONE,0,nil)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980290.excafilter,tp,LOCATION_MZONE,0,1,nil)
  and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
  e:SetLabel(ct)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c99980290.excaop(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetLabel()
  Duel.ConfirmDecktop(tp,ct)
  local g=Duel.GetDecktopGroup(tp,ct)
  if g:GetCount()>0 then
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
    local sg=g:Select(tp,1,1,nil)
    if sg:GetFirst():IsAbleToHand() then
      Duel.SendtoHand(sg,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,sg)
      Duel.ShuffleHand(tp)
    else
      Duel.SendtoGrave(sg,REASON_RULE)
    end
  Duel.ShuffleDeck(tp)
  end
end