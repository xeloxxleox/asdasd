--HN Goddess of Fertility Green Heart
--Scripted by Raivost
function c99980580.initial_effect(c)
  c:EnableReviveLimit()
  --Link summon
  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),2)
  --(1) Special summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980580,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1,99980580)
  e1:SetCondition(c99980580.spcon1)
  e1:SetTarget(c99980580.sptg1)
  e1:SetOperation(c99980580.spop1)
  c:RegisterEffect(e1)
  --(2) Look
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980580,1))
  e2:SetCategory(CATEGORY_DECKDES)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980580.lkcon)
  e2:SetTarget(c99980580.lktg)
  e2:SetOperation(c99980580.lkop)
  c:RegisterEffect(e2)
  --(3) Special Summon 2
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980580,0))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetHintTiming(0,0x1e0)
  e3:SetCost(c99980580.spcost2)
  e3:SetTarget(c99980580.sptg2)
  e3:SetOperation(c99980580.spop2)
  c:RegisterEffect(e3)
  --(4) Special Summon 3
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980580,0))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetTarget(c99980580.sptg3)
  e4:SetOperation(c99980580.spop3)
  c:RegisterEffect(e4)
end
--(1) Special Summon 1
function c99980580.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99980580.spfilter1(c,e,tp,zone)
  return c:IsSetCard(0x998) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone,true)
end
function c99980580.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local zone=e:GetHandler():GetLinkedZone(tp)
  if chk==0 then return zone~=0 and Duel.IsExistingTarget(c99980580.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99980580.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99980580.spop1(e,tp,eg,ep,ev,re,r,rp)
  local zone=e:GetHandler():GetLinkedZone(tp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and zone~=0 then
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
  end
end
--(2) Look
function c99980580.lkconfilter(c,g)
  return c:IsSetCard(0x998) and g:IsContains(c)
end
function c99980580.lkcon(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup()
  return lg and eg:IsExists(c99980580.lkconfilter,1,nil,lg) 
end
function c99980580.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980580.tgfilter(c)
  return c:IsAbleToGrave()
end
function c99980580.lkop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 then return end
  local g=Duel.GetDecktopGroup(1-tp,3)
  Duel.ConfirmCards(tp,g)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local sg=g:FilterSelect(tp,c99980580.tgfilter,1,1,nil)
  Duel.SendtoGrave(sg,REASON_EFFECT)
end
--(3) Special Summon 2
function c99980580.spcostfilter2(c,g)
  return c:IsFaceup() and g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c99980580.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local lg=e:GetHandler():GetLinkedGroup()
  if chk==0 then return Duel.CheckReleaseGroup(tp,c99980580.spcostfilter2,1,nil,lg) end
  local g=Duel.SelectReleaseGroup(tp,c99980580.spcostfilter2,1,1,nil,lg)
  Duel.Release(g,REASON_COST)
end
function c99980580.spfilter2(c,e,tp)
  return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980580.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980580.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99980580.spop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980580.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()~=0 then
    Duel.SpecialSummon(g,1,tp,tp,false,false,POS_FACEUP)
  end
end
--(4) Special Summon 3
function c99980580.spfilter3(c,e,tp)
  return c:IsCode(99980160) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c99980580.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return  Duel.IsExistingTarget(c99980580.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99980580.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99980580.tdfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c99980580.spop3(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
  and Duel.IsExistingMatchingCard(c99980580.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99980580,2)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980580,3))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980580.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
  end
end