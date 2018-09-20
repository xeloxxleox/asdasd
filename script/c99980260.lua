--HN CFW Magic
--Scripted by Raivost
function c99980260.initial_effect(c)
  --Xyz Summon
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x998),4,2)
  c:EnableReviveLimit()
  --(1) Destroy
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980260,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1)
  e1:SetCost(c99980260.descost)
  e1:SetTarget(c99980260.destg)
  e1:SetOperation(c99980260.desop)
  c:RegisterEffect(e1)
  --(2) Gain effects
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(c99980260.gecon)
  e2:SetOperation(c99980260.geop)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_MATERIAL_CHECK)
  e3:SetValue(c99980260.valcheck)
  e3:SetLabelObject(e2)
  c:RegisterEffect(e3)
  --(3) Gain ATK
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_UPDATE_ATTACK)
  e4:SetValue(c99980260.atkvalue)
  e4:SetCondition(c99980260.atkcon)
  c:RegisterEffect(e4)
  --(4) Gain LP
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(99980260,2))
  e5:SetCategory(CATEGORY_RECOVER)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e5:SetCode(EVENT_BATTLE_DESTROYING)
  e5:SetCondition(c99980260.reccon)
  e5:SetTarget(c99980260.rectg)
  e5:SetOperation(c99980260.recop)
  c:RegisterEffect(e5)
  --(5) To hand
  local e6=Effect.CreateEffect(c)
  e6:SetDescription(aux.Stringid(99980260,3))
  e6:SetCategory(CATEGORY_TOHAND)
  e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
  e6:SetCode(EVENT_TO_GRAVE)
  e6:SetTarget(c99980260.thtg)
  e6:SetOperation(c99980260.thop)
  c:RegisterEffect(e6)
end
--(1) Destroy
function c99980260.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99980260.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
  local dam=g:GetFirst():GetAttack()/2
  if dam<0 then dam=0 end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c99980260.desop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
    local dam=tc:GetAttack()/2
    if dam<0 then dam=0 end
    if Duel.Destroy(tc,REASON_EFFECT)~=0 then
      Duel.Damage(1-tp,dam,REASON_EFFECT)
    end
  end
end
--(2) Gain effects
function c99980260.gecon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetLabel()==1
end
function c99980260.geop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  c:RegisterFlagEffect(99980260,RESET_EVENT+0x1fe0000,0,1)
  c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99980260,1))
  c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99980260,2))
end
function c99980260.valcheck(e,c)
  local g=c:GetMaterial()
  if g:IsExists(Card.IsCode,1,nil,99980250) then
    e:GetLabelObject():SetLabel(1)
  else
    e:GetLabelObject():SetLabel(0)
  end
end
--(3) Gain ATK
function c99980260.atkcon(e)
  return e:GetHandler():GetFlagEffect(99980260)>0
end
function c99980260.atkfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980260.atkvalue(e,c)
  local g=Duel.GetMatchingGroup(c99980260.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
  local ct=g:GetClassCount(Card.GetCode)
  return ct*100
end
--(4) Gain LP
function c99980260.reccon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER) and e:GetHandler():GetFlagEffect(99980260)>0
end
function c99980260.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local rec=e:GetHandler():GetBattleTarget():GetBaseAttack()/2
  if rec<0 then rec=0 end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(rec)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c99980260.recop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end
--(5) To hand
function c99980260.thfilter(c)
  return c:IsCode(99980250) and c:IsAbleToHand()
end
function c99980260.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980260.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c99980260.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c99980260.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end