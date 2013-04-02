#!/usr/bin/env lua

--[[ expectbc.lua
 -
 - a somewhat less simple example for lpty, using bc via quite simplistic
 - expect like functionality
 -
 - Gunnar Zötl <gz@tset.de>, 2010, 2011
 - Released under MIT/X11 license. See file LICENSE for details.
--]]

local lpty = require "lpty"

local function start(...)
	local p = lpty.new()
	p:startproc(...)
	while p:hasproc() and not p:readok() do end
	if not p:hasproc() then
		local what, code = p:exitstatus()
		error("start failed: child process terminated because of " .. tostring(what) .. " " ..tostring(code))
	end
	return p
end

local function expect(p, what, plain, timeout)
	if not p:hasproc() then return nil, "no running process." end
	local res = ""
	local found = false

	-- consume all output from client while searching for our pattern
	while not found do
		local r, why = p:read(timeout)
		if r ~= nil then
			res = res .. r
			local first, last, capture = string.find(res, what, 1, plain)
			if first then
				if capture then
					found = capture
				else
					found = string.sub(res, first, last)
				end
			end
		else
			if why then
				error("read failed: " .. why)
			else
				local what, code = p:exitstatus()
				if what then
					error("read failed: child process terminated because of " .. tostring(what) .. " " ..tostring(code))
				end
			end
		end
	end
	return found
end

local function send(p, what)
	local s = p:send(what)
	-- wait for reply
	while not p:readok() and p:hasproc() do end
	return s
end

-- and here's how we use it
p = start("lua")
if expect(p, "> $") then
	send(p, "=111+234\n")
	res = expect(p, "([0-9]+)[^0-9]*> $")
	print("Got '"..tostring(res).."'")
	send(p, "os.exit()\n")
else
	print "Whoops..."
end
