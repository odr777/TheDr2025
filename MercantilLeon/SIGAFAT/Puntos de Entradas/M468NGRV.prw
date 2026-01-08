#Include 'Protheus.ch'
#Include 'ParmType.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M468NGRV  ºAutor  ³Jorge Saavedra  ºFecha ³  19/05/2015     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada que se ejecuta al finalizar la Venta       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function M468NGRV()
Local aArea    := GetArea()

If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N" .OR. Alltrim(FunName()) == "MATA461"
	_cDoc:=SF2->F2_DOC
	_cSerieFac:=SF2->F2_SERIE 
	_cClient:=SF2->F2_CLIENTE  
	_cPedido:=SD2->D2_PEDIDO
	_nValFac:=SF2->F2_VALBRUT
	
	//Executando chamada automatica da Cobranzas Diverzas
	If GetNewPar("MV_UEXECOB",.T.) .AND.U_VerGrpUsr(GetNewPar("MV_UGRPCOB","000000|000000"))  
		IF MSGYESNO("Desea realizar el COBRO de la Factura: "+ Left(SF2->F2_SERIE,3) + " / " + SF2->F2_DOC)
			//IF (POSICIONE('SC5',1,XFILIAL('SC5')+_cPedido,'C5_DOCGER') <> '2')
			
                 
				//Somente para a 1a parcela encontrada	
				//Fina087A(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))
				U_Cobro()
		
			//Endif
		Endif
	Endif
	
	AtuPedFut()
	
	//U_FactQR()
	U_FacturaMCL(_cDoc,_cDoc,_cSerieFac,_cClient)
End
RestArea(aArea)	
Return



Static Function AtuPedFut
Local nPosNum := 0
Local cNumPed := ""
Local aSC5Ped := {}
local aArea := SF2->(GetArea())
Local nQEntr := 0

If Type("aEntFut")=="A"
	for nQEntr := 1 to len(aEntFut)
		aSC5Ped := aClone(aEntFut[nQEntr][1])	//Cabecera Pedido [1]								
		nPosNum	:= aScan(aSC5Ped,{|x| AllTrim(x[1])=="C5_NUM" })
		cNumPed := aSC5Ped[nPosNum,2]
		SF2->(dbgotop())// 
		SF2->(DbSetOrder(1))               
		SF2->(DBSEEK(XFILIAL("SF2") + aEntFut[nQEntr,3] + aEntFut[nQEntr,4])) // F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
		RecLock("SF2",.F.)
		Replace F2_PEDPEND   With  cNumPed
		MsUnLock()
				
		DbSelectArea("SC6")
		dbSetOrder(1)
		MsSeek(xFilial()+cNumPed)
		//Tenho Que garantir a gravacao deste campo com "N" pois o campo pode nao
		//estar em uso e eh preciso que esteja gravado com "N" pois este pedido nao pode ser fatuurado.
		While !Eof() .And. C6_FILIAL == xFilial() .And. C6_NUM == cNumPed
			RecLock("SC6",.F.)
			Replace C6_GERANF	With	"N"
			MsUnLock()
			DbSkip()
		Enddo
	next nQEntr
	aEntFut := NIL
	FreeObj(aEntFut)
Endif
restArea(aArea)
Return
