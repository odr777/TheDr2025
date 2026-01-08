#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INIDESCTA ºAutor  ³EDUAR ANDIA         º Data ³  21/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Descripcão das contas contáveis nos asentos                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IniDesCta(cCampo)
Local aArea 	:= GetArea()
Local cCtaDeb	:= ""
Local cCtaCrd	:= ""
Local cDesc		:= ""                               
Local lIncluir	:= If(Type("Inclui")== "L", Inclui,.T.)
//Default cCampo	:= AllTrim(SubStr(ReadVar(),6,20))

If !lIncluir.OR. IsInCallStack("ctbanfe")	;	//
	 		.OR. IsInCallStack("ctbanfs") 	;	//
	 		.OR. IsInCallStack("fina370") 	;	// Contable Off Line (Financiero)
	 		.OR. IsInCallStack("fina371")		// Off Line op/Recib (Financiero)
	
	Do Case 
		Case cCampo == "CT2_UCTADB"
		    If AllTrim(FUNNAME()) $ "CTBA355|FINA370|CTBANFE|CTBANFS|FINA371"
		    	cCtaDeb	:= TMP->CT2_DEBITO
		    Endif
		    If AllTrim(FUNNAME()) $ "CTBA101|CTBC010|CTBA102"
		    	cCtaDeb	:= CT2->CT2_DEBITO
		    Endif

		    If !Empty(cCtaDeb)
		    	//cDesc := Posicione("CT1",1,xFilial("CT1")+cCtaDeb,"CT1_DESC01")
		    	cDesc := GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+cCtaDeb,1,"")
		    Else
		    	cDesc := ""
		    Endif
			
		Case cCampo == "CT2_UCTACD"
			If AllTrim(FUNNAME()) $ "CTBA355|FINA370|CTBANFE|FINA371" 	//Asto.Contab.Auto.|Verif.Asiento		    	
		    	cCtaCrd	:= TMP->CT2_CREDIT
		    Endif
		    If AllTrim(FUNNAME()) $ "CTBA101|CTBA102"	//Asientos Contables
		    	cCtaCrd	:= CT2->CT2_CREDIT
		    Endif
		    
		    If !Empty(cCtaCrd)
		    	cDesc := GetAdvFVal("CT1","CT1_DESC01",xFilial("CT1")+cCtaCrd,1,"")//  Posicione("CT1",1,xFilial("CT1")+cCtaCrd,"CT1_DESC01")	
		    Endif
	End Case
Endif

RestArea(aArea)
Return(cDesc)