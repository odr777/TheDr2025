#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LOCXPE11  ºAutor  ³Jorge Cardona,		   º Data ³  26/09/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ actualiza el campo cc que viene de la tabla sd1  		  º±±
±±º          ³ 				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXPE11

	Local _aArea	:= GetArea()
	Local aAreaSF1	:= SF1->( GetArea() ) 
	Local aAreaSE2	:= SE2->( GetArea() ) 
	//Local _NomArq	:= SF1->F1_YARQCOM
	Local _Hist		:= ""
	Local cBusq		:= ""
	
	If Alltrim(Funname()) == 'MATA101N' .OR. Alltrim(Funname()) =='MATA143'	//Alltrim(Funname()) <> 'MATA462TN'
	
		cBusq := xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		
		dbSelectArea("SD1")
		DbSetOrder(1)
		dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		While xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == cBusq
		
			iF SD1->D1_RATEIO == "2"
				_cCc	:= SD1->D1_CC
			Else
				_cCc := Posicione("SDE",1,XFILIAL("SDE")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"DE_CC")
			EndIf
			
			If alltrim(_cCc) <> ""
				Exit
			EndIf
			dbSkip()
		End
		
		//aviso("cc"+_cCc)
		
		//_Hist := SE2->E2_HIST
		_Hist := SUBSTR(SF1->F1_XOBS,1,40)
		
		cCond := Posicione("SE4",1,XFILIAL("SE4")+SF1->F1_COND,"E4_TIPO")
		
		If cCond <> "1"
			cParcela := "01"
			
			dbSelectArea("SE2")
			DbSetOrder(1)
			If dbSeek(xFilial("SD1")+SF1->F1_SERIE+SF1->F1_DOC+cParcela+"NF "+SF1->F1_FORNECE+SF1->F1_LOJA)
			
				While dbSeek(xFilial("SD1")+SF1->F1_SERIE+SF1->F1_DOC+cParcela+"NF "+SF1->F1_FORNECE+SF1->F1_LOJA) == .T.
				
					If Alltrim(Funname()) == 'MATA101N'.OR. Alltrim(Funname()) =='MATA143'		// facturas de entrada y despachos (importacion)
						//alert(SE2->E2_NUM)
						If alltrim(SE2->E2_NUM) <> ""
							SE2->( RecLock("SE2",.F.) )
							SE2->E2_HIST	:= _Hist
							SE2->E2_CCUSTO	:= _cCc
							SE2->( MsUnLock() )
						EndIf
					EndIf
					
					cParcela := STRZERO(val(cParcela)+1,2,0) 
					
					dbSkip()
				End
				
			EndIf
		Else 
			cParcela := " "
			
			If Alltrim(Funname()) == 'MATA101N' .OR. Alltrim(Funname()) =='MATA143'			// facturas de entrada
				//alert(SE2->E2_NUM)
				If alltrim(SE2->E2_NUM) <> ""
					SE2->( RecLock("SE2",.F.) )
						SE2->E2_HIST	:= _Hist
						SE2->E2_CCUSTO	:= _cCc
					SE2->( MsUnLock() )
				EndIf
			EndIf
					
		EndIf
	EndIf	
	
	
	//Edson 21.01.2020
	If Alltrim(Funname()) == 'MATA465N'
		//U_NOTAUNION(SF1->F1_DOC,SF1->F1_DOC,SF1->F1_SERIE,1,"ORIGINAL")
		u_imprNcc()	// función está en MT462MNU
	end if
		
	RestArea(_aArea)
	RestArea( aAreaSF1 )
	RestArea( aAreaSE2 )

Return
