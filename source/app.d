import std.stdio;
import Labyrinthe;
import Rend;
import std.algorithm;
import std.process;
import std.array;

import dsfml.graphics;
import std.container;


int main(string args[])
{

	int labWidth=33;
	int labHeight=65;
	auto level = new Labyrinthe(labWidth, labHeight);

	int tileSize=16;
	level.init();
	//level.generate();
	//system("clear");
	//write(level);

	
	ContextSettings settings = ContextSettings.Default;

	int windowWidht = labWidth*tileSize;
	int windowHeight = labHeight*tileSize;
	
	auto window = new RenderWindow(VideoMode(windowHeight,windowWidht),"test", (Window.Style.Titlebar | Window.Style.Close), settings);

	Rend map = new Rend();
	
	if(!map.load("source/tileset.png", Vector2u(tileSize, tileSize), level, windowWidht, windowHeight))
	 {
	 	return -1;
	 }


	while(window.isOpen())
	{
		Event event;
		while(window.pollEvent(event))
		{
			if(event.type == event.EventType.Closed)
            {
				window.close();
            }
		}
		//while(!level.visits.empty()){
		if(!level.visits.empty()){
			level.generateOneIteration();
			map.load("source/tileset.png", Vector2u(tileSize, tileSize), level, windowWidht, windowHeight);
			writeln("prout");
//			window.draw(map);
				
		}  
		
		window.clear();
		window.draw(map);
		window.display();
	
	}

	
	return 0;
}



