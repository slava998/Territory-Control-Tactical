void onInit(CBlob@ this)
{
	this.Tag("head");
	this.Tag("RemoveOnCleaning");

	if (this.getName() == "militaryhelmet" || this.getName() == "compositehelmet" || this.getName() == "lighthelmet")
		this.Tag("armor");
}