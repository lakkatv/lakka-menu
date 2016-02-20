tween = require 'tween'

function responsive()

	ICON_SIZE = 256
	HSPACING = 200.0
	VSPACING = 64.0
	C_ACTIVE_ZOOM = 0.5
	C_PASSIVE_ZOOM = 0.25
	I_ACTIVE_ZOOM = 0.5
	I_PASSIVE_ZOOM = 0.25
	ACTIVE_ITEM_FACTOR = 2.25
	FONT_SIZE = 24
	MARGIN_LEFT = 120.0
	MARGIN_TOP = 200.0
	TITLE_MARGIN_LEFT = 15.0
	TITLE_MARGIN_TOP = 15.0
	LABEL_MARGIN_LEFT = 70
end

function love.load()

	local WIDTH, HEIGHT = love.window.getMode()
	love.window.setMode(WIDTH, HEIGHT, {fullscreen= true, vsync=true})
	love.mouse.setVisible(false)

	theme = 'monochrome'

	repertory = 'retroarch-assets/xmb/'

	responsive()

	love.graphics.setNewFont(repertory .. theme .. "/" .. "font.ttf", FONT_SIZE)
	background = love.graphics.newImage(repertory .. theme .. "/png/" .. "bg.png")
	love.graphics.setColor(255,255,255)

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
		-- {
		-- 	name = "Atari2600",
		-- 	prefix = "Atari 2600",
		-- 	items = {
		-- 		{ name = "Pac-Man" },
		-- 		{ name = "Pengo" },
		-- 	},
		-- },
		{
			name = "GCE - Vectrex",
			prefix = "GCE - Vectrex",
			items = {
				{ name = "Game 1" },
				{ name = "Game 2" },
			},
		},
		{
			name = "Sega - MasterSystem - Mark III",
			prefix = "Sega - Master System - Mark III",
			items = {
				{ name = "Sonic Chaos" },
				{ name = "Zool" },
				{ name = "Wonderboy 3" },
				{ name = "Alex kid" },
			},
		},
		{
			name = "Nintendo - Nintendo Entertainment System",
			prefix = "Nintendo - Nintendo Entertainment System",
			items = {
				{ name = "Mario Bros." },
				{ name = "Final Fantasy 3" },
				{ name = "Mario Bros." },
			},
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

	arrow = love.graphics.newImage(repertory .. theme .. "/png/" .. "arrow.png")

	overlay = { a = 255 }
	tween(1, overlay, { a = 0 }, 'outSine')

	for i,category in ipairs(categories) do
		category.a = i == active_category and 255 or 128
		category.z = i == active_category and C_ACTIVE_ZOOM or C_PASSIVE_ZOOM
		category.active_item = 1
		category.icon = love.graphics.newImage(repertory .. theme .. "/png/" .. category.prefix .. ".png")
		if not category.items then category.items = {} end

		for j,item in ipairs(category.items) do
			if category.prefix == "settings" then
				item.icon = love.graphics.newImage(repertory .. theme .. "/png/setting.png")
			else
				item.icon = love.graphics.newImage(repertory .. theme .. "/png/" .. category.prefix .. "-content.png")
			end
			if i == active_category and j == category.active_item then
				item.a = 255
			elseif i == active_category and j ~= category.active_item then
				item.a = 128
			else
				item.a = 0
			end
			if j == 1 then
				item.y = VSPACING*ACTIVE_ITEM_FACTOR
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
				item.slot = 0
				item.items = {
					{name = "Resume Content" },
					{name = "Save State" },
					{name = "Load State" },
					{name = "Take Screenshot" },
					{name = "Restart Content" },
				}
			end

			for k,subitem in ipairs(item.items) do
				subitem.icon = love.graphics.newImage(repertory .. theme .. "/png/" .. "subsetting.png")
				if category.prefix ~= "settings" then
					if k == 1 then subitem.icon = love.graphics.newImage(repertory .. theme .. "/png/" .. "run.png") end
					if k == 2 then subitem.icon = love.graphics.newImage(repertory .. theme .. "/png/" .. "savestate.png") end
					if k == 3 then subitem.icon = love.graphics.newImage(repertory .. theme .. "/png/" .. "loadstate.png") end
					if k == 4 then subitem.icon = love.graphics.newImage(repertory .. theme .. "/png/" .. "screenshot.png") end
					if k == 5 then subitem.icon = love.graphics.newImage(repertory .. theme .. "/png/" .. "reload.png") end
				end
				subitem.a = 0
				subitem.r = 0
				subitem.v = 0
				subitem.z = k == item.active_subitem and I_ACTIVE_ZOOM or I_PASSIVE_ZOOM
				if k == 1 then
					subitem.y = VSPACING*ACTIVE_ITEM_FACTOR
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

	for j, item in ipairs(categories[active_category].items) do
		-- Above items
		if j < categories[active_category].active_item  then
			tween(0.25, item, { a = 128 }, 'outSine')
			tween(0.25, item, { y = VSPACING*(j-categories[active_category].active_item - 1)}, 'outSine')
			tween(0.25, item, { z = I_PASSIVE_ZOOM }, 'outBack')
		-- Active item
		elseif j == categories[active_category].active_item then
			tween(0.25, item, { a = 255 }, 'outSine')
			tween(0.25, item, { y = VSPACING*ACTIVE_ITEM_FACTOR}, 'outSine')
			tween(0.25, item, { z = I_ACTIVE_ZOOM }, 'outBack')
		-- Under items
		elseif j > categories[active_category].active_item then
			tween(0.25, item, { a = 128 }, 'outSine')
			tween(0.25, item, { y = VSPACING*(j-categories[active_category].active_item + 3)}, 'outSine')
			tween(0.25, item, { z = I_PASSIVE_ZOOM }, 'outBack')
		end
	end
end

-- Move the items of the active category up or down
function switch_subitems ()

	love.audio.play(snd_switch)

	ac = categories[active_category]
	ai = ac.items[ac.active_item]

	for k, subitem in ipairs(ai.items) do
		-- Above items
		if k < ai.active_subitem then
			tween(0.25, subitem, { a = 128 }, 'outSine')
			tween(0.25, subitem, { y = VSPACING*(k-ai.active_subitem + 2)}, 'outSine')
			tween(0.25, subitem, { z = I_PASSIVE_ZOOM }, 'outBack')
		-- Active item
		elseif k == ai.active_subitem then
			tween(0.25, subitem, { a = 255 }, 'outSine')
			tween(0.25, subitem, { y = VSPACING*ACTIVE_ITEM_FACTOR}, 'outSine')
			tween(0.25, subitem, { z = I_ACTIVE_ZOOM }, 'outBack')
		-- Under items
		elseif k > ai.active_subitem then
			tween(0.25, subitem, { a = 128 }, 'outSine')
			tween(0.25, subitem, { y = VSPACING*(k-ai.active_subitem + 3)}, 'outSine')
			tween(0.25, subitem, { z = I_PASSIVE_ZOOM }, 'outBack')
		end
	end
end

function open_submenu ()

	love.audio.play(snd_switch)

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
	ac = categories[active_category]
	ai = ac.items[ac.active_item]

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
	if depth == 0 and love.keyboard.isDown("down") and love.timer.getTime() > t1 + 0.3 and ac.active_item < table.getn(ac.items) then
		t1 = love.timer.getTime()
		ac.active_item = ac.active_item + 1
		switch_items()
	end
	if depth == 0 and love.keyboard.isDown("up") and love.timer.getTime() > t1 + 0.3 and ac.active_item > 1 then
		t1 = love.timer.getTime()
		ac.active_item = ac.active_item - 1
		switch_items()
	end

	-- handle subitem switch
	if depth == 1 and love.keyboard.isDown("down") and love.timer.getTime() > t1 + 0.3 and ai.active_subitem < table.getn(ai.items) then
		t1 = love.timer.getTime()
		ai.active_subitem = ai.active_subitem + 1
		switch_subitems()
	end
	if depth == 1 and love.keyboard.isDown("up") and love.timer.getTime() > t1 + 0.3 and ai.active_subitem > 1 then
		t1 = love.timer.getTime()
		ai.active_subitem = ai.active_subitem - 1
		switch_subitems()
	end

	-- handle slot switch
	if depth == 1 and love.keyboard.isDown("right") and love.timer.getTime() > t1 + 0.3 and ac.prefix ~= "settings" and (ai.active_subitem == 2 or ai.active_subitem == 3) then
		t1 = love.timer.getTime()
		ai.slot = ai.slot + 1
	end
	if depth == 1 and love.keyboard.isDown("left") and love.timer.getTime() > t1 + 0.3 and ac.prefix ~= "settings" and (ai.active_subitem == 2 or ai.active_subitem == 3) and ai.slot > -1 then
		t1 = love.timer.getTime()
		ai.slot = ai.slot - 1
	end

	if love.keyboard.isDown("x") and depth == 0 then
		open_submenu()
		depth = 1
	end

	if love.keyboard.isDown("w") and depth == 1 then
		close_submenu()
		depth = 0
	end

	tween.update(dt)
end

function love.draw()
	--love.graphics.setColor(26, 188, 156, 8)
	--love.graphics.draw(wallpaper)

	--love.graphics.setColor(255,255,255)
	--love.graphics.draw(img_background, obj_background.x)

	-- Print category name
	love.graphics.setColor(255,255,255)
	--love.graphics.draw(background, 0, 0, 0, love.window.getWidth( ), love.window.getHeight( ))

	local WIDTH, HEIGHT = love.window.getMode()
	background_sx = WIDTH/background:getWidth()
	background_sy = HEIGHT/background:getHeight()

	love.graphics.draw(background, 0, 0, 0, background_sx, background_sy)

	love.graphics.setColor(236, 240, 241)
	if depth == 0 then
		love.graphics.print(categories[active_category].name, TITLE_MARGIN_LEFT, TITLE_MARGIN_TOP)
	else
		love.graphics.print(categories[active_category].items[categories[active_category].active_item].name, TITLE_MARGIN_LEFT, TITLE_MARGIN_TOP)
	end
	-- Print the current date
	love.graphics.printf(os.date("%x %H:%M", os.time()), 0, TITLE_MARGIN_TOP, WIDTH-TITLE_MARGIN_LEFT, 'right')

	-- Draw categories and items
	for i, category in ipairs(categories) do

		-- Draw items
		for j, item in ipairs(category.items) do
			love.graphics.setColor(236, 240, 241, item.a) -- set item transparency
			love.graphics.draw( item.icon, MARGIN_LEFT + (HSPACING*i) + all_categories.x, MARGIN_TOP + item.y, item.r, item.z, item.z, ICON_SIZE/2, ICON_SIZE/2)

			for k, subitem in ipairs(item.items) do
				love.graphics.setColor(236, 240, 241, subitem.a)
				love.graphics.draw( subitem.icon, MARGIN_LEFT + (HSPACING*(i+1)) + all_categories.x, MARGIN_TOP + subitem.y, subitem.r, subitem.z, subitem.z, ICON_SIZE/2, ICON_SIZE/2)
				if category.prefix ~= "settings" and  (k == 2 or k == 3) and item.slot == -1 then
					love.graphics.print(subitem.name .. " <" .. item.slot .. " (auto)>", MARGIN_LEFT + LABEL_MARGIN_LEFT + (HSPACING*(i+1)) + all_categories.x, MARGIN_TOP-15 + subitem.y)
				elseif category.prefix ~= "settings" and  (k == 2 or k == 3) then
					love.graphics.print(subitem.name .. " <" .. item.slot .. ">", MARGIN_LEFT + LABEL_MARGIN_LEFT + (HSPACING*(i+1)) + all_categories.x, MARGIN_TOP-15 + subitem.y)
				else
					love.graphics.print(subitem.name, MARGIN_LEFT + LABEL_MARGIN_LEFT + (HSPACING*(i+1)) + all_categories.x, MARGIN_TOP-15 + subitem.y)
				end
				love.graphics.setColor(236, 240, 241, item.a)
			end

			if depth == 0 then
				love.graphics.print(item.name, MARGIN_LEFT + LABEL_MARGIN_LEFT + (HSPACING*i) + all_categories.x, MARGIN_TOP-15 + item.y)
			else
				love.graphics.draw(arrow, MARGIN_LEFT + (HSPACING*(i+0.5)) + all_categories.x, MARGIN_TOP + item.y, item.r, item.z, item.z, ICON_SIZE/2, ICON_SIZE/2)
			end
		end

		-- Draw category
		love.graphics.setColor(255,255,255,category.a) -- set category transparency
		love.graphics.draw(category.icon, MARGIN_LEFT + (HSPACING*i) + all_categories.x, MARGIN_TOP, 0, category.z, category.z, ICON_SIZE/2, ICON_SIZE/2)

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
