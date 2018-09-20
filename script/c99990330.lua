--SAO - Journey's End
function c99990330.initial_effect(c)
  --(1) Activate effect
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990330+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(c99990330.aecost)
  e1:SetTarget(c99990330.aetg)
  e1:SetOperation(c99990330.aeop)
  c:RegisterEffect(e1)
end
function c99990330.aecostfilter(c)
  return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99990330.aecost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99990330.aecostfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c99990330.aecostfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
  e:SetLabel(g:GetFirst():GetAttack())
  Duel.SendtoGrave(g,REASON_COST)
end
function c99990330.atkfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x999) and c:IsType(TYPE_MONSTER)
end
function c99990330.aetg(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=Duel.IsExistingMatchingCard(c99990330.atkfilter,tp,LOCATION_MZONE,0,1,nil)
  local b2=Duel.IsPlayerCanDraw(tp,2)
  if chk==0 then return b1 or b2 end
  local op=0
  if b1 and b2 then
    op=Duel.SelectOption(tp,aux.Stringid(99990330,0),aux.Stringid(99990330,1))
  elseif b1 then
    op=Duel.SelectOption(tp,aux.Stringid(99990330,0))
  else
    op=Duel.SelectOption(tp,aux.Stringid(99990330,1))+1
  end
  if op==0 then
    e:SetCategory(CATEGORY_ATKCHANGE)
  else
    e:SetCategory(CATEGORY_DRAW)
  end
  Duel.SetTargetParam(e:GetLabel())
  e:SetLabel(op)
end    
function c99990330.aeop(e,tp,eg,ep,ev,re,r,rp)
  local op=e:GetLabel()
  if op==0 then
    local dr=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
    local g=Duel.GetMatchingGroup(c99990330.atkfilter,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetValue(dr/2)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
    end
  else
    Duel.Draw(tp,2,REASON_EFFECT)
  end
end