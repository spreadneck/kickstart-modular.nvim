local M = {}

local function seq_along(arr)
  if arr == nil then return {} end
  local res = {}
  for i = 1, #arr do
    res[i] = i
  end
  return res
end

local function has_special_modes(query)
  if #query == 0 then return false end
  local first = query[1]
  local last = query[#query]
  if first == '*' or first == "'" or first == '^' then return true end
  if last == '$' then return true end
  for _, chunk in ipairs(query) do
    if chunk == ' ' then return true end
  end
  return false
end

function M.matcher(minipick)
  local minifuzzy = require 'mini.fuzzy'
  minifuzzy.setup()

  local function minifuzzy_match(stritems, inds, query, opts)
    if has_special_modes(query) then
      return minipick.default_match(stritems, inds, query, opts)
    end

    opts = opts or {}
    local word = table.concat(query)
    local is_sync = opts.sync or not minipick.is_picker_active()
    local set_match_inds = is_sync and function(x) return x end or minipick.set_picker_match_inds

    local function compute()
      if #word == 0 then
        return set_match_inds(seq_along(stritems))
      end

      if #inds == 0 then
        return set_match_inds {}
      end

      local candidates = {}
      for _, ind in ipairs(inds) do
        candidates[#candidates + 1] = stritems[ind]
      end

      local _, relative = minifuzzy.filtersort(word, candidates)
      local match_inds = {}
      for i, rel in ipairs(relative) do
        match_inds[i] = inds[rel]
      end
      return set_match_inds(match_inds)
    end

    if is_sync then
      return compute()
    end
    coroutine.resume(coroutine.create(compute))
  end

  return minifuzzy_match
end

return M
-- vim: ts=2 sts=2 sw=2 et
