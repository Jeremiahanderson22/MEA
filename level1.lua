-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local scoreTotal = 0
local scoreBoard
local highscore
local coin, mapleLeaf, diamond, C4
local coinTimer
local coins = {"coin", "mapleLeaf", "diamond", "C4"}
local coinsScore = { 1, 5, 10, -10 }
--local genericCoin = coins
local pauseButton
local splitCoin = {"DiamondT", "DiamondB", "CoinTop", "CoinBottom", "MapleLeafT", "MapleLeafB"}
math.randomseed( os.time() )
os.clock ()

local dubstep = audio.loadStream( "NinjaDubstep.mp3" )
dubstep = audio.play( dubstep, { duration = 61500, onComplete = finished })

ego = require "ego"
saveFile = ego.saveFile
loadFile = ego.loadFile


local coinsProp = {radius=20, density=1.0, friction=0.3, bounce=0.2, filter = {categoryBits = 2, maskBits = 1}}

local splitCoinProp = {radius=20, density=1.0, friction=0.3, bounce=0.2, filter = {categoryBits = 2, maskBits = 1}}
local allCoins = {}

local function initGroups()
  coinGroup = display.newGroup()
end

local function initCoins()
  local diamond = {}
    diamond.whole = "Diamond.png"
    diamond.top = "DiamondT.png"
    diamond.bottom = "DiamondB.png"
  table.insert( allCoins, diamond )
  
  local coin = {}
    coin.whole = "Coin.png"
    coin.top = "CoinTop.png"
    coin.bottom = "CoinBottom.png"
  table.insert( allCoins, coin )
  
  local mapleLeaf = {}
    mapleLeaf.whole = "MapleLeaf.png"
    mapleLeaf.top = "MapleLeafT.png"
    mapleLeaf.bottom = "MapleLeafB.png"
  table.insert( allCoins, mapleLeaf )
  
  local C4 = {}
    C4.whole = "C4.png"
    --diamond.top = "DiamondT.png"
    --diamond.bottom = "DiamondB.png"
  table.insert( allCoins, C4 )
end

--[[local function splitCoin( name )
  if name == "diamond" then
    print(name)
  elseif name == "coin" then
    print(name)
  elseif name == "mapleLeaf" then
    print(name)
  elseif name == "C4" then
    print(name)
  end
end--]]

local function coinTouchHandler( event )
  --if event.phase == "began" then
    local sounds = audio.loadSound("METALonMETAL.mp3");
    audio.play(sounds)
    print("begin "..event.target.name)
  --elseif event.phase == "ended" then
    --scoreTotal = scoreTotal + event.target.coinValue
    scoreTotal = highscore
    --scoreBoard.text = string.format("%d", scoreTotal ) 
    print(scoreTotal)
    --print(event.target)
    --splitCoin( event.target.name )
  --end
end
-- All of the normal coins
local function createCoins( name, score )
  local initCoins
  if name == "diamond" then
    initCoins = display.newImage( "Diamond.png", 90, 90 )
  elseif name == "coin" then
    initCoins = display.newImage( "Coin.png", 90, 90 )
  elseif name == "mapleLeaf" then
    initCoins = display.newImage( "MapleLeaf.png", 90, 90 )
  elseif name == "C4" then
    initCoins = display.newImage( "C4.png", 90, 90 )
end

  initCoins.name = name
  initCoins.x, initCoins.y = 140, 550
  initCoins.rotation = 100
  initCoins.height = 50
  initCoins.width = 50
  initCoins.coinValue = score
  
  splitCoin.name = name
  splitCoin.x, splitCoin.y = 140, 550
  splitCoin.rotation = 100
  splitCoin.height = 50
  splitCoin.width = 50


  initCoins:addEventListener( "touch", coinTouchHandler )
  return initCoins
end

