function wait(w)
	for i = 1, w do
		coroutine.yield()
	end
end

function switch(t)
  t.case = function (self,x,...)
    local f=self[x] or self.default
    if f then
      if type(f)=="function" then
        f(...,self) --consider making this (...,x,self)
      else
        error("case "..tostring(x).." is not a function")
      end
    end
  end
  return t
end

-- function switch(t) --Original implementation from Lua Users Wiki
--   t.case = function (self,x)
--     local f=self[x] or self.default
--     if f then
--       if type(f)=="function" then
--         f(x,self)
--       else
--         error("case "..tostring(x).." is not a function")
--       end
--     end
--   end
--   return t
-- end

local _coroutine_resume = coroutine.resume
function coroutine.resume(...)
	local state,result = _coroutine_resume(...)
	if not state then
		error( tostring(result), 2 )	-- Output error message
	end
	return state,result
end
