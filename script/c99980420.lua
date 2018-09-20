--HN Uzume
--Scripted by Raivost
function c99980420.initial_effect(c)
  --(1) To hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980420,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetTarget(c99980420.thtg)
  e1:SetOperation(c99980420.thop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --(2) Level 4 Xyz
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_XYZ_LEVEL)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99980420.xyzlv)
  c:RegisterEffect(e3)
end
--(1) To hand
function c99980420.thfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_FIELD) and c:IsAbleToHand() 
end
function c99980420.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980420.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980420.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,tp,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
--(2) Level 4 Xyz
function c99980420.xyzlv(e,c,rc)
  return 0x40000+e:GetHandler():GetLevel()
end