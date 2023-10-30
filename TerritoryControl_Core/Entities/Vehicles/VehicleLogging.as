void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	if (attached !is null)
	{	
		if(attached.getPlayer() !is null)
		{
			printf("[DEBUG]: Attaching " + attached.getPlayer().getUsername() + " to " + this.getName());
		}
	}
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint)
{
	if (detached !is null)
	{
		if(detached.getPlayer() !is null)
		{
			printf("[DEBUG]: Detaching " + detached.getPlayer().getUsername() + " from " + this.getName());
		}
	}
}