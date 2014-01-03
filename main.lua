tween = require 'tween'

function love.load()

	love.mouse.setVisible(false)

	love.graphics.setNewFont('JosefinSans-Bold.ttf', 30)
	love.graphics.setColor(255,255,255)
	love.graphics.setBackgroundColor(155, 89, 182)

	hspacing = 380 -- horizontal spacing between 2 categories
	vspacing = 150 -- vertical spacing between 2 items
	active_zoom = 1
	default_zoom = 0.75

	categories = {
		{
			name = "Settings",
			icon = love.graphics.newImage("settings.png"),
			a = 255,
			z = active_zoom,
			active_item = 1,
			items = {
				{ name = "Theme", icon = love.graphics.newImage("setting.png"), a = 255, z = active_zoom, y = vspacing },
			},
		},
		{
			name = "Nintendo Entertainment System",
			icon = love.graphics.newImage("nes.png"),
			a = 128,
			z = default_zoom,
			active_item = 1,
			items = {
				{ name = "Mario Bros.", icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing },
			},
		},
		{
			name = "Super Nintendo",
			icon = love.graphics.newImage("snes.png"),
			a = 128,
			z = default_zoom,
			active_item = 1,
			items = {
				{ name = "Super Bomberman",  icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom,  y = vspacing*1 },
				{ name = "Secret of Mana",   icon = love.graphics.newImage("item.png"), a = 0, z = default_zoom, y = vspacing*2 },
				{ name = "Chrono Trigger",   icon = love.graphics.newImage("item.png"), a = 0, z = default_zoom, y = vspacing*3 },
				{ name = "Final Fantasy VI", icon = love.graphics.newImage("item.png"), a = 0, z = default_zoom, y = vspacing*4 },
				{ name = "Bahamut Lagoon",   icon = love.graphics.newImage("item.png"), a = 0, z = default_zoom, y = vspacing*5 },
				{ name = "Super Metroid",    icon = love.graphics.newImage("item.png"), a = 0, z = default_zoom, y = vspacing*6 },
			},
		},
		{
			name = "SEGA Megadrive",
			icon = love.graphics.newImage("megadrive.png"),
			a = 128,
			z = default_zoom,
			active_item = 1,
			items = {
				{ name = "Sonic 2", icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*1 },
				{ name = "Sonic 3", icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*2 },
			},
		},
		{
			name = "Playstation",
			icon = love.graphics.newImage("ps1.png"),
			a = 128,
			z = default_zoom,
			active_item = 1,
			items = {},
		},
		{
			name = "NeoGeo",
			icon = love.graphics.newImage("neogeo.png"),
			a = 128,
			z = default_zoom,
			active_item = 1,
			items = {
				{ name = "Metal Slug",   icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*1 },
				{ name = "Metal Slug 2", icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*2 },
				{ name = "Metal Slug 3", icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*3 },
				{ name = "Metal Slug 4", icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*4 },
				{ name = "Metal Slug 5", icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*5 },
				{ name = "Metal Slug X", icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*6 },
				{ name = "Bomberman",    icon = love.graphics.newImage("item.png"), a = 0, z = active_zoom, y = vspacing*7 },
			},
		},
	}

	wallpaper = love.graphics.newImage("wallpaper.png")

	active_category = 1

	t1 = 0
	all_categories = { x = 0 } -- global x for all categories
	--obj_background = { x = 0 }

	r = 0 -- used to rotate the settings icon

	snd_switch = love.audio.newSource("switch.wav", "static")
	--img_background = love.graphics.newImage("bg.png")
end

