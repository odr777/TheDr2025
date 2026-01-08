#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A085ATIT  ºAutor  ³Jorge Saavedraº Data ³ 13/04/2015		 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada  despues de la Grabación de la Orden de Pago º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA		                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A085ATIT()
//Local nPos := aScan( aNOrd , cOrdPago )
Local _lPA:=.F.
Local aArea   := GetArea()
Private _lSai:=.F.   

/*If nPos == 0
	aadd( aOrd , "" )
	aadd( aNOrd , cOrdPago )
	nPos := Len(aOrd)
EndIf
aOrd[nPos] += IIf(Empty(aOrd[nPos]),""," - ") +Alltrim(SE2->E2_HIST)
*/

i := 0
nOpca := 0
cRot := UPPER(AllTrim(ProcName(i)))

//While !Empty(cRot)
    If alltrim(SEK->EK_TIPODOC) $ "PA"  
       _lPA:=.T.
	//	Exit
	//Else
		//i := i + 1
	//	cRot := UPPER(AllTrim(ProcName(i)))
	Endif
//EndDo

If _lPA

			DEFINE MSDIALOG oDlgVCan FROM 05,10 TO 170,270 TITLE "Orden de Pago" PIXEL 
			cPC := Space(Len(SE2->E2_UPC))
		
			@03,04 TO 62,128 LABEL "Numero de Pedido de Compra" OF oDlgVcan PIXEL
			@15,08 MsGet cPC PICTURE "@!" Size C(050),C(009) VALID .T.  COLOR CLR_BLACK PIXEL OF oDlgVcan
			 
		
			DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan
		
			ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela()

            If nOpca == 1
            	
               RecLock('SE2',.F.)
               SE2->E2_UPC := cPC
               SE2->(MsUnlock())
            
            	 RecLock('SEK',.F.)
               SEK->EK_UPC := cPC
               SEK->(MsUnlock())
   	  	         
            End

EndIf		        
RestArea( aArea )
Return


Static Function Cancela(_cPC)
    If Empty(alltrim(_cPC))
      IF  MSGBOX("Desea Asociar el Anticipo a un Pedido de Compras?","Información","YESNO"	)
			_lSai := .F.
		else
			_lSai := .T.
		end
    Else   
       _lSai := .T.   
    endif
Return(_lSai )


