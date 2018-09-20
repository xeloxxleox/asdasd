--SAO Illfang The Kobold Lord
--Scripted by Raivost
function c99990130.initial_effect(c)
  c:EnableReviveLimit()
  --Cannot be Special Summon
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e0)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990130,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99990130.hspcon)
  e1:SetOperation(c99990130.hspop)
  c:RegisterEffect(e1)
  --(2) Special Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990130,0))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99990130.sptg)
  e2:SetOperation(c99990130.spop)
  c:RegisterEffect(e2)
  --(3) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetValue(c99990130.atkval)
  c:RegisterEffect(e3)
  --(4) Cannot be attacket
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
  e1:SetCondition(c99990130.cbacon)
  e1:SetValue(aux.imval1)
  c:RegisterEffect(e1)
end
--(1) Special Summon from hand
function c99990130.hspconfilter(c,tp)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
  and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))
end
function c99990130.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.IsExistingMatchingCard(c99990130.hspconfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp)
end
function c99990130.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99990130.hspconfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--(2) Special Summon
function c99990130.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,99990135,0x9999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c99990130.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsPlayerCanSpecialSummonMonster(tp,99990135,0x9999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then
  local token=Duel.CreateToken(tp,99990135)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
  end
end
--(3) Gain ATK
function c99990130.atkval(e,c)
  return Duel.GetMatchingGroupCount(Card.IsCode,c:GetControler(),LOCATION_ONFIELD,0,nil,99990135)*200
end
--(4) Cannot be attacked
function c99990130.cbafilter(c)
  return c:IsFaceup() and c:IsCode(99990135)
end
function c99990130.cbacon(e)
  return Duel.IsExistingMatchingCard(c99990130.cbafilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end