local function getRandomCoin()
  local coinsProp = allCoins[math.random(1, #allCoins)]
  local coins = display.newImage(coinsProp.whole)
  coins.whole = coinsProp
  coins.top = splitCoinProp
  coins.bottom = splitCoinProp
    return coins
end 

local function shootObject(type)
  -- logic for random coin
  --local r = math.random( 1, 4 )
    --print(r)
  --local object = createCoin(coins[r],coinsScore[r])
    local object
    if(type == "initCoins") then
      object = getRandomCoin()
    else
    end
  -- How I make the coin fly
    physics.addBody( object, { radius=20, density=1.5, friction=0.3, bounce=0.2, filter = {categoryBits = 2, maskBits = 1}} )
    physics.addBody( object, "dynamic" ) 
  --physics.setPreCollision = "passthru"
    local v = math.random( 340, 560 )
    local b = math.random( -65, 65 )
    local c = math.random( 20, 60 )
    object:setLinearVelocity( b, -v )
    object:applyTorque( -c )
end

--[[ Split coins
splitCoin.name = name
splitCoin.x, splitCoin.y = 140, 550
splitCoin.rotation = 100
splitCoin.height = 50
splitCoin.width = 50
end--]]

--coin timer
local function onCoinTimer( event )
  shootObject("initCoins")
  shootObject("initCoins")
end

local function onEndGame( event )
  -- stop all timers here
  timer.cancel (coinTimer)
end

local function startgame()
  initCoins()
  shootObject("initCoins")
  shootObject("initCoins")
  coinTimer = timer.performWithDelay( 1000 , onCoinTimer, 55 )
end 

physics.setDrawMode( "hybrid" )
--system.activate("multitouch");

  
  highscore = loadFile ("highscore.txt")
  --If the file is empty (this means it is the first time you've run the app) save it as 0
  local function checkForFile ()
    if highscore == "empty" then
      highscore = 0
      saveFile("highscore.txt", highscore)
    end
  end
  
  checkForFile()

  --Print the current highscore
  print ("Highscore is", highscore)
  
  local function onSystemEvent ()
    if score > tonumber(highscore) then --We use tonumber as highscore is a string when loaded
      saveFile("highscore.txt", highscore)
    end
  end

Runtime:addEventListener( "system", onSystemEvent )


--Code for line we totally did not steal
local maxPoints = 3
local lineThickness = 12
local endPoints = {}

local function movePoint(event)
-- Insert a new point into the front of the array
    table.insert(endPoints, 1, {x = event.x, y = event.y, line= nil}) 
-- Remove any excessed points
  if(#endPoints > maxPoints) then 
    table.remove(endPoints)
end
 
  for i,v in ipairs(endPoints) do
  local line = display.newLine(v.x, v.y, event.x, event.y)
    line.strokeWidth = lineThickness
      transition.to(line, { alpha = 0, strokeWidth = 0, onComplete = function(event) line:removeSelf() end})                
end
 
	if event.phase == "ended" then
		touchEnd = 1
  while(#endPoints > 0) do
		table.remove(endPoints)
end
  elseif event.phase == "began" then
		touchEnd = 0
	end
end
Runtime:addEventListener("touch", movePoint)

function scene:create( event )

local sceneGroup = self.view 

 --backgroundMusicChannel = audio.play( backgroundMusic, {channel=1,loops=-1 } )
local leftWall = display.newRect (0, 300, 1, display.contentHeight);
local rightWall = display.newRect (display.contentWidth, 300, 1, display.contentHeight);
 
-- Add physics to the walls. They will not move so they will be "static"
physics.addBody (leftWall, "static",  { bounce = 0.7 } );
physics.addBody (rightWall, "static", { bounce = 0.7 } );

	-- create a grey rectangle as the backdrop
local background = display.newImage( "GreenB.png" )
	background.anchorX = 0
  background.height=530
	background.anchorY = 0
  background.width=320
	background:setFillColor( 1,1,1 )
  
  scoreBoard = display.newText(scoreTotal,70,0,native.systemFrontBold,40)
  
  highscore = display.newText("HighScore: 8536",70,30,native.systemFrontBold,15)

  local counter = 60
  local timeDisplay = display.newText(counter,0,0,native.systemFrontBold,40)
    timeDisplay.x = 280
    timeDisplay.y = 0
      startTime = 60;
      totalTime = 60; 
        timeLeft = true;
  
  local function updateTimer(event)
    counter = counter - 1
    timeDisplay.text = counter
      if counter == 0 then
        physics.stop()
    end    
  end
 
timer.performWithDelay(1000, updateTimer, 60)

pauseButton = display.newImage("pauseButton.png",230,7.5)
  pauseButton.height = 55
  pauseButton.width = 50
  
--COINS AND SUCH
  coin = createCoins( "coin", 1 )
  mapleLeaf = createCoins( "mapleLeaf", 5 )
  diamond = createCoins( "diamond", 10 )
  C4 = createCoins( "C4", -10 )
--Split Coins
 
  physics.setGravity( 0, 4.9 * 2 )

  
  --if(type == "Diamond") then
		--object:addEventListener("touch", function(event) cutDiamond(object) end)
	--else
  --end

--function chopDiamond(Diamond)
  --createDiamondPiece(Diamondtop, "DiamondT.png")
  --createDiamondPiece(Diamondbottom, "DiamondB.png")
  --Diamond:removeSelf()
  --end
--end

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( coin )
  sceneGroup:insert( mapleLeaf )
  sceneGroup:insert( diamond )
  sceneGroup:insert( C4 )
  sceneGroup:insert( pauseButton )
  --[[sceneGroup:insert( DiamondT )
  sceneGroup:insert( DiamondB )
  sceneGroup:insert( MapleLeafT )
  sceneGroup:insert( MapleLeafB )
  sceneGroup:insert( CoinTop )
  sceneGroup:insert( CoinBottom )--]]
end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
    startgame()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene