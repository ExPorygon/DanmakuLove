function isTaskAlive(task)
    if not task then return false end
    if coroutine.status(task) == "dead" then return false else return true end
end
