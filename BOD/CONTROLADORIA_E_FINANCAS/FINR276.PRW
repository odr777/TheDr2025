#INCLUDE "FINR276.ch"
#Include "PROTHEUS.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR276  ³ Autor ³  Ana Paula        	³ Data ³ 02.07.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informativo de IDE - México                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  DATA    ³ BOPS ³                 				                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Luis Enríquez ³ 21.12.2061 ³ SERINN001-327 ³Se realizó merge para agre-³±±
±±³              ³            ³               ³gar cambios de ctree       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Oscar Garcia³21/05/18³DMINA2802³ Se elimina variable cDbfTmpque no se  ³±±
±±³            ³        ³         ³ utilizaba                             ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros:                                        	³
//³ mv_par01             // Data Inicial ?             	³
//³ mv_par02             // Data Final ?               	³
//³ mv_par03             // De Filial     ?           	³
//³ mv_par04             // Ate Filial  ?              	³
//³ mv_par05             // Banco?        				³
//³ mv_par06             // Qual Moedas     			³
//³ mv_par07             // Outras Moedas?   			³
//³ mv_par08             // valor minimo de IDE      	³
//³ mv_par09             // taxa de IDE					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Function FINR276()

Local cCabec1   := Space( 0 )
Local cCabec2   := Space( 0 )
Local cDesc1    := Space( 0 )
Local cDesc2    := Space( 0 )
Local cDesc3    := Space( 0 )
//Local nLimite   := 220
Local aOrdem    := {}
Local lEnd       := .T.
Local cPerg     := PADR( "FIR276", 6 )
Local cNRel

Private cNomeProg := "FINR276"        // nome do programa
Private cTitulo   := ""
Private cTamanho  := "M"
Private aReturn := {OemToAnsi(STR0019),1,OemToAnsi(STR0020),1, 1,1,"",1}    //"Zebrado"###"Administracao"
Private m_pag      := 1
Private nLastKey   := 0  // Controla o cancelamento da SetPrint e SetDefault
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private oTmpTable := Nil
Private aIndex      := {}

cNRel  := cNomeProg


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF nLastKey == 27
  Return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("FIR276",.F.)

cTitulo   := STR0003 //"Resumo de clientes que pagaram em dinheiro"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia control para funcion SETPRINT                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNRel := SetPrint( "SE1", cNRel, cPerg, cTitulo, cDesc1, ;
                    cDesc2, cDesc3, .F., aOrdem, .T., ;
                    cTamanho, .T., .f. )

IF nLastKey == 27
   RETURN nil
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicion del Formulario en la Impresora             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault( aReturn, "SE1" )

IF nLastKey == 27
   SET PRINTER TO
   SET PRINT OFF
   RETURN
ENDIF

Private lProc  := .f.

RptStatus( { ||Fir276Imp() } )

SET PRINTER TO

IF aReturn[5] == 1
   SET PRINTER TO
   DbCommitAll()
   OurSpool(cNRel)
ENDIF

Ms_Flush()

//leem
If oTmpTable <> Nil   
	oTmpTable:Delete()  
	oTmpTable := Nil 
EndIf 
RETURN nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina los límites de impresión                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fir276Imp ³ Autor ³    Ana Paula     		³ Data ³ 02/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Impressao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION Fir276Imp()

Local nLine    := 55
Local nCredCli := 0
Local nValorRec:= 0
Local nNumTit	:= 0
Local nMumTitF	:=0
Local nTotMO   := 0
Local nRecno   := 0
Local aFields  := Array( 0 )
Local cNtxTmp
Local nPosTp
//Local nSigno := Iif (MV_PAR08==3, -1,1)
Local cFil	:= ""
Local nTotFil	:= 0
Local cCredInm	:=	If( cPaisLoc <> "BRA" , GetSESTipos({|| ES_RCOPGER == "2"},"1"), "" )
lOCAL cFilAnt := ""
Local aEmp	:={}
Local nSubTot := 0
Local nLimite := mv_par08
Local nTaxa:= mv_par09
Local cNumCta:=""
Local cNomeBco:=""
Local cCodBco:=""
Local nTotCta:=0
Private nDecs := MsDecimais(mv_par06)

cCredInm	:=	IIf(Empty(cCredInm),"EF ",cCredInm)

