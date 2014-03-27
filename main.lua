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
			prefix = "settings",
			items = {
				{ name = "Video Options", items = {
					{name = "Shader Options" },
					{name = "Integer Scale" },
					{name = "Aspect Ratio" },
					{name = "Custom Ratio" },
					{name = "Toggle Fullscreen" },
					{name = "Rotation" },
					{name = "VSync" },
					{name = "Hard GPU Sync" },
					{name = "Hard GPU Sync Frames" },
					{name = "Black Frame Insertion" },
					{name = "VSync Swap Interval" },
					{name = "Threader Driver" },
					{name = "Windowed Scale (X)" },
					{name = "Windowed Scale (Y)" },
					{name = "Crop Overscan (reload)" },
					{name = "Estimated Monitor FPS" },
				} },
				{ name = "Audio Options", items = {
					{name = "Mute Audio" },
					{name = "Rate Control Delta" },
					{name = "Volume Level" },
				} },
				{ name = "Input Options", items = {
					{name = "Overlay Preset" },
					{name = "Overlay Opacity" },
					{name = "Overlay Scale" },
					{name = "Player" },
					{name = "Device" },
					{name = "Device Type" },
					{name = "Analog D-pad Mode" },
					{name = "Autodetect enable" },
					{name = "Configure All (RetroPad)" },
					{name = "Default All (RetroPad)" },
					{name = "RGUI Menu Toggle" },
					{name = "B Button (down)" },
					{name = "Y Button (left)" },
					{name = "..." },
				} },
				{ name = "Path Options", items = {
					{name = "Content Directory" },
					{name = "Config Directory" },
					{name = "Core Directory" },
					{name = "Core Info Directory" },
					{name = "Shader Directory" },
					{name = "Savestate Directory" },
					{name = "Savefile Directory" },
					{name = "Overlay Directory" },
					{name = "System Directory" },
					{name = "Screenshot Directory" },
				} },
				{ name = "Rewind" },
				{ name = "Rewind Granularity" },
				{ name = "GPU Screenshots" },
				{ name = "Config Save On Exit" },
				{ name = "Per-Core Configs" },
				{ name = "SRAM Autosave" },
				{ name = "Show Framerate" },
			},
		},
		{
			name = "SEGA MasterSystem",
			prefix = "mastersystem",
			items = {
				{ name = "Sonic Chaos" },
				{ name = "Zool" },
			},
		},
		{
			name = "Nintendo Entertainment System",
			prefix = "nes",
			items = {
				{ name = "Mario Bros." },
				{ name = "Mario Bros." },
				{ name = "Mario Bros." },
			},
		},
		{
			name = "SEGA Megadrive",
			prefix = "megadrive",
			items = {
				{ name = "Sonic 2" },
				{ name = "Sonic 3" },
			},
		},
		{
			name = "GameBoy",
			prefix = "gb",
			items = {
				{ name = "Pokemon Jaune" },
				{ name = "Pokemon Rouge" },
			},
		},
		{
			name = "Super Nintendo",
			prefix = "snes",
			items = {
				{ name = "Super Bomberman" },
				{ name = "Secret of Mana" },
				{ name = "Super Metroid" },
				{ name = "The Legend of Zelda" },
				{ name = "Tactics Ogre" },
			},
		},
		{
			name = "Playstation",
			prefix = "ps1",
			items = {
				{ name = "Crash Bandicoot" },
				{ name = "Final Fantasy VII" },
				{ name = "Xenogears" },
				{ name = "Suikoden 2" },
				{ name = "Suikoden 2" },
			},
		},
		{
			name = "GameBoy Color",
			prefix = "gbcolor",
			items = {
				{ name = "Pokemon Or" },
				{ name = "New Super Mario Bros" },
			},
		},
		{
			name = "NeoGeo",
			prefix = "neogeo",
			items = {
				{ name = "Metal Slug" },
				{ name = "Metal Slug 2" },
				{ name = "Metal Slug 3" },
				{ name = "Metal Slug 4" },
				{ name = "Metal Slug 5" },
				{ name = "Metal Slug X" },
				{ name = "Bomberman" },
			},
		},
		{
			name = "Cave Story",
			prefix = "cavestory",
		},
	}

	-- wallpaper = love.graphics.newImage("wallpaper.png")

	active_category = 1

	depth = 0

	t1 = 0
	all_categories = { x = 0 } -- global x for all categories
	--obj_background = { x = 0 }

	r = 0 -- used to rotate the settings icon

	snd_switch = love.audio.newSource("switch.wav", "static")
	--img_background = love.graphics.newImage("bg.png")

	overlay = { a = 255 }
	tween(1, overlay, { a = 0 }, 'outSine')

	for i,category in ipairs(categories) do
		category.a = i == active_category and 255 or 128
		category.z = i == active_category and C_ACTIVE_ZOOM or C_PASSIVE_ZOOM
		category.active_item = 1
		category.icon = love.graphics.newImage(category.prefix .. ".png")
		if not category.items then category.items = {} end

		for j,item in ipairs(category.items) do
			item.icon = love.graphics.newImage(category.prefix .. "-item.png")
			if i == active_category and j == category.active_item then
				item.a = 255
			elseif i == active_category and j ~= category.active_item then
				item.a = 128
			else
				item.a = 0
			end
			if j == 1 then
				item.y = VSPACING*2.35
				item.z = I_ACTIVE_ZOOM
			else
				item.y = VSPACING*(j+2)
				item.z = I_PASSIVE_ZOOM
			end
			item.r = 0
			item.v = 0
			item.active_subitem = 1
			if not item.items then item.items = {} end

			if category.prefix ~= "settings" then
				item.items = {
					{name = "Resume Content" },
					{name = "Save State" },
					{name = "Load State" },
					{name = "Take Screenshot" },
					{name = "Restart Content" },
				}
			end

			for k,subitem in ipairs(item.items) do
				subitem.icon = love.graphics.newImage("subsetting.png")
				if category.prefix ~= "settings" then
					if k == 1 then subitem.icon = love.graphics.newImage("play-pause.png") end
					if k == 2 then subitem.icon = love.graphics.newImage("savestate.png") end
					if k == 3 then subitem.icon = love.graphics.newImage("loadstate.png") end
					if k == 4 then subitem.icon = love.graphics.newImage("screenshot.png") end
					if k == 5 then subitem.icon = love.graphics.newImage("reload.png") end
				end
				subitem.a = 0
				subitem.r = 0
				subitem.v = 0
				subitem.z = k == item.active_subitem and I_ACTIVE_ZOOM or I_PASSIVE_ZOOM
				if k == 1 then
					subitem.y = VSPACING*2.35
				else
					subitem.y = VSPACING*(k+2)
				end
			end
		end
	end
