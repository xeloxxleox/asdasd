--SAO Yuuki ALO
--Scripted by Raivost
function c99990220.initial_effect(c)
  --Synchro summon
  aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(Card.IsSetCard,0x999),1,1)
  c:EnableReviveLimit()
  --(1) Lose ATK
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990220,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990220.atkcon1)
  e1:SetTarget(c99990220.atktg1)
  e1:SetOperation(c99990220.atkop1)
  c:RegisterEffect(e1)
  --(2) Attack all monsters
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_ATTACK_ALL)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(3) Cannot attack directly
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
  c:RegisterEffect(e3)
  --(4) Gain ATK/DEF
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99990220,1))
  e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_BATTLE_DESTROYED)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c99990220.atkcon2)
  e4:SetTarget(c99990220.atktg2)
  e4:SetOperation(c99990220.atkop2)
  c:RegisterEffect(e4)
end
--(1) Lose ATK
function c99990220.atkcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99990220.atkfilter1(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990220.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990220.atkop1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  local ct=Duel.GetMatchingGroupCount(c99990220.atklfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-ct*100)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
  end
end
--(3) Gain ATK/DEF
function c99990220.atkcon2(e,tp,eg,ep,ev,re,r,rp)
  local des=eg:GetFirst()
  local rc=des:GetReasonCard()
  if des:IsType(TYPE_XYZ) then
    e:SetLabel(des:GetRank())
  elseif des:IsType(TYPE_LINK) then
    e:SetLabel(des:GetLink()) 
  else
    e:SetLabel(des:GetLevel())
  end
  return rc and rc:IsSetCard(0x999) and rc:IsControler(tp) and rc:IsRelateToBattle() and des:IsReason(REASON_BATTLE) 
end
function c99990220.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990220.atkop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end