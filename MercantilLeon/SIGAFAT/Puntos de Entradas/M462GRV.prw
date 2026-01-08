#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462GRV   ºAutor ³Jorge Saavedraº Data ³ 18/06/15º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada en la Grabacion del Remito de Ventas.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M462GRV()
Local _nPosPed:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_PEDIDO"})
Local _nPosIte:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_ITEMPV"})
Local _nPosSeq:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_SEQUEN"})
Local _nPosPro:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_COD"})
Local _nPosCli:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_UNOMCLI"})
Local _nPosDes:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_UDESC"})
Local _nCont  
Local _cArea:=GetArea()

//Grabacion del Numero Serial asignado en la Aprobacion de Ventas
SC9->(DbSetOrder(1))                                                 
For _nCont:=1 to Len(aCols)
    If SC9->(DbSeek(xFilial('SC9')+aCols[_nCont,_nPosPed]+aCols[_nCont,_nPosIte]+aCols[_nCont,_nPosSeq]+aCols[_nCont,_nPosPro])) 
	    aCols[_nCont,_nPosCli]:= GetAdvFVal("SA1","A1_NOME",XFILIAL("SA1")+SC9->(C9_CLIENTE+C9_LOJA),1,"")     
	    aCols[_nCont,_nPosDes]:= GetAdvFVal("SB1","B1_DESC",XFILIAL("SB1")+SC9->C9_PRODUTO,1,"")
    End
Next _nCont

RestArea(_cArea)	
return