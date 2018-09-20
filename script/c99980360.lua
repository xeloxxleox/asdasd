--HN Dimension Zero
--Scripted by Raivost
function c99980360.initial_effect(c)
  --(1) Destroy 1
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetOperation(c99980360.desop1)
  c:RegisterEffect(e1)
  --(2) Inflict damage
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99980360,4))
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
  e2:SetRange(LOCATION_FZONE)
  e2:SetCode(EVENT_DESTROYED)
  e2:SetCondition(c99980360.damcon)
  e2:SetTarget(c99980360.damtg)
  e2:SetOperation(c99980360.damop)
  c:RegisterEffect(e2)
  --(3) Destroy 2
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(99980360,0))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_FZONE)
  e3:SetCountLimit(1)
  e3:SetCost(c99980360.descost2)
  e3:SetTarget(c99980360.destg2)
  e3:SetOperation(c99980360.desop2)
  c:RegisterEffect(e3)
  --(4) Shuffle
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980360,5))
  e4:SetCategory(CATEGORY_TODECK)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetProperty(EFFECT_FLAG_DELAY)
  e4:SetCode(EVENT_DESTROYED)
  e4:SetCondition(c99980360.tdcon)
  e4:SetTarget(c99980360.tdtg)
  e4:SetOperation(c99980360.tdop)
  c:RegisterEffect(e4)
end
--(1) Destroy 1
function c99980360.desfilter1(c)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c99980360.desop1(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980360,0))
  local g=Duel.GetMatchingGroup(c99980360.desfilter1,tp,LOCATION_ONFIELD,0,nil)
  local ct=Duel.Destroy(g,REASON_EFFECT)
  if ct>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(99980360,1)) then
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980360,2))
    local dr=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if dr<ct then 
      ct=dr
    end
    if ct==1 then
      Duel.Draw(tp,1,REASON_EFFECT)
    else
      local t={}
      for i=1,ct do 
        t[i]=i 
      end
      Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99980360,3))
      local ac=Duel.AnnounceNumber(tp,table.unpack(t))
      Duel.Draw(tp,ac,REASON_EFFECT)
    end
  end
end
--(2) Inflict damage
function c99980360.damcon(e,tp,eg,ep,ev,re,r,rp)
  local dam1=0
  for tc in aux.Next(eg) do
    if tc:IsSetCard(0x998) and tc:IsPreviousLocation(LOCATION_ONFIELD) then
      local dam2=tc:GetAttack()/2
      dam1=dam1+dam2
    end
  end
  if dam1>0 then e:SetLabel(dam1) end
  return dam1>0
end
function c99980360.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local dam=e:GetLabel()
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dam)
end
function c99980360.damop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local dam=e:GetLabel()
  Duel.Damage(tp,dam,REASON_EFFECT,true)
  Duel.Damage(1-tp,dam,REASON_EFFECT,true)
  Duel.RDComplete()
end 
--(3) Destroy 2
function c99980360.descostfilter2(c)
  return c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToRemoveAsCost()
end
function c99980360.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c99980360.descostfilter2,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c99980360.descostfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c99980360.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
  local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99980360.desop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
  if g:GetCount()>0 then
    Duel.HintSelection(g)
    Duel.Destroy(g,REASON_EFFECT)
  end
end
--(4) Shuffle
function c99980360.tdcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousPosition(POS_FACEUP)
end
function c99980360.tdfilter(c)
  return c:IsSetCard(0x998) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToDeck()
end
function c99980360.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local g=Duel.GetMatchingGroup(c99980360.tdfilter,tp,LOCATION_REMOVED,0,nil)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c99980360.tdop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(c99980360.tdfilter,tp,LOCATION_REMOVED,0,nil)
  local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
  if ct>0 then
    Duel.Damage(1-tp,ct*500,REASON_EFFECT)
  end
end