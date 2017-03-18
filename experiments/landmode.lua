
function draw_landmode()
	local width = love.graphics.getWidth()
   local height = love.graphics.getHeight() 
   local bigland = love.graphics.newQuad(-1000,-1000,2000,2000, 800,800)
   
	love.graphics.push() --push for things that need to be scaled   
   love.graphics.translate(width/2+landcamx, height/2+landcamy)
   love.graphics.scale(scale, scale)
   for y=-3,3 do
   	for x=-3,3 do
   		love.graphics.draw(planets[1].landmap,landcamx-767*x, landcamy-767*y)
   	end
   end
   if pilot.enteredship == 0 then
   	draw_spaceship(spaceship)
   end
   love.graphics.pop()
   
   love.graphics.push()
   if raygun == 1 then -- shoot your lazer
      sound_laser:play()
      love.graphics.setColor(0,180,0)
      love.graphics.setLineWidth(3)
      love.graphics.line(pilot.x, pilot.y,love.mouse.getX(), love.mouse.getY() )
      love.graphics.setColor(0,220,0)
      love.graphics.setLineWidth(1)
      love.graphics.line(pilot.x, pilot.y,love.mouse.getX(), love.mouse.getY() )
   else
      sound_laser:stop()
   end
   draw_pilot(pilot)	
   local w = love.graphics.getWidth()/2 
   local h = love.graphics.getHeight()/2 
   if(  spaceship.x-landcamx+w >= love.graphics.getWidth()/2-200 
	     and spaceship.x-landcamx+w <= love.graphics.getWidth()/2+200
	     and spaceship.y-landcamy+h >= love.graphics.getHeight()/2-200 
	  and spaceship.y-landcamy+h <= love.graphics.getHeight()/2+200) then
      pilot.besideship = 1
      love.graphics.print("Enter ship[press e]", 10, love.graphics.getHeight()-60)
   else
      pilot.besideship = 0
   end
   
   love.graphics.pop()
end
