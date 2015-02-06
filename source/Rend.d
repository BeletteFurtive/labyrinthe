import dsfml.graphics;
import Labyrinthe;
import std.stdio;

class Rend : Drawable, Transformable
{

	VertexArray m_vertice;
    Texture m_tileset;

	
	Vector2f m_origin = Vector2f(0,0); ///< Origin of translation/rotation/scaling of the object
	Vector2f m_position = Vector2f(0,0); ///< Position of the object in the 2D world
	float m_rotation = 0; ///< Orientation of the object, in degrees
	Vector2f m_scale = Vector2f(1,1); ///< Scale of the object
	Transform m_transform; ///< Combined transformation of the object
	bool m_transformNeedUpdate; ///< Does the transform need to be recomputed?
	Transform m_inverseTransform; ///< Combined transformation of the object
	bool m_inverseTransformNeedUpdate; ///< Does the transform need to be recomputed?


/**
 * The local origin of the object.
 *
 * The origin of an object defines the center point for all transformations (position, scale, ratation).
 *
 * The coordinates of this point must be relative to the top-left corner of the object, and ignore all transformations (position, scale, rotation). The default origin of a transformable object is (0, 0).
 */
	@property
	{
		Vector2f origin(Vector2f newOrigin)
		{
			m_origin = newOrigin;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
			return newOrigin;
		}
		Vector2f origin() const
		{
			return m_origin;
		}
	}
/// The position of the object. The default is (0, 0).
	@property
	{
		Vector2f position(Vector2f newPosition)
		{
			m_position = newPosition;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
			return newPosition;
		}
		Vector2f position() const
		{
			return m_position;
		}
	}
/// The orientation of the object, in degrees. The default is 0 degrees.
	@property
	{
		float rotation(float newRotation)
		{
			m_rotation = cast(float)fmod(newRotation, 360);
			if(m_rotation < 0)
			{
				m_rotation += 360;
			}
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
			return newRotation;
		}
		float rotation() const
		{
			return m_rotation;
		}
	}
/// The scale factors of the object. The default is (1, 1).
	@property
	{
		Vector2f scale(Vector2f newScale)
		{
			m_scale = newScale;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
			return newScale;
		}
		Vector2f scale() const
		{
			return m_scale;
		}
	}
/**
 * Get the inverse of the combined transform of the object.
 *
 * Returns: Inverse of the combined transformations applied to the object.
 */
	const(Transform) getInverseTransform()
	{
		if (m_inverseTransformNeedUpdate)
		{
			m_inverseTransform = getTransform().getInverse();
			m_inverseTransformNeedUpdate = false;
		}
		return m_inverseTransform;
	}
/**
 * Get the combined transform of the object.
 *
 * Returns: Transform combining the position/rotation/scale/origin of the object.
 */
	const(Transform) getTransform()
	{
		if (m_transformNeedUpdate)
		{
			float angle = -m_rotation * 3.141592654f / 180f;
			float cosine = cast(float)(cos(angle));
			float sine = cast(float)(sin(angle));
			float sxc = m_scale.x * cosine;
			float syc = m_scale.y * cosine;
			float sxs = m_scale.x * sine;
			float sys = m_scale.y * sine;
			float tx = -m_origin.x * sxc - m_origin.y * sys + m_position.x;
			float ty = m_origin.x * sxs - m_origin.y * syc + m_position.y;
			m_transform = Transform( sxc, sys, tx,
									 -sxs, syc, ty,
									 0f, 0f, 1f);
			m_transformNeedUpdate = false;
		}
		return m_transform;
	}
	
/**
 *Move the object by a given offset.
 *
 *This function adds to the current position of the object, unlike the position property which overwrites it.
 *
 * Params:
 * offset = The offset.
 */
	void move(Vector2f offset)
	{
		position = position + offset;
	}


	
	this()
	{
		m_vertice = new VertexArray(PrimitiveType.Quads, 4);
		m_tileset = new Texture();
	}

	bool load(string tileset, Vector2u tileSize, Labyrinthe l, int windowWidht, int windowHeight)
	{
		
		if(!m_tileset.loadFromFile(tileset))
		{
			return false;			
		}

		int labWidth = (windowWidht/tileSize.x);
		int labHeight = (windowHeight/tileSize.y);
		
		m_vertice.primativeType = PrimitiveType.Quads;
		m_vertice.resize((labWidth)*(labHeight)*4);


		for(int i=0; i<(labWidth);i++ )
		{
			for(int j=0; j<(labHeight);j++ )
			{
				int tileNumber;
				//if(l.lab[i][j].getVisited())
				if(cast(Path)(l.lab[i][j]))
				{
					tileNumber = 0;
				}
				else if(cast(Wall)(l.lab[i][j]))
				{
					tileNumber = 1;
					if(j < (labHeight)-1 && cast(Wall)(l.lab[i][j+1]))
					{
						tileNumber = 2;
					}
				}
					
				int tu=tileNumber % (m_tileset.getSize().x/tileSize.x);
				int tv=tileNumber / (m_tileset.getSize().x/tileSize.x);
				Vertex *quad = &m_vertice[(i + j * (windowWidht/tileSize.x)) * 4];

				quad[0].position = Vector2f(i*tileSize.x, j*tileSize.y);
				quad[1].position = Vector2f((i+1)*tileSize.x, j*tileSize.y);
				quad[2].position = Vector2f((i+1)*tileSize.x, (j+1)*tileSize.y);
				quad[3].position = Vector2f(i*tileSize.x, (j+1)*tileSize.y);

				quad[0].texCoords = Vector2f(tu*tileSize.x, tv*tileSize.y);
				quad[1].texCoords = Vector2f((tu+1)*tileSize.x, tv*tileSize.y);
				quad[2].texCoords = Vector2f((tu+1)*tileSize.x, (tv+1)*tileSize.y);
				quad[3].texCoords = Vector2f(tu*tileSize.x, (tv+1)*tileSize.y);
			}
		}
		
		return true;
	}


	void draw(RenderTarget renderTarget, RenderStates renderStates)
	{
		renderStates.transform = renderStates.transform * getTransform();
		renderStates.texture = m_tileset;

		renderTarget.draw(m_vertice, renderStates);
		
	}


	
}
