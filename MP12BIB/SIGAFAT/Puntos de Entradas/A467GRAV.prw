#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A467GRAV  ºAutor  ³TdeP ºFecha ³  12/09/2017     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada que se ejecuta  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function A467GRAV()
Local aArea    := GetArea()

If  Alltrim(FunName()) == "MATA467N"  .OR. Alltrim(FunName()) == "MATA461"
	_cDoc:=SF2->F2_DOC
	_cSerieFac:=SF2->F2_SERIE   
	_cPedido:=SD2->D2_PEDIDO
	_nValFac:=SF2->F2_VALBRUT
	cCond:=SF2->F2_COND
	//Executando chamada automatica da Cobranzas Diverzas
	If GetNewPar("MV_UEXECOB",.T.) .AND.U_VerGrpUsr(GetNewPar("MV_UGRPCOB","000000|000000"))  
		IF MSGYESNO("Desea realizar el COBRO de la Factura: "+ Left(SF2->F2_SERIE,3) + " / " + SF2->F2_DOC)
			//IF (POSICIONE('SC5',1,XFILIAL('SC5')+_cPedido,'C5_DOCGER') <> '2')
			
                 
				//Somente para a 1a parcela encontrada	
				//Fina087A(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))
				U_Cobro()
		//Endif
		eND
	END
	//U_FactQR()
/*	If (AllTrim(SM0->M0_CODFIL) $ "0100|0101|0150")
		If !(cCond == "002")
			U_GFATI301(_cDoc,_cDoc,_cSerieFac,1)
		Else
			U_GFATI3MP(_cDoc,_cDoc,_cSerieFac)
		EndIf
	Else
		U_GFATI3MP(_cDoc,_cDoc,_cSerieFac)
	EndIf */
/*
	If (Left(SF2->F2_SERIE,3) $ GETMV("MV_UfACTTC"))
		U_GFATI301(_cDoc,_cDoc,_cSerieFac,1)
	Else
		U_GFATI3MP(_cDoc,_cDoc,_cSerieFac)
	EndIf
**/
End
RestArea(aArea)	
return