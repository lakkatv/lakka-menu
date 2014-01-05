tween = require 'tween'

function love.load()

	love.mouse.setVisible(false)

	love.graphics.setNewFont('JosefinSans-Bold.ttf', 30)
	love.graphics.setColor(255,255,255)
	love.graphics.setBackgroundColor(26, 188, 156)

	WIDTH, HEIGHT = love.window.getDimensions()
	HSPACING = 380 -- horizontal spacing between 2 categories
	VSPACING = 150 -- vertical spacing between 2 items
	ACTIVE_ZOOM = 1
	PASSIVE_ZOOM = 0.75

	categories = {
		{
			name = "Settings",
			icon = love.graphics.newImage("settings.png"),
			a = 255,
			z = ACTIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Theme", icon = love.graphics.newImage("setting.png"), a = 255, z = ACTIVE_ZOOM, y = VSPACING },
			},
		},
		{
			name = "Nintendo Entertainment System",
			icon = love.graphics.newImage("nes.png"),
			a = 128,
			z = PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Mario Bros.", icon = love.graphics.newImage("item.png"), a = 0, z = ACTIVE_ZOOM, y = VSPACING },
			},
		},
		{
			name = "Super Nintendo",
			icon = love.graphics.newImage("snes.png"),
			lib = '/usr/lib/libretro/libretro-snes9x-next.so',
			a = 128,
			z = PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Super Bomberman",     icon = love.graphics.newImage("item.png"), a = 0, z = ACTIVE_ZOOM,  y = VSPACING*1, bg = love.graphics.newImage("bg_bomberman.png") },
				{ name = "Secret of Mana",      icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*2, bg = love.graphics.newImage("bg_som.png") },
				{ name = "Super Metroid",       icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*3, bg = love.graphics.newImage("bg_metroid.png"), rom = '/home/kivutar/Jeux/roms/metroid.smc' },
				{ name = "The Legend of Zelda", icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*4, bg = love.graphics.newImage("bg_zelda.png"), rom = '/home/kivutar/Jeux/roms/zelda.smc' },
				{ name = "Tactics Ogre",        icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*5, bg = love.graphics.newImage("bg_to.png") },
			},
		},
		{
			name = "SEGA Megadrive",
			icon = love.graphics.newImage("megadrive.png"),
			lib = '/usr/lib/libretro/libretro-genplus.so',
			a = 128,
			z = PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Sonic 2", icon = love.graphics.newImage("item.png"), a = 0, z = ACTIVE_ZOOM, y = VSPACING*1 },
				{ name = "Sonic 3", icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*2, rom = "/home/kivutar/Jeux/roms/sonic3.smd" },
			},
		},
		{
			name = "Playstation",
			icon = love.graphics.newImage("ps1.png"),
			a = 128,
			z = PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Crash Bandicoot",   icon = love.graphics.newImage("item.png"), a = 0, z = ACTIVE_ZOOM, y = VSPACING*1 },
				{ name = "Final Fantasy VII", icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*2 },
				{ name = "Xenogears",         icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*3 },
				{ name = "Suikoden 2",        icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*4 },
				{ name = "Suikoden 2",        icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*5 },
			},
		},
		{
			name = "NeoGeo",
			icon = love.graphics.newImage("neogeo.png"),
			a = 128,
			z = PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Metal Slug",   icon = love.graphics.newImage("item.png"), a = 0, z = ACTIVE_ZOOM, y = VSPACING*1 },
				{ name = "Metal Slug 2", icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*2 },
				{ name = "Metal Slug 3", icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*3 },
				{ name = "Metal Slug 4", icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*4 },
				{ name = "Metal Slug 5", icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*5 },
				{ name = "Metal Slug X", icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*6 },
				{ name = "Bomberman",    icon = love.graphics.newImage("item.png"), a = 0, z = PASSIVE_ZOOM, y = VSPACING*7 },
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

	overlay = { a = 255 }

	tween(1, overlay, { a = 0 }, 'inOutQuad')
end

function switch_categories()

	love.audio.play(snd_switch)

	-- move all categories
	tween(0.25, all_categories, { x = -HSPACING * (active_category-1) }, 'inOutQuad')

	-- tween transparency
	for i, category in ipairs(categories) do
		if i == active_category then
			tween(0.25, category, { a = 255 }, 'inOutQuad')
			tween(0.25, category, { z = ACTIVE_ZOOM }, 'outBack')
			for j, item in ipairs(category.items) do
				if j == category.active_item then
					tween(0.25, item, { a = 255 }, 'inOutQuad')
				else
					tween(0.25, item, { a = 128 }, 'inOutQuad')
				end
			end
		else
			tween(0.25, category, { a = 128 }, 'inOutQuad')
			tween(0.25, category, { z = PASSIVE_ZOOM }, 'outBack')
			for j, item in ipairs(category.items) do
				tween(0.25, item, { a = 0 }, 'inOutQuad')
			end
		end
	end

	--tween(0.25, obj_background, { x = -100 * (active_category-1) }, 'inOutQuad')
end

function switch_items ()

	love.audio.play(snd_switch)

	for y, item in ipairs(categories[active_category].items) do
		if y == categories[active_category].active_item and item.bg then
			wallpaper = item.bg
		end

		if y < categories[active_category].active_item  then
			tween(0.25, item, { a = 128 }, 'inOutQuad')
			tween(0.25, item, { y = VSPACING*(y-categories[active_category].active_item)}, 'inOutQuad')
			tween(0.25, item, { z = PASSIVE_ZOOM }, 'outBack')
		elseif y == categories[active_category].active_item then
			tween(0.25, item, { a = 255 }, 'inOutQuad')
			tween(0.25, item, { y = VSPACING}, 'inOutQuad')
			tween(0.25, item, { z = ACTIVE_ZOOM }, 'outBack')
		elseif y > categories[active_category].active_item then
			tween(0.25, item, { a = 128 }, 'inOutQuad')
			tween(0.25, item, { y = VSPACING*(y-categories[active_category].active_item +1)}, 'inOutQuad')
			tween(0.25, item, { z = PASSIVE_ZOOM }, 'outBack')
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
	--love.graphics.setColor(26, 188, 156, 8)
	--love.graphics.draw(wallpaper)

	--love.graphics.setColor(255,255,255)
	--love.graphics.draw(img_background, obj_background.x)

	-- Print category name
	love.graphics.setColor(236, 240, 241)
	love.graphics.print(categories[active_category].name, 10, 10)
	love.graphics.printf(os.date("%x %H:%M", os.time()), 0, 10, WIDTH-10, 'right')

	--love.graphics.setColor(44, 62, 80)
	--love.graphics.rectangle('fill', 430, 0, 252, 900)


	for i, category in ipairs(categories) do

		-- rotate the settings icon if active
		if active_category == 1 then
			r = r + 0.0025
		end

		for j, item in ipairs(category.items) do
			love.graphics.setColor(236, 240, 241, item.a)
			if i == 1 and j == category.active_item then
				love.graphics.draw( item.icon, 156 + (HSPACING*i) + all_categories.x, 300    + item.y, -r, item.z, item.z, 192/2, 192/2)
			else
				love.graphics.draw( item.icon, 156 + (HSPACING*i) + all_categories.x, 300    + item.y, 0, item.z, item.z, 192/2, 192/2)
			end
			love.graphics.print(item.name, 256 + (HSPACING*i) + all_categories.x, 300-15 + item.y)
		end

		-- Set transparency
		love.graphics.setColor(255,255,255,category.a)

		if i == 1 then
			love.graphics.draw(category.icon, 156 + (HSPACING*i) + all_categories.x, 300, r, category.z, category.z, 192/2, 192/2)
		else
			love.graphics.draw(category.icon, 156 + (HSPACING*i) + all_categories.x, 300, 0, category.z, category.z, 192/2, 192/2)
		end
		
	end

	love.graphics.setColor(0, 0, 0, overlay.a)
	love.graphics.rectangle('fill', 0, 0, 1440, 900)
end

-- Escape the menu
function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "e" then
		for i, category in ipairs(categories) do
			if i == active_category then
				for j, item in ipairs(category.items) do
					if j == category.active_item then
						os.execute("/usr/bin/retroarch -L " .. category.lib .. " " .. item.rom)
					end
				end
			end
		end
	end
end