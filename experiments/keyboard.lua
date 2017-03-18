function decend_ship()
end

function ascend_ship()
end

function on_read_keyboard(dt)
	local kx = 0
	local ky = 0	
   if love.keyboard.isDown("up") then
      increase_ship_speed("up")
      ky = ky + speed -- (speed *dt)
      if drawy % 32 == 0 then locy=locy-2 end
      if love.keyboard.isDown("left") then
	 kx = kx + speed -- (speed *dt)
      elseif love.keyboard.isDown("right") then
	 kx = kx - speed -- (speed *dt)
      end
   elseif love.keyboard.isDown("down") then
      increase_ship_speed("down")
      ky = ky - speed --(speed *dt)
      if love.keyboard.isDown("left") then
	 kx = kx + speed -- (speed *dt)
      elseif love.keyboard.isDown("right") then
	 kx = kx - speed -- (speed *dt)
      end
   elseif love.keyboard.isDown("left") then
      increase_ship_speed("left")
      kx = kx +speed
      if love.keyboard.isDown("up") then
	 ky = ky + speed -- (speed *dt)
      elseif love.keyboard.isDown("down") then
	 ky = ky - speed --(speed *dt)
      end
   elseif love.keyboard.isDown("right") then
      increase_ship_speed("right")
      kx = kx -speed
      if love.keyboard.isDown("up") then
	 ky = ky + speed -- (speed *dt)
      elseif love.keyboard.isDown("down") then
	 ky = ky - speed --(speed *dt)
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
	 scale = scale -(scalespeed *dt)
      else
	 scale = minscale
      end
   elseif scale < maxscale then
      if pilot.enteredship == 0 then
	 scale = scale+0.005
      elseif love.keyboard.isDown(",") then --decend
	 if scale < maxscale then
	    scale = scale +(scalespeed *dt)
	 else
	    scale = maxscale --landed
	 end
      end --else fly! :)
   end
   if drawmode == "land" then
   	landcamx = landcamx+kx
   	landcamy = landcamy+ky
   else 
		spacecamx = spacecamx+kx
		spacecamy = spacecamy+ky
	end
   
end
