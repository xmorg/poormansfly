function draw_spacemode()

	local width = love.graphics.getWidth()
   local height = love.graphics.getHeight()
	for y=1, 100, 1 do
      for x=1, 
      	100, 1 do
      	love.graphics.setColor(
	   		math.random(150,255),
	   		math.random(150,255),
	   		math.random(150,255)
	   		)
	   	love.graphics.rectangle("fill", starXtable[y*x], starYtable[y*x],2,2)
      end
   end
   
   love.graphics.push() --push for things that need to be scaled
   
   love.graphics.scale(scale, scale)
   love.graphics.translate(width/2+spacecamx, height/2+spacecamy)
   
   draw_planets(planets)   
   love.graphics.pop()
   
   love.graphics.push()
   draw_spaceship(spaceship)   --
   love.graphics.pop()	
   
end
