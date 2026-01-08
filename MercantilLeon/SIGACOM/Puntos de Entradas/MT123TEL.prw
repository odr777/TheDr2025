#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   MT123TEL  ºAuthor ³Erick Etcheverry  	 º Date ³  31/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE - Manipulação do Cabeçalho do PO                	      º±±
±±º          ³Para adicionar novos campos					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ Bolivia/Mercantil Leon                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT123TEL
Local oDlg 		:= PARAMIXB[1]
Local aPosGet   := PARAMIXB[2]
Local aObj		:= PARAMIXB[3]
Local nOpcx     := PARAMIXB[4]
Local nReg      := PARAMIXB[5]
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

Public cGetOfrt	:= Space(TamSX3('C7_UOFERTA')[1])
Public cGetMObs	:= Space(TamSX3('C7_UOBSPC')[1])
Public cGetPlz	:= Space(TamSX3('C7_UPLZENT')[1])
Public cGetEnt	:= Space(TamSX3('C7_UCONENT')[1])

If nOpcx == 2 .OR. nOpcx == 4	//Visualizar o Modificar
	cGetOfrt	:= SC7->C7_UOFERTA
	cGetMObs	:= SC7->C7_UOBSPC
	/*cGetPlz 	:= SC7->C7_UPLZENT
	cGetEnt  	:= SC7->C7_UCONENT*/
else
	nMoedaPed:= 2
	cDescMoed := "DOLAR"
	nTxMoeda:= RecMoeda(dDataBase,nMoedaPed)
Endif

@ 107, aPosGet[2,1] SAY oTxtMObs PROMPT "Observ.: " SIZE 025, 006 OF oDlg COLORS 0, 16777215 PIXEL
@ 107, aPosGet[2,2] GET oMultiGe1 VAR cGetMObs OF oDlg MULTILINE SIZE 200, 015 COLORS 0, 16777215 HSCROLL PIXEL

@ 107, aPosGet[2,3] SAY oTxtOfrt PROMPT "Oferta.: " SIZE 30, 006 OF oDlg COLORS 0, 16777215 PIXEL
@ 107, aPosGet[2,4] MSGET oGetOfrt VAR cGetOfrt SIZE 100, 006 OF oDlg COLORS 0, 16777215 PIXEL

/*@ 125, aPosGet[2,1] SAY oTxtPlz PROMPT "Plazo Entrega" SIZE 030, 006 OF oDlg COLORS 0, 16777215 PIXEL
@ 125, aPosGet[2,2] MSGET oGetPlz VAR cGetPlz F3 "DBF" VALID DesTransp(@oTxtDTra, @cDescTran) SIZE 100, 006 OF oDlg COLORS 0, 16777215 PIXEL		
*/
/*@ 125, aPosGet[2,3] SAY oTxtOFat PROMPT "N° Fact.: " SIZE 30, 006 OF oDlg COLORS 0, 16777215 PIXEL
@ 125, aPosGet[2,4] MSGET oGetOfat VAR cGetFat SIZE 100, 006 OF oDlg COLORS 0, 16777215 PIXEL*/
/*
@ 125, aPosGet[2,3] SAY oTxtEnt PROMPT "Cond.Ent.: " SIZE 025, 006 OF oDlg COLORS 0, 16777215 PIXEL
@ 125, aPosGet[2,4] MSGET oGetEnt VAR cGetEnt  SIZE 100, 006 OF oDlg COLORS 0, 16777215 PIXEL		
*/
Return
