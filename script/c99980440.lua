--HN Gamindustri
--Scripted by Raivost
function c99980440.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --(1) Effect indes
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e1:SetRange(LOCATION_FZONE)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetTargetRange(LOCATION_ONFIELD,0)
  e1:SetTarget(c99980440.indtg)
  e1:SetValue(c99980440.indval)
  c:RegisterEffect(e1)
  --(2) Place in S/T Zone
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980440,0))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1,99980440)
  e2:SetRange(LOCATION_FZONE)
  e2:SetTarget(c99980440.stztg)
  e2:SetOperation(c99980440.stzop)
  c:RegisterEffect(e2)
end
--(1) Effect indes
function c99980440.indtg(e,c)
  return c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS 
end
function c99980440.indval(e,re,rp)
  return rp~=e:GetHandlerPlayer()
end
--(2) Place in S/T Zone
function c99980440.stzfilter(c,tp)
  return c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and not c:IsForbidden()
end
function c99980440.stztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
  and Duel.IsExistingMatchingCard(c99980440.stzfilter,tp,LOCATION_DECK,0,1,nil,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980440.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980440.stzop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local tc=Duel.SelectMatchingCard(tp,c99980440.stzfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
  if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 
  and Duel.IsExistingMatchingCard(c99980440.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) 
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(99980440,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980440,2))
  	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  	local g=Duel.SelectMatchingCard(tp,c99980440.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
  	if g:GetCount()>0 then
      Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  	end
  end
end