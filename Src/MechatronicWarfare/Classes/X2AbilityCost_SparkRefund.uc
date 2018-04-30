// Original concept taken from the Spark Puglist Class mod
class X2AbilityCost_SparkRefund extends X2AbilityCost_ActionPoints;

var name RefundedActionPointType;

simulated function ApplyCost(XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local XComGameState_Unit ModifiedUnitState;
	local XComGameState_Unit TargetUnit;

	super.ApplyCost(AbilityContext, kAbility, AffectState, AffectWeapon, NewGameState);

	ModifiedUnitState = XComGameState_Unit(AffectState);

	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (TargetUnit != none)
	{
		ModifiedUnitState.ActionPoints.AddItem(RefundedActionPointType);
	}	
}
