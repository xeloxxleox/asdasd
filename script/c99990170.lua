--SAO Klein SAO
--Scripted by Raivost
function c99990170.initial_effect(c)
  --(1) Gain ATK
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetRange(LOCATION_MZONE)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
  e1:SetValue(c99990170.atkval1)
  c:RegisterEffect(e1)
  --(2) Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990170,0))
  e2:SetCategory(CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_BATTLE_DESTROYED)
  e2:SetTarget(c99990170.drtg)
  e2:SetOperation(c99990170.drop)
  c:RegisterEffect(e2)
  --(3) Gain ATK/DEF
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99990170,1))
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_BATTLE_DESTROYED)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c99990170.atkcon)
  e3:SetTarget(c99990170.atktg)
  e3:SetOperation(c99990170.atkop)
  c:RegisterEffect(e3)
end
--(1) Gain ATK
function c99990170.atkfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x999)
end
function c99990170.atkval1(e,c)
  return Duel.GetMatchingGroupCount(c99990170.atkfilter1,c:GetControler(),LOCATION_MZONE,0,c)*200
end
--(2) Draw
function c99990170.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99990170.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
--(3) Gain ATK/DEF
function c99990170.atkcon(e,tp,eg,ep,ev,re,r,rp)
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
function c99990170.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c99990170.atkop(e,tp,eg,ep,ev,re,r,rp)
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