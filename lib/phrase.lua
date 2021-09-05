local Phrase={}

function Phrase:new(p)
  o={}
  setmetatable(o,self)
  self.__index=self
  o:init(p)
  return o
end

function Phrase:init(p)
  self.division=1/4
  self.root=32 
  self.demand=false 
  self.branches={}
  self.notes={}
  for k,v in pairs(p) do
    if type(k)=="number" then
      table.insert(self.notes,v)
    else
      self[k]=v
    end
  end
  for i,branch in ipairs(self.branches) do
    if self.branches[i].prob==nil then
      self.branches[i].prob=1
    end
  end
  self:reset()
end

function Phrase:print()
  for k,v in pairs(self) do
    if type(v)=="table" then
      print(k)
      for k2,v2 in pairs(v) do
        print(k,v2)
      end
    else
      print(k,v)
    end
  end
end

function Phrase:reset() 
  self.ind=0
end

function Phrase:increment()
  -- increment a step
  self.ind=(self.ind)%#self.notes+1
  if #self.notes==1 then
    self.ind=1
  end
end

function Phrase:check_branch_out()
  for _, branch in ipairs(self.branches) do
    if branch.on==self.ind and math.random()<branch.prob then
      do return branch.to end
    end
  end
end

function Phrase:check_branch_back(i)
  -- check return conditions
  -- return if phrase is on the last note and not main phrase
  -- or return if its a demand phrase
  return (self.ind==#self.notes and i>1) or self.demand 
end

function Phrase:note()
  if self.ind > 0 then 
    do return self.root+self.notes[self.ind] end
  end
end


return Phrase
