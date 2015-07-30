local L = require( "lpeg" )
local LU = require( "adoc_cmd_ext.lpeg_util" )
local P = require( "adoc_cmd_ext.pattern" )
local U = require( "adoc_cmd_ext.util" )

--------------------------------------------------------------------------------

local function raw_cmd_definitions( cmdFileStr )
   local p = LU.list_pattern( P.cmdDef )
   local t = p:match( cmdFileStr ) or {}
   local res = U.get_even_entries( t )
   return res
end

local function scan_parameter( paraStr )
   local extractor = LU.extract_pattern( P.paraBegin, P.paraEnd )
   local relevant = extractor:match( paraStr )
   local attrDeclSubSize = P.attrDecl:match( relevant )

   local n = U.trim( relevant:sub( 1, attrDeclSubSize ):gsub( ":", "" ) )
   local i = U.trim( relevant:sub( attrDeclSubSize ) )

   return n, i
end

local function scan_cmd_definition( cmdStr )
   local extractor = LU.extract_pattern( P.cmdDefBegin, P.cmdDefEnd )
   local spliter = LU.split_pattern( P.cmdDefSep )
   local content = extractor:match( cmdStr )
   local paraSig, repl = spliter:match( content )

   local headerValues = L.Ct( L.C( P.cmdName ) *
                              L.C( P.cmdParaSig )^1 ):match( paraSig )
   local name = headerValues[ 1 ]
   local paras = U.slice( headerValues, 2 )

   local lister = LU.list_pattern( P.attrUse )
   local attrExtractor = LU.extract_pattern( P.attrUseBegin, P.attrUseEnd )
   local attrList = lister:match( repl )

   local res = {}

   res.name = name
   res.order = {}
   res.para = {}
   for k,v in ipairs( paras ) do 
      local n, i = scan_parameter( v )
      table.insert( res.order, n )
      res.para[ n ] = i
   end
   res.repl = U.modify_even_entries( attrList, function( e )
      return attrExtractor:match( e )
   end )

   return res
end

local function scan_cmd( cmdFileStr )
   local entries = raw_cmd_definitions( cmdFileStr )
   local res = {}
   for k,v in ipairs( entries ) do
      local cmdDef = scan_cmd_definition( v )
      res[ cmdDef.name ] = cmdDef
   end

   return res
end

--------------------------------------------------------------------------------
-- Lua module with util functions that allow to scan a string with command
-- definitions.
--
-- Function: scan_cmd
-- The result of the main function scan_cmd is a table-object where the commands
-- that are in the string are stored as obejects with the values name, order,
-- para and repl.
--    name  is the name of the command
--    order shows on which parameter postion an argument is
--    para  stores the possible default values of the parameters
--    repl  is a table-array where on each odd position plain asciidoc is that
--          will not be touched. The even entries should be replaced with the
--          parameters of a command
--
-- Example:
-- {
--    "topic" = { name = "topic", order = { "txt" }, para = { "txt" = "" },
--                repl = { "*", "txt", "*" } },
--    "author" = { name = "author", order = { "short", "name" },
--                 para = { "short" = "-", "name" = "-" },
--                 repl = { "*", "short", "* / _", "name", "_" } }
-- }
--
-- The other functions are just public for the testing of the module interface
-- and will be used internal from the scan_cmd function.
--------------------------------------------------------------------------------

return {
   scan_parameter = scan_parameter,
   scan_cmd_definition = scan_cmd_definition,
   raw_cmd_definitions = raw_cmd_definitions,
   scan_cmd = scan_cmd
}
