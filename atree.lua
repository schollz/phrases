-- atree


engine.name="Synthy"
local lattice=require("lattice")
local phrases=include("atree/lib/phrases")
local phrase=include("atree/lib/phrase")



function note_on(note,velocity)
  synthy.notes[note]=true
  engine.synthy_note_on(note,velocity)
end

function note_off(note)
  synthy.notes[note]=false
  engine.synthy_note_off(note)
end

function note_stop()
  local notes_to_off={}
  for _, note in pairs(synthy.notes) do
    table.insert(notes_to_off,note)
  end
  for _, note in ipairs(notes_to_off) do
    note_off(note)
  end
end

function init()



  -- create phrases
  ps=phrases:new()
  ps:add(phrase:new{0,2,7,6,3,root=32,division=1/2,branches={{on=1,to=2,prob=0.5},{on=4,to=3,prob=0.5}}})
  ps:add(phrase:new{-1,-5,3,11,root=32,demand=true})
  ps:add(phrase:new{5,3,1,root=32})


  -- start lattice
  local sequencer=lattice:new{
    ppqn=96
  }
  local divisions={1,1/2,1/4,1/8,1/16}
  for _, division in ipairs(divisions) do
    sequencer:new_pattern({
      action=function(t)
        ps:emit(division)
      end,
      division=division,
    })
  end

end