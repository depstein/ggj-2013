function SetObjectColor(gameObject, color)
	gameObject.prop:setColor(0, 0, 1, 1)
end

function tableaddr(table)
    return tonumber('0x' .. tostring(table):sub(8))
end

function corout(func)
    local cr = MOAICoroutine.new()
    cr:run(func)
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