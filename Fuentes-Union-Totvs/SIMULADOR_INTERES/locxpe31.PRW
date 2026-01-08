#INCLUDE "PROTHEUS.CH"
//Array aPosicionou
#Define lSF4 		1
#Define lSB1 		2
#Define lSAx 		3
#Define lSC5 		4
#Define lSC6 		5
#Define lSC9		6
#Define lSC7		7
#Define lSD2		8
#Define lSD1		9
#Define nRecSD2	10
#Define nRecSD1	11
#Define nRecSF1	12
#Define lSF1		13
#Define lDAK		14
#Define nMaxPos 	14
//Array aCfgNf
#Define SnTipo      1
#Define ScCliFor    2
#Define SlFormProp  3
#Define SAliasHead  4
#Define SAliasCols  5
#Define ScOpEstoq   6
#Define ScAliasFin  7
#Define ScEspecie   8
#Define ScOpFin     9
#Define ScTipoDoc  10
#Define SaAtualiza 11
#Define SaLancPadC 12
#Define SaLancPadI 13
#Define SaBotoes   14
#Define SaTeclas   15
#Define SaPergs    16
#Define SaPE	   17
#Define SlRemito   18
#Define ScDescri   19
#Define ScDescGer  20
#Define SlPedido   21
#Define SbF12	   22
#Define SaCposGD   23
#Define SlConFrDp  24
#Define ScFilRot   25
#Define SaCposBr   26
#Define SaLancPCO  27
#Define SnMaxCfg   27

/*
LOCXPE31 - Punto de entrada para mostrar y elegir serie de comprobante manual de ventas


*/

User Function LOCXPE31(oDlgPae,lLocxAuto,aAutoCab,lNumNCC,lTransf)

Local nTimes
Local aSerNF 	:= {}
Local nTamNota	:= TamSX3("F1_DOC")[1]
Local nTamSerie	:= TamSX3("F1_SERIE")[1]
Local oDlg,cCadastro := OemToAnsi("Nr de Fatura"),cVarQ:="  ",oQual    //
Local nOpcA 	:= 0, lDone := .F.
Local lAbandona := .F., lInterno := .T.
Local lSeqEspecie := SuperGetMV("MV_SEQESPE",,.F.)
Local nCntErro  := 0
Local nTimeOut	:=	GetMv("MV_NOTAOUT")
Local nPosNum   := 0
Local nPosSer   := 0
Local cLabelSer := OemToAnsi("Serie Factura")  //
Local cLabelDoc := OemToAnsi("NR de Factura")  //
Local cPrefC    := ""
Local cChaveSX5 := xFilial("SX5")+IIf(lSeqEspecie,"AC","01")
Local cSerieChave := ""
Local cSerieSX5 := ""
Local aRet      := {}
Local nPosIni   := 0
Local cCombo    := ""
Local cFilSFP	:= xFilial("SFP")
Local lD1             := ( Ascan( aHeader, { |x| Left( x[2], 3 ) == 'D1_' } ) <> 0 )
Local cSerieCli:= "   "
Local cTexto:= ""

PRIVATE lSX5Troca := .F.

//Se lNumNCC = .T. indica que foi chamado da rotina para geracao de Nota de Credito no cancelamento da NF - Loc. Guatemala
DEFAULT lNumNCC  := .F.

// Parametro utilizado para tranferencia de material
DEFAULT lTransf := .F.



cPrefC := IIf(lTransf,"",PrefixoCpo(aCfgNF[SAliasHead]))

If lNumNCC
   cLabelSer  := OemToAnsi("Serie Nota de Credito")  //"Serie Nota de Credito"
   cLabelDoc  := OemToAnsi("Num. Nota de Credito")  //"Num. Nota de Credito"
   cCadastro  := OemToAnsi("Num. Nota de Credito")  //"Num. Nota de Credito"
EndIf

vNumero   := ""
cFiltro   := ""
cEspecDoc := IIf(lTransf,"",aCfgNf[ScEspecie])

Do Case
	
	Case SA1->A1_TIPO == 'E'
		cSerieCli := 'E'
		
	Case SA1->A1_TIPO $ "I-N"
		cSerieCli := 'A'
		
	Otherwise
		cSerieCli := 'B'
		
