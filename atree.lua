-- atree


engine.name="Synthy"
local lattice=require("lattice")
local phrases=include("atree/lib/phrases")
local phrase=include("atree/lib/phrase")
local synthy={notes={}}


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
  for note,_ in pairs(synthy.notes) do
    table.insert(notes_to_off,note)
  end
  for _, note in ipairs(notes_to_off) do
    note_off(note)
  end
end

function init()
  engine.synthy_attack(0.01)
  engine.synthy_release(0.1)
  engine.synthy_sustain(0.01)
  engine.synthy_decay(0.1)
  osc.event=function(path,args,from)
  end

  -- create phrases
  ps=phrases:new()  
  ps:add(phrase:new{0,0.1,0.1,0.1,2,0.1,7,-1,root=60,division=1/8,branches={{on=1,to=2,prob=0.5},{on=4,to=3,prob=0.5}}})
  ps:add(phrase:new{0,2,7,14,root=72,division=1/16,demand=true})
  ps:add(phrase:new{-1,7,2,0,division=1/16,root=72,branches={{on=1,to=4,prob=0.5},{on=4,to=2,prob=0.5},{on=3,to=1,prob=0.5}}})
  ps:add(phrase:new{-1,7,2,0,2,7,11,division=1/16,root=60-12})


  -- start lattice
  local sequencer=lattice:new{
    ppqn=96
  }
  local divisions={1,1/2,1/4,1/8,1/16}
  for _, division in ipairs(divisions) do
    sequencer:new_pattern({
      action=function(t)
        local note=ps:emit(division)
        if note~=nil then 
          print(note)
          note_stop()
          if math.floor(note)==note then
            note_on(note,1.0)
          end
        end
      end,
      division=division,
    })
  end
  sequencer:hard_restart()

end
