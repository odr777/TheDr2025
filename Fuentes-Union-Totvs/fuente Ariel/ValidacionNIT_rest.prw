#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWMVCDEF.CH"

User Function ValNitREST()
    Local aArea       := GetArea()
    Local oRest       := FWRest():New("http://apidocs.kraken.bo:8031")
    Local aHeader   := {}  

    

    AAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
    AAdd(aHeader, "Accept: application/json")
    AAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
    AAdd(aHeader, 'bearer token:eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ1bmlvbnRvdHZzIiwiYXV0aCI6IjYiLCJleHAiOjE2NTkwNDM2NjZ9.kH0IYssErpumx-kgkcKTT548JdG-MnRwswXrd7symRKgHa8r0bMwfe95Xxxjk_w4l_1mnPlJatu3F5j-Q2jKPg')

    oRest:setPath("/api/integrations/nit-check/147840023")

    If oRest:Get(aHeader)
        ConOut(oRest:GetResult())
    Else
        conout(oRest:GetLastError())
    Endif

    RestArea(aArea)
      
Return Nil



