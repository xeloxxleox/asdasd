--HN Goddess of Order White Heart
--Scripted by Raivost
function c99980570.initial_effect(c)
  c:EnableReviveLimit()
  --Link summon
  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),2)
  --(1) Special summon 1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980570,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1,99980570)
  e1:SetCondition(c99980570.spcon1)
  e1:SetTarget(c99980570.sptg1)
  e1:SetOperation(c99980570.spop1)
  c:RegisterEffect(e1)
  --(2) Destroy
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980570,1))
  e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980570.descon)
  e2:SetTarget(c99980570.destg)
  e2:SetOperation(c99980570.desop)
  c:RegisterEffect(e2)
  --(3) Move
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980570,2))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetHintTiming(0,0x1e0)
  e3:SetTarget(c99980570.movetg)
  e3:SetOperation(c99980570.moveop)
  c:RegisterEffect(e3)
  --(4) Special Summon 2
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980570,0))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_TO_GRAVE)
  e4:SetTarget(c99980570.sptg2)
  e4:SetOperation(c99980570.spop2)
  c:RegisterEffect(e4)
end
--(1) Special Summon 1
function c99980570.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99980570.spfilter1(c,e,tp,zone)
  return c:IsSetCard(0x998) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone,true)
end
function c99980570.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local zone=e:GetHandler():GetLinkedZone(tp)
  if chk==0 then return zone~=0 and Duel.IsExistingTarget(c99980570.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99980570.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99980570.spop1(e,tp,eg,ep,ev,re,r,rp)
  local zone=e:GetHandler():GetLinkedZone(tp)
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) and zone~=0 then
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
  end
end
--(2) Destroy
function c99980570.desconfilter(c,g)
  return c:IsSetCard(0x998) and g:IsContains(c)
end
function c99980570.descon(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup()
  return lg and eg:IsExists(c99980570.desconfilter,1,nil,lg) 
end
function c99980570.desfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99980570.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980570.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
  and Duel.IsPlayerCanDraw(tp,1) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99980570.desop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,c99980570.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
  if g:GetCount()>0 then
    Duel.HintSelection(g)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
      Duel.Draw(tp,1,REASON_EFFECT)
    end
  end
end
--(3) Move
function c99980570.movefilter(c,tp,lg)
  return c:IsFaceup() and lg and lg:IsContains(c) and ((c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) 
  or (c:IsControler(1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0))
end
function c99980570.movetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local lg=e:GetHandler():GetLinkedGroup()
  if chk==0 then return Duel.IsExistingTarget(c99980570.movefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,lg) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99980570.movefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,lg)
end
function c99980570.thfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c99980570.moveop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) then return end
  if tc:IsControler(1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
    local seq=tc:GetSequence()
    local flag=0
    for i=0,4 do
      if Duel.CheckLocation(1-tp,LOCATION_MZONE,i) then flag=bit.bor(flag,math.pow(2,i)) end
    end
    if flag==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,571)
    local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)
    local nseq=0
    for i=0,4 do
      if math.pow(2,i+16)==s then
        nseq=i
        break
      end
    end
    if Duel.MoveSequence(tc,nseq)~=0 and tc:GetSummonLocation()==LOCATION_EXTRA
    and Duel.IsExistingMatchingCard(c99980570.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99980570,3)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980570,4))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980570.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
      if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
      end
    end
  end
  if tc:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,571)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    if Duel.MoveSequence(tc,nseq)~=0 and tc:GetSummonLocation()==LOCATION_EXTRA
    and Duel.IsExistingMatchingCard(c99980570.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99980570,3)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980570,4))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980570.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
      if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
      end
    end
  end
end
--(4) Special Summon 2
function c99980570.spfilter2(c,e,tp)
  return c:IsCode(99980110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c99980570.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return  Duel.IsExistingTarget(c99980570.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c99980570.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c99980570.tdfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c99980570.spop2(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
  and Duel.IsExistingMatchingCard(c99980570.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99980570,5)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980570,6))
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980570.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
  end
end