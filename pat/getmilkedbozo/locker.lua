local _init = init

function init()
  if _init then _init() end
  
  message.setHandler("pat_getmilkedbozo", function(_, _, ...) pat_getmilkedbozo(...) end)
end

function pat_getmilkedbozo(sourceId, cfg)
  if not sourceId or not cfg or storage.pat_milked then return end
  storage.pat_milked = true

  local liq = cfg.liquid
  if liq then
    local pos = object.position()
    pos[1] = pos[1] + liq.offset[1]
    pos[2] = pos[2] + liq.offset[2]

    local prot = world.isTileProtected(pos)
    local dungeon = world.dungeonId(pos)
    if prot then world.setTileProtection(dungeon, false) end

    world.spawnLiquid(pos, root.liquidId(liq.name), liq.amount)

    if prot then world.setTileProtection(dungeon, true) end
  end

  local radio = cfg.radioMessage
  if radio then
    world.sendEntityMessage(sourceId, "queueRadioMessage", radio.config, radio.delay)
  end
end