function switch_categories()

	love.audio.play(snd_switch)

	-- move all categories
	tween(0.25, all_categories, { x = -hspacing * (active_category-1) }, 'inOutQuad')

	-- tween transparency
	for i, category in ipairs(categories) do
		if i == active_category then
			tween(0.25, category, { a = 255 }, 'inOutQuad')
			tween(0.25, category, { z = active_zoom }, 'outBack')
			for y, item in ipairs(category.items) do
				if y == category.active_item then
					tween(0.25, item, { a = 255 }, 'inOutQuad')
				else
					tween(0.25, item, { a = 128 }, 'inOutQuad')
				end
			end
		else
			tween(0.25, category, { a = 128 }, 'inOutQuad')
			tween(0.25, category, { z = default_zoom }, 'outBack')
			for y, item in ipairs(category.items) do
				tween(0.25, item, { a = 0 }, 'inOutQuad')
			end
		end
	end

	--tween(0.25, obj_background, { x = -100 * (active_category-1) }, 'inOutQuad')
end

function switch_items ()

	love.audio.play(snd_switch)

	for y, item in ipairs(categories[active_category].items) do
		if y < categories[active_category].active_item  then
			tween(0.25, item, { a = 128 }, 'inOutQuad')
			tween(0.25, item, { y = vspacing*(y-categories[active_category].active_item)}, 'inOutQuad')
			tween(0.25, item, { z = default_zoom }, 'outBack')
		elseif y == categories[active_category].active_item then
			tween(0.25, item, { a = 255 }, 'inOutQuad')
			tween(0.25, item, { y = vspacing}, 'inOutQuad')
			tween(0.25, item, { z = active_zoom }, 'outBack')
		elseif y > categories[active_category].active_item then
			tween(0.25, item, { a = 128 }, 'inOutQuad')
			tween(0.25, item, { y = vspacing*(y-categories[active_category].active_item +1)}, 'inOutQuad')
			tween(0.25, item, { z = default_zoom }, 'outBack')
		end
	end
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

	if love.keyboard.isDown("down") and love.timer.getTime() > t1 + 0.15 and categories[active_category].active_item < table.getn(categories[active_category].items) then
		t1 = love.timer.getTime()
		categories[active_category].active_item = categories[active_category].active_item + 1
		switch_items()
	end
	if love.keyboard.isDown("up") and love.timer.getTime() > t1 + 0.15 and categories[active_category].active_item > 1 then
		t1 = love.timer.getTime()
		categories[active_category].active_item = categories[active_category].active_item - 1
		switch_items()
	end

	tween.update(dt)
end

function love.draw()

	love.graphics.setColor(255, 255, 255)
	--love.graphics.draw(wallpaper)

	--love.graphics.setColor(255,255,255)
	--love.graphics.draw(img_background, obj_background.x)

	-- Print category name
	love.graphics.setColor(236, 240, 241)
	love.graphics.print(categories[active_category].name, 10, 10)
	love.graphics.print(os.date("%x %H:%M", os.time()), 1245, 10)

	--love.graphics.setColor(44, 62, 80)
	--love.graphics.rectangle('fill', 430, 0, 252, 900)


	for i, category in ipairs(categories) do

		for y, item in ipairs(category.items) do
			love.graphics.setColor(236, 240, 241, item.a)
			love.graphics.draw( item.icon, 156 + (hspacing*i) + all_categories.x, 300    + item.y, 0, item.z, item.z, 192/2, 192/2)
			love.graphics.print(item.name, 256 + (hspacing*i) + all_categories.x, 300-15 + item.y)
		end

		-- Set transparency
		love.graphics.setColor(255,255,255,category.a)

		-- rotate the settings icon if active
		if active_category == 1 then
			r = r + 0.0025
		end

		if i == 1 then
			love.graphics.draw(category.icon, 156 + (hspacing*i) + all_categories.x, 300, r, category.z, category.z, 192/2, 192/2)
		else
			love.graphics.draw(category.icon, 156 + (hspacing*i) + all_categories.x, 300, 0, category.z, category.z, 192/2, 192/2)
		end
		
	end
	
end

-- Escape the menu
function love.keypressed(key)
   if key == "escape" then
	  love.event.quit()
   end
end