AAdd( aFields, { "FILSIS"	,"C", TamSX3('A6_FILIAL')[1], 0 } )
AAdd( aFields, { "CODBCO"	,"C", TamSX3('A6_COD')[1], 0 } )
AAdd( aFields, { "NOMEBCO"	,"C", TamSX3('A6_NOME')[1], 0 } )
AAdd( aFields, { "NUMCTA"	,"C", TamSX3('A6_NUMCON')[1], 0 } )

AAdd( aFields, { "HIST"  	,"C", TamSX3('E5_HISTOR')[1], 0 } )
AAdd( aFields, { "DATAMOV"		,"D", TamSX3('E5_DATA')[1], 0 } )
AAdd( aFields, { "TIPODOC"	,"C", TamSX3('E5_TIPO')[1], 0 } )
AAdd( aFields, { "NUMDOC"	,"C", TamSX3('E5_NUMERO')[1], 0 } )
AAdd( aFields, { "VLTOTCTA","N", TamSX3('E5_VALOR')[1], TamSX3('E5_VALOR')[2] } )
AAdd( aFields, { "VALOR"	,"N", TamSX3('E5_VALOR')[1], TamSX3('E5_VALOR')[2] } )

//Creacion de Objeto 
oTmpTable := FWTemporaryTable():New("TRB") //leem
oTmpTable:SetFields( aFields ) //leem

aIndex	:=	{"FILSIS","CODBCO","NUMCTA"} //leem

oTmpTable:AddIndex("IN1", aIndex) //leem

oTmpTable:Create() //leem

DbSelectArea("SA6")
DbSetOrder(1)

//IF !Empty( Select( "TRB" ) )
//   DbSelectArea( "TRB" )
//   DbCloseArea()
//ENDIF


DbSelectArea( "SE5" )
DbSetOrder( 6 )   	// por data
If !Empty(xFilial("SE5") )
	SE5->(DbSeek(mv_par03+Dtos(mv_par01),.T.))
Else
	SE5->(DbSeek(xFilial("SE5")+Dtos(mv_par01),.T.))
Endif
aEmp:=SM0->(GetArea())
cFilAnt := SE5->E5_FILIAL
aEmp:=SM0->(GetArea())
SetRegua(RecCount())
While !SE5->(EoF()) .AND. SE5->E5_FILIAL >= mv_par03 .And. SE5->E5_FILIAL <= mv_par04
	If	 SE5->E5_TIPO $ cCredInm  .And. SE5->E5_RECPAG == "R" .And. !Empty(SE5->E5_BANCO)  .And.  SE5->E5_SITUACA <> "C"
//		(SE5->E5_TIPODOC $ cCredInm  .And. SE5->E5_RECPAG == "R")

	   	If !Empty(xFilial( "SE5" ) ) .And. cFilAnt <> SE5->E5_FILIAL
			SM0->(DbSkip())
	   	EndIf

	   	IF SE5->E5_DTDIGIT >= mv_par01 .And. SE5->E5_DTDIGIT <= mv_par02 .And. SE5->E5_BANCO == mv_par05
	   //		If mv_par05 == 1//Por Filial
		//	   	cChave:="SE5->E5_FILIAL + SE5->E5_BANCO"

	   //		Else
	   			cChave:='"  " + SE5->E5_BANCO'
	  // 		EndIf
			DbSelectArea( "TRB" )
	   	   	DbSeek(&cChave)
			    If Empty(xFilial( "SA6" ) )
			   		SA6->(DbSeek( xFilial( "SA6" ) + SE5->E5_BANCO ))
			   	Else
			   		SA6->(DbSeek( SM0->M0_CODFIL + SE5->E5_BANCO ))
				EndIf
			   	TRB->( DbAppend() )

		  //		If mv_par05 == 1
		  //			TRB->FILSIS		:= SE5->E5_FILIAL
		 //		Else
	   				TRB->FILSIS		:= "  "
		//		End
				TRB->CODBCO    	:= SA6->A6_COD
	   			TRB->NOMEBCO	:=SA6->A6_NOME
	   			TRB->NUMCTA   	:= SE5->E5_CONTA
				TRB->HIST		:= SE5->E5_HISTOR
				TRB->DATAMOV	:= SE5->E5_DATA
				TRB->TIPODOC	:= SE5->E5_TIPO
				TRB->NUMDOC		:= SE5->E5_NUMERO

		 //	Else
	           // RecLock("TRB",.F.)
		//	EndIF
				If (mv_par07== 2 .AND. mv_par06 == Val(SE5->E5_MOEDA) ) .Or. mv_par07 == 1

	   		   	   	TRB->VALOR	:= ( Round(xMoeda(SE5->E5_VALOR,Val(SE5->E5_MOEDA),mv_par06,SE5->E5_DATA,nDecs+1),nDecs))
					TRB->VLTOTCTA:= TRB->VLTOTCTA+( Round(xMoeda(SE5->E5_VALOR,Val(SE5->E5_MOEDA),mv_par06,SE5->E5_DATA,nDecs+1),nDecs))
		      	EndIf
	      	RecLock("TRB",.F.)
	      	MsUnlock()
	      //EndIf
	    Else
	      RecLock("TRB",.F.)
	    EndIf
	EndIf
	    cFilAnt := SE5->E5_FILIAL
	    SE5->(DbSkip())
		IncRegua()
	//EndIf
