local _init = init

function init()
  if _init then _init() end
  
  message.setHandler("pat_getmilkedbozo", function(_, _, ...) pat_getmilkedbozo(...) end)
end

function pat_getmilkedbozo(sourceId)
  if storage.pat_milked then return end
  storage.pat_milked = true

  world.containerOpen(entity.id())

  local cfg = config.getParameter("pat_getmilkedbozo", {})
  local liq = cfg.liquid
  if liq and liq.name then
    if not liq.spaces then liq.spaces = {{0, 0}} end

    local objPos = object.position()
    local prot = world.isTileProtected(objPos)
    local dungeon = world.dungeonId(objPos)
    if prot then world.setTileProtection(dungeon, false) end

    local id = root.liquidId(liq.name)
    local amount = (liq.amount or 1) / #liq.spaces

    for i = 1, #liq.spaces do
      local pos = object.toAbsolutePosition(liq.spaces[i])
      world.spawnLiquid(pos, id, amount)
    end

    if prot then world.setTileProtection(dungeon, true) end

    world.npcQuery(object.position(), 50, {callScript = "npc.emote", callScriptArgs = {"laugh"}})

    object.setOfferedQuests()
  end

  if sourceId and cfg.radioMessage then
    world.sendEntityMessage(sourceId, "queueRadioMessage", cfg.radioMessage[1], cfg.radioMessage[2])
  end
end
