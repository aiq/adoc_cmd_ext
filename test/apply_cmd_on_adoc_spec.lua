local apply_cmd_on_adoc = require( "adoc_cmd_ext.apply_cmd_on_adoc" )

describe( "apply_cmd_on_adoc", function()

   test( "xmpl01", function()
      local cmdFileStr = io.open( "test/xmpl01/def.acmd" ):read( "*a" )
      local adocFileStr = io.open( "test/xmpl01/pre.adoc" ):read( "*a" )

      local res = apply_cmd_on_adoc( cmdFileStr, adocFileStr )
      local postFileStr = io.open( "test/xmpl01/post.adoc" ):read( "*a" )

      assert.is.same( postFileStr, res )
   end )

   test( "xmpl02", function()
      local cmdFileStr = io.open( "test/xmpl02/def.acmd" ):read( "*a" )
      local adocFileStr = io.open( "test/xmpl02/pre.adoc" ):read( "*a" )

      local res = apply_cmd_on_adoc( cmdFileStr, adocFileStr )
      local postFileStr = io.open( "test/xmpl02/post.adoc" ):read( "*a" )

      assert.is.same( postFileStr, res )
   end )

   test( "xmpl03", function()
      local cmdFileStr = io.open( "test/xmpl03/def.acmd" ):read( "*a" )
      local adocFileStr = io.open( "test/xmpl03/pre.adoc" ):read( "*a" )

      local res = apply_cmd_on_adoc( cmdFileStr, adocFileStr )
      local postFileStr = io.open( "test/xmpl03/post.adoc" ):read( "*a" )

      assert.is.same( postFileStr, res )
   end )

end )
