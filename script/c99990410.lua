--SAO Asuna - OS
--Scripted by Raivost
function c99990410.initial_effect(c)
  --Link Summon
  aux.AddLinkProcedure(c,c99990410.linkmatfilter,2,2)
  c:EnableReviveLimit()
  --(1) Excavate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990410,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCountLimit(1,99990410)
  e1:SetCondition(c99990410.excacon)
  e1:SetTarget(c99990410.excatg)
  e1:SetOperation(c99990410.excaop)
  c:RegisterEffect(e1)
  --(2) Piercing
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_PIERCE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e2:SetTarget(c99990410.pirtg)
  c:RegisterEffect(e2)
  --(3) Gain ATK
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990410,1))
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLE_DESTROYED)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990410.atkcon)
  e3:SetTarget(c99990410.atktg)
  e3:SetOperation(c99990410.atkop)
  c:RegisterEffect(e3)
end
c99990410.listed_names={99990020}
--Link Summon
function c99990410.linkmatfilter(c,lc,sumtype,tp)
  return c:IsSetCard(0x999,lc,sumtype,tp) and not c:IsType(TYPE_TUNER,lc,sumtype,tp)
end
--(1) Excavate
function c99990410.excacon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99990410.excafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x999) and c:GetLink()>0
end
function c99990410.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local lg=Duel.GetMatchingGroup(c99990410.excafilter,tp,LOCATION_MZONE,0,c)
  local ct=lg:GetSum(Card.GetLink)
  if chk==0 then 
    if ct<=0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
    local g=Duel.GetDecktopGroup(tp,ct)
    return g:FilterCount(Card.IsAbleToHand,nil)>0
  end
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c99990410.thfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x999) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c99990410.excaop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local lg=Duel.GetMatchingGroup(c99990410.excafilter,tp,LOCATION_MZONE,0,c)
  local ct=lg:GetSum(Card.GetLink)
  if ct<=0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return end
  Duel.ConfirmDecktop(p,ct)
  local g=Duel.GetDecktopGroup(p,ct)
  if g:GetCount()>0 then
    local sg=g:Filter(c99990410.thfilter,nil)
    if sg:GetCount()>0 then
      if sg:GetFirst():IsAbleToHand() then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-p,sg)
        Duel.ShuffleHand(p)
      else
        Duel.SendtoGrave(sg,REASON_EFFECT)
      end
    end
    Duel.ShuffleDeck(p)
  end
end
--(2) Piercing
function c99990410.pirtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x999)
end
--(3) Gain ATK
function c99990410.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c99990410.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990410.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
end