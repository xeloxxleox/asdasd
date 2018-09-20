--HN UD Neptune
--Scripted by Raivost
function c99980490.initial_effect(c)
  --(1) Neptune
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetCode(EFFECT_CHANGE_CODE)
  e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
  e1:SetValue(99980010)
  c:RegisterEffect(e1)
  --(2) Special Summon from hand
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980490,0))
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_SPSUMMON_PROC)
  e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e2:SetRange(LOCATION_HAND)
  e2:SetCondition(c99980490.hspcon)
  c:RegisterEffect(e2)
  --(3) Special Summon
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980490,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCountLimit(1,99980490)
  e3:SetTarget(c99980490.sptg)
  e3:SetOperation(c99980490.spop)
  c:RegisterEffect(e3)
  --(4) Gain ATK
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980490,1))
  e4:SetCategory(CATEGORY_ATKCHANGE)
  e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_F)
  e4:SetCode(EVENT_ATTACK_ANNOUNCE)
  e4:SetCondition(c99980490.atkcon)
  e4:SetTarget(c99980490.atktg)
  e4:SetOperation(c99980490.atkop)
  c:RegisterEffect(e4)
end
--(2) Special Summon from hand
function c99980490.hspconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ)
end
function c99980490.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
  and not Duel.IsExistingMatchingCard(c99980490.hspconfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--(3) Special Summon
function c99980490.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:GetRank()==4 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
end
function c99980490.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
  if chk==0 then return Duel.IsExistingMatchingCard(c99980490.spfilter,tp,loc,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c99980490.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local loc=0
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
  if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
  if loc==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980490.spfilter),tp,loc,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
    Duel.Overlay(tc,Group.FromCards(c))
    tc:CompleteProcedure()
  end
end
--(4) Gain ATK
function c99980490.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSetCard(0x998)
end
function c99980490.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980490.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
    e1:SetValue(500)
    c:RegisterEffect(e1)
  end
end

