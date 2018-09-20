--HN CPU Xmas
--Scripted by Raivost
function c99980280.initial_effect(c)
  --(1) Draw
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980280,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99980280+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99980280.drcon)
  e1:SetTarget(c99980280.drtg)
  e1:SetOperation(c99980280.drop)
  c:RegisterEffect(e1)
end
--(1) Draw
function c99980280.drconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980280.drcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99980280.drconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99980280.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99980280.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
  local tc=Duel.GetOperatedGroup():GetFirst()
  Duel.ConfirmCards(1-tp,tc)
  if (tc:IsSetCard(0x998) and tc:IsType(TYPE_MONSTER)) and Duel.SelectYesNo(tp,aux.Stringid(99980280,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Draw(tp,1,REASON_EFFECT)
  end
  Duel.ShuffleHand(tp)
end