--SAO Tense Strategy
--Scripted by Raivost
function c99990420.initial_effect(c)
  --(1) Activate effects
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e1:SetHintTiming(TIMING_DAMAGE_STEP)
  e1:SetCountLimit(1,99990420+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99990420.aecost)
  e1:SetTarget(c99990420.aetg)
  e1:SetOperation(c99990420.aeop)
  c:RegisterEffect(e1)
end
--(1) Activate effects
function c99990420.aecostfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x999)
end
function c99990420.aecost(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(c99990420.aecostfilter,tp,LOCATION_MZONE,0,nil)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x999,ct,REASON_COST) end
  e:SetLabel(ct)
  Duel.RemoveCounter(tp,1,0,0x999,ct,REASON_COST)
  Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+99990030,e,0,tp,0,0)
end
function c99990420.aetg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990420.aecostfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c99990420.aeop(e,tp,eg,ep,ev,re,r,rp)
  local ct1=e:GetLabel()
  local g=Duel.GetMatchingGroup(c99990420.aecostfilter,tp,LOCATION_MZONE,0,nil)
  local ct2=g:GetCount()
  --(1.1) Gain ATK
  if ct1>0 and ct2>0 then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99990420,0))
  	for tc in aux.Next(g) do
  	  local e1=Effect.CreateEffect(e:GetHandler())
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_UPDATE_ATTACK)
	  e1:SetValue(ct1*200)
	  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	  tc:RegisterEffect(e1)
	end
  end
  --(1.2) Indes by effect
  if ct1>2 then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99990420,1))
  	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
  end
  --(1.3) Cannot activate
  if ct1>4 then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99990420,2))
  	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c99990420.actcon)
	e2:SetValue(c99990420.actlimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
  end
end
--(1.3) Cannot activate
function c99990420.actfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsControler(tp)
end
function c99990420.actcon(e)
  local tp=e:GetHandlerPlayer()
  local a=Duel.GetAttacker()
  local d=Duel.GetAttackTarget()
  return (a and c99990420.actfilter(a,tp)) or (d and c99990420.actfilter(d,tp))
end
function c99990420.actlimit(e,re,tp)
  return not re:GetHandler():IsImmuneToEffect(e)
end