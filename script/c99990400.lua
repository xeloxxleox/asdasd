--SAO Kirito - OS
--Scripted by Raivost
function c99990400.initial_effect(c)
  --Link Summon
  aux.AddLinkProcedure(c,c99990400.linkmatfilter,2,2)
  c:EnableReviveLimit()
  --(1) Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990400,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1,99990400)
  e1:SetCondition(c99990400.thcon)
  e1:SetTarget(c99990400.thtg)
  e1:SetOperation(c99990400.thop)
  c:RegisterEffect(e1)
  --(2) Second attack
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_EXTRA_ATTACK)
  e2:SetCondition(c99990400.sacon)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(3) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990400,3))
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLE_DESTROYED)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990400.atkcon)
  e3:SetTarget(c99990400.atktg)
  e3:SetOperation(c99990400.atkop)
  c:RegisterEffect(e3)
end
c99990400.listed_names={99990010}
--Link Summon
function c99990400.linkmatfilter(c,lc,sumtype,tp)
  return c:IsSetCard(0x999,lc,sumtype,tp) and not c:IsType(TYPE_TUNER,lc,sumtype,tp)
end
--(1) Search
function c99990400.thcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99990400.thfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x999) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99990400.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990400.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99990400.spfilter(c,e,tp,zone)
  return c:IsSetCard(0x999) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c99990400.thop(e,tp,eg,ep,ev,re,r,rp)
  local zone=e:GetHandler():GetLinkedZone(tp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g1=Duel.SelectMatchingCard(tp,c99990400.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g1:GetCount()>0 and Duel.SendtoHand(g1,tp,REASON_EFFECT)>0
    and g1:GetFirst():IsLocation(LOCATION_HAND) then
    Duel.ConfirmCards(1-tp,g1)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c99990400.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) 
    and Duel.SelectYesNo(tp,aux.Stringid(99990400,1)) then
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99990400,2))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
      local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99990400.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
      if g2:GetCount()>0 then
        Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP,zone)
      end
    end
  end  
end
--(2) Second attack
function c99990400.safilter(c)
	return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990400.sacon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c99990400.safilter,1,nil)
end
--(3) Gain ATK
function c99990400.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local des=eg:GetFirst()
  local rc=des:GetReasonCard()
  if des:IsType(TYPE_XYZ) then
    e:SetLabel(des:GetRank()) 
  elseif des:IsType(TYPE_LINK) then
    e:SetLabel(des:GetLink())
  else
    e:SetLabel(des:GetLevel())
  end
  return rc and rc:IsSetCard(0x999) and rc:IsControler(tp) and rc:IsRelateToBattle() and des:IsReason(REASON_BATTLE) 
end
function c99990400.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990400.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end