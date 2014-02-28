--[[
Be A Cat

Version: 0.0.1
Last update: 28.02.2014
Programmer: Wattanit Hotrakool (@rorasa)
            CannonLight Games
-----------------------------------------------------------
LÖVE version: 0.9.0
]]


ScreenMode = 0 --[[
	0 = Start Screen
	1 = Game Screen
	2 = Next Level
	3 = Game Over
]]
GameLevel = 1
GameScore = 0
GameLife = 9
Targets = {}

function love.load()
	graphicsInit()
	love.math.setRandomSeed( os.time() )
end

function love.update(dt)
	if ScreenMode == 1 then
		createYarn(dt)
		createBird(dt)
		createMouse(dt)
		updateTargets(dt)
		updateLevel()
		gameOverCheck()
	end
end

function love.draw()
	-- draw background
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(BG)
	
	-- draw contents
	-- Game Screen
	if ScreenMode == 1 then
		drawGame()
	-- Next Level
	elseif ScreenMode == 2 then
		drawLevel()
	-- Game Over
	elseif ScreenMode == 3 then
		drawOver()
	-- Start Screen
	else
		drawStart()
	end
end

-- ====================== Callback ========================

function love.mousereleased(x,y,button)
	-- Check game mode
	if ScreenMode == 1 then
		checkClick(x,y)
	elseif ScreenMode == 2 then
		ScreenMode = 1
	elseif ScreenMode == 3 then
		if x > 260 and x<510 and y > 450 and y < 500 then
			ScreenMode = 0
		end
	else
		-- Start Game
		GameLevel = 1
		GameScore = 0
		GameLife = 9
		ScreenMode = 2
	end
end

-- ================== Game Functions ======================

function createYarn(dt)
	if #Targets < 2*GameLevel then
		local newYarnChance = love.math.random()
		if newYarnChance<0.5 then
			local newYarnDirection = love.math.random()
			local Target = {}
			Target.type = "yarn"
			Target.score = 100
			Target.width = 50
			Target.height = 50
			if newYarnDirection < 0.5 then 
				Target.direction = "right"
				Target.x = -Target.width+50
			else 
				Target.direction = "left"
				Target.x = 800-50
			end
			Target.y = (love.math.random()*130)+400
			table.insert(Targets,Target)
		end
	end
end

function createBird(dt)
	if #Targets < 2*GameLevel and GameLevel >= 2 then
		local newBirdChance = love.math.random()
		if newBirdChance<0.5 then
			local Target = {}
			Target.type = "bird"
			Target.score = 150
			Target.width = 70
			Target.height = 58
			local newBirdDirection = love.math.random()
			if newBirdDirection < 0.5 then 
				Target.direction = "right"
				Target.x = -Target.width+100
			else 
				Target.direction = "left"
				Target.x = 800-100
			end
			Target.y = (love.math.random()*350)+60
			table.insert(Targets,Target)
		end
	end
end

function createMouse(dt)
	if #Targets < 2*GameLevel and GameLevel >= 3 then
		local newMouseChance = love.math.random()
		if newMouseChance<0.5 then
			local Target = {}
			Target.type = "mouse"
			Target.score = 300
			Target.width = 62
			Target.height = 65
			Target.move = 0
			Target.life = 0
			Target.maxLife = 3
			Target.x = (love.math.random()*600)+100
			Target.y = (love.math.random()*130)+400
			table.insert(Targets,Target)
		end
	end
end

function updateTargets(dt)
	for i,v in ipairs(Targets) do
	
		if v.type == "yarn" then
			-- move yarns
			if v.direction == "right" then
				v.x = v.x+(GameLevel*25*dt)
			else
				v.x = v.x-(GameLevel*25*dt)
			end
		end
	
		if v.type == "bird" then
			-- move birds
			if v.direction == "right" then
				v.x = v.x+(GameLevel*30*dt)
			else
				v.x = v.x-(GameLevel*30*dt)
			end
		end
		
		if v.type == "mouse" then
			-- move mouse, randomly
			v.move = v.move + dt
			if v.move >= 1 then
				v.x = (love.math.random()*600)+100
				v.y = (love.math.random()*130)+400
				v.move = 0
			end
			
			v.life = v.life + dt
			-- remove old mouses
			if v.life >= v.maxLife then
				table.remove(Targets,i)
				GameLife = GameLife-1
			end
		end
		
		-- remove targets outside screen
		if v.x > 800 or v.x < -v.width then
			table.remove(Targets,i)
			GameLife = GameLife-1
		end
	end
