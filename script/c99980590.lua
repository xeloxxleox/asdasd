--HN Broccoli
--Scripted by Raivost
function c99980590.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Pendulum Effects
  --(1) Gain LP
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980590,0))
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetCondition(c99980590.reccon)
  e1:SetTarget(c99980590.rectg)
  e1:SetOperation(c99980590.recop)
  c:RegisterEffect(e1)
  --(2) Unaffected
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980590,1))
  e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_CHAINING)
  e2:SetRange(LOCATION_PZONE)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e2:SetCountLimit(1)
  e2:SetCondition(c99980590.unfcon)
  e2:SetTarget(c99980590.unftg)
  e2:SetOperation(c99980590.unfop)
  c:RegisterEffect(e2)
  --Monster Effects
  --(1) Place in PZone
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980590,2))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_SUMMON_SUCCESS)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e3:SetCountLimit(1,99980590)
  e3:SetTarget(c99980590.pentg)
  e3:SetOperation(c99980590.penop)
  c:RegisterEffect(e3)
  local e4=e3:Clone()
  e4:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e4)
end
--Pendulum Effects
--(1)Gain LP
function c99980590.reccon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99980590.recfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998)
end
function c99980590.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local rec=Duel.GetMatchingGroupCount(c99980590.recfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,nil)
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(rec)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec*200)
end
function c99980590.recop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local rec=Duel.GetMatchingGroupCount(c99980590.recfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,nil)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  Duel.Recover(p,rec*200,REASON_EFFECT)
end
--(2) Unaffected
function c99980590.unffilter(c,tp)
  return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x998)
end
function c99980590.unfcon(e,tp,eg,ep,ev,re,r,rp)
  if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
  local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
  return g and g:IsExists(c99980590.unffilter,1,nil,tp)
end
function c99980590.unftg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return re:GetHandler():IsRelateToEffect(re) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980590.unfop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c99980590.unffilter,nil,tp)
  local tg=g:Filter(Card.IsRelateToEffect,nil,re)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local tc=tg:Select(tp,1,1,nil):GetFirst()
  if tc and tc:IsFaceup() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(99980590,1))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetValue(c99980590.efilter)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(500)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
    tc:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    tc:RegisterEffect(e3)
  end
end
function c99980590.efilter(e,te)
  return te:GetOwner()~=e:GetOwner()
end
--Monster Effects
--(1) Place in PZone
function c99980590.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980590.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980590.penop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) or Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)==0 then return end
  if Duel.IsExistingMatchingCard(c99980590.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.SelectYesNo(tp,aux.Stringid(99980590,3)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99950020,4))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c99980590.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
  end
end