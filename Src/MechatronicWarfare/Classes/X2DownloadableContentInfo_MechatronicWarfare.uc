class X2DownloadableContentInfo_MechatronicWarfare extends X2DownloadableContentInfo dependson(X2Character) config(UpdateSpark);

var config bool SPARK_CANNON_BREAKTHROUGH;

`define GETTECH(TECHNAME) X2TechTemplate(ElementManager.FindStrategyElementTemplate('`TECHNAME'))
`define IFGETTECH(TECHNAME) CannonTech=`GETTECH(`TECHNAME); if (CannonTech!=None)

`define GETITEM(ITEMNAME) X2GremlinTemplate(ItemManager.FindItemTemplate('`ITEMNAME'))
`define IFGETITEM(ITEMNAME) Bit=`GETITEM(`ITEMNAME); IF (bit!=None)
`define FIXBIT(ITEMNAME, BONUSNAME) `IFGETITEM(`ITEMNAME){Bit.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Hacking, class'X2Item_DLC_Day90Weapons'.default.`BONUSNAME);}

static event OnLoadedSavedGameToStrategy()
{
	PatchSparkTechs();
	PatchSparkSlots();
	PatchBreakthrough();
	PatchBondmates();
	PatchSparkBonding();

	OnExitPostMissionSequence();
}

static event OnPostTemplatesCreated()
{
	PatchSparkItemT2Arm();
	PatchSparkItemT2Wep();
	PatchSparkItemT2Bit();
	PatchSparkItemT3Arm();
	PatchSparkItemT3Wep();
	PatchSparkItemT3Bit();

	PatchSparkBuildT2Arm();
	PatchSparkBuildT2Wep();
	PatchSparkBuildT2Bit();
	PatchSparkBuildT3Arm();
	PatchSparkBuildT3Wep();
	PatchSparkBuildT3Bit();
	
	PatchSquadBuildT2Arm();
	PatchSquadBuildT2Wep();
	PatchSquadBuildT2Grem();
	PatchSquadBuildT3Arm();
	PatchSquadBuildT3Wep();
	PatchSquadBuildT3Grem();

	PatchRepairFacility();
	PatchCreateSpark();
	PatchMechWar();
}

//================================================================================================================
// ITEMS
//================================================================================================================

static function PatchSparkItemT2Arm()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('PlatedSparkArmor');
	
	// Change the schematic that creates this item from the Reinforced Frame schematic to the Predator Armor schematic
	Template.CreatorTemplateName = 'MediumPlatedArmor_Schematic';
	`log("Spark T2 Armour Patched");
}

static function PatchSparkItemT2Wep()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('SparkRifle_MG');

	// Change the schematic that creates this item from the Helix Autocannon schematic to the Mag Cannon schematic
	Template.CreatorTemplateName = 'Cannon_MG_Schematic';
	`log("Spark T2 Weapon Patched");
}

static function PatchSparkItemT2Bit()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('SparkBit_MG');

	// Change the schematic that creates this item from the Reinforced Frame schematic to the Gremlin MK2 schematic
	Template.CreatorTemplateName = 'Gremlin_MG_Schematic';
	`log("Spark T2 BIT Patched");
}

static function PatchSparkItemT3Arm()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('PoweredSparkArmor');
	
	// Change the schematic that creates this item from the Anodized Chassis schematic to the Warden Armor schematic
	Template.CreatorTemplateName = 'MediumPoweredArmor_Schematic';
	`log("Spark T3 Armour Patched");
}

static function PatchSparkItemT3Wep()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('SparkRifle_BM');
	
	// Change the schematic that creates this item from the Elerium Phase-Cannon schematic to the Beam Cannon schematic
	Template.CreatorTemplateName = 'Cannon_BM_Schematic';
	`log("Spark T3 Weapon Patched");
}

static function PatchSparkItemT3Bit()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('SparkBit_BM');
	
	// Change the schematic that creates this item from the Anodized Chassis schematic to the Gremlin MK3 schematic
	Template.CreatorTemplateName = 'Gremlin_BM_Schematic';
	`log("Spark T3 BIT Patched");
}

//================================================================================================================
// SCHEMATICS
//================================================================================================================

static function PatchSparkBuildT2Arm()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('PlatedSparkArmor_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('PlatedSparkArmor_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Armor_Mk2";
		}
	}
	`log("Spark T2 Armour Schematic Patched");
}

