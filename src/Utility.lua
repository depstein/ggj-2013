
Class = {}

function Class:new(o)
	o = o or {}
	setmetatable(o, {__index = self})
	return o
end

--[[ CLASS TEMPLATE:

require "Utility"

ClassName = Class:new()
ClassName.type = "ClassName"

ClassName.MY_CONSTANT = 0

function ClassName:init()
    -- Initialize all members here
    self.field = 0

    return self;
end

]]--

function SetObjectColor(gameObject, color)
	gameObject.prop:setColor(0, 0, 1, 1)
end

function tableaddr(table)
    return tonumber('0x' .. tostring(table):sub(8))
end

function math.sign(val)
    if (val > 0) then return 1 end
    if (val < 0) then return -1 end
    return 0
end

function corout(func, ...)
    local cr = MOAICoroutine.new()
    cr:run(func, ...)
    return cr
end

function timedCorout(func)
	local prevElapsedTime = MOAISim.getDeviceTime()
	local elapsedTime = 0
	local cr = MOAICoroutine.new()
	cr:run(function() 
        local currElapsedTime = MOAISim.getDeviceTime()
        elapsedTime = currElapsedTime - prevElapsedTime
        prevElapsedTime = currElapsedTime

        func(elapsedTime)
	end)

	return cr
end

function block(action)
    MOAICoroutine.blockOnAction(action)
end

function afterNFrames(func, n)
    local count = 1
    corout(function() 
        while true do
            if count > n then 
                func()
                break
            else 
                count = count + 1
            end
            coroutine.yield()
        end 
    end)
end

function dump(t,indent)
    local names = {}
    if not indent then indent = "" end
    for n,g in pairs(t) do
        table.insert(names,n)
    end
    table.sort(names)
    for i,n in pairs(names) do
        local v = t[n]
        if type(v) == "table" then
            if(v==t) then -- prevent endless loop if table contains reference to itself
                print(indent..tostring(n)..": <-")
            else
                print(indent..tostring(n)..":")
                dump(v,indent.."   ")
            end
        else
            if type(v) == "function" then
                print(indent..tostring(n).."()")
            else
                print(indent..tostring(n)..": "..tostring(v))
            end
        end
    end
end

function makeMOAIColor(color) 
    local c = Game.colors[color]
    moaiColor = MOAIColor.new()
    moaiColor:setColor(c.r/255.0, c.g/255.0, c.b/255.0, 1)

    return moaiColor
end

------------------------------------------------------------------------------
--  Converts hex number to rgb (format: #FF00FF)
--============================================================================

function string.hexToRGB( s, returnAsTable )
    if returnAsTable then
        return  { tonumber ( "0x"..string.sub( s, 2, 3 ) )/255.0,
                tonumber ( "0x"..string.sub( s, 4, 5 ) )/255.0,
                tonumber ( "0x"..string.sub( s, 6, 7 ) )/255.0 }
    else
        return  tonumber ( "0x"..string.sub( s, 2, 3 ) )/255.0,
                tonumber ( "0x"..string.sub( s, 4, 5 ) )/255.0,
                tonumber ( "0x"..string.sub( s, 6, 7 ) )/255.0
    end
end

function colorGet(color) 
    return {
        r = color:getAttr(MOAIColor.ATTR_R_COL),
        g = color:getAttr(MOAIColor.ATTR_G_COL),
        b = color:getAttr(MOAIColor.ATTR_B_COL),
        a = color:getAttr(MOAIColor.ATTR_A_COL),
    }
end

function setColorAlpha(color, alpha)
    local vals = colorGet(color)
    color:setColor(vals.r, vals.g, vals.b, alpha)
end