end

-- Move the categories left or right depending on the active_category var
function switch_categories()

	love.audio.play(snd_switch)

	-- move all categories
	tween(0.25, all_categories, { x = -HSPACING * (active_category-1) }, 'outSine')

	-- tween transparency
	for i, category in ipairs(categories) do
		if i == active_category then
			tween(0.25, category, { a = 255 }, 'outSine')
			tween(0.25, category, { z = C_ACTIVE_ZOOM }, 'outBack')
			for j, item in ipairs(category.items) do
				if j == category.active_item then
					tween(0.25, item, { a = 255 }, 'outSine')
					tween(0.25, item, { z = I_ACTIVE_ZOOM }, 'outSine')
				else
					tween(0.25, item, { a = 128 }, 'outSine')
					tween(0.25, item, { z = I_PASSIVE_ZOOM }, 'outSine')
				end
			end
		else
			tween(0.25, category, { a = 128 }, 'outSine')
			tween(0.25, category, { z = C_PASSIVE_ZOOM }, 'outBack')
			for j, item in ipairs(category.items) do
				tween(0.25, item, { a = 0 }, 'outSine')
			end
		end
	end

	--tween(0.25, obj_background, { x = -100 * (active_category-1) }, 'outSine')
end

-- Move the items of the active category up or down
function switch_items ()

	love.audio.play(snd_switch)

	for y, item in ipairs(categories[active_category].items) do
		-- Above items
		if y < categories[active_category].active_item  then
			tween(0.25, item, { a = 128 }, 'outSine')
			tween(0.25, item, { y = VSPACING*(y-categories[active_category].active_item)}, 'outSine')
			tween(0.25, item, { z = I_PASSIVE_ZOOM }, 'outBack')
		-- Active item
		elseif y == categories[active_category].active_item then
			tween(0.25, item, { a = 255 }, 'outSine')
			tween(0.25, item, { y = VSPACING*2.35}, 'outSine')
			tween(0.25, item, { z = I_ACTIVE_ZOOM }, 'outBack')
		-- Under items
		elseif y > categories[active_category].active_item then
			tween(0.25, item, { a = 128 }, 'outSine')
			tween(0.25, item, { y = VSPACING*(y-categories[active_category].active_item + 3)}, 'outSine')
			tween(0.25, item, { z = I_PASSIVE_ZOOM }, 'outBack')
		end
	end
end

-- Move the items of the active category up or down
function switch_subitems ()

	love.audio.play(snd_switch)

	for k, subitem in ipairs(categories[active_category].items[categories[active_category].active_item].items) do
		-- Above items
		if k < categories[active_category].items[categories[active_category].active_item].active_subitem then
			tween(0.25, subitem, { a = 128 }, 'outSine')
			tween(0.25, subitem, { y = VSPACING*(k-categories[active_category].items[categories[active_category].active_item].active_subitem + 2)}, 'outSine')
			tween(0.25, subitem, { z = I_PASSIVE_ZOOM }, 'outBack')
		-- Active item
		elseif k == categories[active_category].items[categories[active_category].active_item].active_subitem then
			tween(0.25, subitem, { a = 255 }, 'outSine')
			tween(0.25, subitem, { y = VSPACING*2.35}, 'outSine')
			tween(0.25, subitem, { z = I_ACTIVE_ZOOM }, 'outBack')
		-- Under items
		elseif k > categories[active_category].items[categories[active_category].active_item].active_subitem then
			tween(0.25, subitem, { a = 128 }, 'outSine')
			tween(0.25, subitem, { y = VSPACING*(k-categories[active_category].items[categories[active_category].active_item].active_subitem + 3)}, 'outSine')
			tween(0.25, subitem, { z = I_PASSIVE_ZOOM }, 'outBack')
		end
	end
