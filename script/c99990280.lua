--SAO Limitless Combat
--Scripted by Raiovst
function c99990280.initial_effect(c)
  --(1) Multiples attack
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990280,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c99990280.mulatcon)
  e1:SetTarget(c99990280.mulattg)
  e1:SetOperation(c99990280.mulatop)
  c:RegisterEffect(e1)
end
 --(1) Multiples attack
function c99990280.mulatcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsAbleToEnterBP()
end
function c99990280.mulatfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990280.mulattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local ct=Duel.GetMatchingGroupCount(c99990280.mulatfilter,tp,LOCATION_MZONE,0,nil)
  if chk==0 then return Duel.IsExistingTarget(c99990280.mulatfilter,tp,LOCATION_MZONE,0,1,nil) and ct>1 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99990280.mulatfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99990280.mulatop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local ct=Duel.GetMatchingGroupCount(c99990280.mulatfilter,tp,LOCATION_MZONE,0,tc)
  if tc:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(ct-1)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    --(1.1) Reduce damage
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e2:SetCondition(c99990280.rdcon)
    e2:SetOperation(c99990280.rdop)
    tc:RegisterEffect(e2)
    --(1.2) Others cannot attack
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ATTACK)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c99990280.ftarget)
    e3:SetLabel(tc:GetFieldID())
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
  end
end
--(1.1) Reduce damage
function c99990280.rdcon(e,tp,eg,ep,ev,re,r,rp)
  return ep~=tp
end
function c99990280.rdop(e,tp,eg,ep,ev,re,r,rp)
  Duel.ChangeBattleDamage(ep,ev/2)
end
--(1.2) Others cannot attack
function c99990280.ftarget(e,c)
  return e:GetLabel()~=c:GetFieldID()
end