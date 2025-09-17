---Node Object
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Node is the base object of all game objects
Node = {}
Node.__index = Node

---Node Object Constructer
---@param nx float New X Position
---@param ny float New Y Position
---@param args table A table containing arguments to change the construction of the object
---@return table
function Node.new(nx, ny, args)
    local self = setmetatable({}, Node)

    self.T = "Node"

    self._Args = args or { T = {} }

    self._Conf = self._Args.conf or {}

    -- Transformation in the nodes local space
    self._Transform =
    {
        x = self._Args.T.x or nx or 0,
        y = self._Args.T.y or ny or 0,
        w = self._Args.T.w or 0,
        h = self._Args.T.h or 0,
        r = self._Args.T.r or 0,
        sx = self._Args.T.sx or 1,
        sy = self._Args.T.sy or 1,
        skx = self._Args.T.skx or 0,
        sky = self._Args.T.sky or 0
    }

    self._GlobalTransform =
    {
        x = self._Args.T.x or nx or 0,
        y = self._Args.T.y or ny or 0,
        w = self._Args.T.w or 0,
        h = self._Args.T.h or 0,
        r = self._Args.T.r or 0,
        sx = self._Args.T.sx or 1,
        sy = self._Args.T.sy or 1,
        skx = self._Args.T.skx or 0,
        sky = self._Args.T.sky or 0
    }

    self._ClickOffset = Vector.new(0, 0)

    -- Zone of the Node where mouse hover will not be trigered
    self._DeadZone = nil

    -- Node States
    self._States =
    {
        visible = true,
        paused = false,
        clicked = { is = false, can = true },
        drag = { is = false, can = true },
        hovered = { is = false, can = true },
    }

    -- Valid modes are "Always", "Never", "Input",
    self._PauseMode = self._Args.PauseMode or "Always"

    -- Parent/Children pointers
    self._Parent = self._Args.parent or nil
    self._Children = {}

    -- Added functions
    self._Functions = self._Args.functions or {}

    return self
end

-- Width and height getters
function Node:getWidth()
    return (self._Transform.w * self._Transform.sx)
end

function Node:getHeight()
    return (self._Transform.h * self._Transform.sy)
end

function Node:getSize()
    return Vector.new(self._Transform.x, self._Transform.y)
end

function Node:setSize(nw, nh)
    local nw = nw or nil
    local nh = nh or nil
    if nw then
        self._Transform.w = nw
    end
    if nh then
        self._Transform.h = nh
    end
end

function Node:setGlobalPos()
    if self.parent then
        local parentTransform = self.parent._GlobalTransform
        self._GlobalTransform.x = parentTransform.x + self._Transform.x
        self._GlobalTransform.y = parentTransform.y + self._Transform.y
        self._GlobalTransform.r = parentTransform.r + self._Transform.r
        self._GlobalTransform.sx = parentTransform.sx * self._Transform.sx
        self._GlobalTransform.sy = parentTransform.sy * self._Transform.sy
        self._GlobalTransform.skx = parentTransform.skx + self._Transform.skx
        self._GlobalTransform.sky = parentTransform.sky + self._Transform.sky
    else
        self._GlobalTransform = self._Transform
    end
end

-- Parent Child relationship functions
function Node:addChildren(newChild, tag)
    newChild:setParent(self)
    if tag then
        self._Children[tag] = newChild
    else
        table.insert(self._Children, newChild)
    end
end

function Node:removeChild(child, tag)
    if tag then
        table.remove(self.children[tag])
        return
    end
    if child then
        removeSelf(child, self.children)
        return
    end
end

function Node:updateChildren(dt)
    for _, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Node:setParent(newParent)
    self.parent = newParent
    self.stopOnPause = self.parent.stopOnPause
end

function Node:removeParent()
    removeSelf(self, self.parent.children)
    self:setParent(nil)
end

function Node:addFunction(newFunction)
    table.insert(self.functions, newFunction)
end

