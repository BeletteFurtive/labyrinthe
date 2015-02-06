class Case
{

	int x, y;
	bool visited;
	
	
	this()
	{

		this.x = 0;
		this.y = 0;
	}

	
	this(Case c)
	{
		if(c !is null)
		{
			this.x = c.getX();
			this.y = c.getY();
			this.visited = c.getVisited();
		}
	}



	void setPosition(int a, int b)
	{
		this.x = a;
		this.y = b;
	}

	bool getVisited()
	{
		return visited;
	}

	void setVisited()
	{
		visited = true;
	}

	void setUnVisited()
	{
		visited = false;
	}

	int getX()
	{
		return x;
	}

	int getY()
	{
		return y;
	}

	
}
