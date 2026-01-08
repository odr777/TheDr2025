#Include "TOTVS.ch"
#include "protheus.ch"
#include "topconn.ch"
/*/{Protheus.doc} User Function showImgR
    Realiza el envío de la imagen para ser proyectada por la App.
    @type  Function
    @author user Nahim 
    @since 23/05/2021
    @version version
    @param cCodProd, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function showImgR(cCodProd)
     // muestra 
    // Local cURI      := "http://" + cServer + ":" + (cPort + "/rest") // URI DO SERVIÇO REST
    Local cURI      := GetMV("MV_XURLROO") //"https://ml-show-room.herokuapp.com" // URI DO SERVIÇO REST
    Local cResource := "/setImage"                  // RECURSO A SER CONSUMIDO
    Local oRest     := FwRest():New(cURI)                            // CLIENTE PARA CONSUMO REST
    Local aHeader   := {}                                            // CABEÇALHO DA REQUISIÇÃO
    // PREENCHE CABEÇALHO DA REQUISIÇÃO
    AAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
    AAdd(aHeader, "Accept: application/json")
    AAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")
    // INFORMA O RECURSO E INSERE O JSON NO CORPO (BODY) DA REQUISIÇÃO
    oRest:SetPath(cResource)
    oRest:SetPostParams(GetJson(cCodProd))
    // REALIZA O MÉTODO POST E VALIDA O RETORNO
    If (oRest:Post(aHeader))
        ALERT("POST: " + oRest:GetResult())
    Else
        ALERT("POST: " + oRest:GetLastError())
    EndIf
Return 



// CRIA O JSON QUE SERÁ ENVIADO NO CORPO (BODY) DA REQUISIÇÃO
Static Function GetJson(cCodProd)
    Local bObject := {|| JsonObject():New()}
    Local oJson   := Eval(bObject)
    // alert(cusername)
    oJson["url"]                            := GetAdvFVal("SB1","B1_XURLAWS" , XFILIAL("SB1") + cCodProd ,1,"") //"https://mercantilleon.s3-sa-east-1.amazonaws.com/7583122.jpg" 
    oJson["room"]                           := cusername
    // oJson["name"]                               := "MENIACX IMPORTAÇÕES CORP"
    // oJson["shortName"]                          := "MENIACX CORP"
    // oJson["type"]                               := 1
    // oJson["strategicCustomerType"]              := "F"
    // oJson["address"]                            := Eval(bObject)
    // oJson["address"]["state"]                   := Eval(bObject)
    // oJson["address"]["state"]["stateId"]        := "SP"
    // oJson["address"]["address"]                 := "AVENIDA SOUZA CRUZ"
    // oJson["address"]["city"]                    := Eval(bObject)
    // oJson["address"]["city"]["cityDescription"] := "JARDIM ALVES CARMO"
Return (oJson:ToJson())
