function init()
  quest.fail()

  local name = config.getParameter("objectName")
  local objects = world.objectQuery(entity.position(), 500, {name = name, order = "nearest"})
  local locker = objects[1]
  
  if not locker then return end

  world.sendEntityMessage(locker, config.getParameter("message"), entity.id())
end
