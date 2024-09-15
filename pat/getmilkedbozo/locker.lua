local _init = init

function init()
  if _init then _init() end
  
  message.setHandler("pat_getmilkedbozo", function(_, _, ...) pat_getmilkedbozo(...) end)
end

function pat_getmilkedbozo(sourceId, cfg)
  if not sourceId or not cfg or storage.pat_milked then return end
  storage.pat_milked = true

  local liq = cfg.liquid
  if liq and liq.name then
    local pos = object.position()
    if liq.offset then
      pos[1] = pos[1] + liq.offset[1]
      pos[2] = pos[2] + liq.offset[2]
    end

    local prot = world.isTileProtected(pos)
    local dungeon = world.dungeonId(pos)
    if prot then world.setTileProtection(dungeon, false) end

    world.spawnLiquid(pos, root.liquidId(liq.name), liq.amount or 1)

    if prot then world.setTileProtection(dungeon, true) end

    world.npcQuery(object.position(), 50, {callScript = "npc.emote", callScriptArgs = {"laugh"}})
  end

  local radio = cfg.radioMessage
  if radio and radio.config then
    world.sendEntityMessage(sourceId, "queueRadioMessage", radio.config, radio.delay)
  end
end
