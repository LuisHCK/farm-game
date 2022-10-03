local Utils = {}

function Utils.split(str, char)
    local words = {}
    for word in string.gmatch(str, '([^'.. char ..']+)') do
        table.insert(words, #words + 1, word)
    end

    return words
end

return Utils