EndCase
If Substr(cEspecDoc,1,1) =='R'
	cSerieCli := 'R'
EndIf



// Busca pos. da descricao da especie da nota no combo da tabela SFP (1=NF;2=NCI;3=NDI;4=NCC;5=NDC)
SX3->(dbSetOrder(2))
SX3->(MsSeek("FP_ESPECIE"))
nPosIni := At(AllTrim(cEspecDoc),AllTrim(SX3->X3_CBOX))
cCombo := Substr(AllTrim(SX3->X3_CBOX),nPosIni-2,1)

iF cEspecDoc == "RCD"
cCombo := "6"
Endif

iF cEspecDoc == "RTS"
cCombo := "6"
ENDiF

cPe	:=	LocxPE(32)
If !Empty(cPe)
	cFiltro := ExecBlock(cPe,.F.,.F.,{cFiltro})
EndIf
aSerNF := {}
// Leandro Prado - 24/02/2014 - Controle de Ponto de Venda p/ Argentina.
If (cPaisLoc =="ARG") .And. ( cFunName $ "MATA465N|MATA466N|MATA467N|MATA468N|MATA101N|MATA462N|MATA462DN|MATA462TN|MATA102DN")
	("SFP")->(DbSetOrder(9))
	If ("SFP")->(MsSeek(xFilial("SFP")+cLocxNFPV))
		While (SFP->(!EOF())) .And. (SFP->FP_PV = cLocxNFPV) 
		    If AllTrim(SFP->FP_ESPECIE) == AllTrim(cCombo) .AND. Left(SFP->FP_SERIE,1) $ cSerieCli
			   cFiltro += "'" + AllTrim(SFP->FP_SERIE) + cIdPVArg + "|'"
			ENDIF
			SFP->( DBSkip() )
		EndDo
	EndIf
