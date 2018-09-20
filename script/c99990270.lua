--SAO Guns And Swords
--Scripted by Raivost
function c99990270.initial_effect(c)
  --(1) Activate effect
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_BATTLE_START)
  e1:SetCountLimit(1,99990270+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99990270.aecon)
  e1:SetTarget(c99990270.aetg)
  e1:SetOperation(c99990270.aeop)
  c:RegisterEffect(e1)
end
--(1) Activate effect
function c99990270.filter1(c)
  return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0x999)
end
function c99990270.filter2(c,tp)
  return c:IsPosition(POS_FACEUP_ATTACK)
end
function c99990270.aecon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetCurrentPhase()==PHASE_BATTLE_START and Duel.GetTurnPlayer()==tp
  and Duel.IsExistingMatchingCard(c99990270.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99990270.aetg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
  and Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
end
function c99990270.aeop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
  or not Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g1=Duel.SelectMatchingCard(tp,c99990270.filter2,tp,LOCATION_MZONE,0,1,1,nil)
  Duel.HintSelection(g1)
  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TARGET)
  local g2=Duel.SelectMatchingCard(1-tp,c99990270.filter2,1-tp,LOCATION_MZONE,0,1,1,nil)
  Duel.HintSelection(g2)
  local c1=g1:GetFirst()
  local c2=g2:GetFirst()
  if c2:IsAttackable() and not c2:IsImmuneToEffect(e) and not c1:IsImmuneToEffect(e) then
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_DAMAGE_STEP_END)
  e1:SetTarget(c99990270.damtg)
  e1:SetOperation(c99990270.damop)
  e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
  e1:SetLabelObject(c2)
  Duel.RegisterEffect(e1,tp)
  Duel.CalculateDamage(c1,c2)
  Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
  end
end
function c99990270.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c2=e:GetLabelObject()
  local bc=c2:GetBattleTarget()
  if chk==0 then return Duel.GetAttackTarget()~=nil
  and bc:IsRelateToBattle() and bc:IsLocation(LOCATION_ONFIELD) end
end
function c99990270.spfilter(c,e,tp)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c99990270.damop(e,tp,eg,ep,ev,re,r,rp)
  local c2=e:GetLabelObject()
  local bc=c2:GetBattleTarget()
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK+LOCATION_HAND end   
  if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
  if loc==0 then return end
  local g=Duel.GetMatchingGroup(c99990270.spfilter,tp,loc,0,nil,e,tp)
  if bc:IsRelateToBattle() and loc~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(99990270,0)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99990270,1))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=g:Select(tp,1,1,nil)
    if Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)~=0 then
      sg:GetFirst():RegisterFlagEffect(99990270,RESET_EVENT+0x1fe0000,0,1)
      --(1.1) Destroy
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetCountLimit(1)
      e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
      e1:SetLabelObject(sg:GetFirst())
      e1:SetCondition(c99990270.descon)
      e1:SetOperation(c99990270.desop)
      Duel.RegisterEffect(e1,tp)
      local e2=Effect.CreateEffect(e:GetHandler())
      e2:SetType(EFFECT_TYPE_FIELD)
      e2:SetCode(EFFECT_BP_TWICE)
      e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
      e2:SetTargetRange(1,0)
      e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
      Duel.RegisterEffect(e2,tp)
    end
  end
end
--(1.1) Destroy
function c99990270.descon(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  if tc:GetFlagEffect(99990270)~=0 then
    return true
  else
    e:Reset()
    return false
  end
end
function c99990270.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.Destroy(tc,REASON_EFFECT)
end