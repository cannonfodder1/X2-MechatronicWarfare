class X2StrategyElement_TechsMW extends X2StrategyElement config(StrategyTuning);

var config int EXPERIENCED_SPARK_LEVEL;

var config int EXP_SPARK_CORES;
var config int EXP_SPARK_SUPPLIES;
var config int EXP_SPARK_ALLOYS;
var config int EXP_SPARK_ELERIUM;

var config int REBUILD_SPARK_SUPPLIES;

var config int REPAIRBAY_SUPPLIES;
var config int REPAIRBAY_ALLOYS;
var config int REPAIRBAY_ELERIUM;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	Techs.AddItem(CreateBuildCaptainSparkTemplate());
	Techs.AddItem(CreateRebuildSPARKTemplate());
	Techs.AddItem(CreateExpandRepairBayTemplate());

	return Techs;
}

static function int StafferXDays(int iNumScientists, int iNumDays)
{
	return (iNumScientists * 5) * (24 * iNumDays); // Scientists at base skill level
}

static function X2DataTemplate CreateBuildCaptainSparkTemplate()
{
	local X2TechTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BuildExpSpark');
	Template.PointsToComplete = StafferXDays(1, 18);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";

	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.ResearchCompletedFn = CreateCaptainSparkSoldier;
	
	// Narrative Requirements
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyAndromedon');

	// Non Narrative Requirements
	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyAndromedon');
	Template.AlternateRequirements.AddItem(AltReq);
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.EXP_SPARK_SUPPLIES; //75
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.EXP_SPARK_ALLOYS; //30
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.EXP_SPARK_ELERIUM; //15
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = default.EXP_SPARK_CORES; //1
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function CreateCaptainSparkSoldier(XComGameState NewGameState, optional XComGameState_Tech SparkCreatorTech)
{
	local XComGameStateHistory History;
	local XComOnlineProfileSettings ProfileSettings;
	local X2CharacterTemplateManager CharTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit NewSparkState;
	local int NewRank, idx;

	CreateCaptainSparkTrooper(NewGameState, SparkCreatorTech);

	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	}

	// Create a Spark from the Character Pool (will be randomized if no Sparks have been created)
	ProfileSettings = `XPROFILESETTINGS;
	NewSparkState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, ProfileSettings.Data.m_eCharPoolUsage, 'SparkSoldier');
	NewSparkState.RandomizeStats();
	NewSparkState.ApplyInventoryLoadout(NewGameState);
	
	// Make sure the new Spark has the best gear available (will also update to appropriate armor customizations)
	NewSparkState.ApplySquaddieLoadout(NewGameState);
	NewSparkState.ApplyBestGearLoadout(NewGameState);

	NewSparkState.kAppearance.nmPawn = 'XCom_Soldier_Spark';
	NewSparkState.kAppearance.iAttitude = 2; // Force the attitude to be Normal
	NewSparkState.UpdatePersonalityTemplate(); // Grab the personality based on the one set in kAppearance
	NewSparkState.SetStatus(eStatus_Active);
	NewSparkState.bNeedsNewClassPopup = false;
	
	// Set the SPARK to a higher rank than normal
	NewRank = default.EXPERIENCED_SPARK_LEVEL;
	NewSparkState.SetXPForRank(NewRank);
	NewSparkState.StartingRank = NewRank;
	for (idx = 1; idx < NewRank; idx++)
	{
		NewSparkState.RankUpSoldier(NewGameState, NewSparkState.GetSoldierClassTemplate().DataName);
	}

	XComHQ.AddToCrew(NewGameState, NewSparkState);

	if (SparkCreatorTech != none)
	{
		SparkCreatorTech.UnitRewardRef = NewSparkState.GetReference();
	}
}

// Huge thanks to RealityMachina for allowing me to include the Rebuild SPARK project from his Metal Over Flesh mod
static function X2DataTemplate CreateRebuildSPARKTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local StrategyRequirement AltReq;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'RebuildSPARK');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.SortingTier = 2;
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.ResearchCompletedFn = CreateRebuiltSparkSoldier;

	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;

	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	Template.AlternateRequirements.AddItem(AltReq);

	//resource cost
	Resources.ItemTemplateName = 'CorpseSPARK';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.REBUILD_SPARK_SUPPLIES; //50
	Template.Cost.ResourceCosts.AddItem(Resources);


	return Template;
}

function CreateRebuiltSparkSoldier(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local StateObjectReference		DeadSpark;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	DeadSpark = GetDeadSpark(XComHQ, NewGameState);

	if(DeadSpark.ObjectID > 0)
		RemakeSparkSoldier(NewGameState, DeadSpark, TechState);

	if(DeadSpark.ObjectID <= 0)
		class'X2Helpers_DLC_Day90'.static.CreateSparkSoldier(NewGameState, , TechState);

	UnlockFirstRepairSlot(NewGameState, TechState);
}

function StateObjectReference GetDeadSpark(XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState)
{
	local int i;
	local StateObjectReference DeadCrew, SparkToRevive;
	local array<StateObjectReference> DeadSparks;
	local XComGameState_Unit UnitState;
	
	foreach XComHQ.DeadCrew(DeadCrew)
	{
		UnitState = XComGameState_Unit(`XCOMHistory.GetGameStateForObjectID(DeadCrew.ObjectID ));

		if(UnitState.GetMyTemplateName() == 'SparkSoldier')
		{
		DeadSparks.AddItem(DeadCrew);
		}

	}

	if(DeadSparks.Length > 0) 
	{
	i = `SYNC_RAND(DeadSparks.Length);

	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	XComHQ.DeadCrew.RemoveItem(DeadSparks[i]);
	SparkToRevive = DeadSparks[i];

	return SparkToRevive;
	}

	if(DeadSparks.Length <= 0)
		return SparkToRevive;
}


function RemakeSparkSoldier(XComGameState NewGameState, optional StateObjectReference CopiedSpark, optional XComGameState_Tech SparkCreatorTech)
{
	local XComGameStateHistory History;
	local XComOnlineProfileSettings ProfileSettings;
	local X2CharacterTemplateManager CharTemplateMgr;
	local X2CharacterTemplate CharacterTemplate;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit NewSparkState, CopiedSparkState;
	local int i, SparkRank;

	History = class'XComGameStateHistory'.static.GetGameStateHistory();

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
	}

	CopiedSparkState = XComGameState_Unit(History.GetGameStateForObjectID(CopiedSpark.ObjectID));

	// Either copy lost towers unit or generate a new unit from the character pool
	if(CopiedSparkState != none)
	{
		CharTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
		CharacterTemplate = CharTemplateMgr.FindCharacterTemplate('SparkSoldier');

		NewSparkState = CharacterTemplate.CreateInstanceFromTemplate(NewGameState);
		NewSparkState.SetTAppearance(CopiedSparkState.kAppearance);
		NewSparkState.SetCharacterName(CopiedSparkState.GetFirstName(), CopiedSparkState.GetLastName(), CopiedSparkState.GetNickName());
		NewSparkState.SetCountry(CopiedSparkState.GetCountry());

		// Thanks to TeslaRage for this method to rank up the spark to it's original rank!
		SparkRank = CopiedSparkState.GetRank();
		for (i = 0; i < SparkRank - 1; i++)
		{
			NewSparkState.RankUpSoldier(NewGameState);
		}
		NewSparkState.SetXPForRank(SparkRank);

		NewSparkState.CopyKills(CopiedSparkState);
		NewSparkState.CopyKillAssists(CopiedSparkState);
		NewSparkState.RandomizeStats();
		NewSparkState.ApplyInventoryLoadout(NewGameState);
	}
	else
	{
		// Create a Spark from the Character Pool (will be randomized if no Sparks have been created)
		ProfileSettings = XComOnlineProfileSettings(class'Engine'.static.GetEngine().GetProfileSettings());
		NewSparkState = CharacterPoolManager(class'Engine'.static.GetEngine().GetCharacterPoolManager()).CreateCharacter(NewGameState, ProfileSettings.Data.m_eCharPoolUsage, 'SparkSoldier');
		NewSparkState.RandomizeStats();
		NewSparkState.ApplyInventoryLoadout(NewGameState);
	}
	
	// Make sure the new Spark has the best gear available (will also update to appropriate armor customizations)
	NewSparkState.ApplySquaddieLoadout(NewGameState);
	NewSparkState.ApplyBestGearLoadout(NewGameState);

	NewSparkState.kAppearance.nmPawn = 'XCom_Soldier_Spark';
	NewSparkState.kAppearance.iAttitude = 2; // Force the attitude to be Normal
	NewSparkState.UpdatePersonalityTemplate(); // Grab the personality based on the one set in kAppearance
	NewSparkState.SetStatus(eStatus_Active);
	NewSparkState.bNeedsNewClassPopup = false;
	NewGameState.AddStateObject(NewSparkState);

	XComHQ.AddToCrew(NewGameState, NewSparkState);

	if (SparkCreatorTech != none)
	{
		SparkCreatorTech.UnitRewardRef = NewSparkState.GetReference();
	}
}

static function X2DataTemplate CreateExpandRepairBayTemplate()
{
	local X2TechTemplate Template;
	local StrategyRequirement AltReq;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ExpandRepairBay');
	Template.PointsToComplete = StafferXDays(1, 10);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";

	Template.bProvingGround = true;
	Template.bRepeatable = false;
	Template.ResearchCompletedFn = UnlockSecondRepairSlot;
	
	// Narrative Requirements
	Template.Requirements.SpecialRequirementsFn = class'X2Helpers_DLC_Day90'.static.IsLostTowersNarrativeContentComplete;
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');

	// Non Narrative Requirements
	AltReq.RequiredTechs.AddItem('MechanizedWarfare');
	AltReq.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.AlternateRequirements.AddItem(AltReq);
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.REPAIRBAY_SUPPLIES; //25
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.REPAIRBAY_ALLOYS; //15
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.REPAIRBAY_ELERIUM; //5
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function UnlockSecondRepairSlot(XComGameState NewGameState, XComGameState_Tech TechState)
{
    local XComGameState_StaffSlot StaffSlotState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom Facility;
    local int i;

    XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	Facility = XComHQ.GetFacilityByName('Storage');

    for (i = 0; i < Facility.StaffSlots.Length; i++)
    {
        StaffSlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(Facility.StaffSlots[i].ObjectID));
        if (StaffSlotState.IsLocked() && StaffSlotState.GetMyTemplateName() == 'SparkStaffSlot2')
        {
            StaffSlotState = XComGameState_StaffSlot(NewGameState.ModifyStateObject(class'XComGameState_StaffSlot', Facility.StaffSlots[i].ObjectID));
            StaffSlotState.UnlockSlot();
			//`log("SECOND SLOT UNLOCKED");
            return;
        }
    }
}

