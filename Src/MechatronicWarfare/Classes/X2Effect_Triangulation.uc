class X2Effect_Triangulation extends X2Effect_Persistent;

var name Triangulation_TriggeredName;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Defender, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local XComGameState		NewGameState;

	`log("TRIANGULATION FUNCTION CALLED");
	if (Defender.ControllingPlayer != Attacker.ControllingPlayer)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Triangulation: Apply Effect");
    
        `XEVENTMGR.TriggerEvent(default.Triangulation_TriggeredName, Attacker, Defender, NewGameState);
        `log("TRIGGERED TRIANGULATION EVENT");

        `GAMERULES.SubmitGameState(NewGameState);
	}
	return false;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Triangulation"
	Triangulation_TriggeredName = "Triangulation_Triggered"
}