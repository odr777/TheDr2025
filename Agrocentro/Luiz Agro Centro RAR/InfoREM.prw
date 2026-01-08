#include "protheus.ch"
#include "adprint.ch"
#include "RPTDEF.CH"
#include "FWPrintSetup.ch

/*/{Protheus.doc} InfoREM
Remito de Salida
@type function
@version 1.0
@author Luiz Fael
@since 16/11/2022
/*/
User Function InfoREM()
	Local   aArea		:= GetArea()
	Local   aPar 		:= {}
	Local   aRetPrb   	:= {}
	Local   aLayOut 	:= {"Remito Venta", "Remito Venta"}
	Private cUser 		:= ''
	Private cDocName	:= ""
	Private cDir 		:= Space(120)

	If !Empty(SC5->C5_NOTA)
		aAdd(aPar,{9,"Sucursal"+Space(20)+SC5->C5_FILIAL   ,100,100,.T.})
		aAdd(aPar,{9,"Orden de venta"+space(5)+SC5->C5_NUM ,100,100,.T.})
		aAdd(aPar,{2,"Remito",2, aLayOut, 080,'.T.',.T.})
		aAdd(aPar,{6,"Guardar archivo en ", cDir,"","","",080,.T.,"*.PDF",,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY})
		If ParamBox(aPar,"Orden de Venta ",@aRetPrb, , , , , , ,"oCpdf",.F., .F.)
			MV_PAR1	:= SC5->C5_FILIAL 		//Filial
			MV_PAR2	:= SC5->C5_NUM 			//Pedido
			MV_PAR3	:= aRetPrb[3] 			//Lay Oout
			MV_PAR4	:= Alltrim(aRetPrb[4]) 	//DIRETORIO
			If !Empty(MV_PAR4)
				If MV_PAR3 = 1
					U_RMT001()
				ElseIf MV_PAR3 = 2
					U_RMT001()
				EndIf
			ELSE
				MsgStop("¡La ubicación para grabar el archivo no fue informada! ")
			EndIf
		EndIf
	Else
		MsgStop("¡Orden de venda sem Remito! ")
	EndIf
	RestArea(aArea)
	FwFreeArray(aPar)
	FwFreeArray(aRetPrb)
Return
