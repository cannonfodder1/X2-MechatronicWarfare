class X2Item_SPARKCorpse extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreateSPARKCorpse());

	return Resources;
}

static function X2DataTemplate CreateSPARKCorpse()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseSPARK');

	Template.strImage = "img:///UILibrary_DLC3Images.TECH_Spark";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 10;
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;
	Template.bAlwaysRecovered = true;

	return Template;
}
