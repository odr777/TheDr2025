#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³MT110TEL  ºAuthor ³EDUAR ANDIA      	 º Date ³  31/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE - Manipulação do Cabeçalho do Pedido de Compras 	      º±±
±±º          ³Para adicionar novos campos					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ Bolivia/Mercantil Leon                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120TEL
	Local oDlg 		:= PARAMIXB[1]
	Local aPosGet   := PARAMIXB[2]
	Local aObj		:= PARAMIXB[3]
	Local nOpcx     := PARAMIXB[4]
	Local nReg      := PARAMIXB[5]
	Local oTxtEnt
	Local oGetEnt

	Local oTxtOfrt
	Local oGetOfrt
	Local oTxtMObs
	Local oGetMObs
	Local oMultiGe1
	local ohora
	local chora


/*Public cGetEnt	:= Space(TamSX3('C7_UCONENT')[1])
Public cGetPlz	:= Space(TamSX3('C7_UPLZENT')[1])*/
Public cGetOfrt	:= Space(TamSX3('C7_UOFERTA')[1])
Public cGetMObs	:= Space(TamSX3('C7_UOBSPC')[1])

	If nOpcx == 2 .OR. nOpcx == 4	//Visualizar o Modificar
	/*cGetEnt  	:= SC7->C7_UCONENT
	cGetPlz 	:= SC7->C7_UPLZENT*/
	cGetOfrt	:= SC7->C7_UOFERTA
	cGetMObs	:= SC7->C7_UOBSPC
	cHora		:= SC7->C7_XHORA
	Endif

	IF nOpcx == 3 // si es inclusion
		oDlg:aControls[15]:bWhen:= {||lDescCusto(@oDlg)}  //naturaleza 15
	EndIf

@ 073, aPosGet[2,1] SAY oTxtOfrt PROMPT "Oferta Prov.: " SIZE 30, 006 OF oDlg COLORS 0, 16777215 PIXEL
//@ 043, aPosGet[2,6]-25 MSGET oGetOfrt VAR cGetOfrt SIZE 100, 006 OF oDlg COLORS 0, 16777215 PIXEL
@ 073, aPosGet[2,2] MSGET oGetOfrt VAR cGetOfrt SIZE 100, 006 OF oDlg COLORS 0, 16777215 PIXEL

@ 088, aPosGet[2,1] SAY oTxtMObs PROMPT "Observ.: " SIZE 025, 006 OF oDlg COLORS 0, 16777215 PIXEL
//@ 054, aPosGet[2,2] MSGET oGetMObs VAR cGetMObs SIZE 100, 006 OF oDlg COLORS 0, 16777215 PIXEL	
@ 088, aPosGet[2,2] GET oMultiGe1 VAR cGetMObs OF oDlg MULTILINE SIZE 200, 018 COLORS 0, 16777215 HSCROLL PIXEL


@ 073,aPosGet[1,3] SAY   "Hora" OF oDlg PIXEL SIZE 030,006               // "Taxa da Moeda"
@ 073,aPosGet[1,4] GET ohora VAR cHora OF oDlg SIZE 25,06 PIXEL;
WHEN  .f.

Return


Static Function DesTransp(oTxtDTra)
Local lRet	:= .T.
	If !Empty(cGetTran)
	cDescTran	:= Posicione("DBF",1,xFilial("DBF")+cGetTran,"DBF_DESCR")
	Endif
oTxtDTra:Refresh()
Return(lRet)

//Funcion para disparar al msget customizado arriba ->disparador
STATIC Function lDescCusto(oDlgo)//cCondicao,oDescCusto,cDescCusto,oGetDados)
	
		
		cA120Num := u_CORSPCS()
        //cA120Num := cxNum //GETNUMSC7()
        oDlgo:aControls[3]:CTEXT := cA120Num
        M->C7_NUM := cA120Num
		oDlgo:Refresh()
	

Return .T.


