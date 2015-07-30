local L = require( "lpeg" )
local LU = require( "adoc_cmd_ext.lpeg_util" )

--------------------------------------------------------------------------------

local function nP( p )
   return ( 1 - p )^0
end

--------------------------------------------------------------------------------

-- /=
-- sub_def[:name:]
-- -->
-- == {name}[[{name}]]
-- =/

local spc = L.S" \t\n"^0
local alpha = L.R"az" + L.R"AZ"
local alphaNum = alpha + L.R"09"
local name = alpha * ( alpha + L.P"_" + L.P"-" + L.R"09" )^0

--------------------------------------------------------------------------------

local attrName = name
local attrValue = nP( L.P"]" )
local attrDecl = L.P":" * name * L.P":" 
local attrDef = attrDecl * spc * attrValue * spc
local attrUseBegin = L.P"{"
local attrUseEnd = L.P"}"
local attrUse = attrUseBegin * name * attrUseEnd

local cmdDefBegin = L.P"/=" * spc
local cmdDefSep = spc * L.P"-->" * spc
local cmdDefEnd = spc * L.P"=/"

local notCmdBegin = nP( cmdDefBegin )
local notCmdEnd = nP( cmdDefEnd )
local cmdDefCont = nP( cmdDefEnd )

local cmdName = name

local paraBegin = L.P"[" * spc
local paraEnd = spc * L.P"]"
local paraSig = paraBegin * spc * attrDef * spc * paraEnd

local cmdDefSig = cmdName * paraSig^1

local cmdDefBetween = cmdDefSig * cmdDefSep * cmdDefCont

local cmdDef = cmdDefBegin * cmdDefBetween * cmdDefEnd

--------------------------------------------------------------------------------

local cmdInsBegin = L.P"/:"

local para = ( paraBegin * spc * attrValue * spc * paraEnd ) +
             ( paraBegin * spc * paraEnd )

local cmdIns = cmdInsBegin * cmdName * para^1

--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------

return {
   attrUseBegin = attrUseBegin,
   attrUseEnd = attrUseEnd,
   attrUse = attrUse,
   attrDecl = attrDecl,

   cmdName = cmdName,
   cmdParaSig = paraSig,
   paraBegin = paraBegin,
   paraEnd = paraEnd,

   cmdDefBegin = cmdDefBegin,
   cmdDefSep = cmdDefSep,
   cmdDefEnd = cmdDefEnd,

   cmdDef = cmdDef,

   cmdIns = cmdIns,
   cmdInsPara = para
}
