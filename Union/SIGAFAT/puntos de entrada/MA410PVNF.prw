#INCLUDE "PROTHEUS.CH"
#DEFINE CRLF Chr(13)+Chr(10)
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA410PVNF ºAutor ³ Widen Gonzales(TOTVS-BOLIVIA)º Data ³15/12/2019º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada al darle la opcion de Preparar Documento de º±±
±±º          ³ salida                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function M410PVNF()

	Local lRet := .T.
	Local aArea := GetArea()
	Local aAreaC9 := SC9->(GetArea())
	Local aAreaC5 := SC5->(GetArea())
	Local cPro:=''
	//Local aAreaC6 := SC6->(GetArea())
	//Se tiver em branco o campo, não permite prosseguir
	//alert(SC5->C5_NUM)
	//alert(SC6->C6_ITEM)
	//cBloq:=POSICIONE('SC9',1,xFilial('SC9')+SC5->C5_NUM,'C9_BLEST')

	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))

	If SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM))

		While SC9->(!Eof()) .AND. SC9->C9_PEDIDO == SC5->C5_NUM

			If !Empty(SC9->C9_BLEST)
				//Alert('Entro')
				//MSGINFO( 'Producto: '+alltrim(C9_PRODUTO), "Bloqueado por Stock" )
				//lRet := .F.
				//exit
				//cPro=cPro + alltrim(C9_PRODUTO) + CRLF + 'Producto : '
				cPro=  cPro + 'Producto : ' + alltrim(C9_PRODUTO)  +" Bloqueo de Stock "+ CRLF
				//MSGINFO( 'Producto: '+ CRLF +cPro , "Bloqueado por Stock" )
			EndIf
			If !Empty(SC9->C9_BLCRED)
				//Alert('Entro')
				//MSGINFO( 'Producto: '+alltrim(C9_PRODUTO), "Bloqueado por Stock" )
				//lRet := .F.
				//exit
				//cPro=cPro + alltrim(C9_PRODUTO) + CRLF + 'Producto : '
				cPro=  cPro + 'Producto : ' + alltrim(C9_PRODUTO) +" Bloqueo de Crédito "+ CRLF// Nahim 10/06/2020
				//MSGINFO( 'Producto: '+ CRLF +cPro , "Bloqueado por Stock" )
			EndIf
			SC9->(DbSkip())
		EndDo
		IF !Empty(cPro)
			//MSGINFO( 'Producto: '+ cPro, "Bloqueado por Stock" )
			//MSGINFO( 'Producto: '+ cPro + CRLF +"Linea de abajo", "Bloqueado por Stock" )
			MSGINFO( cPro , "Productos bloqueados" ) // Nahim 10/06/2020
			lRet := .F.
			//exit
		ENDIF
	Endif


	//RestArea(aAreaC6)
	RestArea(aAreaC5)
	RestArea(aAreaC9)
	RestArea(aArea)

Return lRet








