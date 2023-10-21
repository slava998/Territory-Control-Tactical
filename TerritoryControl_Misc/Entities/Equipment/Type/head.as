void onInit(CBlob@ this)
{
	this.Tag("head");

	if (this.getName() == "militaryhelmet" || this.getName() == "compositehelmet" || this.getName() == "lighthelmet")
		this.Tag("armor");
}