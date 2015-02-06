import std.stdio;
import Labyrinthe;
import Rend;
import std.algorithm;
import std.process;
import std.array;
import settings;
import dsfml.graphics;
import std.container;


int main(string args[])
{
	Settings settings;
	settings = set(args);
	
	auto level = new Labyrinthe(settings.labHeight, settings.labWidth);
	
	int tileSize=32;
	level.init();
	if(!settings.dynamic)
	{
		level.generate();
	}
	
	
	ContextSettings windowSettings = ContextSettings.Default;
	
	int viewWidht = settings.labWidth*tileSize;
	int viewHeight = settings.labHeight*tileSize;

	int windowWidht = 1366;
	int windowHeight = 768;
	
	auto window = new RenderWindow(VideoMode(windowWidht, windowHeight),"Labyrinthe", (Window.Style.Titlebar | Window.Style.Close), windowSettings);
	
	Rend map = new Rend();
	
	if(!map.load("source/tileset.png", Vector2u(tileSize, tileSize), level,viewWidht, viewHeight))
	{
	 	return -1;
	}
	
	auto view =  new View( FloatRect(0, 0, cast(float)window.size().x, cast(float)window.size().y));
  	window.view = view;				
	

	while(window.isOpen())
	{
		Event event;
		while(window.pollEvent(event))
		{
			if(event.type == event.EventType.Closed)
            {
				window.close();
            }
			else if(event.type == event.EventType.KeyPressed)
			{
			 	if(event.key.code == Keyboard.Key.Down)
			 	{
					view.move(Vector2f(0, 10));
			 	}
				if(event.key.code == Keyboard.Key.Up)
			 	{
					view.move(Vector2f(0, -10));
			 	}
			 	if(event.key.code == Keyboard.Key.Left)
			 	{
					view.move(Vector2f(-10, 0));					
			 	}
				if(event.key.code == Keyboard.Key.Right)
				{
					view.move(Vector2f(10, 0));					
			 	}
				window.view = view;				
			}
			else if(event.type == event.EventType.MouseWheelMoved)
			{
				if(event.mouseWheel.delta == -1)
				{
					view.zoom(1.1);	
				}
				else
				{
					view.zoom(0.9);
				}
				window.view = view;
			}
		}
		if(settings.dynamic)
		{
			if(!level.visits.empty()){
				level.generateOneIteration();
				map.load("source/tileset.png", Vector2u(tileSize, tileSize), level,viewWidht, viewHeight);
			}
		}
		
		window.clear();
		window.draw(map);
		window.display();
		
	}
	
	return 0;
}
