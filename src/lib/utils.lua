local Utils = {}

function Utils:split(str, delimiter)
    local results = {}
    for s in string.gmatch(str, "[^" .. delimiter .. "]+") do
        results[#results + 1] = s
    end

    return results
end

return Utils