EndIf
dbSelectArea("SX5")
dbSetOrder(1)
DbSeek( cChaveSX5 )
If (Type("lLocxAuto") == "U" .OR. !lLocxAuto)
    While !Eof() .AND. X5_FILIAL+X5_TABELA == cChaveSX5
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Filtrar as Serie a serem mostradas �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If ! Empty(cFiltro)
	       cSerieChave  := IIf(lSeqEspecie,SX5->X5_CHAVE,Substr(SX5->X5_CHAVE,1,nTamSerie))
	       cSerieChave  := IIf(cPaisLoc = "ARG",AllTrim(X5_CHAVE),cSerieChave)
	       cSerieSX5    := IIf(lSeqEspecie,Substr(X5_CHAVE,4,nTamSerie),Padr(X5_CHAVE,nTamSerie))
	       cSerieSX5    := IIf(cPaisLoc = "ARG",RetSERNF(X5_CHAVE),cSerieSX5)
	       If cSerieChave $ cFiltro
	       	If ((cPaisLoc = "ARG") .And. (Len(cSerieChave) > 3)) .Or. (cPaisLoc <> "ARG")
			    	AADD( aSerNF,{ cSerieSX5, LocConvNota(X5Descri(),nTamNota) } )
			    EndIF
           EndIf
        EndIf
		dbSkip()
	End
	If (Len(aSerNF) == 0) .OR. lAbandona
	    cTexto:="No tiene configurado correctamente la serie en tabla Series vs Control de formularios."+CHR(13)
	    cTexto+="Debe configurar la tabla SX5 (tabla 01 -series), SFP(Control de formularios) y CFH (Punto de venta)"+CHR(13)
		MSGINFO(cTexto,"LOCXPE31")
		Return({Space(4), Space(8), Space(3) }  )
	Endif

	If Len(aSerNF) > 1
		DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO 264,378 OF oDlgPae	PIXEL
		@ .5,.80 LISTBOX oQual VAR cVarQ Fields HEADER "Serie","Nro comprobante" SIZE 180,100 ON DBLCLICK (aSerNF:=aSX5Troca(oQual:nAt,aSerNF,nTimeOut),oQual:Refresh()) NOSCROLL  //"Serie Factura"###"NR de Factura"
		oQual:SetArray(aSerNF)
		oQual:bLine := { || {aSerNf[oQual:nAT,1],aSerNf[oQual:nAT,2]}}
		DEFINE SBUTTON FROM 120,130  TYPE 1 ACTION (nOpca := 1,cNumero:=aSerNf[oQual:nAt,2],cSerie:=aSerNf[oQual:nAt,1],oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 120,160 TYPE 2 ACTION (nOpcA := 3,oDlg:End()) ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg
	Else
		cNumero := aSerNf[1,2]
		cSerie  := aSerNf[1,1]
		nOpcA   := 1
	EndIf
	IF (nOpcA != 1)
		Return ( {Space(4), Space(8), Space(3) } )
	Endif
	If !lSX5Troca
		vNumero := cNumero
	Endif

Else
    nPosNum  := Ascan(aAutoCab, { |x| Upper(AllTrim(x[1]))==cPrefC+"_DOC"   })
    nPosSer  := Ascan(aAutoCab, { |x| Upper(AllTrim(x[1]))==cPrefC+"_SERIE" })

	If nPosNum > 0
		cNumero := aAutoCab[nPosNum][2]
	Else
		cNumero := Space(nTamNota)
	Endif
	If nPosSer > 0
		cSerie	:= aAutoCab[nPosSer][2]
	Else
		cSerie	:= Space(nTamSerie)
	Endif
Endif

cSerieSX5  := IIf(lSeqEspecie,cEspecDoc+cSerie,cSerie)
If DbSeek( cChaveSX5+cSerieSX5,.F. )
	If (Type("lLocxAuto") <> "U" .AND. lLocxAuto)
		cNumero := IIf(Empty(cNumero),X5Descri(),cNumero)
		//Caso o numero do documento nao tenha sido enviado no array do cabecalho
		If nPosNum == 0
		   AADD(aAutoCab,{IIf(lTransf,"F2",PrefixoCpo(aCfgNF[SAliasHead]))+"_DOC", cNumero, NIL})
		EndIf
	Endif
	cNumero := LocConvNota(cNumero,nTamNota)
	nTimes := 0

	If !InTransact()
		While !MsRLock() .AND. nTimes < 10
			nTimes++
			Inkey(.1)
			DbSeek( cChaveSX5+cSerieSX5,.F. )
		EndDo
	EndIf

	IF RecLock("SX5",.F.)
		Replace X5_DESCRI  With cNumero
		Replace X5_DESCENG With cNumero
		Replace X5_DESCSPA With cNumero
		MsUnlock()
	Else
		Return( {Space(4), Space(8), Space(3) } )
	Endif
Else
	If !InTransact()
		SX5->(MsRUnLock())
	EndIf
	Return( {Space(4), Space(8), Space(3) }  )
EndIf

If !lTransf .AND. lGerarCFD
	// Busca pos. da descricao da especie da nota no combo da tabela SFP (1=NF;2=NCI;3=NDI;4=NCC;5=NDC)
	SX3->(dbSetOrder(2))
	SX3->(MsSeek("FP_ESPECIE"))
	nPosIni := At(AllTrim(cEspecie),AllTrim(SX3->X3_CBOX))
	cCombo := Substr(AllTrim(SX3->X3_CBOX),nPosIni-2,1)

	// Verifica se a nota selecionada esta dentro de algum range cadastrado
	// Necessario em caso de existir mais de um range com a mesma serie
	SFP->(DbSeek(cFilSFP + cFilAnt + cSerie))
	While SFP->FP_FILIAL+SFP->FP_FILUSO+SFP->FP_SERIE == cFilSFP+cFilAnt+cSerie
		If AllTrim(SFP->FP_ESPECIE) == AllTrim(cCombo)
			If Val(cNumero) >= Val(SFP->FP_NUMINI) .AND. Val(cNumero) <= Val(SFP->FP_NUMFIM)
				Exit
			Endif
		EndIf
		SFP->(dbSkip())
	EndDo
	aRet := {Left(cNumero,4), Right(cNumero,8), cSerie, SFP->FP_CAI, SFP->FP_NRCERT}
Else
	aRet := {Left(cNumero,4), Right(cNumero,8), cSerie }
Endif

Return( aRet )
