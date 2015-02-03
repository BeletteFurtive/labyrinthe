class Case
{

	bool east, west, north, south, visited;

	int x, y;
	
	this()
	{
		this.east = false;
		this.west = false;
		this.north = false;
		this.south = false;
		this.visited = false;
		this.x = 0;
		this.y = 0;
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
