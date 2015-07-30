local U = require( "adoc_cmd_ext.util" )

describe( "util", function()

   it( "should be possible to get the elements on even positions of a table", function()
      local t = { 1, 2, 3, 4, 5, "six", 7 }
      local res = U.get_even_entries( t )
      assert.is.same( { 2, 4, "six" }, res )
   end )

   it( "should be possible to modify the elements on even positions in a table", function()
      local t = { 1, 1, 1, 1, 1, 1 }
      U.modify_even_entries( t, function( e )
         return e + 1
      end )
      assert.is.same( { 1, 2, 1, 2, 1, 2 }, t )
   end )
 
end )
