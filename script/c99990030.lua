--SAO Aincrad
--Scripted by Raivost
function c99990030.initial_effect(c)
  c:EnableCounterPermit(0x999)
  --(1) Place counter 
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_COUNTER)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99990030.pcttg)
  e1:SetOperation(c99990030.pctop)
  c:RegisterEffect(e1)
  --(2) Special Summon token
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990030,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
  e2:SetCountLimit(1)
  e2:SetCondition(c99990030.spcon1)
  e2:SetTarget(c99990030.sptg1)
  e2:SetOperation(c99990030.spop1)
  c:RegisterEffect(e2)  
  --(3) Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990030,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCost(c99990030.spcost2)
  e3:SetTarget(c99990030.sptg2)
  e3:SetOperation(c99990030.spop2)
  c:RegisterEffect(e3)
  --(4) Remove counter
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_PHASE+PHASE_END)
  e4:SetRange(LOCATION_FZONE)
  e4:SetCountLimit(1)
  e4:SetTarget(c99990030.rcttg)
  e4:SetOperation(c99990030.rctop)
  c:RegisterEffect(e4)
  --(3) Win
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
  e5:SetCode(EVENT_CUSTOM+99990030)
  e5:SetRange(LOCATION_FZONE)
  e5:SetOperation(c99990030.winop)
  c:RegisterEffect(e5)
  --(6) Destroy replace
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
  e6:SetCode(EFFECT_DESTROY_REPLACE)
  e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e6:SetRange(LOCATION_FZONE)
  e6:SetTarget(c99990030.dreptg)
  c:RegisterEffect(e6)
end
--(1) Place counter
function c99990030.pcttg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanAddCounter(tp,0x999,100,e:GetHandler()) end
  Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,100,0,0x999)
end
function c99990030.pctop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
  	c:AddCounter(0x999,100)
  end
end
--(2) Special Summon tokens
function c99990030.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()==tp
end
function c99990030.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function c99990030.spop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
  if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,99990035,0,0x4011,500,500,2,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then return end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  local fid=e:GetHandler():GetFieldID()
  local g=Group.CreateGroup()
  for i=1,ft do
    local token=Duel.CreateToken(tp,99990035)
    Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) 
    token:RegisterFlagEffect(99990030,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
    g:AddCard(token)
  end
  Duel.SpecialSummonComplete()
  g:KeepAlive()
  --(2.1) Destroy
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_PHASE+PHASE_END)
  e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetReset(RESET_PHASE+PHASE_END)
  e2:SetCountLimit(1)
  e2:SetLabel(fid)
  e2:SetLabelObject(g)
  e2:SetCondition(c99990030.descon)
  e2:SetOperation(c99990030.desop)
  Duel.RegisterEffect(e2,tp)
end
--(2.1) Destroy
function c99990030.desfilter(c,fid)
  return c:GetFlagEffectLabel(99990030)==fid
end
function c99990030.descon(e,tp,eg,ep,ev,re,r,rp)
  local g=e:GetLabelObject()
  if not g:IsExists(c99990030.desfilter,1,nil,e:GetLabel()) then
  g:DeleteGroup()
  e:Reset()
  return false
  else return true end
end
function c99990030.desop(e,tp,eg,ep,ev,re,r,rp)
  local g=e:GetLabelObject()
  local tg=g:Filter(c99990030.desfilter,nil,e:GetLabel())
  g:DeleteGroup()
  Duel.Destroy(tg,REASON_EFFECT)
end
--(3) Special Summon
function c99990030.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x999,5,REASON_COST) end
  e:GetHandler():RemoveCounter(tp,0x999,5,REASON_COST)
end
function c99990030.spfilter2(c,e,sp)
  return c:IsSetCard(0x999) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c99990030.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99990030.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99990030.spop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99990030.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
  	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(4) Remove counter
function c99990030.rctfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990030.rcttg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetChainLimit(c99990030.chlimit)
end
function c99990030.chlimit(e,ep,tp)
  return tp==ep
end
function c99990030.rctop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ct1=Duel.GetMatchingGroupCount(c99990030.rctfilter,tp,LOCATION_MZONE,0,nil)
  local ct2=c:GetCounter(0x999)
  if ct1>ct2 then ct1=ct2 end
  if c:IsRelateToEffect(e) and ct1>0 then
  	c:RemoveCounter(tp,0x999,ct1,REASON_EFFECT)
  	Duel.RaiseEvent(c,EVENT_CUSTOM+99990030,e,0,tp,0,0)
  end
end
--(5) Win
function c99990030.winop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:GetCounter(0x999)==0 then
  	Duel.Win(tp,0x99)
  end
end
--(6) Destroy replace
function c99990030.drepfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c99990030.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
  and Duel.IsExistingMatchingCard(c99990030.drepfilter,tp,LOCATION_GRAVE,0,1,nil) end
  if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE+REASON_REPLACE)
  local g=Duel.SelectMatchingCard(tp,c99990030.drepfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
  return true
  else return false end
end