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
local coin, mapleLeaf, diamond, C4
local coinTimer
local coins = {"coin", "mapleLeaf", "diamond", "C4"}
local coinsScore = { 25, 50, 100, -100 }
local genericCoin = coins
math.randomseed( os.time() )
os.clock ()

local dubstep = audio.loadStream( "NinjaDubstep.mp3" )
local dubstep = audio.play( dubstep, { duration = 61500, onComplete = finished })

local function splitCoin( name )
  if name == "diamond" then
    print(name)
  elseif name == "coin" then
    print(name)
  elseif name == "mapleLeaf" then
    print(name)
  end
end

local coinsProp = {radius=20, density=1.0, friction=0.3, bounce=0.2, filter = {categoryBits = 2, maskBits = 1}}
local allCoins = {}

local function coinTouchHandler( event )
  if event.phase == "began" then
    local sounds = audio.loadSound("METALonMETAL.mp3");
    audio.play(sounds)
    print("begin "..event.target.name)
  elseif event.phase == "ended" then
    scoreTotal = scoreTotal + event.target.coinValue
    print(scoreTotal)
    --print(event.target)
    splitCoin( event.target.name )
  end
end
 
local function createCoin( name, score )
  local genericCoin
  if name == "diamond" then
    genericCoin = display.newImage( "Diamond.png", 90, 90 )
  elseif name == "coin" then
    genericCoin = display.newImage( "Coin.png", 90, 90 )
  elseif name == "mapleLeaf" then
    genericCoin = display.newImage( "MapleLeaf.png", 90, 90 )
  elseif name == "C4" then
    genericCoin = display.newImage( "C4.png", 90, 90 )
  end
  genericCoin.name = name
  genericCoin.x, genericCoin.y = 140, 550
  genericCoin.rotation = 100
  genericCoin.height = 50
  genericCoin.width = 50
  genericCoin.coinValue = score

  genericCoin:addEventListener( "touch", coinTouchHandler )
  return genericCoin
end

local function getRandomCoin()
  local coinsProp = genericCoin[math.random(1, #genericCoin)]
  local coins = display.newImage(coinsProp.whole)
end 

local function shootObject(type)
  -- logic for random coin
  local r = math.random( 1, 4 )
    --print(r)
  local object = createCoin(coins[r],coinsScore[r])
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


--coin timer
local function onCoinTimer( event )
  shootObject("genericCoin")
  shootObject("genericCoin")
end

local function onEndGame( event )
  -- stop all timers here
  --timer.cancel (coinTimer)
end

local function startgame()
  shootObject("genericCoin")
  shootObject("genericCoin")
    coinTimer = timer.performWithDelay( 1000 , onCoinTimer, 57 )
end 


physics.setDrawMode( "hybrid" )
--system.activate("multitouch");
function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

local sceneGroup = self.view

--function scene:createScene( event )
  --local screenGroup = self.view
	--backgroundMusic = audio.loadStream("TheNextEpisode.mp3")
--end  
 
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
  

  local counter = 60
  local timeDisplay = display.newText(counter,0,0,native.systemFrontBold,50)
  timeDisplay.x = 280
  timeDisplay.y = 0
 startTime = 60;
totalTime = 60; 
timeLeft = true;

  local function updateTimer(event)
    counter = counter - 1
    timeDisplay.text = counter
       if counter == 0 then
            -- do what you want to do when the timer ends
    end
  end
 
    timer.performWithDelay(1000, updateTimer, 60)
  
--COINS AND SUCH
  coin = createCoin( "coin", 25 )
  mapleLeaf = createCoin( "mapleLeaf", 50 )
  diamond = createCoin( "diamond", 100 )
  C4 = createCoin( "C4", -100 )
-- Coin physics
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
  --sceneGroup:insert( DiamondT )
  --sceneGroup:insert( DiamondB )
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