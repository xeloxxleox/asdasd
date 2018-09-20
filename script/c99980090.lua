--HN Uni
--Scripted by Raivost
function c99980090.initial_effect(c)
  --(1) Level 4 Xyz
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_XYZ_LEVEL)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(c99980090.xyzlv)
  c:RegisterEffect(e1)
  --(2) Search
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980090,0))
  e2:SetCategory(CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_HAND)
  e2:SetCountLimit(1,99980090)
  e2:SetCost(c99980090.thcon)
  e2:SetTarget(c99980090.thtg)
  e2:SetOperation(c99980090.thop)
  c:RegisterEffect(e2)
  --(3) Special Summon from hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980090,1))
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_SPSUMMON_PROC)
  e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e3:SetRange(LOCATION_HAND)
  e3:SetCountLimit(1,99980091)
  e3:SetCondition(c99980090.hspcon)
  c:RegisterEffect(e3)
end
--(1) Level 4 Xyz
function c99980090.xyzlv(e,c,rc)
  return 0x40000+e:GetHandler():GetLevel()
end
--(2) Search
function c99980090.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99980090.thfilter(c)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsAbleToHand() and not c:IsCode(99980090)
end
function c99980090.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980090.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99980090.thop(e,tp,eg,ep,ev,re,r,rp,chk)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local tg=Duel.SelectMatchingCard(tp,c99980090.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  if tg:GetCount()>0 then
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tg)
  end
end
--(3) Special Summon from hand
function c99980090.hspconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsLevelBelow(4) and not c:IsCode(99980090)
end
function c99980090.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99980090.hspconfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end