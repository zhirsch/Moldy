Moldy.CircularBuffer = {
    new = function(size)
        assert(size > 1)
        local self = { buffer = {}, found = nil, next = 1, size = size }
        local cls  = { __index = Moldy.CircularBuffer.prototype }
        return setmetatable(self, cls)
    end,
    rotate = function(i, n)
        return ((i - 1) % n) + 1
    end,
}
Moldy.CircularBuffer.prototype = {
    len = function(self)
        return #(self.buffer)
    end,
    peek = function(self, i)
        if i > self:len() then return nil end
        local ir = Moldy.CircularBuffer.rotate((self.next - 1) + i, self:len())
        return self.buffer[ir]
    end,
    push = function(self, value)
        self.buffer[self.next] = value
        self.next = Moldy.CircularBuffer.rotate(self.next + 1, self.size)
    end,
    find = function(self, predicate)
        -- cache the last found item so that repetitive lookups are fast
        if self.found and predicate(self.found) then return self.found end
        for item in self:iter() do
            if item and predicate(item) then
                self.found = item
                return item
            end
        end
        self.found = nil
        return nil
    end,
    iter = function(self)
        local i = 0
        return function()
            i = i + 1
            return self:peek(i)
        end
    end,
}
