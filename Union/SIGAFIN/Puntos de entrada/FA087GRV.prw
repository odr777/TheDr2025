#INCLUDE "Protheus.ch"
#INCLUDE "Parmtype.ch"
#INCLUDE "RWMAKE.ch"

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA087GRV  บAutor ณTdeP Horeb SRL บ Data ณ  21/12/2019      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
AฑบDesc.     ณPUNTO DE ENTRADA que valida cada salto de pantalla en		  บฑฑ
ฑฑบ           cobros diversos FINA087A      							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP12BIB -BELEN											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FA087GRV()
	cCondiPago := NIL
	FreeObj(cCondiPago)	
	lDesdFact := nil
	FreeObj(lDesdFact)
		
	If GetRemoteType() < 0 // nahim Terrazas toma en cuenta solo si no es un web services
		return .T.
	endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza Recno SYE   		ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nRecnoSEY==0
		nRecnoSEY := PesqRecSEY()
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Glosa en Anticipo (RA)   	ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If AllTrim(SE1->E1_TIPO) == "RA"
		HistRA()
	Endif	
	
Return .T.


Static Function PesqRecSEY()
Local aArea		:= GetArea()       
Local nRet		:= 0
Local lValSer	:= SuperGetMv('MV_SERREC') // Usando serie nos recibos 

If !Empty(cCobrador)
	DbSelectArea("SAQ")
	DbSetOrder(1)
	If dbSeek(xFilial("SAQ")+cCobrador) 
		nRecnoSAQ:=Recno()
		If SAQ->AQ_TIPOREC=="3"
			cRecComp:= Iif(SAQ->AQ_TIPOREC =="1",cRecibo,cRecProv)
			cTipo 	:= SAQ->AQ_TIPOREC // Valida Tipo do Recibo do Cobrador  
			
			DbSelectArea("SEY")
			DbSetOrder(1)
			If dbSeek(xFilial("SEY")+cCobrador)      
				//So validar a serie quando ้ um recibo definitivo, provisorio nao tem serie
				While !EOF() .and. cCobrador == SEY->EY_COBRAD 	
					If SEY->EY_STATUS<>"2" .and. /*cTipo == SEY->EY_TIPOREC .and.*/ ;
						cRecComp  >= SEY->EY_RECINI .and. cRecComp <= SEY->EY_RECFIN .and.;
						If(lValser, cSerie== SEY->EY_SERIE .Or. Empty(SEY->EY_SERIE),.T.)
						nRet:= SEY->(Recno())
						Exit
					EndIf
					DbSkip()
				Enddo
		   EndIf
		EndIf	
	EndIf
EndIf	
RestArea(aArea)
Return(nRet)

Static Function HistRA
Local cObs := ""

If(AllTrim(SE1->E1_TIPO) == "RA")
		DEFINE MSDIALOG oDlgVCan FROM 05,10 TO 170,270 TITLE "Cobranza" PIXEL
		cObs := Space(Len(SE1->E1_HIST))

		@03,04 TO 62,128 LABEL "Glosa" OF oDlgVcan PIXEL
		@12,08 GET cObs PICTURE "@!" SIZE C(090),C(009) VALID .T. Object oGt

		DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan

		ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela(cObs)

		If nOpca == 1
			RecLock("SE1",.F.)
			SE1->E1_HIST := cObs
			SE1->(MsUnlock())
		EndIf
EndIf

Static Function Cancela(cObs)
Local _lSai := .F.

If Empty(cObs)
	MSGBOX("Se debe informar la Glosa.","ALERT")
Else
	_lSai := .T.
	oDlgVCan:End()
Endif
Return(_lSai)