static function PatchSparkBuildT2Wep()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('SparkRifle_MG_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('SparkRifle_MG_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Cannon_Mk2";
		}
	}
	`log("Spark T2 Weapon Schematic Patched");
}

static function PatchSparkBuildT2Bit()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('SparkBit_MG_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('SparkBit_MG_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Drone_Mk2";
		}
	}
	`log("Spark T2 BIT Schematic Patched");
}

static function PatchSparkBuildT3Arm()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('PoweredSparkArmor_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('PoweredSparkArmor_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Armor_Mk3";
		}
	}
	`log("Spark T3 Armour Schematic Patched");
}

static function PatchSparkBuildT3Wep()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('SparkRifle_BM_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('SparkRifle_BM_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Cannon_Mk3";
		}
	}
	`log("Spark T3 Weapon Schematic Patched");
}

static function PatchSparkBuildT3Bit()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('SparkBit_BM_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('SparkBit_BM_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Drone_Mk3";
		}
	}
	`log("Spark T3 BIT Schematic Patched");
}

static function X2TechTemplate CreateFakeTechTemplate()
{
	local X2TechTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'NonExistent');
	Template.PointsToComplete = 0;
	Template.SortingTier = 0;

	// Make Adv. Mag Weapons the requirement for this tech to show up
	// Make the prerequisite for Adv. Mag Weapons be the tech that will hide this tech from the menu
	// I love making Catch-22s
	Template.Requirements.RequiredTechs.AddItem('GaussWeapons');
	Template.UnavailableIfResearched = 'MagnetizedWeapons';

	return Template;
}

//================================================================================================================
// SQUISHY HUMAN SCHEMATICS
//================================================================================================================

static function PatchSquadBuildT2Arm()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('MediumPlatedArmor_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('MediumPlatedArmor_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Armor_Mk2";
		}
	}
	`log("Squad T2 Armour Schematic Patched");
}

static function PatchSquadBuildT2Wep()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('Cannon_MG_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('Cannon_MG_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Cannon_Mk2";
		}
	}
	`log("Squad T2 Cannon Schematic Patched");
}

static function PatchSquadBuildT2Grem()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('Gremlin_MG_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('Gremlin_MG_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Drone_Mk2";
		}
	}
	`log("Squad T2 Gremlin Schematic Patched");
}

static function PatchSquadBuildT3Arm()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('MediumPoweredArmor_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('MediumPoweredArmor_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Armor_Mk3";
		}
	}
	`log("Squad T3 Armour Schematic Patched");
}

static function PatchSquadBuildT3Wep()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('Cannon_BM_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('Cannon_BM_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Cannon_Mk3";
		}
	}
	`log("Squad T3 Cannon Schematic Patched");
}

static function PatchSquadBuildT3Grem()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('Gremlin_BM_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('Gremlin_BM_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Drone_Mk3";
		}
	}
	`log("Squad T3 Gremlin Schematic Patched");
}

//================================================================================================================
// BREAKTHROUGHS
//================================================================================================================


static function PatchBreakthrough()
{
	local X2StrategyElementTemplateManager ElementManager;
	local X2TechTemplate CannonTech;
	local X2ItemTemplateManager ItemManager;
	local X2GremlinTemplate Bit;

	ItemManager=class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	`FIXBIT(SparkBit_CV, SPARKBIT_CONVENTIONAL_HACKBONUS);
	`FIXBIT(SparkBit_MG, SPARKBIT_MAGNETIC_HACKBONUS);
	`FIXBIT(SparkBit_BM, SPARKBIT_BEAM_HACKBONUS);

	ElementManager=class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	`IFGETTECH(BreakthroughCannonWeaponUpgrade)
	{
		CannonTech.ResearchCompletedFn = BreakthroughWeaponUpgradeCompleted;
	}

	if (default.SPARK_CANNON_BREAKTHROUGH) UpdateDamageTemplate();
}

static function UpdateDamageTemplate(optional bool bAddTech=true)
{
	local X2StrategyElementTemplateManager ElementManager;
	local X2TechTemplate CannonTech;
	local X2BreakthroughCondition WeaponCondition;
	
	ElementManager=class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	`IFGETTECH(BreakthroughCannonDamage)
	{
		if (bAddTech)
		{
			WeaponCondition = new class'X2BreakthroughCondition_WeaponTypes';
			X2BreakthroughCondition_WeaponTypes(WeaponCondition).WeaponTypeMatch.additem('cannon');
			X2BreakthroughCondition_WeaponTypes(WeaponCondition).WeaponTypeMatch.additem('sparkrifle');
		}
		else
		{
			WeaponCondition = new class'X2BreakthroughCondition_WeaponType';
			X2BreakthroughCondition_WeaponType(WeaponCondition).WeaponTypeMatch='cannon';
		}
		if (WeaponCondition==none) `redscreen("wtf???????????????");
		CannonTech.BreakthroughCondition = WeaponCondition;
	}
}

static event OnLoadedSavedGame()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local bool bSubmit;
	local int idx;

	OnExitPostMissionSequence();

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("upgrading sparkrifles");
	XComHQ = `XCOMHQ;
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	for (idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		if (XComHQ.Crew[idx].ObjectID != 0)
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));

			if ( UnitState.GetMyTemplateName()=='SparkSoldier' &&
				(UnitState.GetCurrentStat(eStat_CombatSims)==0 ||
				!UnitState.bRolledForAWCAbility) )
			{
				NewGameState.AddStateObject(UnitState);
				UnitState.SetCurrentStat(eStat_CombatSims, 1);
				UnitState.RollForTrainingCenterAbilities();
				bSubmit=true;
			}
		}
	}
	if (bSubmit) `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else `XCOMHISTORY.CleanupPendingGameState(NewGameState);

	PatchSparkTechs();
	PatchSparkSlots();
	PatchBreakthrough();
	PatchBondmates();
	PatchSparkBonding();
}