end

function open_submenu ()

	-- move all categories
	tween(0.25, all_categories, { x = -HSPACING * (active_category) }, 'outSine')

	for i, category in ipairs(categories) do
		if i == active_category then
			tween(0.25, category, { a = 255 }, 'outSine')
			for j, item in ipairs(category.items) do
				if j == category.active_item then
					for k, subitem in ipairs(item.items) do
						if k == item.active_subitem then
							tween(0.25, subitem, { a = 255 }, 'outSine')
							tween(0.25, subitem, { z = I_ACTIVE_ZOOM }, 'outBack')
						else
							tween(0.25, subitem, { a = 128 }, 'outSine')
							tween(0.25, subitem, { z = I_PASSIVE_ZOOM }, 'outBack')
						end
					end
				else
					tween(0.25, item, { a = 0 }, 'outSine')
				end
			end
		else
			tween(0.25, category, { a = 0 }, 'outSine')
		end
	end
end

function close_submenu ()

	-- move all categories
	tween(0.25, all_categories, { x = -HSPACING * (active_category-1) }, 'outSine')

	-- tween transparency
	for i, category in ipairs(categories) do
		if i == active_category then
			tween(0.25, category, { a = 255 }, 'outSine')
			tween(0.25, category, { z = C_ACTIVE_ZOOM }, 'outBack')
			for j, item in ipairs(category.items) do
				if j == category.active_item then
					tween(0.25, item, { a = 255 }, 'outSine')
					for k, subitem in ipairs(item.items) do
						tween(0.25, subitem, { a = 0 }, 'outSine')
					end
				else
					tween(0.25, item, { a = 128 }, 'outSine')
				end
			end
		else
			tween(0.25, category, { a = 128 }, 'outSine')
			tween(0.25, category, { z = C_PASSIVE_ZOOM }, 'outBack')
			for j, item in ipairs(category.items) do
				tween(0.25, item, { a = 0 }, 'outSine')
			end
		end
	end
end

function love.update(dt)
	-- handle category switch
	if depth == 0 and love.keyboard.isDown("right") and love.timer.getTime() > t1 + 0.3 and active_category < table.getn(categories) then
		t1 = love.timer.getTime()
		active_category = active_category + 1
		switch_categories()
	end
	if depth == 0 and love.keyboard.isDown("left") and love.timer.getTime() > t1 + 0.3 and active_category > 1 then
		t1 = love.timer.getTime()
		active_category = active_category - 1
		switch_categories()
	end

	-- handle item switch
	if depth == 0 and love.keyboard.isDown("down") and love.timer.getTime() > t1 + 0.3 and categories[active_category].active_item < table.getn(categories[active_category].items) then
		t1 = love.timer.getTime()
		categories[active_category].active_item = categories[active_category].active_item + 1
		switch_items()
	end
	if depth == 0 and love.keyboard.isDown("up") and love.timer.getTime() > t1 + 0.3 and categories[active_category].active_item > 1 then
		t1 = love.timer.getTime()
		categories[active_category].active_item = categories[active_category].active_item - 1
		switch_items()
	end

	-- handle subitem switch
	if depth == 1 and love.keyboard.isDown("down") and love.timer.getTime() > t1 + 0.3 and categories[active_category].items[categories[active_category].active_item].active_subitem < table.getn(categories[active_category].items[categories[active_category].active_item].items) then
		t1 = love.timer.getTime()
		categories[active_category].items[categories[active_category].active_item].active_subitem = categories[active_category].items[categories[active_category].active_item].active_subitem + 1
		switch_subitems()
	end
	if depth == 1 and love.keyboard.isDown("up") and love.timer.getTime() > t1 + 0.3 and categories[active_category].items[categories[active_category].active_item].active_subitem > 1 then
		t1 = love.timer.getTime()
		categories[active_category].items[categories[active_category].active_item].active_subitem = categories[active_category].items[categories[active_category].active_item].active_subitem - 1
		switch_subitems()
	end

	if love.keyboard.isDown(" ") and depth == 0 then
		open_submenu()
		depth = 1
	end

	if love.keyboard.isDown("backspace") and depth == 1 then
		close_submenu()
		depth = 0
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

			for k, subitem in ipairs(item.items) do
				love.graphics.setColor(236, 240, 241, subitem.a)
				love.graphics.draw( subitem.icon, 156 + (HSPACING*(i+1)) + all_categories.x, 300 + subitem.y - 25, subitem.r, subitem.z, subitem.z, 192/2, 192/2)
				love.graphics.print(subitem.name, 256 + (HSPACING*(i+1)) + all_categories.x, 300-15 + subitem.y - 25)
				love.graphics.setColor(236, 240, 241, item.a)
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
