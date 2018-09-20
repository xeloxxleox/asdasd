--HN Neptune
--Scripted by Raivost
function c99980010.initial_effect(c)
  --(1) Place in S/T Zone
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980010,0))
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetTarget(c99980010.stztg)
  e1:SetOperation(c99980010.stzop)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  --(2) Level 4 Xyz
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_XYZ_LEVEL)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99980010.xyzlv)
  c:RegisterEffect(e3)
end
--(1) Place S/T Zone
function c99980010.stzfilter(c,tp)
  return c:IsCode(99980030) and not c:IsForbidden()
end
function c99980010.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingMatchingCard(c99980010.stzfilter,tp,LOCATION_DECK,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980010.stzop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  local tc=Duel.GetFirstMatchingCard(c99980010.stzfilter,tp,LOCATION_DECK,0,nil,tp)
  if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
    if Duel.GetFlagEffect(tp,99980010)~=0 then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x998))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,99980010,RESET_PHASE+PHASE_END,0,1)
  end
end
--(2) Level 4 Xyz
function c99980010.xyzlv(e,c,rc)
  return 0x40000+e:GetHandler():GetLevel()
end