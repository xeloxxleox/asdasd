--HN Gust
--Scripted by Raivost
function c99980390.initial_effect(c)
  --(1) Copy effect
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980390,0))
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetRange(LOCATION_HAND)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980390)
  e1:SetCost(c99980390.cpcost)
  e1:SetTarget(c99980390.cptg)
  e1:SetOperation(c99980390.cpop)
  c:RegisterEffect(e1)
end
--(1) Copy effect
function c99980390.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c99980390.cpfilter(c)
  return c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL and c:CheckActivateEffect(false,true,false)~=nil
end
function c99980390.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then
    local te=e:GetLabelObject()
    local tg=te:GetTarget()
    return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
  end
  if chk==0 then return Duel.IsExistingTarget(c99980390.cpfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectMatchingCard(tp,c99980390.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
  Duel.ConfirmCards(1-tp,g)
  local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
  Duel.ClearTargetCard()
  g:GetFirst():CreateEffectRelation(e)
  local tg=te:GetTarget()
  if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
  te:SetLabelObject(e:GetLabelObject())
  e:SetLabelObject(te)
end
function c99980390.cpop(e,tp,eg,ep,ev,re,r,rp)
  local te=e:GetLabelObject()
  if not te then return end
  if not te:GetHandler():IsRelateToEffect(e) then return end
  e:SetLabelObject(te:GetLabelObject())
  local op=te:GetOperation()
  if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
