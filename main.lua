
ScreenMode = 0 --[[
	0 = Start Screen
	1 = Game Screen
	2 = Next Level
	3 = Game Over
]]
GameLevel = 0

Targets = {}

function love.load()
	graphicsInit()
	love.math.setRandomSeed( 10 )
	
	local Target = {}
	Target.type = 1
	Target.width = 98
	Target.height = 98
	Target.x = 500
	Target.y = 500
end

function love.update(dt)
	if ScreenMode == 1 then
		--createYarn(dt)
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
	
	-- Start Screen
	else
		drawStart()
	end
end

-- ====================== Callback ========================

function love.mousereleased(x,y,button)
	-- Check game mode
	if ScreenMode == 1 then
	
	elseif ScreenMode == 2 then
		ScreenMode = 1
	elseif ScreenMode == 3 then
	
	else
		-- Start Game
		GameLevel = GameLevel + 1
		ScreenMode = 2
	end
end

-- ================== Game Functions ======================

function createYarn(dt)
	if #Targets < 2*GameLevel then
		local newYarnChance = love.math.random()
		if true then
			local newYarnDirection = love.math.random()
			local Target = {}
			Target.type = "yarn"
			Target.width = 98
			Target.height = 98
			if newYarnDirection < 0.5 then Target.x = -Target.width+100
			else Target.x = 800-700 end
			Target.y = (love.math.random()*130)+435
			table.insert(Targets,Target)
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

function drawGame()
	for i,v in ipairs(Targets) do
		love.graphics.setColor(255,255,255,255)
		if v.type == 1 then
			love.graphics.draw(GSContents.yarn,v.x,v.y)
		end
		
	end
end