static event OnExitPostMissionSequence()
{
	local array <name> arrTest;
	local int i;

	arrTest=`XCOMHQ.ExtraUpgradeWeaponCats;

	if (default.SPARK_CANNON_BREAKTHROUGH)
	{
		if (arrTest.find('cannon')!=INDEX_NONE &&
			arrTest.find('sparkrifle')==INDEX_NONE)
		{
			UpDateUpgradeSlot();
		}
	}
	else if (arrTest.Find('cannon')!=INDEX_NONE &&  arrTest.Find('sparkrifle')!=INDEX_NONE) //Do they have the cannon breakthrough?
	{
		if(arrTest.Find('SBMarker')!=INDEX_NONE) //Our trick marker entry!
			UpdateUpgradeSlot(false);
		else
		{
			i=arrTest.Length;
			arrTest.RemoveItem('sparkrifle');
			if (i-arrTest.Length>1)
				UpdateUpgradeSlot(false);
		}
	}
}

static function UpDateUpgradeSlot (optional bool bAddTech=true)
{
	local XComGameState NewGameState;
	local array <name> arrTest;
	arrTest=`XCOMHQ.ExtraUpgradeWeaponCats;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("upgrading sparkrifles");
	if (bAddTech)
	{
		ArrTest.AddItem('sparkrifle');
		ArrTest.AddItem('SBMarker');
	}
	else
	{
		ArrTest.Remove(ArrTest.find('sparkrifle'), 1);
		ArrTest.RemoveItem('SBMarker');
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

static function BreakthroughWeaponUpgradeCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', `XComHQ.ObjectID));
	XComHQ.ExtraUpgradeWeaponCats.AddItem(TechState.GetMyTemplate().RewardName);
	if ((default.SPARK_CANNON_BREAKTHROUGH) &&TechState.GetMyTemplate().RewardName=='cannon')
	{
		XComHQ.ExtraUpgradeWeaponCats.AddItem('sparkrifle');
		XComHQ.ExtraUpgradeWeaponCats.AddItem('SBMarker');
	}
}

//================================================================================================================
// BONDMATE ABILITIES
//================================================================================================================

static function PatchBondmates()
{
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty TargetCondition;

	// Allow bondmate abilities to target robotic units
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = true;
	TargetCondition.ExcludePanicked = true;
		
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('BondmateTeamwork');
	AbilityTemplate.AbilityTargetConditions[0] = TargetCondition;

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('BondmateTeamwork_Improved');
	AbilityTemplate.AbilityTargetConditions[0] = TargetCondition;
}

static function PatchSparkBonding()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharTemplate;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharTemplate = CharacterTemplateMgr.FindCharacterTemplate('SparkSoldier');

	// Add SPARK bondmate abilities
	CharTemplate.Abilities.AddItem('BondmateSolaceCleanse');
	CharTemplate.Abilities.AddItem('BondmateSolacePassive');
	CharTemplate.Abilities.AddItem('BondmateTeamwork_Spark');
	CharTemplate.Abilities.AddItem('BondmateTeamwork_Improved_Spark');
	CharTemplate.Abilities.AddItem('BondmateSpotter_Aim');
	CharTemplate.Abilities.AddItem('BondmateSpotter_Aim_Adjacency');
	CharTemplate.Abilities.AddItem('BondmateDualStrike');
}

