locx = 50
locy = 50
drawx = -32*locx
drawy = -32*locy


starXtable = {}
starYtable = {}

blocktable = {}
spaceship = {
   x = -drawx +200, 
   y = -drawy +200,
   speed = 3,
   maxspeed=150,
   rot = 0,
   playedtakeoff = 0,
   csprite = 4,
   sprite = {love.graphics.newImage("data/ship_1_1.png"),
	     love.graphics.newImage("data/ship_1_2.png"),
	     love.graphics.newImage("data/ship_1_3.png"),
	     love.graphics.newImage("data/ship_1_4.png")
   }
}
otherships = {}

pilot = {
   x = drawx+32*locx+love.graphics.getWidth()/2, 
   y = drawy+32*locy+love.graphics.getHeight()/2,
   besideship = 0,
   enteredship = 0,
   speed=3,
   csprite =1,
   sprite = {love.graphics.newImage("data/pilot1.png"),
	     love.graphics.newImage("data/pilot2.png"),
	     love.graphics.newImage("data/pilot3.png"),
	     love.graphics.newImage("data/pilot4.png")
   }
}

speed = 3
scale = 1
minscale = 0.005
maxscale = 1
translate = 0
title_screen = nil
mode = "title"

planets = {
   {
      name = "allos 1",
      x = love.graphics.getWidth(), --drawx+50*32,
      y = love.graphics.getHeight(), --drawx+50*32,
      w = 75*32,
      blocktable = {},
      landmap= nil,
      circlemap = nil,
      pmesh = nil,
      ptype = "normal"
   }
}

function load_other_ships()
   for i=1,100 do
      local shipnum = math.random(1,3)
      table.insert(otherships,
		   {
		      x = math.random(-250000, 250000),
		      y = math.random(-250000, 250000),
		      destx = math.random(-250000, 250000),
		      desty = math.random(-250000, 250000),
		      speed = 100,
		      maxspeed=150,
		      rot = 0,
		      csprite = 4,
		      travel_timer = 0,
		      sprite = {love.graphics.newImage("data/ship_"..shipnum.."_1.png"),
				love.graphics.newImage("data/ship_"..shipnum.."_2.png"),
				love.graphics.newImage("data/ship_"..shipnum.."_3.png"),
				love.graphics.newImage("data/ship_"..shipnum.."_4.png")
		      }
		   }
      )
   end
end
function draw_other_ships()
   --if at a certain alt(0.155, draw all ships)
   if scale <= 0.155 then
      for i,v in ipairs(otherships) do
	 love.graphics.draw(otherships[i].sprite[otherships[i].csprite],
			    otherships[i].x+drawx,
			    otherships[i].y+drawy, 0,
			    40, 40
			    --scale, scale
	 )	 
      end
   end
end
function move_other_ships()
   for i,v in ipairs(otherships) do 
  		otherships[i].travel_timer = otherships[i].travel_timer+1
   	if otherships[i].x >= otherships[i].destx then
   		otherships[i].x = otherships[i].x - otherships[i].speed
   	else
   		--otherships[i].x = otherships[i].destx
   	end
   	
   	if otherships[i].x <= otherships[i].destx then
   		otherships[i].x = otherships[i].x + otherships[i].speed
   	else
   		--otherships[i].x = otherships[i].destx
   	end
   	
   	if otherships[i].y >= otherships[i].desty then
   		otherships[i].y = otherships[i].y - otherships[i].speed
   	else
   		--otherships[i].y = otherships[i].desty
   	end
   	
   	if otherships[i].y <= otherships[i].desty then
   		otherships[i].y = otherships[i].y + otherships[i].speed
   	else
   		--otherships[i].y = otherships[i].desty
   	end
   	
   	if otherships[i].travel_timer >= 500 then
   			otherships[i].destx = otherships[i].destx + math.random(-100000, 100000)
   			otherships[i].desty = otherships[i].desty + math.random(-100000, 100000)
   			otherships[i].travel_timer=0
   	end   	
   end
end

