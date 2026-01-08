#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"
#INCLUDE "FWEVENTVIEWCONSTS.CH"       
#INCLUDE "RWMAKE.CH"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPE  ณSUPTASKCPEบ Autor  ณTdeP Bolivia บFecha ณ  06/04/22 			  บฑฑ
ฑฑ						                			                      นฑฑ
ฑฑบDesc.     ณ Cambiar el query para la atribuci๓n de costos en TOP		  บฑฑ
ฑฑบDesc.     ณ En el servicio REST de integraci๓n SUPTASKREST		      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

aParam			:= {cCodProj,cCodRev,cCodITsk,cCodFTsk,dIDate,dFDate,aTpMov,nPages,nPSize,cBanco,cCurrencySimbol,cQry}
cQry := ExecBlock("SUPTASKCPE", .F., .F., aParam)
*/

user function SUPTASKCPE()
	Local aParam     := PARAMIXB

    Local aArea := GetArea()
	Local cQuery

If aParam <> NIL

		cQuery  := aParam[12]

EndIf
MemoWrite("SUPTASKCPE.sql",cQuery)

RETURN
