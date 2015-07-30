local L = require( "lpeg" )

--------------------------------------------------------------------------------

local function extract_pattern( startPoint, endPoint )
   startPoint = L.P( startPoint )
   endPoint = endPoint and L.P( endPoint ) or startPoint
   local between = ( 1 - endPoint )^1 
   return startPoint * L.C( between ) * endPoint
end

local function list_pattern( token )
   token = L.P( token )
   local between = ( 1 - token )^1
   return L.Ct( L.C( between^0 ) * L.C( token ) *
                ( L.C( between^0 ) * L.C( token ) )^0 * L.C( between^0 ) )
end

local function split_pattern( sep )
   sep = L.P( sep )
   local before = ( 1 - sep )^1
   local after  = ( 1 - sep )^1
   return L.C( before ) * sep * L.C( after )
end

--------------------------------------------------------------------------------
-- Lua module that defines LPEG patterns that can be used for general use cases.
--
-- * extract_pattern to capture arbitrary content that is surroundet with by a
--   pattern
--
-- * list_pattern to tokenize a text by a pattern, empty strings between the
--   pattern are allowed
--
-- * split_pattern to capture arbitrary content that is separated by a pattern
--------------------------------------------------------------------------------

return {
   extract_pattern = extract_pattern,
   list_pattern    = list_pattern,
   split_pattern   = split_pattern
}
