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