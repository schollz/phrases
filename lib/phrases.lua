local Phrases={}

function Phrases:new(o)
  o=o or {}
  setmetatable(o,self)
  self.__index=self
  o:init()
  return o
end

function Phrases:init()
  self.phrases={}
  self:reset()
end

function Phrases:reset()
  self.started=false
  self.next,self.last=1,1  
end

function Phrases:add(p)
  table.insert(self.phrases,p)
end

function Phrases:step(i,j)
  local note=nil

  -- increment a step
  self.phrases[i]:increment()

  -- check if this note branches
  local branch_to=self.phrases[i]:check_branch_out()
  if branch_to~=nil then
      print("branching to "..branch_to)
      i,j,note=self:step(branch_to,i)
  else
    -- queue its note
    note=self.phrases[i]:note()
  end

  -- check return conditions
  -- return if phrase is on the last note and not main phrase
  -- or return if its a demand phrase
  if self.phrases[i]:check_branch_back(i) then
    print("branching back to "..j)
    i=j
  end
  return i,j,note
end

function Phrases:emit(division)
  if division==self.phrases[self.next].division then
    self.next,self.last,self.note=self:step(self.next,self.last)
    print(self.note)
  end
end

return Phrases


-- phrases=Phrases:new()
-- phrases:add(Phrase:new{0,2,7,6,3,root=32,division=1/2,branches={{on=1,to=2,prob=0.5},{on=4,to=3,prob=0.5}}})
-- phrases:add(Phrase:new{-1,-5,3,11,root=32,demand=true})
-- phrases:add(Phrase:new{5,3,1,root=32})
-- for i=1,16 do
--   phrases:emit(0.5)
-- end
-- for i=1,16 do
--   phrases:emit(0.25)
-- end
-- for i=1,16 do
--   phrases:emit(0.5)
-- end

