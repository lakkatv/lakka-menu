tween = require 'tween'

function love.load()

	love.mouse.setVisible(false)

	love.graphics.setNewFont('JosefinSans-Bold.ttf', 30)
	love.graphics.setColor(255,255,255)
	love.graphics.setBackgroundColor(26, 188, 156)

	WIDTH, HEIGHT = love.window.getDimensions()
	HSPACING = 300 -- horizontal spacing between 2 categories
	VSPACING = 100 -- vertical spacing between 2 items
	C_ACTIVE_ZOOM = 1
	C_PASSIVE_ZOOM = 0.5
	I_ACTIVE_ZOOM = 0.75
	I_PASSIVE_ZOOM = 0.35

	categories = {
		{
			name = "Settings",
			icon = love.graphics.newImage("settings.png"),
			a = 255,
			z = C_ACTIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Theme",   icon = love.graphics.newImage("setting.png"), a = 255, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0 },
				{ name = "Network", icon = love.graphics.newImage("setting.png"), a = 128, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0 },

			},
		},
		{
			name = "SEGA MasterSystem",
			icon = love.graphics.newImage("mastersystem.png"),
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Sonic Chaos", icon = love.graphics.newImage("mastersystem-cartidge.png"), a = 0, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0 },
				{ name = "Zool",        icon = love.graphics.newImage("mastersystem-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0 },
			},
		},
		{
			name = "Nintendo Entertainment System",
			icon = love.graphics.newImage("nes.png"),
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Mario Bros.", icon = love.graphics.newImage("nes-cartidge.png"), a = 0, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0 },
				{ name = "Mario Bros.", icon = love.graphics.newImage("nes-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0 },
				{ name = "Mario Bros.", icon = love.graphics.newImage("nes-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*5   , r = 0, v = 0 },
			},
		},
		{
			name = "SEGA Megadrive",
			icon = love.graphics.newImage("megadrive.png"),
			lib = '/usr/lib/libretro/libretro-genplus.so',
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Sonic 2", icon = love.graphics.newImage("megadrive-cartidge.png"), a = 0, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0 },
				{ name = "Sonic 3", icon = love.graphics.newImage("megadrive-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0},
			},
		},
		{
			name = "GameBoy",
			icon = love.graphics.newImage("gb.png"),
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Pokemon Jaune", icon = love.graphics.newImage("gb-cartidge.png"), a = 0, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0 },
				{ name = "Pokemon Rouge", icon = love.graphics.newImage("gb-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0 },
			},
		},
		{
			name = "Super Nintendo",
			icon = love.graphics.newImage("snes.png"),
			lib = '/usr/lib/libretro/libretro-snes9x-next.so',
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Super Bomberman",     icon = love.graphics.newImage("snes-cartidge.png"), a = 0, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0},
				{ name = "Secret of Mana",      icon = love.graphics.newImage("snes-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0},
				{ name = "Super Metroid",       icon = love.graphics.newImage("snes-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*5   , r = 0, v = 0},
				{ name = "The Legend of Zelda", icon = love.graphics.newImage("snes-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*6   , r = 0, v = 0},
				{ name = "Tactics Ogre",        icon = love.graphics.newImage("snes-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*7   , r = 0, v = 0},
			},
		},
		{
			name = "Playstation",
			icon = love.graphics.newImage("ps1.png"),
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Crash Bandicoot",   icon = love.graphics.newImage("ps1-cd.png"), a = 0, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0 },
				{ name = "Final Fantasy VII", icon = love.graphics.newImage("ps1-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0 },
				{ name = "Xenogears",         icon = love.graphics.newImage("ps1-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*5   , r = 0, v = 0 },
				{ name = "Suikoden 2",        icon = love.graphics.newImage("ps1-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*6   , r = 0, v = 0 },
				{ name = "Suikoden 2",        icon = love.graphics.newImage("ps1-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*7   , r = 0, v = 0 },
			},
		},
		{
			name = "GameBoy Color",
			icon = love.graphics.newImage("gbcolor.png"),
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Pokemon Or",           icon = love.graphics.newImage("gbcolor-cartidge.png"), a = 0, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0 },
				{ name = "New Super Mario Bros", icon = love.graphics.newImage("gbcolor-cartidge.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0 },
			},
		},
		{
			name = "NeoGeo",
			icon = love.graphics.newImage("neogeo.png"),
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
				{ name = "Metal Slug",   icon = love.graphics.newImage("neogeo-cd.png"), a = 0, z = I_ACTIVE_ZOOM,  y = VSPACING*2.35, r = 0, v = 0 },
				{ name = "Metal Slug 2", icon = love.graphics.newImage("neogeo-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*4   , r = 0, v = 0 },
				{ name = "Metal Slug 3", icon = love.graphics.newImage("neogeo-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*5   , r = 0, v = 0 },
				{ name = "Metal Slug 4", icon = love.graphics.newImage("neogeo-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*6   , r = 0, v = 0 },
				{ name = "Metal Slug 5", icon = love.graphics.newImage("neogeo-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*7   , r = 0, v = 0 },
				{ name = "Metal Slug X", icon = love.graphics.newImage("neogeo-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*8   , r = 0, v = 0 },
				{ name = "Bomberman",    icon = love.graphics.newImage("neogeo-cd.png"), a = 0, z = I_PASSIVE_ZOOM, y = VSPACING*9   , r = 0, v = 0 },
			},
		},
		{
			name = "Cave Story",
			icon = love.graphics.newImage("cavestory.png"),
			a = 128,
			z = C_PASSIVE_ZOOM,
			active_item = 1,
			items = {
			},
		},
	}

	-- wallpaper = love.graphics.newImage("wallpaper.png")

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

-- Move the categories left or right depending on the active_category var
function switch_categories()

	love.audio.play(snd_switch)

	-- move all categories
	tween(0.25, all_categories, { x = -HSPACING * (active_category-1) }, 'inOutQuad')

	-- tween transparency
	for i, category in ipairs(categories) do
		if i == active_category then
			tween(0.25, category, { a = 255 }, 'inOutQuad')
			tween(0.25, category, { z = C_ACTIVE_ZOOM }, 'outBack')
			for j, item in ipairs(category.items) do
				if j == category.active_item then
					tween(0.25, item, { a = 255 }, 'inOutQuad')
				else
					tween(0.25, item, { a = 128 }, 'inOutQuad')
				end
			end
		else
			tween(0.25, category, { a = 128 }, 'inOutQuad')
			tween(0.25, category, { z = C_PASSIVE_ZOOM }, 'outBack')
			for j, item in ipairs(category.items) do
				tween(0.25, item, { a = 0 }, 'inOutQuad')
			end
		end
	end

	--tween(0.25, obj_background, { x = -100 * (active_category-1) }, 'inOutQuad')
end

-- Move the items of the active category up or down
function switch_items ()

	love.audio.play(snd_switch)

	for y, item in ipairs(categories[active_category].items) do
		if y == categories[active_category].active_item and item.bg then
			wallpaper = item.bg
		end

		-- Above items
		if y < categories[active_category].active_item  then
			tween(0.25, item, { a = 128 }, 'inOutQuad')
			tween(0.25, item, { y = VSPACING*(y-categories[active_category].active_item)}, 'inOutQuad')
			tween(0.25, item, { z = I_PASSIVE_ZOOM }, 'outBack')
		-- Active item
		elseif y == categories[active_category].active_item then
			tween(0.25, item, { a = 255 }, 'inOutQuad')
			tween(0.25, item, { y = VSPACING*2.35}, 'inOutQuad')
			tween(0.25, item, { z = I_ACTIVE_ZOOM }, 'outBack')
		-- Under items
		elseif y > categories[active_category].active_item then
			tween(0.25, item, { a = 128 }, 'inOutQuad')
			tween(0.25, item, { y = VSPACING*(y-categories[active_category].active_item + 3)}, 'inOutQuad')
			tween(0.25, item, { z = I_PASSIVE_ZOOM }, 'outBack')
		end
	end
end

function love.update(dt)
	-- handle category switch
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

	-- handle item switch
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


	for i, category in ipairs(categories) do
		for j, item in ipairs(category.items) do
			if i == 7 and i == active_category and j == category.active_item then
				item.v = item.v + (math.pi/1024)
				rotation_speed(item, dt)
			else
				item.v = item.v - (math.pi/1024)
				rotation_speed(item, dt)
			end
		end
	end

	tween.update(dt)
end

function rotation_speed(item, dt)
	if item.v > math.pi/4 then
		item.v = math.pi/4
	elseif item.v < 0 then
		item.v = 0
	end

	item.r = item.r + item.v

	if item.r >= math.pi*2 then
		item.r = 0
	end
end

function love.draw()
	--love.graphics.setColor(26, 188, 156, 8)
	--love.graphics.draw(wallpaper)

	--love.graphics.setColor(255,255,255)
	--love.graphics.draw(img_background, obj_background.x)

	-- Print category name
	love.graphics.setColor(236, 240, 241)
	love.graphics.print(categories[active_category].name, 10, 10)
	-- Print the current date
	love.graphics.printf(os.date("%x %H:%M", os.time()), 0, 10, WIDTH-10, 'right')

	-- Draw categories and items
	for i, category in ipairs(categories) do

		-- rotate the settings icon if active
		if active_category == 1 then
			r = r + 0.0025
		end

		-- Draw items
		for j, item in ipairs(category.items) do
			love.graphics.setColor(236, 240, 241, item.a) -- set item transparency
			if i == 1 and j == category.active_item then
				love.graphics.draw( item.icon, 156 + (HSPACING*i) + all_categories.x, 300 + item.y - 25, -r, item.z, item.z, 192/2, 192/2)
			else
				love.graphics.draw( item.icon, 156 + (HSPACING*i) + all_categories.x, 300 + item.y - 25, item.r, item.z, item.z, 192/2, 192/2)
			end
			love.graphics.print(item.name, 256 + (HSPACING*i) + all_categories.x, 300-15 + item.y - 25)
		end

		-- Draw category
		love.graphics.setColor(255,255,255,category.a) -- set category transparency
		if i == 1 then
			love.graphics.draw(category.icon, 156 + (HSPACING*i) + all_categories.x, 300, r, category.z, category.z, 192/2, 192/2)
		else
			love.graphics.draw(category.icon, 156 + (HSPACING*i) + all_categories.x, 300, 0, category.z, category.z, 192/2, 192/2)
		end
		
	end

	-- Draw the black overlay that fade of during startup
	love.graphics.setColor(0, 0, 0, overlay.a)
	love.graphics.rectangle('fill', 0, 0, 1920, 1080)
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
