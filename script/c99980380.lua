--HN Candidate's Training
--Scripted by Raivost
function c99980380.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980380,0))
  e1:SetCategory(CATEGORY_ATKCHANGE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c99980380.attachtg)
  e1:SetOperation(c99980380.attachop)
  c:RegisterEffect(e1)
end
function c99980380.attachfilter1(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsRankBelow(4)
  and Duel.IsExistingMatchingCard(c99980380.attachfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c)
end
function c99980380.attachfilter2(c)
  return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x998) 
  and (c:GetLevel()==3 or c:GetLevel()==4) and not c:IsType(TYPE_TOKEN)
end
function c99980380.attachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99980380.attachfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  Duel.SelectTarget(tp,c99980380.attachfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99980380.attachop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c99980380.attachfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,tc)
    if g:GetCount()>0 and Duel.Overlay(tc,g)~=0 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_UPDATE_ATTACK)
      e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
      e1:SetValue(tc:GetOverlayCount()*200)
      e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
      tc:RegisterEffect(e1)
    end
  end
end