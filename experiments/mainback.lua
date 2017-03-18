
locx = 50
locy = 50
drawx = 0
drawy = 0
--drawx = 0
--drawy = 0

require("keyboard")
require("planet")
require("landmode")
require("spacemode")

starXtable = {}
starYtable = {}

blocktable = {}
spaceship = {
	x = 0,
	y = 0,
	speed = 3,
	maxspeed=20,
	rot = 0,
	playedtakeoff = 0
}
pilot = {
	x = drawx+love.graphics.getWidth()/2, 
	y = drawy+love.graphics.getHeight()/2,
	besideship = 0,
	enteredship = 0,
	speed=3
}

speed = 3
scalespeed = 0.1
scale = 1
minscale = 0.01
maxscale = 1
translate = 0
landcamx = 0
landcamy = 0
spacecamx = 0
spacecamy = 0
drawmode = "land" --/or space
nearestplanetindex = 0

planets = {
   {
      name = "Allos 1",
      x = 0, --center of planet
      y = 0, --center of planet
      w = 2000,  --radius
      blocktable = {},
      landmap= nil, --the land map/texture for pmesh
      pmesh = nil
   }
}

function check_near_planet() -- you are near a planet and can land if you decend
   w = love.graphics.getWidth()/2
   h = love.graphics.getHeight()/2

   --if(  spaceship.x-landcamx+w >= love.graphics.getWidth()/2-200 
   --	     and spaceship.x-landcamx+w <= love.graphics.getWidth()/2+200
   --	     and spaceship.y-landcamy+h >= love.graphics.getHeight()/2-200 
   --	  and spaceship.y-landcamy+h <= love.graphics.getHeight()/2+200) then

   
   for i,v in ipairs(planets) do
      --check if the circle of the planet is near the screen.
      if planets[i].x -planets[i].w +spacecamx >= w-200 and
	 planets[i].x +planets[i].w +spacecamx <= w+200 and
	 planets[i].y -planets[i].w +spacecamy >= h-200 and
      planets[i].y +planets[i].w +spacecamy <= h+200 then
	 return i
      end
   end
   return 0 -- found nothing
end

function generate_spaceship1()
	spaceship1 = love.graphics.newCanvas(300, 300)
end

function draw_pilot(p)
   local dx = 0
   local dy = 0	
   if pilot.enteredship == 0 then
      love.graphics.setColor(255,255,255) --pilot
      love.graphics.print("loc: "..pilot.x-drawx..":"..pilot.y-drawy, 
			  pilot.x+15, pilot.y+15)
      love.graphics.circle("fill", pilot.x, pilot.y , 16, 8)
   else -- ship is ready to fly!
      draw_spaceship(spaceship)
   end
end

function draw_spaceship(s)
   local dx = 0
   local dy = 0
   local width = love.graphics.getWidth()
   local height = love.graphics.getHeight()
   local function putship(x,y)
   	love.graphics.translate(width/2+50, height/2)
      love.graphics.rotate(spaceship.rot)
      love.graphics.translate(-width/2-50, -height/2)
      love.graphics.setColor(50,50,50)
      love.graphics.polygon("fill", 				
			 s.x + x,     s.y + y,
			 s.x +x+200, s.y +y-80,
			 s.x +x+200, s.y +y+80)
		love.graphics.setColor(60,60,60)
		love.graphics.polygon("fill", 				
			 s.x+x+10,     s.y+y,
			 s.x+x+200-10, s.y+y-80+10,
			 s.x+x+200-10, s.y+y+80-10)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("Loc: " ..spaceship.x-landcamx.."x"..spaceship.y-landcamy, 
			spaceship.x+landcamx,
			spaceship.y+landcamy-15 )
   end
   if drawmode == "land" then
   	if pilot.enteredship == 1 then
      	dx = love.graphics.getWidth()/2
      	dy = love.graphics.getHeight()/2
      	s.x=0
      	s.y=0
      else
      	dx = landcamx
      	dy = landcamy
      end
      
      -- rotate around the center of the screen by angle radians	
      putship(dx,dy)
	else --in space
		if pilot.enteredship == 1 then
      	dx = love.graphics.getWidth()/2
      	dy = love.graphics.getHeight()/2
      	putship(dx,dy)
      end
	end
	
