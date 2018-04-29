// This file takes requests from the RepairMW ability and checks what's in the caster's armor slot,
// then tells the ability how many charges of Repair the caster should have

class X2AbilityCharges_Repair extends X2AbilityCharges config(GameData_SoldierSkills);

var config int T1_CHARGES;
var config int T2_CHARGES;
var config int T3_CHARGES;
var config int UNYIELDING_REPAIR;

simulated function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
	local X2GremlinTemplate				SparkBITTemplate;
	local XComGameState_Item			BITState;
	local XComGameState_Unit			UnitState;
	local XComGameStateHistory			History;
	local int							RepairCharges;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	BITState = UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon);
	SparkBITTemplate = X2GremlinTemplate(BITState.GetMyTemplate());

	if (SparkBITTemplate != none)
	{
		if (SparkBITTemplate.GetItemFriendlyNameNoStats() == "SPARK BIT")
		{
			RepairCharges = default.T1_CHARGES;
			`log("T1 SparkBIT detected, applying T1_CHARGES to Repair ability");
		}
		else if (SparkBITTemplate.GetItemFriendlyNameNoStats() == "Plated BIT")
		{
			RepairCharges = default.T2_CHARGES;
			`log("T2 SparkBIT detected, applying T2_CHARGES to Repair ability");
		}
		else if (SparkBITTemplate.GetItemFriendlyNameNoStats() == "Powered BIT")
		{
			RepairCharges = default.T3_CHARGES;
			`log("T3 SparkBIT detected, applying T3_CHARGES to Repair ability");
		}
		else
		{
			`log("ERROR! Unrecognized SparkBIT detected, applying T2_CHARGES to Repair ability");
			RepairCharges = default.T2_CHARGES;
		}
	}

	if (UnitState.HasSoldierAbility('Unyielding'))
	{
		RepairCharges += default.UNYIELDING_REPAIR;
		`log("SPARK has Unyielding, granting extra Repair charges");
	}

	return RepairCharges;
}