static function UnlockFirstRepairSlot(XComGameState NewGameState, XComGameState_Tech TechState)
{
    local XComGameState_StaffSlot StaffSlotState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom Facility;
    local int i;

    XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	Facility = XComHQ.GetFacilityByName('Storage');

    for (i = 0; i < Facility.StaffSlots.Length; i++)
    {
        StaffSlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(Facility.StaffSlots[i].ObjectID));
        if (StaffSlotState.IsLocked() && StaffSlotState.GetMyTemplateName() == 'SparkStaffSlot')
        {
            StaffSlotState = XComGameState_StaffSlot(NewGameState.ModifyStateObject(class'XComGameState_StaffSlot', Facility.StaffSlots[i].ObjectID));
            StaffSlotState.UnlockSlot();
			//`log("FIRST SLOT UNLOCKED");
            return;
        }
    }
}

static function CreateSparkTrooperAndEquipment(XComGameState NewGameState, XComGameState_Tech TechState)
{	
	class'X2Helpers_DLC_Day90'.static.CreateSparkEquipment(NewGameState);
	CreateSparkTrooper(NewGameState, TechState);
}

static function CreateSparkTrooper(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_CampaignSettings CampaignSettings;
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	if (CampaignSettings.HasIntegratedDLCEnabled() && XComHQ.IsTechResearched('BuildSpark') || XComHQ.IsTechResearched('BuildExpSpark'))
	{
		// The first time a Spark is built in DLC Integrated XPack games, create the necessary Spark gear for XComHQ
		class'X2Helpers_DLC_Day90'.static.CreateSparkEquipment(NewGameState);
	}

	class'X2Helpers_DLC_Day90'.static.CreateSparkSoldier(NewGameState, , TechState);

	UnlockFirstRepairSlot(NewGameState, TechState);
}

static function CreateCaptainSparkTrooper(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_CampaignSettings CampaignSettings;
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	if (CampaignSettings.HasIntegratedDLCEnabled() && XComHQ.IsTechResearched('BuildSpark') || XComHQ.IsTechResearched('BuildExpSpark'))
	{
		// The first time a Spark is built in DLC Integrated XPack games, create the necessary Spark gear for XComHQ
		class'X2Helpers_DLC_Day90'.static.CreateSparkEquipment(NewGameState);
	}

	UnlockFirstRepairSlot(NewGameState, TechState);
}