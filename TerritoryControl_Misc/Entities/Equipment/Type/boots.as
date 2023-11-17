void onInit(CBlob@ this)
{
	this.getShape().SetRotationsAllowed(true);

	this.Tag("boots");
	this.Tag("RemoveOnCleaning");

	if (this.getName() == "combatboots" || this.getName() == "compositeboots")
		this.Tag("armor");
}