function CreateTexturedCircle(image, segments, ptype)
   major, minor, revision, codename = love.getVersion( )
   --print("Version: Major"..major.."minor"..minor)
   segments = segments or 40
   local vertices = {}
   -- The first vertex is at the center, and has a red tint. We're centering the circle around the origin (0, 0).
   table.insert(vertices, {0, 0, 0.5, 0.5, 255, 255, 255}) 	
   for i=0, segments do  -- Create the vertices at the edge of the circle.
      local angle = (i / segments) * math.pi * 2 
      -- Unit-circle.
      local x = math.cos(angle)
      local y = math.sin(angle)
      -- Our position is in the range of [-1, 1] but we want the 
      -- texture coordinate to be in the range of [0, 1].
      
      local u = (x + 1) * 0.5
      if ptype == "gasgiant" then
	 u = (x+1) *5
      end
      local v = (y + 1) * 0.5
      -- The per-vertex color defaults to white.
      table.insert(vertices, {x, y, u, v, 255, 255, 255})
   end
   -- The "fan" draw mode is perfect for our circle.
   if minor == 10 then
      --print("version 10 detected")
      local mesh = love.graphics.newMesh(vertices, "fan")
      mesh:setTexture(image)
      return mesh
   else
      print("version 9 detected")
      local mesh = love.graphics.newMesh( vertices, image, "fan" )
      return mesh
   end      
   --mesh:setAttributeEnabled("VertexColor", enable)
   return mesh
end

function draw_planets()
   for i, v in ipairs(planets) do
      --print("drawing planet: "..i.." at "..planets[i].x.."x"..planets[i].y)
      love.graphics.setColor(255,255,255)
      if planets[i].pmesh == nil then --print("its nil")
	 love.graphics.setColor(255,255,255)
	 love.graphics.circle("fill",
			      planets[i].x +drawx,
			      planets[i].y +drawy,
			      2000,32)
      else
	 love.graphics.setColor(255,255,255)
	 love.graphics.draw( planets[i].pmesh,
			     planets[i].x +drawx ,
			     planets[i].y +drawy ,
			     0,
			     planets[i].w,
			     planets[i].w)
      end
   end
end

function generate_spaceship1()
   spaceship1 = love.graphics.newCanvas(300, 300)
end

function draw_pilot(p)
   local dx = 0
   local dy = 0	
   if pilot.enteredship == 0 then
      love.graphics.setColor(255,255,255) --pilot
      --love.graphics.print("loc: "..pilot.x-drawx..":"..pilot.y-drawy, 
      --pilot.x+15, pilot.y+15)
      --love.graphics.circle("fill", pilot.x, pilot.y , 16, 8)
      love.graphics.draw(pilot.sprite[pilot.csprite], pilot.x-28, pilot.y-28)
   else -- ship is ready to fly!
      draw_spaceship(spaceship)
   end
end

function draw_spaceship(s)
   local dx = 0
   local dy = 0
   if pilot.enteredship == 1 then
      dx = love.graphics.getWidth()/2 -100
      dy = love.graphics.getHeight()/2 -100
      s.x=0
      s.y=0
   else
      dx = drawx
      dy = drawy
   end
   love.graphics.push()
   local width = love.graphics.getWidth()
   local height = love.graphics.getHeight()
   -- rotate around the center of the screen by angle radians	
   love.graphics.translate(width/2+50, height/2)
   --love.graphics.rotate(spaceship.rot)
   love.graphics.translate(-width/2-50, -height/2)
   love.graphics.setColor(255,255,255)
   love.graphics.draw(s.sprite[s.csprite], s.x-100+dx, s.y-100+dy, s.rot,3,3 )
   
   love.graphics.pop()
end


function generate_starfield()
   for y=1, 100, 1 do
      for x=1, 100, 1 do
	 table.insert(starXtable, math.random(1, love.graphics.getWidth()))
	 table.insert(starYtable, math.random(1, love.graphics.getHeight()))
      end
   end
end

function generate_landmap(r,g,b)
   local bt = {}
   for y=1, 100, 1 do
      for x=1, 100, 1 do
	 --table.insert(p.blocktable, math.random(70,150)  )
	 --table.insert(p.blocktable, math.random(g,g+80)  )
	 table.insert(bt, math.random(g,g+80)  )
      end
   end
   bts = love.graphics.newCanvas(100*32,  100*32)
   love.graphics.setCanvas(bts)
   for y=1, 100, 1 do --draw the landscape
      for x=1, 100, 1 do					
	 --love.graphics.setColor(100, p.blocktable[y*x], 100)
	 love.graphics.setColor(r, bt[y*x], b)
	 love.graphics.rectangle("fill", x*32, y*32, 32, 32 )
      end
   end
   love.graphics.setCanvas()
   return bts
   
