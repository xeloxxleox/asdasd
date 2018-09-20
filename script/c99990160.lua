--SAO The Skull Reaper
--Scripted by Raivost
function c99990160.initial_effect(c)
  c:EnableReviveLimit()
  --Cannot be Special Summon
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetCode(EFFECT_SPSUMMON_CONDITION)
  c:RegisterEffect(e0)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990160,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99990160.hspcon)
  e1:SetOperation(c99990160.hspop)
  c:RegisterEffect(e1)
  --(2) Halve ATK/def
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990160,1))
  e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetTarget(c99990160.atktg)
  e2:SetOperation(c99990160.atkop)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e3)
  local e4=e2:Clone()
  e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
  c:RegisterEffect(e4)
  --(3) Cannot be targeted
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e5:SetValue(1)
  c:RegisterEffect(e5)
  --(4) Discard
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99990160,2))
  e6:SetCategory(CATEGORY_HANDES)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e6:SetCode(EVENT_BATTLE_DESTROYING)
  e6:SetCondition(aux.bdcon)
  e6:SetTarget(c99990160.distg)
  e6:SetOperation(c99990160.disop)
  c:RegisterEffect(e6)
end
--(1) Special Summon from hand
function c99990160.hspcostfilter(c)
  return c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c99990160.hspcon(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  local rg=Duel.GetMatchingGroup(c99990160.hspcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and rg:GetCount()>2 and aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),0)
end
function c99990160.hspop(e,tp,eg,ep,ev,re,r,rp,c)
  local rg=Duel.GetMatchingGroup(c99990160.hspcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
  local g=aux.SelectUnselectGroup(rg,e,tp,3,3,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--(2) Halve ATK/DEF
function c99990160.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990160.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetValue(tc:GetAttack()/2)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
    e2:SetValue(tc:GetDefense()/2)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e2)
  end
end
--(4) Discard
function c99990160.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c99990160.disop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
  if g:GetCount()~=0 then
  	local sg=g:RandomSelect(tp,1)
 	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
  end
end