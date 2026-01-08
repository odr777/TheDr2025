#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWMVCDEF.CH"

User Function ValNitREST()
    Local aArea       := GetArea()
    Local oRest       := FWRest():New("http://apidocs.kraken.bo:8031/api/integrations")
    Local aHeader   := {}  

    

    AAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
    AAdd(aHeader, "Accept: application/json")
    AAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
    AAdd(aHeader, 'Authorization:Bearer 934564981df7d0061d0bd73e5cae1bc9')

    oRest:setPath("/nit-check/147840023")

    If oRest:Get(aHeader)
        ConOut(oRest:GetResult())
    Else
        conout(oRest:GetLastError())
    Endif

    RestArea(aArea)
      
Return Nil



