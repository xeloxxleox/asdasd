--HN Falcom
--Scripted by Raivost
function c99980600.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Pendulum Effects
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980600,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCondition(c99980600.descon)
  e1:SetTarget(c99980600.destg)
  e1:SetOperation(c99980600.desop)
  c:RegisterEffect(e1)
  --Monster Effects
  --(1) Search
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980600,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e2:SetCondition(c99980600.thcon)
  e2:SetTarget(c99980600.thtg)
  e2:SetOperation(c99980600.thop)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e3)
end
--Pendulum Effects
--(1) Destroy
function c99980600.desconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:GetSummonType()==SUMMON_TYPE_XYZ and c:GetSummonPlayer()==tp 
end
function c99980600.descon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980600.desconfilter,1,nil,tp) and eg:GetCount()==1
end
function c99980600.desfilter(c,atk)
  return c:IsFaceup() and c:GetAttack()<atk
end
function c99980600.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local tc=eg:GetFirst()
  if chk==0 then return Duel.IsExistingTarget(c99980600.desfilter,tp,0,LOCATION_MZONE,1,nil,tc:GetAttack()) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,c99980600.desfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetAttack())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99980600.desop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
    Duel.Destroy(tc,REASON_EFFECT)
  end
end
--Monster Effects
--(1) Search
function c99980600.thconfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:GetLevel()==4 and not c:IsCode(99980600)
end
function c99980600.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c99980600.thconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99980600.thfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsLevelBelow(4) and Duel.IsExistingMatchingCard(c99980600.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetOriginalLevel())
end
function c99980600.thfilter2(c,lvl)
  return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x998) and c:GetLevel()<lvl
end
function c99980600.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99980600.thfilter1,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99980600.thfilter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
  local lvl=g:GetFirst():GetOriginalLevel()
  e:SetLabel(lvl)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99980600.thop(e,tp,eg,ep,ev,re,r,rp)
  local lvl=e:GetLabel()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980600.thfilter2,tp,LOCATION_DECK,0,1,1,nil,lvl)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end