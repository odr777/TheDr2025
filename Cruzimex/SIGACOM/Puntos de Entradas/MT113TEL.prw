#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   MT113TEL  ºAuthor ³Erick Etcheverry  	 º Date ³  31/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE - Manipulação do Cabeçalho do PO                	      º±±
±±º          ³Para adicionar novos campos					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ Bolivia/Mercantil Leon                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT113TEL
Local oDlg 		:= PARAMIXB[1]
Local aPosGet   := PARAMIXB[2]
Local nOpcx     := PARAMIXB[3]
Local nReg      := PARAMIXB[4]
Local oTxtEnt
Local oGetEnt
Local oTxtOFat
Local oGetOfat
Local oTxtMObs
Local oGetMObs
Local oGetPlz
Local oTxtPlz
Local oMultiGe1
Local oTxtOfrt
Local oGetOfrt


If nOpcx == 2 .OR. nOpcx == 4	//Visualizar o Modificar
	/*cGetOfrt	:= SC7->C7_UOFERTA
	cGetMObs	:= SC7->C7_UOBSPC*/
	/*cGetPlz 	:= SC7->C7_UPLZENT
	cGetEnt  	:= SC7->C7_UCONENT*/
else

    cCodCompr := "001"
    cDescComp := Posicione("SY1",1,xFilial("SY1")+cCodCompr ,"Y1_NOME")

    cCodLocEn := "01"
    cDesLocEn := Posicione("DB4",1,xFilial("DB4")+cCodLocEn,"DB4_DESC")

	nMoedaSI:= 2
	cDescMoed := "DOLAR"

Endif

Return
