task.spawn(function()
    while task.wait() do game.Lighting.TimeOfDay = 12 end
end)

local Garbage = getgc(true)

function OverwriteFunction(funcname, func)
    print("Hooking function:", funcname, "-", func)

    local Success, Message = pcall(function()
        hookfunction(func, function(...)
            return wait(5^12)
        end)
    end)

    if Success then
        print("Hooked", funcname)
    else
        print("Failed to hook", funcname, "Error:", Message)
    end
end

for _,v in next, Garbage do
    if type(v) == "table" then
        if rawget(v, "Detected") then
            for i, data in next, v do
                if type(data) == "function" and i:lower():find("detect") then
                    OverwriteFunction(i, data)
                end
            end
        end
    end
end