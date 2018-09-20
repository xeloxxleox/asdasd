--SAO Counteract
--Scripted by Raivost
function c99990260.initial_effect(c)
  --(1) Negate attack
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990260,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCondition(c99990260.negcon)
  e1:SetTarget(c99990260.negtg)
  e1:SetOperation(c99990260.negop)
  c:RegisterEffect(e1)
  --(2) Act in hand
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  e2:SetCondition(c99990260.handcon)
  c:RegisterEffect(e2)
end
--(1) Negate attack
function c99990260.negconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990260.negcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(c99990260.negconfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c99990260.thfilter(c)
  return c:IsSetCard(0x999)
end
function c99990260.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990260.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990260.negop(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  if Duel.NegateAttack() and Duel.IsExistingMatchingCard(c99990260.filter,tp,LOCATION_DECK,0,1,nil) 
  and Duel.SelectYesNo(tp,aux.Stringid(99990260,1)) then  
  	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99990260,2))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c99990260.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
       Duel.BreakEffect()
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end
--(2) Act in hand
function c99990260.handcon(e)
  return Duel.IsExistingMatchingCard(c99990260.negconfilter,tp,LOCATION_MZONE,0,2,nil) 
end