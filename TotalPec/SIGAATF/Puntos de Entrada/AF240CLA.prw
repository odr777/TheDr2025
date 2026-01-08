#Include 'Protheus.ch'
#Include "Topconn.ch"
#Include "fwmvcdef.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPE         ³AF240CLA  ºAutor                                			  º±±
±±º						ºMarco A. Melgar ºFecha ³03/06/2025  			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.³Punto de entrada que se ejecuta al Clasificar la compra de un actº±±
±±º     ³Validacion de los campos necesario                               º±± 
±±º     ³y asignacion de valor al campo N3_XGRUPO                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P1212410_BIB (Totalpec)                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function AF240CLA()
Local aArea := GetArea()
Local lRet := .T.
Local n1Local //Direccion
local n1Cbase //Codigo de bien
Local oModel := FWModelActive()
Local oSN3 	:= oModel:GetModel('SN3DETAIL')//Acceder al modelo para poder ingresar a los datos del detalle
Local n3Descest //Desc. Extendida
local validacionCambio := .F.

n1Local := M-> N1_LOCAL 
N1grupo := M-> N1_GRUPO
n1Cbase := M-> N1_CBASE
n1Item := M-> N1_ITEM
n3Descest := oSN3:GetValue('N3_DESCEST')

If empty(n1Local) .or.n1Local == NIL
    cMensagem := " Campo direccion no rellenado." + CRLF + CRLF + ;
             " <b>Solucion:</b> Informe el campo direccion."
    Help("ATFA010",1,"HELP","N1_LOCAL",cMensagem,1,0)
    lRet := .F.
    Return lRet
EndIf

If empty(n1Cbase) .or.n1Cbase == NIL
     cMensagem := " Campo Codigo de Bien no rellenado." + CRLF + CRLF + ;
             " <b>Solucion:</b> Informe el campo Coidgo de Bien"
             
    Help("ATFA010",1,"HELP","N1_CBASE",cMensagem,1,0)
    lRet := .F.
    Return lRet
EndIf

IF empty(n3Descest) .OR. n3Descest == NIL
    cMensagem := " Campo Desc. Extendida no rellenado." + CRLF + CRLF + ;
             " <b>Solucion:</b> Informe el campo Desc. Extendida"
    Help("ATFA010",1,"HELP","DESC. EXTENDIDA",cMensagem,1,0)
    lRet := .F.
Return lRet
EndIf

if !EMPTY(n3Descest) .AND. !EMPTY(n1Local) .AND. !Empty(n1Cbase)
       validacionCambio:= oSN3:SetValue("N3_XGRUPO", N1grupo)
endif 

RestArea(aArea)     
Return
