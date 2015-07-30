local AU = require( "adoc_cmd_ext.adoc_util" )
local CU = require( "adoc_cmd_ext.cmd_util" )
local U = require( "adoc_cmd_ext.util" )

--------------------------------------------------------------------------------

local function values_map( order, values, defValues )
   local res = {}
   for k, v in ipairs( values ) do
      local name = order[ k ]
      if v == "" then v = defValues[ name ] end
      res[ name ] = v
   end
   return res
end

local function apply_cmd_on_adoc( cmdFileStr, adocFileStr )
   local acmdTab = CU.scan_cmd( cmdFileStr )
   local adocTab = AU.scan_adoc( adocFileStr )

   U.modify_even_entries( adocTab, function( e )
      local cmd = acmdTab[ e.name ]
      if cmd == nil then
         print( string.format( "INFO: Command %q is not defined", e.name ) )
         return ""
      end

      local map = values_map( cmd.order, e.para, cmd.para )

      local repl = U.shallowcopy( cmd.repl )
      U.modify_even_entries( repl, function( r )
         return map[ r ]
      end )
      return table.concat( repl )
   end )

   return table.concat( adocTab )
end

--------------------------------------------------------------------------------
-- Lua module that offers the global functionality of this extension.
--
-- Function: apply_cmd_on_adoc
-- The result is a string where the command instances in adocFileStr are
-- replaced with the command replacements from cmdFileStr.
--
-- See the examples in the xmpl?? folders.
--------------------------------------------------------------------------------

return apply_cmd_on_adoc
