local p = require( "adoc_cmd_ext.pattern" )

local cmdDef = [=[/=
sub_def[:name: final]
-->
== {name}[[{name}]]
=/]=]

describe( "pattern", function()

   it( "should match a command parameter signature", function()
      assert.is.same( 15, p.cmdParaSig:match( "[:name: final]" ) )
      assert.is.same( 25, p.cmdParaSig:match( "[ :name: Rupert Pupkin ]" ) )
   end )

   it( "should match a full command", function()
      assert.is.same( 52, p.cmdDef:match( cmdDef ) )
   end )

   it( "should match an instance", function()
      assert.is.same( 19, p.cmdIns:match( "/:sub_def[ first ]" ) )
      assert.is.same( 12, p.cmdIns:match( "/:sub_def[]" ) )
   end )
   
end )
