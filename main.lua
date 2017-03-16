
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
	playedtakeoff = 0
}
pilot = {
	x = drawx+32*locx+love.graphics.getWidth()/2, 
	y = drawy+32*locy+love.graphics.getHeight()/2,
	besideship = 0,
	enteredship = 0,
	speed=3
}

speed = 3
scale = 1
minscale = 0.001
maxscale = 1
translate = 0

planets = {
	{
		name = "allos 1",
		x = drawx+50*32,
		y = drawx+50*32,
		blocktable = {},
		landmap= nil
	}
}

function draw_planets()
	--local x = drawx+50*32
	--local y = drawx+50*32
	--local c = drawy+50*32+ (100*16)
	love.graphics.setColor(255,255,255)--hal0
	--love.graphics.circle("fill", x-10,y-10,100*32+10, 16)
	--love.graphics.setColor(100,blocktable[1], 100)--planet, planet
	--love.graphics.circle("fill", x,y,100*32, 16) --draw the planet
	love.graphics.circle("fill", 
				planets[1].x+drawx-10, planets[1].y+drawy-10, 
				100*32+20, 16)
	love.graphics.setColor(100,planets[1].blocktable[1], 100)--planet, planet
	love.graphics.circle("fill", 
				planets[1].x+drawx-5, planets[1].y+drawy-5, 100*32, 16)
				
	if scale > 0.35 then
		--draw planets, puts it off the circle, can we texture a circle?
		love.graphics.draw(planets[1].landmap, drawx, drawy)
	end
	
	
	--if c < 0 then love.graphics.print("?: "..x..":"..y, 10, y)
	--elseif c < 0 then love.graphics.print("?: "..x..":"..y, x, 10) 
	--elseif c < 0 then love.graphics.print("?: "..x..":"..y, x, 10) 
	--end
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
	if pilot.enteredship == 1 then
		dx = love.graphics.getWidth()/2
		dy = love.graphics.getHeight()/2
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
	love.graphics.rotate(spaceship.rot)
	love.graphics.translate(-width/2-50, -height/2)
	love.graphics.setColor(50,50,50)
	love.graphics.polygon("fill", 				
		s.x + dx,     s.y + dy,
		s.x +dx+200, s.y +dy-80,
		s.x +dx+200, s.y +dy+80)
	love.graphics.setColor(60,60,60)
	love.graphics.polygon("fill", 				
		s.x+dx+10,     s.y+dy,
		s.x+dx+200-10, s.y+dy-80+10,
		s.x+dx+200-10, s.y+dy+80-10)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("loc: " ..spaceship.x.."x"..spaceship.y,
	spaceship.x+drawx,spaceship.y+drawy-15 )

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
function generate_planetoid(p)
	for y=1, 100, 1 do
		for x=1, 100, 1 do
			table.insert(p.blocktable, math.random(70,150)  )	
		end
	end
	p.landmap = love.graphics.newCanvas(100*32,  100*32)
	love.graphics.setCanvas(p.landmap)
	for y=1, 100, 1 do --draw the landscape
		for x=1, 100, 1 do					
			love.graphics.setColor(100, p.blocktable[y*x], 100)
			love.graphics.rectangle("fill", x*32, y*32, 32, 32 )
		end
	end
	love.graphics.setCanvas()
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
	generate_planetoid(planets[1])	
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
	
	if love.mouse.isDown(1) then
		raygun=1
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
	
	
end

function love.draw()
	for y=1, 100, 1 do
		for x=1, 100, 1 do
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
	love.graphics.translate(translate, translate)
	love.graphics.scale(scale, scale)
	
	
	draw_planets()
	love.graphics.pop()
	
	love.graphics.push()
	love.graphics.translate(translate, translate)
	love.graphics.scale(scale, scale)	
	--pilot shadow?
	if pilot.enteredship == 0 then
		love.graphics.setColor(0,0,0, 100)
		love.graphics.circle("fill", pilot.x, pilot.y, 16, 8)
		draw_spaceship(spaceship)
	end
	
	love.graphics.print("loc: " ..spaceship.x.."x"..spaceship.y,
		spaceship.x+drawx,spaceship.y+drawy-15 )
	
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
	
end