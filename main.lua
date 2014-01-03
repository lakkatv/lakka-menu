tween = require 'tween'

function love.load()

	love.mouse.setVisible(false)

	love.graphics.setNewFont('JosefinSans-Bold.ttf', 30)
	love.graphics.setColor(255,255,255)
	love.graphics.setBackgroundColor(155, 89, 182)

	spacing = 380 -- spacing between 2 icons
	zooming = 1
	default_zoom = 0.75

	categories = {
		{ name = "Settings",                      icon = love.graphics.newImage("settings.png"), a = 255, z = zooming      },
		{ name = "Nintendo Entertainment System", icon = love.graphics.newImage("nes.png"),      a = 128, z = default_zoom },
		{ name = "Super Nintendo",                icon = love.graphics.newImage("snes.png"),     a = 128, z = default_zoom },
		{ name = "Playstation",                   icon = love.graphics.newImage("ps1.png"),      a = 128, z = default_zoom },
	}

	active_category = 1

	t1 = 0
	obj_categories = { x = 0 } -- global x for all categories
	--obj_background = { x = 0 }

	r = 0 -- used to rotate the settings icon

	snd_switch = love.audio.newSource("switch.wav", "static")
	--img_background = love.graphics.newImage("bg.png")
end

function switch_categories()

	love.audio.play(snd_switch)

	-- move all categories
	tween(0.25, obj_categories, { x = -spacing * (active_category-1) }, 'inOutQuad')

	-- tween transparency
	for i, category in ipairs(categories) do
		if i == active_category then
			tween(0.25, categories[i], { a = 255 },     'inOutQuad')
			tween(0.25, categories[i], { z = zooming }, 'outBack')

		else
			tween(0.25, categories[i], { a = 128 }, 'inOutQuad')
			tween(0.25, categories[i], { z = default_zoom }, 'outBack')

		end
	end

	--tween(0.25, obj_background, { x = -100 * (active_category-1) }, 'inOutQuad')
end

function love.update(dt)
	if love.keyboard.isDown("right") and love.timer.getTime() > t1 + 0.3 and active_category < table.getn(categories) then
		t1 = love.timer.getTime()
		active_category = active_category + 1
		switch_categories()
	end
	if love.keyboard.isDown("left") and love.timer.getTime() > t1 + 0.3 and active_category > 1 then
		t1 = love.timer.getTime()
		active_category = active_category - 1
		switch_categories()
	end

	tween.update(dt)
end

function love.draw()

	--love.graphics.setColor(255,255,255)
	--love.graphics.draw(img_background, obj_background.x)

	-- Print category name
	love.graphics.setColor(236, 240, 241)
	love.graphics.print(categories[active_category].name, 10, 10)
	love.graphics.print(os.date("%x %H:%M", os.time()), 1245, 10)

	--love.graphics.setColor(44, 62, 80)
	--love.graphics.rectangle('fill', 430, 0, 252, 900)


	for i, category in ipairs(categories) do

		-- Set transparency
		love.graphics.setColor(255,255,255,category.a)

		-- rotate the settings icon if active
		if active_category == 1 then
			r = r + 0.0025
		end

		if i == 1 then
			love.graphics.draw(category.icon, 156 + (spacing*i) + obj_categories.x, 321, r, category.z, category.z, 192/2, 192/2)
		else
			love.graphics.draw(category.icon, 156 + (spacing*i) + obj_categories.x, 321, 0, category.z, category.z, 192/2, 192/2)
		end
		
	end
	
end

-- Escape the menu
function love.keypressed(key)
   if key == "escape" then
	  love.event.quit()
   end
end