end
function generate_planetoid(p,r,g,b)
   for y=1, 100, 1 do
      for x=1, 100, 1 do
	 --table.insert(p.blocktable, math.random(70,150)  )
	 table.insert(p.blocktable, math.random(g,g+80)  )	
      end
   end
   p.landmap = love.graphics.newCanvas(100*32,  100*32)
   love.graphics.setCanvas(p.landmap)
   for y=1, 100, 1 do --draw the landscape
      for x=1, 100, 1 do					
	 --love.graphics.setColor(100, p.blocktable[y*x], 100)
	 love.graphics.setColor(r, p.blocktable[y*x], b)
	 love.graphics.rectangle("fill", x*32, y*32, 32, 32 )
      end
   end
   love.graphics.setCanvas()	
   p.pmesh = CreateTexturedCircle(p.landmap, 32)
end

function add_more_planets()
   local w = love.graphics.getWidth()
   local h = love.graphics.getHeight()
   --local placex = 0
   --local placey = 0
   for i=2, 20 do
      local placex = math.random(-80, 80) *48
      local placey = math.random(-80, 80) *48
      local gettype = math.random(1,5)
      if gettype == 1 then
	 s = "gasgiant"
      else
	 s = "normal"
      end
      local lm = generate_landmap(math.random(100,150),	100, math.random(100.150))
      local pm = CreateTexturedCircle(lm, 32, s)
      table.insert(planets, {
		      name = "?",
		      x = love.graphics.getWidth()+placex *32,
                      y = love.graphics.getHeight()+placey*32,
		      w = 75*32, 
		      blocktable = {},
		      landmap= lm,
		      --circlemap = nil,
		      pmesh = pm,
		      ptype = s
      })
      local rbcolors = math.random(80,120)
      local gcolors = math.random(20, 100)
      generate_planetoid(planets[i], rbcolors,gcolors,rbcolors)
   end
end

function love.load()
   --love.graphics.setCanvas(starfield)
   sound_laser = love.audio.newSource("data/laser.ogg", "static")
   sound_laser:setLooping(true)
   sound_booster = love.audio.newSource("data/booster.ogg", "static")
   sound_thruster = love.audio.newSource("data/thruster.ogg", "static")
   --sound_booster = love.audio.newSource("data/booster.ogg", "static")
   --sound_thruster = love.audio.newSource("data/thruster.ogg", "static")
   --sound_woosh = love.audio.newSource("woosh.wav", "static")
   voice_welcomepilot = love.audio.newSource("data/welcomepilot.ogg", "static")
   voice_welcomepilot:setLooping(false)
   voice_liftoff = love.audio.newSource("data/liftoff.ogg", "static")
   voice_liftoff:setLooping(false)
   generate_starfield()
   generate_planetoid(planets[1], 100, 70, 100)	
   add_more_planets()
   load_other_ships()
   title_screen = love.graphics.newImage("data/title.jpg")
   --love.graphics.setCanvas()
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

