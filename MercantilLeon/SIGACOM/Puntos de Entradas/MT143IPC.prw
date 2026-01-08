#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#include 'parmtype.ch'
#Include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  MT143IPC  บAutor  ณErick Etcheverry    	บ Data ณ  01/03/13บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. ณPunto de entrada para Actualizar campos al jalar el PO          บฑฑ
ฑฑบ      ณdespues de seleccionar PO            							บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  BASE BOLIVIA   	                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function MT143IPC()
    Local aArea := GetArea()
    Local nPosEspe := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'DBC_UESPEC' } )
    Local nPosEsp2 := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'DBC_UESPE2' } )
    Local nPosProd := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'DBC_CODPRO' } )
    Local nPosPeso := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'DBC_UPESO' } )
    Local nPosQuua := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'DBC_QUANT' } )

    For nI := 1 To Len(aCols)
        
            aCols[nI][nPosEspe] := Posicione("SB1",1,xFilial("SB1")+  aCols[nI][nPosProd],"B1_ESPECIF")      

            aCols[nI][nPosEsp2] := Posicione("SB1",1,xFilial("SB1")+ aCols[nI][nPosProd],"B1_UESPEC2") 

            aCols[nI][nPosPeso] := aCols[nI][nPosQuua] * Posicione("SB1",1,xFilial("SB1")+ aCols[nI][nPosProd],"B1_PESO") 

    Next nI

    RestArea(aArea)
return
