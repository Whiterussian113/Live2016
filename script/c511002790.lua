--Armored Back
function c511002790.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c511002790.condition)
	e1:SetTarget(c511002790.target)
	e1:SetOperation(c511002790.activate)
	c:RegisterEffect(e1)
end
function c511002790.cfilter(c,tp)
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec and ec:GetPreviousControler()==tp 
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA) and ec:IsLocation(LOCATION_GRAVE)
end
function c511002790.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511002790.cfilter,nil,tp)
	return g:GetCount()==1
end
function c511002790.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c511002790.cfilter,nil,tp)
	local tc=g:GetFirst():GetPreviousEquipTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and tc and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(tc)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c511002790.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=eg:Filter(c511002790.cfilter,nil,tp)
	local tc=g:GetFirst()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local ec=tc:GetPreviousEquipTarget()
	if not ec or not ec:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(ec,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Equip(tp,tc,ec)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		ec:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		ec:RegisterEffect(e2)
	end
end