end


function generate_starfield()
   for y=1, 100, 1 do
      for x=1, 100, 1 do
	 table.insert(starXtable, math.random(1, love.graphics.getWidth()))
	 table.insert(starYtable, math.random(1, love.graphics.getHeight()))
      end
   end
end



function love.load()
   --love.graphics.setCanvas(starfield)
   sound_laser = love.audio.newSource("data/laser.ogg", "static")
   sound_laser:setLooping(true)
   sound_booster = love.audio.newSource("data/booster.ogg", "static")
   sound_thruster = love.audio.newSource("data/thruster.ogg", "static")
   voice_welcomepilot = love.audio.newSource("data/welcomepilot.ogg", "static")
   voice_welcomepilot:setLooping(false)
   voice_liftoff = love.audio.newSource("data/liftoff.ogg", "static")
   voice_liftoff:setLooping(false)
   generate_starfield()
   generate_planetoid(planets[1], 100, 70, 100, 0, 0)	
   add_more_planets()
   --love.graphics.setCanvas()
   frame = 0
end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   elseif key == "e" then
      if pilot.besideship == 1 and pilot.enteredship == 0 then
	 pilot.enteredship = 1
	 spaceship.x = pilot.x+drawx
	 spaceship.y = pilot.y+drawy  		
	 voice_welcomepilot:play()
      elseif pilot.enteredship == 1 then --exit the ship
	 pilot.enteredship = 0
	 
	 --pilot.x = love.graphics.getWidth()/2 
	 --pilot.y = love.graphics.getHeight()/2  	
	 pilot.x = love.graphics.getWidth()/2
	 pilot.y = love.graphics.getHeight()/2
	 spaceship.x = pilot.x -drawx
	 spaceship.y = pilot.y -drawy
	 spaceship.rot = 0
      end -- the ship loc needs to update!
   end
end

function increase_ship_speed(dir)
   if pilot.enteredship == 1 then 
      sound_thruster:play()
   end
   if pilot.enteredship == 1 and spaceship.speed <= spaceship.maxspeed then
      spaceship.speed = spaceship.speed+1
      --if dir == "up" then spaceship.rot = 90
      --elseif dir == "right" then spaceship.rot =180
      --elseif dir == "down" then spaceship.rot = 270
      --elseif dir == "left" then spaceship.rot = 0
      --end
   end
end
function decrease_ship_speed()
	if pilot.enteredship == 1 and spaceship.speed >= 3 then
		spaceship.speed = spaceship.speed-1
	end
end

function love.update(dt)
   -----
   if love.mouse.isDown(1) then
      raygun=1
   else
      raygun=0
   end
   if pilot.enteredship == 0 then
      speed = pilot.speed
   else -- =1
      speed = spaceship.speed
      if scale <= 0.25 then
      	drawmode = "space"
      end
   end
   on_read_keyboard(dt) --keyboard.lua

   nearestplanetindex = check_near_planet()
end

function love.draw()
   local width = love.graphics.getWidth()
   local height = love.graphics.getHeight()
   if drawmode == "land" then
   	draw_landmode()
   else --spacemode
   	draw_spacemode()
   end   

   love.graphics.setColor(255,255,255)
   love.graphics.print("Altitude: ".. scale..10, 20)
   if pilot.enteredship == 0 then
      love.graphics.print("Use Directional Keys to walk, around, spacebar to use jetpack, and left mouse to shoot laser.",
			  10, love.graphics.getHeight()-30 )
   else -- you are in the ship
      love.graphics.print("Use directional keys for thrusters, comma to fly up, and period to fly down. Use A and D to rotate ship",
			  10, love.graphics.getHeight()-30 ) 
   end
   --love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
   love.graphics.print("Nearest Planet: nearestplanetindex"..nearestplanetindex, 0,20)
end
