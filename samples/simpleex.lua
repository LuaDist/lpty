#!/usr/bin/env lua

--[[ simplebc.lua
 -
 - a very simple example of how to use lpty
 -
 - Gunnar Zötl <gz@tset.de>, 2010, 2011
 - Released under MIT/X11 license. See file LICENSE for details.
--]]

lpty = require "lpty"

p = lpty.new()
p:startproc("lua")
p:read()				-- skip startup message

p:send("=111+234\n")
r = p:read()
print("Result is "..r)

p:send("os.exit()\n")	-- terminate lua all friendly-like

print("Done.")
