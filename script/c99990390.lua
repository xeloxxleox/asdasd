--SAO Hidden Potential Leafa - ALO
--Scripted by Raivost
function c99990390.initial_effect(c)
  --Synchro Summon
  aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(Card.IsSetCard,0x999),1,1)
  c:EnableReviveLimit()
  --(1) Gain LP
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990390,0))
  e1:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetCondition(c99990390.reccon)
  e1:SetTarget(c99990390.rectg)
  e1:SetOperation(c99990390.recop)
  c:RegisterEffect(e1)
  --(2) Shuffle
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990390,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c99990390.tdtg)
  e2:SetOperation(c99990390.tdop)
  c:RegisterEffect(e2)
  --(3) Gain ATK/DEF
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990390,2))
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLE_DESTROYED)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990390.atkcon)
  e3:SetTarget(c99990390.atktg)
  e3:SetOperation(c99990390.atkop)
  c:RegisterEffect(e3)
end
--(1) Gain LP
function c99990390.reccon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99990390.recfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:GetAttack()>0
end
function c99990390.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99990390.recfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99990390.recfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack()/2)
end
function c99990390.recop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
    local rec=Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
    if c:IsRelateToEffect(e) and c:IsFaceup() and rec>0 then
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(rec/2)
      e1:SetReset(RESET_EVENT+0x1ff0000)
      c:RegisterEffect(e1)
    end  
  end
end
--(2) Shuffle
function c99990390.tdfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x999)  and c:IsAbleToDeck()
end
function c99990390.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c99990390.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c99990390.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99990390.tdop(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
  if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=1 then return end
  Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
  local g=Duel.GetOperatedGroup()
  if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
  local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
  if ct==1 then
    Duel.Draw(tp,1,REASON_EFFECT)
  end
end
--(3) Gain ATK/DEF
function c99990390.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c99990390.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990390.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(e:GetLabel()*100)
  e1:SetReset(RESET_EVENT+0x1ff0000)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e2)
end