end

function updateLevel()
	if GameScore > 2000*(2^GameLevel-1) then
		GameLevel = GameLevel + 1
		ScreenMode = 2
		GameLife = 9
		for i,_ in ipairs(Targets) do
			table.remove(Targets,i)
		end
	end
end

function checkClick(cx,cy)
	for i,v in ipairs(Targets) do
	
		-- click detection
		local tx1,tx2 = v.x, v.x+v.width
		local ty1,ty2 = v.y, v.y+v.height
		
		if cx > tx1 and cx < tx2 and cy > ty1 and cy < ty2 then
			-- remove clicked object
			table.remove(Targets,i)
			
			-- add score
			GameScore = GameScore + GameLevel*v.score;
		end
	end
end

function gameOverCheck()
	if GameLife <= 0 then
		ScreenMode = 3
		for i,_ in ipairs(Targets) do
			table.remove(Targets,i)
		end
	end
end

-- ================ Graphic functions =====================

function graphicsInit()
	-- load font
	Fonts = {}
	Fonts.small = love.graphics.newFont( "IntuitiveRegular.ttf", 18 )
	Fonts.big = love.graphics.newFont( "IntuitiveRegular.ttf", 32 )
	Fonts.Xbig = love.graphics.newFont( "IntuitiveRegular.ttf", 64 )
	Fonts.default = love.graphics.newFont(18)

	-- load background
	BG = love.graphics.newImage("images/BG.png")
	
	-- load Start Screen contents
	SCContents = {}
	SCContents.Start = love.graphics.newImage("images/start.png")
	SCContents.Logo = love.graphics.newImage("images/logo.png")
	
	-- load Game Screen contents
	GSContents = {}
	GSContents.yarn = love.graphics.newImage("images/yarn.png")
	GSContents.birdL = love.graphics.newImage("images/birdL.png")
	GSContents.birdR = love.graphics.newImage("images/birdR.png")
	GSContents.mouse = love.graphics.newImage("images/mouse.png")
end

function drawStart()
	love.graphics.setFont(Fonts.default)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Be A Cat 0.0.1")
		
	love.graphics.draw(SCContents.Start, 300,360)
	love.graphics.draw(SCContents.Logo, 220,100)
end

function drawLevel()
	love.graphics.setFont(Fonts.big)
	love.graphics.print("LEVEL",370,200)
	love.graphics.setFont(Fonts.Xbig)
	love.graphics.print(GameLevel, 400,220)
end

function drawOver()
	love.graphics.setColor(255,0,0,255)
	love.graphics.setFont(Fonts.Xbig)
	love.graphics.print("GAME OVER",250,200)
	
	love.graphics.setFont(Fonts.big)
	love.graphics.print("SCORE: "..GameScore,200,300)
	love.graphics.print("MAX LEVEL: "..GameLevel, 450,300)
	
	love.graphics.setFont(Fonts.Xbig)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("RESTART?",260,450)
end

function drawGame()

	-- draw score
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(Fonts.big)
	love.graphics.print("SCORE: "..GameScore,20,10)
	
	-- draw lift
	love.graphics.print("LIFE: "..GameLife, 700,10)

	-- draw targets
	for i,v in ipairs(Targets) do
		love.graphics.setColor(255,255,255,255)
		if v.type == "yarn" then
			love.graphics.draw(GSContents.yarn,v.x,v.y)
		elseif v.type == "bird" then
			if v.direction == "left" then
				love.graphics.draw(GSContents.birdL,v.x,v.y)
			else
				love.graphics.draw(GSContents.birdR,v.x,v.y)
			end
		elseif v.type == "mouse" then
			love.graphics.draw(GSContents.mouse,v.x,v.y)
		end
	end
end