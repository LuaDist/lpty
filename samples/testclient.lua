#!/usr/bin/env lua

--[[ testclient.lua
 -
 - a simple test client for lptytest.lua
 -
 - Gunnar Zötl <gz@tset.de>, 2010, 2011
 - Released under MIT/X11 license. See file LICENSE for details.
--]]

while true do
	s = io.read()
	print("+"..s.."+")
	if s == "quit" then os.exit() end
end
