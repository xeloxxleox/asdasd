--HN CFW Judge
--Scripted by Raivost
function c99980530.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --(1) Lose ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980530,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCost(c99980530.atkcost)
  e1:SetTarget(c99980530.atktg)
  e1:SetOperation(c99980530.atkop)
  c:RegisterEffect(e1)
  --(2) Gain effects
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980530.gecon)
  e2:SetOperation(c99980530.geop)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_MATERIAL_CHECK)
  e3:SetValue(c99980530.valcheck)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
  --(3) Indes by effect
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e4:SetCondition(c99980530.indcon)
  e4:SetValue(1)
  c:RegisterEffect(e4)
  --(4) Gain Def
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetCode(EFFECT_UPDATE_DEFENSE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(c99980530.defcon)
  e5:SetValue(300)
  c:RegisterEffect(e5)
  --(5) To hand
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99980530,3))
  e6:SetCategory(CATEGORY_TOHAND)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e6:SetCode(EVENT_TO_GRAVE)
  e6:SetTarget(c99980530.thtg)
  e6:SetOperation(c99980530.thop)
  c:RegisterEffect(e6)
end
--(1) Destroy
function c99980530.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980530.atkfilter(c,def)
  return c:IsFaceup() and c:IsAttackBelow(def)
end
function c99980530.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99980530.atkfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetDefense()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99980530.atkfilter,tp,0,LOCATION_MZONE,1,1,nil,e:GetHandler():GetDefense())
  local def=e:GetHandler():GetDefense()
  local atk=def-g:GetFirst():GetAttack()-700
  if atk>0 then
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
  end
end
function c99980530.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-700)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
    local atk=e:GetHandler():GetDefense()-tc:GetAttack()
      if atk>0 then
      Duel.Damage(1-tp,atk,REASON_EFFECT)
      end
  end
end
--(2) Gain effects
function c99980530.gecon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetLabel()==1
end
function c99980530.geop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  c:RegisterFlagEffect(99980530,RESET_EVENT+0x1fe0000,0,1)
  c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99980530,1))
  c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99980530,2))
end
function c99980530.valcheck(e,c)
  local g=c:GetMaterial()
  if g:IsExists(Card.IsCode,1,nil,99980250) then
    e:GetLabelObject():SetLabel(1)
  else
    e:GetLabelObject():SetLabel(0)
  end
end
--(3) Indes by effect
function c99980530.indcon(e)
  return e:GetHandler():GetFlagEffect(99980530)>0
end
--(4) Gain DEF
function c99980530.defcon(e)
  return e:GetHandler():IsDefensePos() and e:GetHandler():GetFlagEffect(99980530)>0
end
--(5) To hand
function c99980530.thfilter(c)
  return c:IsCode(99980250) and c:IsAbleToHand()
end
function c99980530.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980530.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99980530.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980530.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end