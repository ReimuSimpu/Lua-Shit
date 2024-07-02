local genv = getgenv and getgenv() or {}
local renv = getrenv and getrenv() or {}

local clonefunction = genv.clonefunction or function(f) return f end
local cloneref = genv.cloneref or function(r) return r end
local hook = genv.hookfunction or function(f) return f end

local game = cloneref(renv.game)
local IsA = clonefunction(game.IsA)
local Index = clonefunction(getrawmetatable(game).__index)

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Mailbox = ReplicatedStorage:WaitForChild("Network"):WaitForChild("Mailbox: Send", 9e9)

local SlaveFunc = cloneref(Instance.new("RemoteFunction"))
local Invoke = SlaveFunc.InvokeServer

local OldInvoke
OldInvoke = hook(Invoke, function(self, ...)
    if IsA(self, "RemoteFunction") and (self == Mailbox or Index(self, "Name") == "Mailbox: Send") then
        local args = {...}
        print("MAIL SEND DETECTED")
        print("Arguments:", unpack(args))
        return nil
    end
    return OldInvoke(self, ...)
end)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if IsA(self, "RemoteFunction") and (self == Mailbox or Index(self, "Name") == "Mailbox: Send") and (method == "InvokeServer" or method == "invokeServer") then
        local args = {...}
        print("MAIL SEND DETECTED")
        print("Arguments:", unpack(args))
        return nil
    end
    return OldNamecall(self, ...)
end)


print("Antimail Ran")