function love.update()	
   if love.mouse.isDown(1) and mode == "scene" then
   	raygun=1
   elseif love.mouse.isDown(1) and mode == "title" then
   	mode = "scene"
   else
   	raygun=0
   end
   if pilot.enteredship == 0 then
      speed = pilot.speed
   else
      speed = spaceship.speed
   end
   
   if love.keyboard.isDown("space") or love.keyboard.isDown(".") then
      if pilot.enteredship == 1 then 
	 sound_thruster:play()
      elseif pilot.enteredship == 0 then 
	 sound_booster:play()
      end
      
      if scale > minscale then
	 if pilot.enteredship == 1 and spaceship.playedtakeoff == 0 then
	    voice_liftoff:play()
	    spaceship.playedtakeoff = 1
	 end
	 scale = scale-0.005
	 translate = translate+1
      else
	 scale = minscale
      end
   elseif scale < maxscale then
      if pilot.enteredship == 0 then
	 scale = scale+0.005
	 translate = translate-1
      elseif love.keyboard.isDown(",") then --decend
	 if scale < maxscale then
	    scale = scale+0.002
	 else
	    scale = maxscale --landed
	 end
      end --else fly! :)
   end
   if love.keyboard.isDown("up") then
      pilot.csprite = 1
      if pilot.enteredship == 1 then spaceship.csprite = 1 end
      increase_ship_speed("up")
      drawy = drawy+speed
      if drawy % 32 == 0 then locy=locy-2 end
      if love.keyboard.isDown("left") then
	 drawx = drawx+speed
	 if drawx % 32 == 0 then locx=locx-2 end
      elseif love.keyboard.isDown("right") then
	 drawx = drawx-speed
	 if drawx % 32 == 0 then locx=locx+2 end
      end
   elseif love.keyboard.isDown("down") then
      pilot.csprite = 3
      if pilot.enteredship == 1 then spaceship.csprite = 3 end
      increase_ship_speed("down")
      drawy = drawy-speed
      if drawy % 32 == 0 then locy=locy+2 end
      if love.keyboard.isDown("left") then
	 drawx = drawx+speed
	 if drawx % 32 == 0 then locx=locx+2 end
      elseif love.keyboard.isDown("right") then
	 drawx = drawx-speed
	 if drawx % 32 == 0 then locx=locx-2 end
      end
   elseif love.keyboard.isDown("left") then
      pilot.csprite = 4
      if pilot.enteredship == 1 then spaceship.csprite = 4 end
      increase_ship_speed("left")
      drawx = drawx+speed
      if drawx % 32 == 0 then locx=locx-2 end
      if love.keyboard.isDown("up") then
	 drawy = drawy+speed
	 if drawy % 32 == 0 then locy=locy-2 end
      elseif love.keyboard.isDown("down") then
	 drawy = drawy-speed
	 if drawy % 32 == 0 then locy=locy+2 end
      end
   elseif love.keyboard.isDown("right") then
      pilot.csprite = 2
      if pilot.enteredship == 1 then spaceship.csprite = 2 end
      increase_ship_speed("right")
      drawx = drawx-speed
      if drawx % 32 == 0 then locx=locx+2 end
      if love.keyboard.isDown("up") then
	 drawy = drawy+speed
	 if drawy % 32 == 0 then locy=locy-2 end
      elseif love.keyboard.isDown("down") then
	 drawy = drawy-speed
	 if drawy % 32 == 0 then locy=locy+2 end
      end
   elseif love.keyboard.isDown("a") then
      if pilot.enteredship == 1 then
	 spaceship.rot = spaceship.rot-0.1
      end
   elseif love.keyboard.isDown("d") then
      if pilot.enteredship == 1 then
	 spaceship.rot = spaceship.rot+0.1
      end
   else
      decrease_ship_speed()
   end
   move_other_ships()
end

function draw_scene()
	local width  = love.graphics.getWidth()/2
   local height = love.graphics.getHeight()/2
   for y=1, 100, 1 do
      for x=1, 
      100, 1 do
	 love.graphics.setColor(
	    math.random(150,255),
	    math.random(150,255),
	    math.random(150,255)
	 )
	 love.graphics.rectangle("fill", starXtable[y*x],
				 starYtable[y*x],2,2)
      end
   end
   love.graphics.push() --push for things that need to be scaled
   love.graphics.scale(scale, scale)
   love.graphics.translate(translate, translate)
   --love.graphics.scale(scale, scale)
   
   draw_planets()
   draw_other_ships()
   love.graphics.pop()   
   love.graphics.push()
   love.graphics.translate(translate, translate)
   --love.graphics.scale(scale, scale)
   love.graphics.scale(scale, scale)
   --love.graphics.translate(width/2+drawx, height/2+drawy)
   --pilot shadow?
   if pilot.enteredship == 0 then
      love.graphics.setColor(0,0,0, 100)
      love.graphics.circle("fill", pilot.x, pilot.y, 16, 8)
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
   
   if(    spaceship.x+drawx >= love.graphics.getWidth()/2-200 
	     and spaceship.x+drawx <= love.graphics.getWidth()/2+200
	     and spaceship.y+drawy >= love.graphics.getHeight()/2-200 
	  and spaceship.y+drawy <= love.graphics.getHeight()/2+200) then
      pilot.besideship = 1
      love.graphics.print("Enter ship[press e]", 10, love.graphics.getHeight()-60)
   else
      pilot.besideship = 0
   end
   love.graphics.pop()
   love.graphics.setColor(255,255,255)
   love.graphics.print("Altitude: ".. scale..10, 20)
   if pilot.enteredship == 0 then
      love.graphics.print("Use Directional Keys to walk, around, spacebar to use jetpack, and left mouse to shoot laser.",
			  10, love.graphics.getHeight()-30 )
   else -- you are in the ship
      love.graphics.print("Use directional keys for thrusters, comma to fly up, and period to fly down. Use A and D to rotate ship",
			  10, love.graphics.getHeight()-30 ) 
   end
   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
end

function love.draw()
   if mode == "title" then
   	love.graphics.setColor(255,255,255)
   	love.graphics.draw(title_screen, 0,0)
   else
   --draw everything else
   	draw_scene()
   end
end

