import std.stdio;
import std.string;
import std.container;
import std.random;
import std.array;
import std.algorithm;
import std.process;
import core.thread;
import Case;
import Path;
import Wall;

class Labyrinthe
{
	Case[][] tab_lab;
	Case[] visits;


	@property
	{
		Case[][] lab()
		{
			return tab_lab;
		}
	}

	
	this(int y, int x)
	{
		if(x<=2 || y<=2)
		{
			x = 16;
			y = 16;
		}
		this.tab_lab.length = x;	   	
		foreach(ref e; this.tab_lab)
		{
			e.length = y;
		}
	}

	void init()
	{
	
		for(int i=0; i<this.tab_lab.length; i++)
		{			
			for(int j=0; j<this.tab_lab[i].length; j++)
			{
				tab_lab[i][j] = new Wall();
				tab_lab[i][j].setPosition(i, j);
			}			
		}
		visits = [tab_lab[1][1]];
		tab_lab[1][1] = new Path(tab_lab[1][1]);
		tab_lab[1][1].setVisited();
	}

	void generate()
	{
		while(!visits.empty()){
			generateOneIteration();
		}   
	}


	void generateOneIteration()
	{
		int x;
		int y;
		bool east, west, south, north;
	

		auto rand = uniform(0, 4);
		
		x = visits.front.getX();
		y = visits.front.getY();
		
			
		if(y+2 < tab_lab[0].length-1)
			south = tab_lab[x][y+2].getVisited();
		else
			south = true;

		if(y-2 > 0)
			north = tab_lab[x][y-2].getVisited();
		else
			north = true;
			
		if(x+2 < tab_lab.length-1)
			east = tab_lab[x+2][y].getVisited();
		else
			east = true;
			
		if(x-2 > 0)
			west = tab_lab[x-2][y].getVisited();
		else
			west = true;
			

	
			
		if(south && north && east && west)
		{
	
			visits = visits [1..$];
		}
		else
		{
			//south
			if(rand==0)
			{
				if(!south)
				{
					tab_lab[x][y+1] = new Path(tab_lab[x][y+1]);
					tab_lab[x][y+2] = new Path(tab_lab[x][y+2]);
					tab_lab[x][y+1].setVisited();
					tab_lab[x][y+2].setVisited();
					y+=2;
					visits = tab_lab[x][y] ~ visits;
				}
			}
				
			//east
			if(rand==1)
			{
				if(!east)
				{
					tab_lab[x+1][y] = new Path(tab_lab[x+1][y]);
					tab_lab[x+2][y] = new Path(tab_lab[x+2][y]);
					tab_lab[x+1][y].setVisited();
					tab_lab[x+2][y].setVisited();
					x += 2;
					visits = tab_lab[x][y] ~ visits;
												
				}
			}
				
			//north
			if(rand==2)
			{
				if(!north)
				{

					tab_lab[x][y-1] = new Path(tab_lab[x][y-1]);
					tab_lab[x][y-2] = new Path(tab_lab[x][y-2]);
					tab_lab[x][y-1].setVisited();
					tab_lab[x][y-2].setVisited();
					y -= 2;
					visits = tab_lab[x][y] ~ visits;
												
				}
			}

			//west
			if(rand==3)
			{
				if(!west)
				{
					tab_lab[x-1][y] = new Path(tab_lab[x-1][y]);
					tab_lab[x-2][y] = new Path(tab_lab[x-2][y]);
					tab_lab[x-1][y].setVisited();
					tab_lab[x-2][y].setVisited();
					x -= 2;
					visits = tab_lab[x][y] ~ visits;	
				}				
			}
			//Thread.sleep( dur!("msecs")( 50 ) );
			//system("clear");
			// write(this);
		}
		

	}



	override string toString()
	{

		string result = "";
		foreach(e; this.tab_lab)
		{
			foreach(e2; e)
			{
			   	switch(e2.getVisited())
				{
				case true:
					result ~= " ";
					break;
				case false:
					result ~= "1";
	 				break;
	 			default:
	 				result ~= "0";
					break;
				}
			}
			result ~= "\n";
		}
		return result;
	}
	
}


