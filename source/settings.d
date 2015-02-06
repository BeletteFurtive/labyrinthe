import std.conv;
import std.stdio;
import std.getopt;

struct Settings
{
	int labWidth;
	int labHeight;
	bool dynamic;
}


Settings set(string args[])
{

	Settings s;

	bool d;
	int w;
	int h;

	getopt(args,
		   "dynamic|d", &d,
		   "width|w", &w,
		   "height|h", &h);

	
	s.dynamic = d;
	s.labWidth = w;
	s.labHeight = h;

	if(w<=1)
	{
		s.labWidth = 51;
	}
	else
	{
		if(w%2 == 0)
		{
			s.labWidth = w+1;
		}
	}
	if(h<=1)
	{
		s.labHeight = 51;
	}
	else
	{
		if(h%2 == 0)
		{
			s.labHeight = h+1;
		}
	}
	return s;
}
