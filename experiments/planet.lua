

function CreateTexturedCircle(image, segments)
   segments = segments or 40
   local vertices = {}
   
   -- The first vertex is at the center, and has a red tint. We're centering the circle around the origin (0, 0).
   table.insert(vertices, {0, 0, 0.5, 0.5})--, 255, 0, 0})
   
   -- Create the vertices at the edge of the circle.
   for i=0, segments do
      local angle = (i / segments) * math.pi * 2
      
      -- Unit-circle.
      local x = math.cos(angle)
      local y = math.sin(angle)
      
      -- Our position is in the range of [-1, 1] but we want the texture coordinate to be in the range of [0, 1].
      local u = (x + 1) * 0.5
      local v = (y + 1) * 0.5
      
      -- The per-vertex color defaults to white.
      table.insert(vertices, {x, y, (x+1)*0.5, (y+1)*0.5})
   end
   
   -- The "fan" draw mode is perfect for our circle.
   local mesh = love.graphics.newMesh(vertices, "fan")
   mesh:setTexture(image)
   
   return mesh
end

function generate_planetoid(p,r,g,b, x,y) --first make the blocktable
   for y=1, 25, 1 do
      for x=1, 25, 1 do
	 table.insert(p.blocktable, math.random(g,g+80)  )	
      end
   end
   p.landmap = love.graphics.newCanvas(800,  800) --small planets zoomed in.
   love.graphics.setCanvas(p.landmap)
   for y=1, 25, 1 do --draw the landscape
      for x=1, 25, 1 do					
	 love.graphics.setColor(r, p.blocktable[y*x], b)
	 love.graphics.rectangle("fill", x*32, y*32, 32, 32 )  --100 2x2 squares.
      end
   end
   love.graphics.setCanvas() --end coloring the square
   p.pmesh = CreateTexturedCircle(p.landmap, 40) 
end

function add_more_planets()
   for i=2, 20 do
      placex = math.random(-5000, 5000)
      placey = math.random(-5000, 5000)
      table.insert(planets, i,  {
		      name = "?",
		      x = drawx+placex*32,
		      y = drawx+placey*32,
		      w = 2000+math.random(-500, 2000),
		      blocktable = {},
		      landmap= nil,
		      circlemap = nil,
		      pmesh = nil
      })
      local rbcolors = math.random(80,120)
      local gcolors = math.random(20, 100)
      generate_planetoid(planets[i],rbcolors,gcolors,rbcolors)
   end
end


function draw_planets(p)
   for i, v in ipairs(p) do
      love.graphics.setColor(255,255,255, 100)
      --love.graphics.draw(planets[1].circlemap, planets[1].x+drawx, planets[1].y+drawy)
      --love.graphics.draw( p[i].pmesh, p[i].x+drawx, p[i].y+drawy, 0, 100, 100)
      love.graphics.circle("fill", p[i].x+spacecamx, p[i].y+spacecamy, p[i].w, 100)   --atmosphere
      love.graphics.setColor(100,p[i].blocktable[1],100)
      love.graphics.circle("fill", p[i].x+spacecamx, p[i].y+spacecamy, p[i].w-20, 100) --planet
      --love.graphics.setColor(100,p[i].blocktable[2],100)
      --love.graphics.circle("fill", planets[1].x+spacecamx, planets[1].y+spacecamy, p[i].w-100, 100)
   end
end
