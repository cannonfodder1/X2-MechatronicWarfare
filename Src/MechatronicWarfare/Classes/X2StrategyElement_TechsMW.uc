class X2StrategyElement_TechsMW extends X2StrategyElement config(StrategyTuning);
/*
var config int NANO_SUPPLY_COST;
var config int NANO_ALLOY_COST;
var config int NANO_ELERIUM_COST;
var config int NANO_MEC_COST;
var config int NANO_CORE_COST;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	Techs.AddItem(CreateInterlinkedNanogelTemplate());

	return Techs;
}

static function int StafferXDays(int iNumScientists, int iNumDays)
{
	return (iNumScientists * 5) * (24 * iNumDays); // Scientists at base skill level
}

static function X2DataTemplate CreateInterlinkedNanogelTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'InterlinkedNanogel');
	Template.PointsToComplete = StafferXDays(1, 14);
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.bProvingGround = true;
	Template.bRepeatable = false;

	// Tech Requirements
	Template.Requirements.RequiredTechs.AddItem('PlatedArmor');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');

	// Resource Cost
 	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = default.NANO_SUPPLY_COST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.NANO_ALLOY_COST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.NANO_ELERIUM_COST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseAdventMEC';
	Artifacts.Quantity = default.NANO_MEC_COST;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = default.NANO_CORE_COST;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}
*/