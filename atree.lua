

-- local root = {
--     { note=2, children = { { note=5 }, { note=13 } }  },
--     {  children = { { note=1 }, { note=17 }, { note=17 } } },
--     { note=7 },
--     { note=9 },
--     { note=11, children = { {note=3} } },
-- }


-- function traverse(r)
--   t = {branch=1,total=1}
--   for _, child in ipairs(r) do
--     traverse_(child,t)
--   end
-- end

-- function traverse_(node,t)
--   local total=t.total
--   if node.note~=nil then
--     print(t.branch,node.note)
--   end
--   if node.children ~= nil then
--     t.total = t.total+1
--     t.branch=t.branch+total
--     for i, child in ipairs(node.children) do
--       t.root=i==1
--       traverse_(child,t)
--     end
--     t.branch=t.branch-total
--   end
-- end

-- traverse(root)



local phrases={}
phrases[1]={
  bpm=120,
  root=0,
  demand=false,
  notes={1,2,3,4},
  branches={{on=3,to=3,prob=0.5},{on=1,to=2,prob=0.5}},  
}
phrases[2]={
  bpm=90,
  root=100,
  demand=false,
  notes={5,6,7,8},
  branches={{on=1,to=4,prob=0.5}},  
}
phrases[3]={
  bpm=90,
  root=1000,
  demand=true,
  notes={5,6,7,8},
}
phrases[4]={
  bpm=90,
  root=1000,
  demand=false,
  notes={5,6,7,8},
}

for _,v in pairs(phrases) do
  v.ind=0
  if v.branches==nil then 
    v.branches={}
  end
end


function step(i,j)
  -- increment a step
  phrases[i].ind=(phrases[i].ind)%#phrases[i].notes+1
  if #phrases[i].notes==1 then
    phrases[i].ind=1
  end

  -- check if this note branches
  local branched=false
  for _, branch in ipairs(phrases[i].branches) do
    if branch.on==phrases[i].ind and math.random()<branch.prob then
      branched=true
      print("branching to "..branch.to)
      -- switch to that branch
      i,j=step(branch.to,i)
    end
  end
  if not branched then
    -- do its note
    print(i,j,phrases[i].ind)
  end

  -- check return conditions
  -- return if phrase is on the last note and not main phrase
  -- or return if its a demand phrase
  if (phrases[i].ind==#phrases[i].notes and i>1) or phrases[i].demand then
    print("branching back to "..j)
    i=j
  end
  return i,j
end

local current,last=1,1
for it=1,16 do
  current,last=step(current,last)
end


