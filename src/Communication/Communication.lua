require "socket"
require "msgpack"
require "Utility"

local import = {
    corout = corout,
    socket = socket,
    table = table,
    coroutine = coroutine,
    string = string
}

module "Communication"

local private = {}
local b1 = 1
local b2 = 256 * b1
local b3 = 256 * b2
local b4 = 256 * b3
local debugMessages = false
local debugConnect = false

local timeout = 0
local port = 666

function private.pump(sock, outgoing, incoming)
    local listen = { sock }
    while (not server) do
        local writelisten = nil
        if (import.table.getn(outgoing) > 0) then
            writelisten = listen
        end
        read, write = import.socket.select(listen, writelisten, timeout)
        if (import.table.getn(read) > 0) then
            local data;
            while(true) do
                data = sock:receive(4)
                if(not data) then break end
                local len = 
                    import.string.byte(data, 1) * b1 + 
                    import.string.byte(data, 2) * b2 + 
                    import.string.byte(data, 3) * b3 + 
                    import.string.byte(data, 4) * b4
                if(debugMessages) then print("Recv: length = " .. len) end
                sock:settimeout(nil);
                local content = sock:receive(len)
                sock:settimeout(timeout);
                if(debugMessages) then print("      content= `" .. content .. "`") end
                import.table.insert(incoming, content)
            end
        end
        if (import.table.getn(write) > 0 and import.table.getn(outgoing) > 0) then
            local content = import.table.remove(outgoing)
            local len = import.string.len(content)
            local data = import.string.char(
                ((len / b1) % 256),
                ((len / b2) % 256),
                ((len / b3) % 256),
                ((len / b4) % 256)) .. content
            if(debugMessages) then print("Send: length = " .. len) end
            if(debugMessages) then print("      content= `" .. content .. "`") end
            sock:send(data)
        end
        import.coroutine.yield()
    end
end

function private.server(outgoing, incoming, socketinfo)
	if (debugConnect) then print("Server: Creating Socket") end

    local sock, err = import.socket.tcp()
    if not sock then return nil, err end
    sock:settimeout(timeout);

	if (debugConnect) then print("Server: Binding") end
    local result, err = sock:bind("*", port)
    if not result then print("Server: Error: " .. err); return nil, err end

    local result, err = sock:listen()
    if not result then rint("Server: Error: " .. err); return nil, err end

    local listen = { sock }
    local client = nil
    while (not client) do
        read, write = import.socket.select(listen, nil, timeout)
        if (import.table.getn(read) > 0) then
            if (debugConnect) then print("Server: Attempting to connect to client!") end
            client = sock:accept();

            socketinfo.sockname = client:getsockname()
            if(socketinfo.socknamecallback) then
                socketinfo.socknamecallback(socketinfo)
            end
        end
        import.coroutine.yield()
    end

    if (debugConnect) then print("Server: Connected!") end

    private.pump(client, outgoing, incoming)
    
end

function private.client(outgoing, incoming, socketinfo)
	if (debugConnect) then print("Client: Creating Socket") end

    local sock, err = import.socket.tcp()
    if not sock then return nil, err end
    sock:settimeout(timeout);

	if (debugConnect) then print("Client: Connecting") end
    sock:connect("127.0.0.1", 666)

    if (debugConnect) then print("Client: Connected") end
    private.pump(sock, outgoing, incoming)

end

function getIP()
    return socket.dns.toip("localhost")
end

function createServer()
    local outgoing, incoming, socketinfo = {}, {}, {}
    import.corout(private.server, outgoing, incoming, socketinfo)
    return outgoing, incoming, socketinfo
end

function createClient()
    local outgoing, incoming, socketinfo = {}, {}, {}
    import.corout(private.client, outgoing, incoming, socketinfo)
    return outgoing, incoming, socketinfo
end