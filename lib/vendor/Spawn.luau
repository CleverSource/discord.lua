-- Lovingly taken & modified. Original work by @red-blox
-- https://github.com/red-blox/Util
--
-- MIT License
-- Copyright 2023 The Redblox Authors
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local task = require("@lune/task")

local FreeThreads: { thread } = {}

local function RunCallback(Callback, Thread, ...)
	Callback(...)
	table.insert(FreeThreads, Thread)
end

local function Yielder()
	while true do
		RunCallback(coroutine.yield())
	end
end

return function<T...>(Callback: (T...) -> (), ...: T...)
	local Thread
	if #FreeThreads > 0 then
		Thread = FreeThreads[#FreeThreads]
		FreeThreads[#FreeThreads] = nil
	else
		Thread = coroutine.create(Yielder)
		coroutine.resume(Thread)
	end

	task.spawn(Thread, Callback, Thread, ...)
end