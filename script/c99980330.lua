--HN Rank-Up-Magic CPU Memory
--Scripted by Raivost
function c99980330.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99980330,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c99980330.sptg)
  e1:SetOperation(c99980330.spop)
  c:RegisterEffect(e1)
  end
function c99980330.spfilter1(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_XYZ) and c:GetRank()==4 and Duel.GetLocationCountFromEx(tp,tp,c)>0
  and Duel.IsExistingMatchingCard(c99980330.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
end
function c99980330.spfilter2(c,e,tp,mc,rk)
  if c.rum_limit and not c.rum_limit(mc,e) then return false end
  return c:GetRank()==rk and c:IsSetCard(0x998) and mc:IsCanBeXyzMaterial(c)
  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c99980330.attachfilter(c)
  return c:IsSetCard(0x998) and c:IsType(TYPE_MONSTER)
end
function c99980330.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c99980330.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c99980330.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99980330.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
  if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c99980330.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
  local sc=g:GetFirst()
  if sc then
    local mg=tc:GetOverlayGroup()
    if mg:GetCount()~=0 then
      Duel.Overlay(sc,mg)
    end
    sc:SetMaterial(Group.FromCards(tc))
    Duel.Overlay(sc,Group.FromCards(tc))
    Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
    if Duel.IsExistingTarget(c99980330.attachfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(99980330,1)) then 
      Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(99980330,2))
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
      local mg2=Duel.SelectTarget(tp,aux.NecroValleyFilter(c99980330.attachfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
      if mg2:GetCount()==0 then return end
      local sc2=mg2:GetFirst()
      if sc2 then
        Duel.Overlay(sc,mg2)
      end
    end
  sc:CompleteProcedure()
  end
end