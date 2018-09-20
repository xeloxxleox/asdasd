--HN Goddess of Fate Purple Heart
--Scripted by Raivost
function c99980550.initial_effect(c)
  c:EnableReviveLimit()
  --Link summon
  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),2)
  --(1) Special summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980550,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1,99980550)
  e1:SetCondition(c99980550.spcon1)
  e1:SetTarget(c99980550.sptg1)
  e1:SetOperation(c99980550.spop1)
  c:RegisterEffect(e1)
  --(2) Gain ATK/DEF
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980550.atkcon)
  e2:SetOperation(c99980550.atkop)
  c:RegisterEffect(e2)
  --(3) To hand
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980550,1))
  e3:SetCategory(CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetHintTiming(0,0x1e0)
  e3:SetTarget(c99980550.thtg)
  e3:SetOperation(c99980550.thop)
  c:RegisterEffect(e3)
  --(4) Special Summon 2
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980550,0))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetTarget(c99980550.sptg2)
  e4:SetOperation(c99980550.spop2)
  c:RegisterEffect(e4)
end
--(1) Special Summon 1
function c99980550.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99980550.spfilter1(c,e,tp,zone)
  return c:IsSetCard(0x998) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone,true)
end
function c99980550.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local zone=e:GetHandler():GetLinkedZone(tp)
  if chk==0 then return zone~=0 and Duel.IsExistingTarget(c99980550.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99980550.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99980550.spop1(e,tp,eg,ep,ev,re,r,rp)
  local zone=e:GetHandler():GetLinkedZone(tp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and zone~=0 then
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
  end
end
--(2) Gain ATK
function c99980550.atkconfilter(c,g)
  return c:IsSetCard(0x998) and g:IsContains(c)
end
function c99980550.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998)
end
function c99980550.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup()
  return lg and eg:IsExists(c99980550.atkconfilter,1,nil,lg)
end
function c99980550.atkop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99980550)
  local g=Duel.GetMatchingGroup(c99980550.atkfilter,tp,LOCATION_MZONE,0,nil)
  for tc in aux.Next(g) do
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(300)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    tc:RegisterEffect(e2)
  end
end
--(3) To hand
function c99980550.thfilter1(c,lg)
  return c:IsFaceup() and lg and lg:IsContains(c) and c:IsAbleToHand()
end
function c99980550.thfilter2(c,lg)
  return c:IsFaceup() and c:IsSetCard(0x998) and lg and lg:IsContains(c) and c:IsAbleToHand()
end
function c99980550.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local lg=e:GetHandler():GetLinkedGroup()
  if chk==0 then return Duel.IsExistingTarget(c99980550.thfilter1,tp,0,LOCATION_MZONE,1,nil,lg) 
  and Duel.IsExistingTarget(c99980550.thfilter2,tp,LOCATION_MZONE,0,1,nil,lg) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g1=Duel.SelectTarget(tp,c99980550.thfilter1,tp,0,LOCATION_MZONE,1,1,nil,lg)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g2=Duel.SelectTarget(tp,c99980550.thfilter2,tp,LOCATION_MZONE,0,1,1,nil,lg)
  g1:Merge(g2)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c99980550.thop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
  Duel.SendtoHand(g,nil,REASON_EFFECT)
end
--(4) Special Summon 2
function c99980550.spfilter2(c,e,tp)
  return c:IsCode(99980010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c99980550.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return  Duel.IsExistingTarget(c99980550.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99980550.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99980550.tdfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c99980550.spop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
  and Duel.IsExistingMatchingCard(c99980550.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99980550,2)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980550,3))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980550.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
  end
end