--HN Oblivion Conflict
--Scripted by Raivost
function c99980350.initial_effect(c)
  --(1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetCondition(c99980350.atkcon)
  e1:SetTarget(c99980350.atktg)
  e1:SetOperation(c99980350.atkop)
  c:RegisterEffect(e1)
end
function c99980350.atkconfilter(c)
  return c:IsPosition(POS_FACEUP_ATTACK)
end
function c99980350.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local ph=Duel.GetCurrentPhase()
  return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and (ph~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
  and Duel.IsExistingMatchingCard(c99980350.atkconfilter,tp,LOCATION_MZONE,0,1,nil)
  and Duel.IsExistingMatchingCard(c99980350.atkconfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c99980350.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980350.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99980350.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99980350.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99980350.atkop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local g=Duel.GetMatchingGroup(c99980350.atkfilter,tp,LOCATION_MZONE,0,nil)
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(g:GetCount()*500)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    --(1.1) Cannot activate S/T
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetTargetRange(0,1)
    e2:SetLabelObject(tc)
    e2:SetValue(c99980350.aclimit)
    e2:SetCondition(c99980350.actcon)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
  end
end
 --(1.1) Cannot activate S/T
function c99980350.aclimit(e,re,tp)
  return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c99980350.actcon(e)
  return Duel.GetAttacker()==e:GetLabelObject()
end