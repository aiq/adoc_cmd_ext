local CU = require( "adoc_cmd_ext.cmd_util" )
local U = require( "adoc_cmd_ext.util" )

local cmdStr = [=[/=
sub_def[:name: final][ :salt: ]
-->
== {name}[[{name}]]

{salt}
=/]=]

local multiCmdStr = [=[

/=
sub_def[:name: final]
-->
== {name}[[{name}]]
=/

/=
sub[:name:]
-->
<<{name}>>
=/
]=]

local multiSingleLineCmdStr = [=[
/= sub_def[:name: final] --> == {name}[[{name}]] =/

/= sub[:name:] --> <<{name}>> =/
]=]

describe( "cmd_util", function()

   test( "raw_cmd_definitions", function()
      local t = CU.raw_cmd_definitions( multiCmdStr )
      assert.is.same( #t, 2 )

      t = CU.raw_cmd_definitions( multiSingleLineCmdStr )
      assert.is.same( #t, 2 )
   end )

   test( "scan_parameter", function()
      local n1, i1 = CU.scan_parameter( "[:name: final]" )
      assert.is.same( n1, "name" )
      assert.is.same( i1, "final" )

      local n2, i2 = CU.scan_parameter( "[ :salt: ]" )
      assert.is.same( n2, "salt" )
      assert.is.same( i2, "" )

      local n3, i3 = CU.scan_parameter( "[ :tip: don't use drugs ]" )
      assert.is.same( n3, "tip" )
      assert.is.same( i3, "don't use drugs" )
   end )

   test( "scan_cmd_definition", function()
      local cmd = CU.scan_cmd_definition( cmdStr )
      
      assert.is.same( cmd.name, "sub_def" )

      assert.is.same( "name", cmd.order[ 1 ] )
      assert.is.same( "salt", cmd.order[ 2 ] )

      assert.is.same( cmd.para.name, "final" )
      assert.is.same( cmd.para.salt, "" )

      assert.is.same( #cmd.repl, 7 )
   end )
   
end )