function Node:updateFunctions()
    for _, func in ipairs(self.functions) do
        func(self)
    end
end

--- Returns a spesifed point on the object
--- @param pos string Default: center [center, topleft, topright, bottomleft, bottomright, centerleft, centerright, centertop, centerbottom]
--- @return Vector
function Node:getPos(pos, locFlag)
    local flag = locFlag or false
    local pos = pos or "center"
    local ret = Vector.new()

    local function calcPos(xFactor, yFactor)
        if flag then
            ret.x = self._GlobalTransform.x + (self._Transform.w * self._GlobalTransform.sx * xFactor)
            ret.y = self._GlobalTransform.y + (self._Transform.h * self._GlobalTransform.sy * yFactor)
        else
            ret.x = self._Transform.x + (self._Transform.w * self._GlobalTransform.sx * xFactor)
            ret.y = self._Transform.y + (self._Transform.h * self._GlobalTransform.sy * yFactor)
        end
    end

    if pos == "center" then
        calcPos(0, 0)
    elseif pos == "topleft" then
        calcPos(-.5, -.5)
    elseif pos == "topright" then
        calcPos(.5, -.5)
    elseif pos == "bottomleft" then
        calcPos(-.5, .5)
    elseif pos == "bottomright" then
        calcPos(.5, .5)
    elseif pos == "centerleft" then
        calcPos(-.5, 0)
    elseif pos == "centerright" then
        calcPos(.5, 0)
    elseif pos == "centertop" then
        calcPos(0, -.5)
    elseif pos == "centerbottom" then
        calcPos(0, .5)
    end
    return ret
end

function Node:setDeadZone(deadZone)
    self.deadZone = deadZone
end

function Node:setScale(newScale)
    self._Transform.scale = newScale
end

function Node:setPos(nx, ny)
    nx = nx or nil
    ny = ny or nil
    if nx ~= nil then
        self._Transform.x = nx
    end
    if ny ~= nil then
        self._Transform.y = ny
    end
end

function Node:checkDeadZone(mx, my)
    -- Check the dead Zone
    if self.deadZone ~= nil then
        if mx > self.deadZone.t1.x and mx < self.deadZone.t2.x then
            return true
        end
    else
        return false
    end
    return false
end

function Node:checkMouseHover()
    local mousex, mousey = love.mouse.getPosition()
    local mousex, mousey = toGame(mousex, mousey)
    if mousex > (self._GlobalTransform.x - self:getWidth() / 2) and mousex < (self._GlobalTransform.x + self:getWidth() / 2) then
        if mousey > (self._GlobalTransform.y - self:getHeight() / 2) and mousey < (self._GlobalTransform.y + self:getHeight() / 2) then
            if not self:checkDeadZone(mousex, mousey) then
                return true
            end
        end
        return false
    end
    return false
end

function Node:isInside(x, y)
    if x > (self._GlobalTransform.x - self:getWidth() / 2) and x < (self._GlobalTransform.x + self:getWidth() / 2) then
        if y > (self._GlobalTransform.y - self:getHeight() / 2) and y < (self._GlobalTransform.y + self:getHeight() / 2) then
            return true
        end
        return false
    end
    return false
end

function Node:checkPause()
    if G.SETTINGS.PAUSED then
        if self._PauseMode == "Always" then
            return true
        else
            return false
        end
    end
end

function Node:drawBoundingRect()
    if G.DRAWBOUNDINGRECTS then
        love.graphics.setColor(lovecolors:getColor("BLUE"))
        love.graphics.setLineWidth(10)
        love.graphics.rectangle("line", self._GlobalTransform.x - (self:getWidth() / 2),
            self._GlobalTransform.y - (self:getHeight() / 2), self:getWidth(), self:getHeight())
        love.graphics.setColor({ 1, 1, 1, 1 })
    end
end

function Node:update(dt)
    updateList(self._Children, dt)
end

function Node:draw()
    drawList(self._Children)
end