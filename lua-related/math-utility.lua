--[[
  Just some math functions I use a lot.
--]]
local Math = {}

function Math.Normalize(min, max, total)
	return (min / max) * total
end

--https://stackoverflow.com/a/31687097
function Math.ScaleBetween(unscaledNum, minAllowed, maxAllowed, min, max)
	return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed
end

-- http://lua-users.org/wiki/SimpleRound
function Math.Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function Math.RoundF(number, decimalPlaces)
	return tonumber(string.format("%".."."..tostring(decimalPlaces).."f", number))
end

function Math.SubRemainder(number, amount)
    local subtracted = math.min(number, amount)
    return subtracted > 0 and subtracted or 0
end

return Math
