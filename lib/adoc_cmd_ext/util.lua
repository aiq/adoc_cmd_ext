
local function get_even_entries( t )
   local res = {}
   for i,v in ipairs( t ) do
      if ( i % 2 == 0 ) then
         table.insert( res, v )
      end
   end
   return res
end

local function modify_even_entries( t, modf )
   for i = 1,#t do
      if ( i % 2 == 0 ) then
         t[ i ] = modf( t[ i ] )
      end
   end

   return t
end

local function slice( tab, first, last )
   local res = {}
   local n = #tab

   first = first or 1
   last = last or n
   if last < 0 then
      last = n + last + 1
   elseif last > n then
      last = n
   end

   if first < 1 or first > n then
      return {}
   end

   for i = first, last do
      table.insert( res, tab[ i ] )
   end
   
   return res
end

local function trim( str )
   return str:find'^%s*$' and '' or str:match'^%s*(.*%S)'
end

local function tprint ( tbl, indent )
   if not indent then indent = 3 end
   for k, v in pairs(tbl) do
      formatting = string.rep( "  ", indent ) .. k .. ": "
      if type( v ) == "table" then
         print( formatting )
         tprint(v, indent+1)
      else
         print(formatting .. v)
      end
   end
end

function shallowcopy( orig )
   local orig_type = type( orig )
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in pairs( orig ) do
         copy[orig_key] = orig_value
      end
   else -- number, string, boolean, etc
      copy = orig
   end
   return copy
end

--------------------------------------------------------------------------------
-- Lua module that defines util functions to  handle default Lua data structurs
-- like tables and strings.
--
-- * get_even_entries copies the even entries from a table into a new table
--
-- * modify_even_entries modifies even entries on a table
--
-- * slice is similar to the JavaScript Array function slice
--
-- * trim removes spaces add the beginning and the end of a string
--
-- * tprint dumps the content of table to the output stream
--
-- * shallowcopy creates a shallowcopy of an table
--------------------------------------------------------------------------------

return {
   get_even_entries    = get_even_entries,
   modify_even_entries = modify_even_entries,
   slice               = slice,
   trim                = trim,
   tprint              = tprint,
   shallowcopy         = shallowcopy
}