EndDo

SM0->(RestArea(aEmp))

SetRegua( RecCount() )
DbGoTop()

nLine := 55
nTotBco:=0


cFil:= FILSIS

Fir276Cab(@lProc,@nLine)
cBanco:= Alltrim(TRB->CODBCO)+Space(5)+ Alltrim(TRB->NOMEBCO)
F256Bco(@nLine,@cBanco)

WHILE !TRB->(EOF()) .And. TRB->VALOR > 0
	cNumCta:=TRB->NUMCTA
	cNomeBco:=TRB->NOMEBCO
	cCodBco:=TRB->CODBCO
	nTotCta:=nSubTot
	nSubTot:=0
	If nLine >= 55
		Roda()
		Fir276Cab(@lProc,@nLine)
		F256Bco(@nLine,@cBanco)
 	EndIf

	@ nLine,  00 PSAY STR0010
	@ nLine,  15 PSAY Alltrim(NUMCTA)
	nLine := nLine + 1
	//Imprime o subtotal da conta

	While !TRB->(EOF()) .And. TRB->NUMCTA == cNumCta
		nSubTot:=nSubTot+VLTOTCTA
		If nLine >= 55
			Roda()
			Fir276Cab(@lProc,@nLine)
			F256Bco(@nLine,@cBanco)
		EndIf
		Fir276It(@nLine)

		TRB->(dbSkip())
	EndDo

	nTotBco	:= nTotBco + nSubTot
	nIDEBase:=Iif((nTotBco - nLimite)>0,nTotBco - nLimite,0)
	nVlIDE:= Iif(nIDEBase > 0,(nIDEBase * (nTaxa/100)),0)

	If nLine > 55
		Roda()
		Fir276Cab(@lProc,@nLine)
		F256Bco(@nLine,@cBanco)
	EndIf
	F276SubTot(@nLine,@nSubTot,@cNumCta)

	IncRegua()


EndDo

If !Empty(cCodBco) .And. !Empty(cNomeBco)
	If nLine >= 55
		Roda()
	 	Fir276Cab(@lProc,@nLine)
 		F256Bco(@nLine,@cBanco)
	EndIf

	//Imprime o total do banco
	@ nLine,  60 PSAY STR0012 + Space(2) +	Alltrim(cCodBco)
	@ nLine,  90 PSAY Abs(nTotBco) Picture TM(nTotBco,16,nDecs)
	nLine := nLine + 1

	Fir276Res(@nLine,@nTotBco,@nIDEBase,@nVlIDE,@nLimite,@cNomeBco,@cCodBco)

EndIf
If nLine <> 55
	Roda()
EndIf

RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fir276Cab ³ Autor ³    Ana Paula     		³ Data ³ 02/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do cabecalho                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUNCTION Fir276Cab(lProc,nLine)
Local cCabec1,cCabec2

cTitulo   := STR0001// + GETMV("MV_SIMB"+ Alltrim(Str(MV_PAR06)))+" " +Alltrim(Str(MV_PAR09)) + STR0005 +  dtoc(mv_par01) + STR0006  +  dtoc(mv_par02) //"Resumo de clientes que pagaram mais de "###" em dinheiro no periodo de: "###" ate "


   IF !lProc
      lProc := .t.
   ENDIF

