--HN Arfoire
--Scropted by Raivost
function c99980250.initial_effect(c)
  --(1) Special Summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980250,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99980250.hspcon)
  c:RegisterEffect(e1)
end
--(1) Special Summon from hand
function c99980250.hspconfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980250.hspcon(e,c)
  if c==nil then return true end
  if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
  local g=Duel.GetMatchingGroup(c99980250.hspconfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
  local ct=g:GetClassCount(Card.GetCode)
  return ct>3
end