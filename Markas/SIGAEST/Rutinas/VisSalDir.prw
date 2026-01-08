#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VisSalDir ºAutor  ³Jorge Saavedra           º Data ³  17/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rutina para mostrar los Saldos por Direccion  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ INESCO                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VisSalDir(cProcesso,cLocal,L410AUTO)
LOCAL aArea := GetArea()
LOCAL lRet  := .T.
LOCAL aCab  := {}
LOCAL aPicture := {}
LOCAL aCampos  := {"BF_LOCAL","BF_LOCALIZ","BF_NUMSERIE","BF_LOTECTL","BF_QUANT"}
Local nResult := 0
Local cDescAlm:=cLocal +" - "+Posicione('NNR',1,xFilial('NNR')+cProcesso,'NNR_DESCRI') 
Local cDescri:=SB1->B1_DESC                          
Local aDatos:=""
DEFAULT cProcesso := aCols[n][2]

iF TYPE('CTESPEND')=='C'
	RETURN 0
END            
nSaldo		:= 0
lLocaliz	:= Localiza(cProcesso)
lRastro		:= Rastro(cProcesso)


nQ:=0

aLotes := {}
DbSelectArea("SX3")
DbSetOrder(2)
For nI := 1 To Len(aCampos)
		DbSeek(aCampos[nI])
		AADD(aCab,X3Titulo())
		AADD(aPicture,SX3->X3_PICTURE)
Next nI                                     

DbSetOrder(1)
DbSelectArea("SBF")
DbSetOrder(2)
If DbSeek(xFilial("SBF")+cProcesso)

	While !Eof() .and. SBF->BF_PRODUTO == cProcesso

		//			dVencto		:= Posicione("SD5",2,xFilial("SD5")+SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL,"D5_DTVALID")
		dVencto		:= Posicione("SB8",3,xFilial("SB8")+SBF->BF_PRODUTO+SBF->BF_LOCAL+SBF->BF_LOTECTL,"B8_DTVALID")
		
		//			nSaldo:= SldAtuEst(SBF->BF_PRODUTO,SBF->BF_LOCAL,99999999999,SBF->BF_LOTECTL,NIL,SBF->BF_LOCALIZ,Nil,Nil)
		nSaldo  := SBF->BF_QUANT - (SBF->BF_EMPENHO+AvalQtdPre("SBF",1))
		                /*
		//Sumando Qtde Pedido de Ventas
		If Select('PEDIDOS') > 0
			PEDIDOS->(DbCloseArea())
		End
		_cQuery:="SELECT SUM(C6_QTDVEN-C6_QTDENT-C6_QTDEMP) AS SALDOPED FROM " + RetSqlName('SC6') + " SC6 "
		_cQuery+="Inner Join "+RetSqlName("SF4")+" SF4 On F4_CODIGO=C6_TES and SF4.D_E_L_E_T_ = '' "
		_cQuery+="Left Outer Join "+RetSqlName("SF2")+" SF2 On F2_FILIAL = C6_FILIAL and F2_PEDPEND = C6_NUM and SF2.D_E_L_E_T_ = '' "
		_cQuery+="WHERE C6_PRODUTO = '" + cProcesso + "' AND "
		_cQuery+="C6_FILIAL = '" + xFilial('SC6') + "' AND "
		_cQuery+="C6_LOTECTL = '" + SBF->BF_LOTECTL + "' AND "
		_cQuery+="C6_LOCALIZ = '" + SBF->BF_LOCALIZ + "' AND "
		_cQuery+="C6_BLQ <> 'S"+Space(Len(SC6->C6_BLQ)-1)+"' AND "
		_cQuery+="C6_BLQ <> 'R"+Space(Len(SC6->C6_BLQ)-1)+"' AND "
		_cQuery+="C6_LOCAL = '" + SBF->BF_LOCAL + "' AND "
		_cQuery+="(C6_QTDVEN > C6_QTDENT OR (C6_QTDVEN <= C6_QTDENT AND C6_ENTREG>='"+DTOS(dDataBase-31)+"')) AND "
		_cQuery+="F2_PEDPEND is null and "
		_cQuery+="F4_ESTOQUE = 'S' and "
		_cQuery+="SC6.D_E_L_E_T_=' ' "
		
		If FunName() == 'MATA410' .and. Altera
			_cQuery += " AND SC6.C6_NUM <> '" + M->C5_NUM + "'"
		End
		
		_cQuery := ChangeQuery(_cQuery)
		
		MemoWrite("A410Cons.SQL",_cQuery)
		
		TCQUERY _cQuery NEW ALIAS 'PEDIDOS'
		If PEDIDOS->(!EOF())
			nSaldo:=nSaldo-PEDIDOS->SALDOPED
		End
		*/
		If nSaldo>0
		   Aadd(aLotes,{SBF->BF_LOCAL,SBF->BF_LOCALIZ,SBF->BF_NUMSERIE,SBF->BF_LOTECTL,nSaldo}) 
		EndIf
		
		SBF->(DbSkip())
		
	EndDo
	
EndIf

If Len(aLotes) > 0  .AND. !L410AUTO
	DEFINE MSDIALOG oDlgShow  STYLE DS_MODALFRAME TITLE  Oemtoansi("Ubicacion / Series disponibles");
	FROM 10,30 To 25,110 OF GetWndDefault()

@ 10, 15 Say   "Producto: " Size 40,10 Pixel Of oDlgShow
@ 10, 50 MsGet cProcesso Picture "@!" Size 50,10 When .f. Pixel Of oDlgShow

@ 10,115 Say "Almacen: "  Size 40,10 Pixel Of oDlgShow
@ 10,150 MsGet cDescAlm Picture "@!" Size 80,010 When .f. Pixel Of oDlgShow
/*
@ 10,245 Say "Descripcion: "  Size 40,10 Pixel Of oDlgShow
@ 10,280 MsGet cDescri Picture "@!" Size 220,010 When .f. Pixel Of oDlgShow
  */                     
nTotSerial:=Len(aLotes)
@ 99.4,15 Say "Total Seriales: "  Size 40,10 Pixel Of oDlgShow
@ 99.4,70 MsGet nTotSerial Picture "@E 999,999" Size 40,010 When .f. Pixel Of oDlgShow

	
	oLbx := RDListBox(1.9, .5, 310 , 65.5, aLotes, aCab,aPicture,, )
	@ 99.4,260 BMPBUTTON TYPE 1 ACTION aDatos:=A410OK()
	//		ACTIVATE MSDIALOG oDlgShow
	oDlgShow:Activate(Nil,Nil,Nil, .T.,Nil, Nil, {|| oDlgShow:lEscClose := .F. }, Nil, Nil )
Else
	Aviso("Saldos en Stock","No Existe Saldo Disponible para el producto: " + cProcesso ,{"Ok"})
End
RestArea(aArea)
Return aDatos

Static Function a410Ok()
Local aDatos:=""
nOpc := 1
nLbxnAt := oLbx:nAt
aDatos:=oLbx:aArray[nLbxnAt][3] +"||"+ oLbx:aArray[nLbxnAt][2]+"||"+ oLbx:aArray[nLbxnAt][4]
Close(oDlgShow)

Return aDatos
