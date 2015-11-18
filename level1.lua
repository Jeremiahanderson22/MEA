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
math.randomseed( os.time() )
os.clock ()

local function coinTouchHandler( event )
  local sounds = audio.loadSound("METALonMETAL.mp3");
  audio.play(sounds)
end

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

local sceneGroup = self.view

	-- create a grey rectangle as the backdrop
local background = display.newImage( "WOOD.png" )
	background.anchorX = 0
  background.height=530
	background.anchorY = 0
  background.width=320
	background:setFillColor( 1,1,1 )
  
  local coinTable = {}

    coinTable[1] = "Coin.png"
    coinTable[2] = "Diamond.png"
    coinTable[3] = "MapleLeaf.png"
print( coinTable[2] )

--COINS AND SUCH
local coin = display.newImage( "Coin.png", 90, 90 )
  coin.name = "coin"
  coin.x, coin.y = 140, 550
  coin.rotation = 100
  coin.height=40
  coin.width=40

  --local function touchListener( event )
   --local object = event.target
   --print( object.name.." coin " )
--end
--add "tap" event listener to back object and update text label
coin:addEventListener( "touch", coinTouchHandler )
coin.text = "touch"

local coin1 = display.newImage( "MapleLeaf.png", 90, 90 )
  coin1.name = "coin1"
  coin1.x, coin1.y = 140, 550
  coin1.rotation = 100
  coin1.height=40
  coin1.width=40
  
    local function touchListener( event )
   local object = event.target
   print( object.name.." coin1 " )
end
--add "tap" event listener to back object and update text label
coin1:addEventListener( "touch", touchListener )
coin1.text = "touch"
  
local Diamond = display.newImage( "Diamond.png", 90, 90 )
--local DiamondT = display.newImage( "DiamondT.png", 90, 90 )
--local DiamondB = display.newImage( "DiamondB.png", 90, 90 )
  Diamond.name = "Diamond"
  --DiamondT.name = "DiamondT"
  --DiamondB.name = "DiamondB"
  Diamond.x, Diamond.y = 140, 550
  Diamond.rotation = 100
  Diamond.height=40
  Diamond.width=40
  
  local function touchListener( event )
   local object = event.target
   print( object.name.." Diamond " )
end
--add "tap" event listener to back object and update text label
Diamond:addEventListener( "touch", touchListener )
Diamond.text = "touch"


--local maxPoints = 5
--local lineThickness = 20
--local lineFadeTime = 250
--local endPoints = {}

--Runtime:addEventListener("touch", drawSlashLine)

-- Coin physics
  physics.setGravity( 0, 9.8 * 2 )
  
  physics.addBody( coin, { radius=20, density=1.0, friction=0.3, bounce=0.2, filter = {categoryBits = 2, maskBits = 1}} )
  physics.addBody( coin, "dynamic" ) 
  --physics.setPreCollision = "passthru"
    local v = math.random( 350, 560 )
    local b = math.random( -60, 60 )
    local c = math.random( 20, 60 )
      print( v )
      print( b )
      print( c )
  --applyForce( 0, 0 )
    coin:setLinearVelocity( b, -v )
    coin:applyTorque( -c )

  physics.setGravity( 0, 10 )
  physics.addBody( coin1, { radius=20, density=1.0, friction=0.3, bounce=0.2, filter = {categoryBits = 2, maskBits = 1}} )
  physics.addBody( coin1, "dynamic" )
    local a = math.random( 350, 560 )
    local q = math.random( -60, 60 )
    local f = math.random( 20, 60 )
      print( a )
      print( q )
      print( f )
  --coin1:applyForce( q, -a )
    coin1:setLinearVelocity( q, -a )
    coin1:applyTorque( -f )
  
  physics.setGravity( 0, 10 )
  physics.addBody( Diamond, { radius=20, density=1.0, friction=0.3, bounce=0.2, filter = {categoryBits = 2, maskBits = 1}} )
  physics.addBody( Diamond, "dynamic" )
    local w = math.random( 350, 560 )
    local e = math.random( -60, 60 )
    local r = math.random( 20, 60 )
      print( w )
      print( e )
      print( r )
  --coin1:applyForce( q, -a )
    Diamond:setLinearVelocity( e, -w )
    Diamond:applyTorque( -r )
  --end
  
  if(type == "Diamond") then
		object:addEventListener("touch", function(event) cutDiamond(object) end)
	else

function chopDiamond(Diamond)
  createDiamondPiece(Diamondtop, "DiamondT.png")
  createDiamondPiece(Diamondbottom, "DiamondB.png")
  Diamond:removeSelf()
  end
end

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( coin )
  sceneGroup:insert( coin1 )
  sceneGroup:insert( Diamond )
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