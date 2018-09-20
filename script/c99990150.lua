--SAO Confront Battle
--Scripted by Raivost
function c99990150.initial_effect(c)
  --(1) Gain ATK/DEF
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990150,0))
  e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
  e1:SetCountLimit(1,99990150+EFFECT_COUNT_CODE_OATH)
  e1:SetCondition(c99990150.atkcon)
  e1:SetTarget(c99990150.atktg)
  e1:SetOperation(c99990150.atkop)
  c:RegisterEffect(e1)
end
function c99990150.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetAttacker()
  local at=Duel.GetAttackTarget()
  if not at or tc:IsFacedown() or at:IsFacedown() then return false end
  if tc:IsControler(1-tp) then tc=at end
  e:SetLabelObject(tc)
  return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:IsSetCard(0x999)
end
function c99990150.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990150.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=e:GetLabelObject()
  if tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(tc:GetBaseAttack()/2)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_DEFENCE)
    e2:SetValue(tc:GetBaseDefense()/2)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
    tc:RegisterFlagEffect(99990150,RESET_EVENT+0x1620000+RESET_PHASE+PHASE_END,0,1)
    --(1.1) Draw
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetDescription(aux.Stringid(99990150,1))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetLabelObject(tc)
    e3:SetCondition(c99990150.drcon)
    e3:SetTarget(c99990150.drtg)
    e3:SetOperation(c99990150.drop)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
  end
end
--(1.1) Draw
function c99990150.drcon(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  return eg:IsContains(tc) and tc:GetFlagEffect(99990150)~=0
end
function c99990150.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99990150.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end