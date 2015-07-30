local LU = require( "adoc_cmd_ext.lpeg_util" )

local cmdDef = [=[/=sub_def[:name: final]-->== {name}[[{name}]]=/]=]

describe( "lpeg_util", function()

   test( "extract_pattern", function()
      local p = LU.extract_pattern( "/=", "=/" )
      local content = p:match( cmdDef )
      assert.is.same( "sub_def[:name: final]-->== {name}[[{name}]]", content )
   end )

   test( "list_pattern", function()
      local p = LU.list_pattern( "/==/" )
      local t = p:match( "foo/==/bar/==/tar" )
      assert.is.same( 5, #t )
      assert.is.same( { "foo", "/==/", "bar", "/==/", "tar" }, t )

      t = p:match( "/==/bar/==/tar" )
      assert.is.same( 5, #t )
      assert.is.same( { "", "/==/", "bar", "/==/", "tar" }, t )

      t = p:match( "foo/==/bar/==/" )
      assert.is.same( 5, #t )
      assert.is.same( { "foo", "/==/", "bar", "/==/", "" }, t )

      t = p:match( "/==/bar/==/" )
      assert.is.same( 5, #t )
      assert.is.same( { "", "/==/", "bar", "/==/", "" }, t )

      t = p:match( "foo/==//==/tar" )
      assert.is.same( 5, #t )
      assert.is.same( { "foo", "/==/", "", "/==/", "tar" }, t )

      t = p:match( "foobar" )
      assert.is.same( nil, t )
   end )

   test( "split_pattern", function()
      local p = LU.split_pattern( "-->" )
      local before, after = p:match( "sub_def[:name: final]-->== {name}[[{name}]]" )
      assert.is.same( "sub_def[:name: final]", before )
      assert.is.same( "== {name}[[{name}]]", after )
   end )

end )
