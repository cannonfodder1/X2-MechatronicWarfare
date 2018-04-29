//--------------------------------------------------------------------------------------- 
//  ORIGINAL FILE:				X2Effect_Resilience
//  ORIGINAL AUTHOR:			John Lumpkin (Pavonis Interactive)
//  SHAMELESSLY STOLEN FROM:	Long War 2
//--------------------------------------------------------------------------------------- 

class X2Effect_Unyielding extends X2Effect_Persistent;

var int CritDef_Bonus;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

	ShotInfo.ModType = eHit_Crit;
	ShotInfo.Reason = FriendlyName;
	ShotInfo.Value = -CritDef_Bonus;
	ShotModifiers.AddItem(ShotInfo);
}

defaultproperties
{
    DuplicateResponse=eDupe_Allow
}
