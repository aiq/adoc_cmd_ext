local AU = require( "adoc_cmd_ext.adoc_util" )
local U = require( "adoc_cmd_ext.util" )

describe( "adoc_util", function()

   test( "tokenize_table", function()
      local f = io.open( "test/xmpl01/pre.adoc" )
      local str = f:read( "*a" )
      local t = AU.tokenize_table( str )
      assert.is.same( #t, 21 )
   end )

   test( "scan_parameter_value", function()
      local v1 = AU.scan_parameter_value( "[ foobar ]" )
      assert.is.same( "foobar", v1 )

      local v2 = AU.scan_parameter_value( "[ foo bar ]" )
      assert.is.same( "foo bar", v2 )

      local v3 = AU.scan_parameter_value( "[]" )
      assert.is.same( "", v3 )

      local v4 = AU.scan_parameter_value( "[ ]" )
      assert.is.same( "", v4 )
   end )

   test( "scan_command_instance", function()
      local c1 = AU.scan_command_instance( "/:sub_def[ abc ][][ foo bar ]" )
      assert.is.same( "sub_def", c1.name )
      assert.is.same( "abc", c1.para[ 1 ] )
      assert.is.same( "", c1.para[ 2 ] )
      assert.is.same( "foo bar", c1.para[ 3 ] )
   end )

end )
