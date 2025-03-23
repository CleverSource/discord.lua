-- Lovingly taken & modified. Original work by @red-blox
-- https://github.com/red-blox/Util
--
--	MIT License
--	Copyright 2023 The Redblox Authors
--
--	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
--	The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local Spawn = require("Spawn")

type SignalNode<T...> = {
	Next: SignalNode<T...>?,
	Callback: (T...) -> (),
}

export type Signal<T...> = {
	Root: SignalNode<T...>?,

	Connect: (self: Signal<T...>, Callback: (T...) -> ()) -> () -> (),
	Wait: (self: Signal<T...>) -> T...,
	Once: (self: Signal<T...>, Callback: (T...) -> ()) -> () -> (),
	Fire: (self: Signal<T...>, T...) -> (),
	DisconnectAll: (self: Signal<T...>) -> (),
}

local Signal = {}
Signal.__index = Signal

-- Extracted this function from Connect as it results in the closure
-- made in Connect using less memory because this function can be static
local function Disconnect<T...>(self: Signal<T...>, Node: SignalNode<T...>)
	if self.Root == Node then
		self.Root = Node.Next
	else
		local Current = self.Root

		while Current do
			if Current.Next == Node then
				Current.Next = Node.Next
				break
			end

			Current = Current.Next
		end
	end
end

function Signal.Connect<T...>(self: Signal<T...>, Callback: (T...) -> ()): () -> ()
	local Node = {
		Next = self.Root,
		Callback = Callback,
	}

	self.Root = Node

	return function()
		Disconnect(self, Node)
	end
end

function Signal.Wait<T...>(self: Signal<T...>): T...
	local Thread = coroutine.running()
	local Disconnect

	Disconnect = self:Connect(function(...)
		Disconnect()
		coroutine.resume(Thread, ...)
	end)

	return coroutine.yield()
end

function Signal.Once<T...>(self: Signal<T...>, Callback: (T...) -> ()): () -> ()
	local Disconnect

	Disconnect = self:Connect(function(...)
		Disconnect()
		Callback(...)
	end)

	return Disconnect
end

function Signal.Fire<T...>(self: Signal<T...>, ...: T...)
	local Current = self.Root

	while Current do
		Spawn(Current.Callback, ...)
		Current = Current.Next
	end
end

function Signal.DisconnectAll<T...>(self: Signal<T...>)
	self.Root = nil
end

return function<T...>(): Signal<T...>
	return setmetatable({
		Root = nil,
	}, Signal) :: any
end