#Include 'Protheus.ch'
#Include 'Parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA088CAN  ºAutor ³EDUAR ANDIA 	º Data ³  18/08/2019      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
A±ºDesc.     ³PUNTO DE ENTRADA que valida cada salto de pantalla en		  º±±
±±º           cobros diversos FINA087A      							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\ Unión Agronegocios S.A.							  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA088CAN
Local lAtuSEY := .F.
Local nReg 	  := TRB->(RECNO())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Recno SYE   		³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	lAtuSEY := VeriAtuSEY(TRB->SERIE,TRB->NUMERO)
	If !lAtuSEY		
		If !Empty(SEL->EL_BANCO)
			AtuSEY(TRB->SERIE,TRB->NUMERO)
		Endif
	Endif
Return


Static Function AtuSEY(cSerie,cRecibo)
Local aArea	:=GetArea() 
Local cRecComp, cSerComp
Local lRet 	:= .F.

dbSelectArea("SEL")   
DbSetOrder(8)
DbSeek(xFilial("SEL")+cSerie+cRecibo)
If !Empty(SEL->EL_COBRAD)
	
	DbSelectArea("SAQ")
	DbSetOrder(1)
	If dbSeek(xFilial("SAQ")+SEL->EL_COBRAD) 
		cTipo:=AQ_TIPOREC
		cSerComp:= cSerie
		cRecComp:= cRecibo
		
		If SAQ->AQ_TIPOREC=="3"
			cRecComp:= Iif(SAQ->AQ_TIPOREC =="1",cRecibo,SEL->EL_RECPROV)
		Endif
		
		DbSelectArea("SEY")
		DbSetOrder(1)
		If dbSeek(xFilial("SEY")+SEL->EL_COBRAD)
			While !EOF() .and. SEL->EL_COBRAD == SEY->EY_COBRAD 	
				If  /*cTipo == SEY->EY_TIPOREC .and. */ cRecComp  >= SEY->EY_RECINI .and. cRecComp <= SEY->EY_RECFIN .and. cSerComp == SEY->EY_SERIE  
					RecLock("SEY",.F.)
	   		 		SEY->EY_RECPEND :=SEY->EY_RECPEND +1
	   		 		If SEY->EY_STATUS == "2"
	   		        	//MsgStop(OemToAnsi(STR0055)+ SEY->EY_TALAO + OemToAnsi(STR0056) + SEY->EY_COBRAD + OemToAnsi(STR0057)) //"O talao numero : "###" do cobrador numero :"###"  estava encerrado e apartir deste momento sera reaberto "
	   		        	SEY->EY_STATUS	:= "1"
	   		 	   	EndIf
	   		 	   	
	   		 	   	MsUnlock()
					Exit
				EndIf	
     			DbSkip()
			Enddo
		EndIf
	EndIf
EndIf   
RestArea(aArea)
Return(lRet)


Static Function VeriAtuSEY(cSerie,cRecibo)
Local aArea	:=GetArea() 
Local cRecComp, cSerComp
Local lRet 	:= .F.

dbSelectArea("SEL")   
DbSetOrder(8)
DbSeek(xFilial("SEL")+cSerie+cRecibo)
If !Empty(SEL->EL_COBRAD)
	DbSelectArea("SAQ")
	DbSetOrder(1)
	If dbSeek(xFilial("SAQ")+SEL->EL_COBRAD) 
		cTipo:=AQ_TIPOREC   
		cSerComp:= cSerie
		cRecComp:= cRecibo
		DbSelectArea("SEY")
		DbSetOrder(1)
		If dbSeek(xFilial("SEY")+SEL->EL_COBRAD)
			While !EOF() .and. SEL->EL_COBRAD == SEY->EY_COBRAD 	
				If  cTipo == SEY->EY_TIPOREC .and. cRecComp  >= SEY->EY_RECINI .and. cRecComp <= SEY->EY_RECFIN .and. cSerComp == SEY->EY_SERIE  
					lRet := .T.
					Exit
				EndIf	
     			DbSkip()
			Enddo
		EndIf
	EndIf
EndIf   
RestArea(aArea)
Return(lRet)