//================================================================================================================
// TECHNOLOGIES
//================================================================================================================

static function PatchSparkTechs()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2TechTemplate TechTemplate;
	//local XComGameState_Tech TechState;
	local X2StrategyElementTemplateManager	StratMgr;

	//This adds the techs to games that installed the mod in the middle of a campaign.
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	History = `XCOMHISTORY;	

	//Create a pending game state change
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Research Templates");

	//Find tech templates
	if ( !IsResearchInHistory('BuildSpark') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('BuildSpark'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}
	if ( !IsResearchInHistory('BuildExpSpark') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('BuildExpSpark'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}
	if ( !IsResearchInHistory('RebuildSpark') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('RebuildSpark'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}
	if ( !IsResearchInHistory('ExpandRepairBay') )
	{
	TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate('ExpandRepairBay'));
	NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);
	}

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		//Commit the state change into the history.
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

static function bool IsResearchInHistory(name ResearchName)
{
	// Check if we've already injected the tech templates
	local XComGameState_Tech	TechState;
	
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if ( TechState.GetMyTemplateName() == ResearchName )
		{
			return true;
		}
	}
	return false;
}

//================================================================================================================
// STAFF SLOTS
//================================================================================================================

// Thanks to RealityMachina for figuring out how to add new repair slots
static function PatchSparkSlots()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local X2FacilityTemplate FacilityTemplate;
	local XComGameState_StaffSlot StaffSlotState, ExistingStaffSlot, LinkedStaffSlotState;
	local X2StaffSlotTemplate StaffSlotTemplate;
	local StaffSlotDefinition SlotDef;
	local int i, j;
	local bool bReplaceSlot, DidChange;
	local X2StrategyElementTemplateManager StratMgr;
	local array<int> SkipIndices;
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Mechatronic Warfare -- Adding New Slots");

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	
	FacilityState = XComHQ.GetFacilityByName('Storage');
	if (FacilityState != none)
	{
		FacilityState = XComGameState_FacilityXCom(NewGameState.ModifyStateObject(class'XComGameState_FacilityXCom', FacilityState.ObjectID));
		FacilityTemplate = FacilityState.GetMyTemplate();

		for (i = 0; i < FacilityTemplate.StaffSlotDefs.Length; i++)
		{
			if(SkipIndices.Find(i) == INDEX_NONE)
			{
				SlotDef = FacilityTemplate.StaffSlotDefs[i];
				// Check to see if the existing staff slot at this index no longer matches the template and needs to be replaced
				bReplaceSlot = false;
				if(i < FacilityState.StaffSlots.Length && FacilityState.StaffSlots[i].ObjectID != 0)
				{
					ExistingStaffSlot = FacilityState.GetStaffSlot(i);
					if(ExistingStaffSlot.GetMyTemplateName() != SlotDef.StaffSlotTemplateName)
					{
						bReplaceSlot = true;
					}
				}
				
				if(i >= FacilityState.StaffSlots.Length || bReplaceSlot) // Only add a new staff slot if it doesn't already exist or needs to be replaced
				{
					StaffSlotTemplate = X2StaffSlotTemplate(StratMgr.FindStrategyElementTemplate(SlotDef.StaffSlotTemplateName));
					DidChange = true;
					
					if(StaffSlotTemplate != none)
					{
						// Create slot state and link to this facility
						StaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewGameState);
						StaffSlotState.Facility = FacilityState.GetReference();

						// Check for starting the slot locked
						if(SlotDef.bStartsLocked)
						{
							StaffSlotState.LockSlot();
						}

						if(bReplaceSlot)
						{
							FacilityState.StaffSlots[i] = StaffSlotState.GetReference();
						}
						else
						{
							FacilityState.StaffSlots.AddItem(StaffSlotState.GetReference());
						}
						
						// Check rest of list for partner slot
						if(SlotDef.LinkedStaffSlotTemplateName != '')
						{
							StaffSlotTemplate = X2StaffSlotTemplate(StratMgr.FindStrategyElementTemplate(SlotDef.LinkedStaffSlotTemplateName));

							if(StaffSlotTemplate != none)
							{
								for(j = (i + 1); j < FacilityTemplate.StaffSlotDefs.Length; j++)
								{
									SlotDef = FacilityTemplate.StaffSlotDefs[j];

									if(SkipIndices.Find(j) == INDEX_NONE && SlotDef.StaffSlotTemplateName == StaffSlotTemplate.DataName)
									{
										// Check to see if the existing staff slot at this index no longer matches the template and needs to be replaced
										bReplaceSlot = false;
										if(j < FacilityState.StaffSlots.Length && FacilityState.StaffSlots[j].ObjectID != 0)
										{
											ExistingStaffSlot = FacilityState.GetStaffSlot(j);
											if(ExistingStaffSlot.GetMyTemplateName() != SlotDef.StaffSlotTemplateName)
											{
												bReplaceSlot = true;
											}
										}

										if(j >= FacilityState.StaffSlots.Length || bReplaceSlot) // Only add a new staff slot if it doesn't already exist or needs to be replaced
										{
											// Create slot state and link to this facility
											LinkedStaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewGameState);
											LinkedStaffSlotState.Facility = FacilityState.GetReference();

											// Check for starting the slot locked
											if(SlotDef.bStartsLocked)
											{
												LinkedStaffSlotState.LockSlot();
											}

											// Link the slots
											StaffSlotState.LinkedStaffSlot = LinkedStaffSlotState.GetReference();
											LinkedStaffSlotState.LinkedStaffSlot = StaffSlotState.GetReference();

											if(bReplaceSlot)
											{
												FacilityState.StaffSlots[j] = LinkedStaffSlotState.GetReference();
											}
											else
											{
												FacilityState.StaffSlots.AddItem(LinkedStaffSlotState.GetReference());
											}

											// Add index to list to be skipped since we already added it
											SkipIndices.AddItem(j);
											break;
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}

	if (NewGameState.GetNumGameStateObjects() > 0 && DidChange)
	{
		XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHistory.CleanupPendingGameState(NewGameState);
	}

}

static function PatchRepairFacility()
{
	local X2FacilityTemplate FacilityTemplate;
	local array<X2FacilityTemplate> FacilityTemplates;
	local StaffSlotDefinition StaffSlotDef;

	FindFacilityTemplateAllDifficulties('Storage', FacilityTemplates);
	StaffSlotDef.StaffSlotTemplateName = 'SparkStaffSlot2';
	StaffSlotDef.bStartsLocked = true;
	foreach FacilityTemplates(FacilityTemplate)
	{
		FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);
		`log("REPAIR FACILITY PATCHED");
	}
}

