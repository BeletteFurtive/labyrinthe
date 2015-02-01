import std.stdio;
import std.string;
import std.container;
import std.random;
import std.array;
import std.algorithm;

import Case;


class Labyrinthe
{

	Case[][] lab;
	Case[] visits;
	
	this(int x, int y)
	{
		if(x<=2 || y<=2)
		{
			x = 16;
			y = 16;
		}
		this.lab.length = x;	   	
		foreach(ref e; this.lab)
		{
			e.length = y;
		}
	}

	void init()
	{
		for(int i=0; i<this.lab.length; i++)
		{			
			for(int j=0; j<this.lab[i].length; j++)
			{
				lab[i][j] = new Case();
				lab[i][j].setPosition(i, j);
			}			
		}
	}

	void generate()
	{
		visits.insertInPlace(0, lab[1][1]);
		int x = lab[1][1].getX();
		int y = lab[1][1].getY();
		lab[1][1].setVisited();
		bool east, west, south, north;
	

		while(!visits.empty()){
			auto rand = uniform(0, 4);
			if(y+2 < lab[0].length-1)
				south = lab[x][y+2].getvisited();
			else
				south = true;

			if(y-2 > 0)
				north = lab[x][y-2].getvisited();
			else
				north = true;
			
			if(x+2 < lab.length-1)
				east = lab[x+2][y].getvisited();
			else
				east = true;
			
			if(x-2 > 0)
				west = lab[x-2][y].getvisited();
			else
				west = true;
			

			x = visits.front.getX();
			y = visits.front.getY();
			
			if(south && north && east && west)
			{
				visits = visits.remove(0);
			}
			else
			{
				//south
				if(rand==0)
				{
					if(!south)
					{
						y+=2;
						lab[x][y].setVisited();
						lab[x][y-1].setVisited();
						visits.insertInPlace(0, lab[x][y]);
					}
				}
				
				//east
				if(rand==1)
				{
					if(!east)
					{
						x += 2;
						lab[x][y].setVisited();
						lab[x-1][y].setVisited();
						visits.insertInPlace(0, lab[x][y]);
					}
				}
				
				//north
				if(rand==2)
				{
					if(!north)
					{
						y -= 2;
						lab[x][y].setVisited();
						lab[x][y+1].setVisited();
						visits.insertInPlace(0, lab[x][y]);
					}
				}

				//west
				if(rand==3)
				{
					if(!west)
					{
						x -= 2;
						lab[x][y].setVisited();
						lab[x+1][y].setVisited();
						visits.insertInPlace(0, lab[x][y]);
					}
				
				}
			}
		}

		
		
	}




	override string toString()
	{
		string result = "";
		foreach(e; this.lab)
		{
			foreach(e2; e)
			{
			   	switch(e2.getvisited())
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


