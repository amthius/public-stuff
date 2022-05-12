--[[
  Just some math functions I use a lot.
--]]
local Math = {}

function Math.Normalize(Min, Max, Total)
	return (Min / Max) * Total
end

--https://stackoverflow.com/a/31687097
function Math.scaleBetween(unscaledNum, minAllowed, maxAllowed, min, max)
	return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed
end

-- http://lua-users.org/wiki/SimpleRound
function Math.Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function Math.RoundF(Number, DecimalPlaces)
	return tonumber(string.format("%".."."..tostring(DecimalPlaces).."f", Number))
end

return Math
