local L = require( "lpeg" )
local LU = require( "adoc_cmd_ext.lpeg_util" )
local P = require( "adoc_cmd_ext.pattern" )
local U = require( "adoc_cmd_ext.util" )

--------------------------------------------------------------------------------

local function tokenize_table( adocFileStr )
   local p = LU.list_pattern( P.cmdIns )
   return p:match( adocFileStr ) or { adocFileStr }
end

local function scan_parameter_value( para )
   local extractor = LU.extract_pattern( P.paraBegin, P.paraEnd )
   local relevant = extractor:match( para )
   
   if relevant == nil then return "" else return U.trim( relevant ) end
end

local function scan_command_instance( ins )
   local p = L.Ct( L.P"/:" * L.C( P.cmdName ) * L.C( P.cmdInsPara )^1 )
   local values = p:match( ins )
   local name = values[ 1 ]
   local paras = U.slice( values, 2 )

   local res = {}

   res.name = name
   res.para = {}
   for k,v in ipairs( paras ) do
      local i = scan_parameter_value( v )
      table.insert( res.para, i )
   end

   return res
end

local function scan_adoc( adocFileStr )
   local t = tokenize_table( adocFileStr )
   return U.modify_even_entries( t, function( e )
      return scan_command_instance( e )
   end )
end

--------------------------------------------------------------------------------
-- Lua module with util functions that allow to scan an asciidoc file string
-- with command instances in it.
--
-- Function: scan_adoc
-- The result structure of the main function scan_adoc is a table-array where
-- on each odd position plain asciidoc is that will be not touched, and on each
-- even position are table-objects that represent a command instance that should
-- be replaced.
--
-- Example:
-- 1 = "This is a simple "
-- 2 = { name = "topic", para = { "Example" } }
-- 3 = " to show the power. "
-- 3 = { name = "author", para = { "AIQ", "Alexander" } }
-- 4 = ""
--
-- The other functions are just public for the testing of the module interface
-- and will be used internal from the scan_adoc function.
--------------------------------------------------------------------------------

return {
   tokenize_table        = tokenize_table,
   scan_parameter_value  = scan_parameter_value,
   scan_command_instance = scan_command_instance,
   scan_adoc             = scan_adoc
}