//retrieves all difficulty variants of a given facility template
static function FindFacilityTemplateAllDifficulties(name DataName, out array<X2FacilityTemplate> FacilityTemplates, optional X2StrategyElementTemplateManager StrategyTemplateMgr)
{
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
	local X2FacilityTemplate FacilityTemplate;

	if(StrategyTemplateMgr == none)
		StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	StrategyTemplateMgr.FindDataTemplateAllDifficulties(DataName, DataTemplates);
	FacilityTemplates.Length = 0;
	foreach DataTemplates(DataTemplate)
	{
		FacilityTemplate = X2FacilityTemplate(DataTemplate);
		if( FacilityTemplate != none )
		{
			FacilityTemplates.AddItem(FacilityTemplate);
		}
	}
}

static function PatchCreateSpark()
{
	local X2StrategyElementTemplateManager      AllItems;
	local X2TechTemplate						CurrentSchematic;

	// Find the schematic template
	AllItems = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	CurrentSchematic = X2TechTemplate(AllItems.FindStrategyElementTemplate('BuildSpark'));
	
	if ( CurrentSchematic != none )
	{
		CurrentSchematic.ResearchCompletedFn = class'X2StrategyElement_TechsMW'.static.CreateSparkTrooper;
		`log("BUILD PROJECT PATCHED");
	}
}

static function PatchMechWar()
{
	local X2StrategyElementTemplateManager      AllItems;
	local X2TechTemplate						CurrentSchematic;

	// Find the schematic template
	AllItems = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	CurrentSchematic = X2TechTemplate(AllItems.FindStrategyElementTemplate('MechanizedWarfare'));
	
	if ( CurrentSchematic != none )
	{
		CurrentSchematic.ResearchCompletedFn = class'X2StrategyElement_TechsMW'.static.CreateSparkTrooperAndEquipment;
		`log("MECHWAR PROJECT PATCHED");
	}
}