//   IF nLine >= 60
         cCabec1 := STR0005+Space(10)+STR0006+Space(30)+STR0007+Space(10)+STR0008+Space(15)+STR0009
         cCabec2 := ""
//                    1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                             1         2         3         4         5         6         7         8         9         10        11        12        13        14        15             16                  17

      Cabec( cTitulo, cCabec1, Ccabec2, cNomeProg, cTamanho, 18 )


      nLine := 09

 //  ENDIF

RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fir276It  ³ Autor ³    Ana Paula    		³ Data ³ 02/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao dos Itens                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION Fir276It(nLine)

@ nLine,  00 PSAY DATAMOV
@ nLine,  15 PSAY HIST
@ nLine,  55 PSAY NUMDOC
@ nLine,  80 PSAY TIPODOC
@ nLine,  89 PSAY Abs(VALOR) Picture TM(VALOR,16,nDecs)

nLine := nLine + 1

RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³F276SubTot³ Autor ³    Ana Paula    		³ Data ³ 02/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Subtotal da conta                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUNCTION F276SubTot(nLine,nSubTot,cNumCta)

nLine := nLine + 1


@ nLine,  60 PSAY STR0011 + Space(2)+ Alltrim(cNumCta)
@ nLine,  90 PSAY Abs(nSubTot) Picture TM(nSubTot,16,nDecs)
nLine := nLine + 1
@ nLine,  00 PSAY Replicate( "-", 165)


nLine := nLine + 2

RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Fir276Tot ³ Autor ³   Ana Paula		    ³ Data ³ 02/07/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³resumo global das operacoes. calculo de IDE                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fir276Res(nLine,nTotBco,nIDEBase,nVlIDE,nLimite,cNomeBco,cCodBco)
Local nTaxa:= mv_par09

cBanco:= Alltrim(cCodBco)+Space(5)+ Alltrim(cNomeBco)+Space(10)

nLine:= nLine +1
@nLine,00 PSAY __PrtThinLine()
nLine := nLine + 1
@ nLine,  00 PSAY  Space(55) + STR0013 //"Resumo global de operacoes "
nLine := nLine + 1
@nLine,00 PSAY __PrtThinLine()
nLine := nLine + 2

@ nLine,  00 PSAY STR0003+ cBanco
nLine := nLine + 1
@ nLine,  00 PSAY STR0004
@ nLine,  10 PSAY mv_par01
@ nLine,  20 PSAY STR0002
@ nLine,  25 PSAY mv_par02
nLine:= nLine +1
@nLine,00 PSAY __PrtThinLine()
nLine:= nLine + 1


@ nLine, 25 PSAY STR0014   //Total de depositos
@ nLine, 90 PSAY Abs(nTotBco) PICTURE TM(nTotBco,16,nDecs) //"99,999,999.99"
nLine := nLine + 1
@ nLine, 25 PSAY STR0015  //Limite para calculo de IDE
@ nLine, 90 PSAY Abs(nLimite) PICTURE TM(nLimite,16,nDecs)
nLine := nLine + 1
@ nLine, 25 PSAY STR0016   //Base IDE
@ nLine, 90 PSAY Abs(nIDEBase) PICTURE TM(nIDEBase,16,nDecs) //"99,999,999.99"
nLine := nLine + 1
@ nLine, 25 PSAY STR0017 //taxa de imposto
//@ nLine, 105 PSAY nTaxa //taxa de imposto
@ nLine, 90 psay PadL(Transform( nTaxa, "@E 99,999.99" ),16 ) + "%"
nLine := nLine + 1
@ nLine, 25 PSAY STR0018   //imposto causado no periodo
@ nLine, 90 PSAY Abs(nVlIDE) PICTURE TM(nVlIDE,16,nDecs) //"99,999,999.99"


RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³F256Bco   ³ Autor ³    Ana Paula      	³ Data ³02/07/08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime descrição e codigo do banco                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function F256Bco(nLine,cBanco)
	nLine := nLine - 1
	@ nLine,  00 PSAY STR0003+ cBanco
	nLine:= nLine +1
	@ nLine,  00 PSAY STR0004
	@ nLine,  10 PSAY mv_par01
	@ nLine,  20 PSAY STR0002
	@ nLine,  25 PSAY mv_par02
	nLine:= nLine +1
	@nLine,00 PSAY __PrtThinLine()
	nLine:= nLine +1
Return()
