require "socket"
require "msgpack"
require "Utility"

Communication = {}

Communication.DEFAULT_IP = "127.0.0.1"

local b1 = 1
local b2 = 256 * b1
local b3 = 256 * b2
local b4 = 256 * b3

local TIMEOUT = 0
local PORT = 666

local debugMessages = false
local debugConnect = true

local function pump(sock, outgoing, incoming)
    local listen = { sock }
    while (not server) do
        local writelisten = nil
        if (table.getn(outgoing) > 0) then
            writelisten = listen
        end
        read, write = socket.select(listen, writelisten, TIMEOUT)
        if (table.getn(read) > 0) then
            local data;
            while(true) do
                data = sock:receive(4)
                if(not data) then break end
                local len = 
                    string.byte(data, 1) * b1 + 
                    string.byte(data, 2) * b2 + 
                    string.byte(data, 3) * b3 + 
                    string.byte(data, 4) * b4
                if(debugMessages) then print("Recv: length = " .. len) end
                sock:settimeout(nil);
                local content = sock:receive(len)
                sock:settimeout(TIMEOUT);
                if(debugMessages) then print("      content= `" .. content .. "`") end
                table.insert(incoming, content)
            end
        end
        if (table.getn(write) > 0 and table.getn(outgoing) > 0) then
            local content = table.remove(outgoing)
            local len = string.len(content)
            local data = string.char(
                (math.floor(len / b1) % 256),
                (math.floor(len / b2) % 256),
                (math.floor(len / b3) % 256),
                (math.floor(len / b4) % 256)) .. content
            if(debugMessages) then print("Send: length = " .. len) end
            if(debugMessages) then print("      content= `" .. content .. "`") end
            sock:send(data)
        end
        coroutine.yield()
    end

    print("Communication Pump Died")
end

local function server(outgoing, incoming, socketinfo)
	if (debugConnect) then print("Server: Creating Socket") end

    local sock, err = socket.tcp()
    if not sock then return nil, err end
    sock:settimeout(TIMEOUT);

	if (debugConnect) then print("Server: Binding") end
    local result, err = sock:bind("*", PORT)
    if not result then print("Server: Error: " .. err); return nil, err end

    local result, err = sock:listen()
    if not result then print("Server: Error: " .. err); return nil, err end

    local listen = { sock }
    local client = nil
    while (not client) do
        read, write = socket.select(listen, nil, TIMEOUT)
        if (table.getn(read) > 0) then
            if (debugConnect) then print("Server: Attempting to connect to client!") end
            client = sock:accept();

            socketinfo.sockname = client:getsockname()
            if(socketinfo.socknamecallback) then
                socketinfo.socknamecallback(socketinfo)
            end
        end
        coroutine.yield()
    end

    if (debugConnect) then print("Server: Connected!") end

    pump(client, outgoing, incoming)
    
end

local function client(outgoing, incoming, socketinfo)
    if(not socketinfo.connectIP) then
        socketinfo.connectIP = Communication.DEFAULT_IP
    end
	if (debugConnect) then print("Client: Creating Socket") end

    local sock, err = socket.tcp()
    if not sock then return nil, err end

	if (debugConnect) then print("Client: Connecting to " .. socketinfo.connectIP .. ":" .. PORT) end
    local result, err = sock:connect(socketinfo.connectIP, PORT)
    if not result then print("Client: Error: " .. err); return nil, err end

    sock:settimeout(TIMEOUT);

    if (debugConnect) then print("Client: Connected") end
    pump(sock, outgoing, incoming)

end

function Communication.createServer()
    local outgoing, incoming, socketinfo = {}, {}, {}
    corout(server, outgoing, incoming, socketinfo)
    return outgoing, incoming, socketinfo
end

function Communication.createClient(ip)
    local outgoing, incoming, socketinfo = {}, {}, {connectIP = ip}
    corout(client, outgoing, incoming, socketinfo)
    return outgoing, incoming, socketinfo
end