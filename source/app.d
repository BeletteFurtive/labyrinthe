import std.stdio;
import Labyrinthe;


void main()
{
	auto level = new Labyrinthe(20, 30);
	level.init();
	level.generate();
	write(level);
}



