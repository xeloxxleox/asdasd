--SAO Phantom Bullet
--Scripted by Raivost
function c99990290.initial_effect(c)
  --(1) Negate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990290,0))
  e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_CHAINING)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e1:SetCountLimit(1,99990290+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99990290.negcon)
  e1:SetCost(c99990290.negcost)
  e1:SetTarget(c99990290.negtg)
  e1:SetOperation(c99990290.negop)
  c:RegisterEffect(e1)
end
--(1) Negate
function c99990290.negcon(e,tp,eg,ep,ev,re,r,rp)
  if ep==tp then return false end
  return Duel.IsChainNegatable(ev)
end
function c99990290.negcostfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99990290.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990290.negcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99990290.negcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99990290.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c99990290.negop(e,tp,eg,ep,ev,re,r,rp)
  local tc=eg:GetFirst()
  local dg=Duel.GetMatchingGroup(Card.IsCode,tc:GetControler(),LOCATION_DECK+LOCATION_HAND,0,nil,tc:GetCode())
  if Duel.NegateActivation(ev)~=0 and dg:GetCount()>0 then
    Duel.Destroy(dg,REASON_EFFECT)
  end
end