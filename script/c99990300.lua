--SAO Illusion Incantation
--Scripted by Raivost
function c99990300.initial_effect(c)
  --(1) Gain ATK 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990300,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(c99990300.atkcost1)
  e1:SetTarget(c99990300.atktg1)
  e1:SetOperation(c99990300.atkop1)
  c:RegisterEffect(e1)
  --(2) Gain ATK 2
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990300,0))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetCondition(aux.exccon)
  e2:SetCost(c99990300.atkcost2)
  e2:SetTarget(c99990300.atktg1)
  e2:SetOperation(c99990300.atkop1)
  c:RegisterEffect(e2)
end
--(1) Gain ATK 1
function c99990300.atkcostfilter1(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) 
end
function c99990300.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990300.atkcostfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99990300.atkcostfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
  e:SetLabel(g:GetFirst():GetAttack())
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
  Duel.SendtoGrave(g,REASON_COST)
end
function c99990300.atkfilter1(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x999)
end
function c99990300.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99990300.atkfilter1,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99990300.atkfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99990300.atkop1(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(e:GetLabel()/2)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
  end
end
--(2) Gain ATK 2
function c99990300.atkcostfilter2(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99990300.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
  and Duel.IsExistingMatchingCard(c99990300.atkcostfilter2,tp,LOCATION_GRAVE,0,1,c) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990300.atkcostfilter2,tp,LOCATION_GRAVE,0,1,1,c)
  e:SetLabel(g:GetFirst():GetAttack())
  g:AddCard(c)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end