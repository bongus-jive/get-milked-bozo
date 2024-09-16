local milk = {}
pat_getmilkedbozo = milk

local _init = init
function init()
  if _init then _init() end
  milk:init()
end

function milk:init()
  local cfg = config.getParameter("pat_getmilkedbozo", {})
  if cfg.worldType and cfg.worldType ~= world.type() then return end

  object.setOfferedQuests(cfg.quests)

  message.setHandler("pat_getmilkedbozo", function(_, _, ...)
    self:trigger(...)
  end)
end

function milk:trigger(sourceId)
  world.containerOpen(entity.id())
  object.setOfferedQuests()

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
  end

  if cfg.npcEmote then
    world.npcQuery(object.position(), 50, {callScript = "npc.emote", callScriptArgs = {cfg.npcEmote}})
  end

  if sourceId and cfg.radioMessage then
    world.sendEntityMessage(sourceId, "interruptRadioMessage")
    world.sendEntityMessage(sourceId, "queueRadioMessage", cfg.radioMessage[1], cfg.radioMessage[2])
  end
end
