// #include "SIGAWIN.CH"        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
#include "PROTHEUS.CH"
#include "CHQENT.CH"

User Function CHQENT()        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99

PRIVATE cPerg   := "CHQENT"   // elija el Nombre de la pregunta 
CriaSX1(cPerg)	// Si no esta creada la crea
Pergunte(cPerg,.F.) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTIT,CDESC1,CDESC2,CDESC3,ARETURN,NLASTKEY")
SetPrvt("CSAVCOR,CSAVSCR,AORD,CNOMREL,CIND,CCOND")
SetPrvt("CCHAVE,AMES,ADRIVER,LCAB,LIMP,NLI")
SetPrvt("CPROGRAMA,M_PAG,CCAB1,CCAB2,CTITC,CTAM")
SetPrvt("NGERIMP,NMESANT,NYEARANT,CCLIANT,NTOTCLI,NTOTMES")
SetPrvt("CCLI,CLOJA,CRAZ,CBANCO,_SALIAS")
SetPrvt("AREGS,I,J,")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CHQENT   ³ Autor ³ M.Hernadez/B.Sobieski ³ Data ³ 05.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impresion de los cheques recibidos aun no ingresados en la ³±±
±±³          ³ Movimentacion bancaria de siga (no depositados).           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ACTUALIZACIONES EFECTUADAS DESDE LA CODIFICACION INICIAL      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Bruno       ³22/09/99³Melhor³Control de IndRegua Vazio, control de chq ³±±
±±³            ³        ³      ³en bco ou carteira e Imp coluna Banco.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Private Tamanho := "M"
Private LIMITE  := 132

cTIT     := OemToAnsi(STR0001)  // "Listado de Cheques a Acreditar"
cDESC1   := OemToAnsi(STR0002)  // "Este programa emite un informe de los cheques "
cDESC2   := OemToAnsi(STR0003)  // "a acreditar."
cDESC3   := ""
aRETURN  := { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 2, 2, 1, "",1 }  //"Zebrado 80/132","Administracion"
nLASTKEY := 0
//"Vencimiento","Cliente","Recibo","Numero de Cheque","Emision"
aOrd		:=	{OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010)}

/*
+-Preguntas---------------------------------+
¦  Mv_par01    ¿Del Cliente       ?         ¦
¦  Mv_par02    ¿Hasta Cliente     ?         ¦
¦  Mv_par03    ¿Del Emissao       ?         ¦
¦  Mv_par04    ¿Hasta Emissao     ?         ¦
¦  Mv_par05    ¿Del Vencimiento   ?         ¦
¦  Mv_par06    ¿Hasta Vencimiento ?         ¦
¦  Mv_par07    ¿Situacao          ?         ¦
¦  Mv_par08    ¿Imprime Banco     ?         ¦
+-------------------------------------------+
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Requisitos Entidades Bancarias - Julho de 2012 ³
//³ O Pergunte eh alterado para CHQENTB            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If cPaisLoc == "ARG" .And. AliasInDic( "FJN" ) .And. SE1->( FieldPos( "E1_POSTAL" ) ) > 0
     cPerg := "CHQENTB"
  Else
     cPerg := "CHQENT"
  EndIf

If !Pergunte( cPerg , .T. )
   Return
EndIf


cNOMREL  := SETPRINT( "SE1", "CHQENT", cPerg , @cTIT, cDESC1, cDESC2, cDESC3,.F.,aOrd,.F.,TAMANHO,"",.F. )

If nLASTKEY == 27
   RETURN NIL
EndIf

SETDEFAULT(aRETURN,"SE1")

If nLASTKEY == 27
   RETURN NIL
EndIf


//--- Titulos a Receber
dbSelectArea( "SE1" )
//--- E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO  
dbSetOrder( 1 ) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Construcao do FILTRO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIND  := CriaTrab( Nil ,.F. )

cCond := 'E1_FILIAL=="' + xFilial("SE1") + '" .And. E1_CLIENTE >= "' + MV_PAR01 + '"' 
cCond += ' .And. E1_CLIENTE <= "' + MV_PAR02 + '" .And. E1_TIPO == "CH " .And. E1_SALDO > 0'
cCond += ' .And. DTOS( E1_VENCTO ) >= "' + DTOS( MV_PAR05 ) + '" .And. DTOS( E1_VENCTO ) <= "' + DTOS( MV_PAR06 ) + '"'
cCond += ' .And. DTOS( E1_EMISSAO ) >= "' + DTOS( MV_PAR03 ) + '" .And. DTOS( E1_EMISSAO ) <= "' + DTOS( MV_PAR04 ) + '"'

cCond += ' .And. E1_PORTADO >= "' + MV_PAR09 + '" .And. E1_PORTADO <= "' + MV_PAR12 + '"'
cCond += ' .And. E1_AGEDEP >= "' + MV_PAR10 + '" .And. E1_AGEDEP <= "' + MV_PAR13 + '"'
cCond += ' .And. E1_CONTA >= "' + MV_PAR11 + '" .And. E1_CONTA <= "' + MV_PAR14 + '"'


If MV_PAR07 == 1      // Carteira
   cCond += ' .And. E1_SITUACA=="0"'
ElseIf MV_PAR07 == 2  // Banco
   cCond += ' .And. E1_SITUACA=="1"'
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Requisitos Entidades Bancarias - Julho de 2012 ³
//³ O Pergunte eh alterado para CHQENTB            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If cPaisLoc == "ARG" .And. AliasInDic( "FJN" ) .And. SE1->( FieldPos( "E1_POSTAL" ) ) > 0
     /*
     +-Preguntas---------------------------------+
     ¦  MV_PAR09    ¿Considera Abaixo ?          ¦
     ¦  MV_PAR10    ¿Banco Cheque ?              ¦
     ¦  MV_PAR11    ¿Agencia Cheque ?            ¦
     ¦  Mv_par12    ¿Conta Cheque ?              ¦
     ¦  Mv_par13    ¿Codigo Postal ?             ¦
     ¦  Mv_par14    ¿Imprime Banco ?             ¦
     +-------------------------------------------+
     */

       //--- Verifica se deve levar em conta os Parametros de Entidades Bancarias
	   If MV_PAR09 == 1                                                 

          If Empty( MV_PAR10 )  // Empty( cBcoChq )

             If !Empty( MV_PAR13 )   // !Empty( cPostal )

                 cCond += " .And. E1_POSTAL=='" + MV_PAR13 + "'"
     
             EndIf

          Else

             cCond += " .And. E1_BCOCHQ=='" + MV_PAR10 + "'"
             cCond += " .And. E1_AGECHQ=='" + MV_PAR11 + "'"
          
          EndIf

       EndIf

  EndIf  
//ÚÄÄÄÄÄÄÄ¿
//³ F I M ³
//ÀÄÄÄÄÄÄÄÙ

Do Case
	Case aReturn[8]==1
		#IFNDEF TOP
			cCHAVE := "DTOS(E1_VENCTO)+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA"
		#ELSE
			cCHAVE := "E1_VENCTO+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA"
		#ENDIF
	Case aReturn[8]==2
		#IFNDEF TOP
			cCHAVE := "E1_CLIENTE+E1_LOJA+DTOS(E1_VENCTO)+E1_PREFIXO+E1_NUM+E1_PARCELA"
		#ELSE
			cCHAVE := "E1_CLIENTE+E1_LOJA+E1_VENCTO+E1_PREFIXO+E1_NUM+E1_PARCELA"
		#ENDIF
	Case aReturn[8]==3
		#IFNDEF TOP
			cCHAVE := "E1_SERREC+E1_RECIBO+DTOS(E1_VENCTO)+E1_NUM+E1_PARCELA"
		#ELSE
			cCHAVE := "E1_SERREC+E1_RECIBO+E1_VENCTO+E1_NUM+E1_PARCELA"
		#ENDIF
	Case aReturn[8]==4
		cCHAVE := "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_CLIENTE+E1_LOJA"
	Case aReturn[8]==5
		#IFNDEF TOP
			cCHAVE := "DTOS(E1_EMISSAO)+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA"
		#ELSE
			cCHAVE := "E1_EMISSAO+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA"
		#ENDIF
EndCase

//"ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SETIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"
aMes	:=	{OemToAnsi(STR0011),OemToAnsi(STR0012),OemToAnsi(STR0013),OemToAnsi(STR0014),OemToAnsi(STR0015),OemToAnsi(STR0016),;
             OemToAnsi(STR0017),OemToAnsi(STR0018),OemToAnsi(STR0019),OemToAnsi(STR0020),OemToAnsi(STR0021),OemToAnsi(STR0022)}

IndRegua("SE1",cInd,cChave,,cCOND,OemToAnsi(STR0023))  //"Selecionando Cheques..."

nIndex	:=	Retindex("SE1")

#IFNDEF TOP
	DbSetIndex(cInd+OrdBagExt())
#ENDIF

dbSelectArea( "SE1" )
dbSetOrder( nIndex+1 )
dbGoTop()

/*
If EOF() .And. BOF()
   RETINDEX("SE1")
   RETURN
Endif   */

aDRIVER := READDRIVER()

lCAB  := .T.
lIMP  := .F.
nLI   := 1

//cPROGRAMA := "RFINR04"
cPROGRAMA := "CHQENT"
M_PAG := 1 // No DA PAGINA


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ * * *   Estabelece o Titulo    * * * ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc == "ARG" .And. AliasInDic( "FJN" ) .And. SE1->( FieldPos( "E1_POSTAL" ) ) > 0

   //--- Verifica se deve levar em conta os Parametros de Entidades Bancarias
   If MV_PAR09 == 1                                

      If MV_PAR14 == 1        // Por Codigo

         // "Codigo/Filial  Nome                      Numero                      Data        Estado    Dt. Vcto./    Importe   Bco Chq.(Bco/Age/Post.) Moeda"
	     cCAB1 := OemToAnsi(STR0062)

      ElseIf MV_PAR14 == 2   // Por Nome

         // "Codigo/Filial  Nome                      Numero                      Data        Estado    Dt. Vcto./    Importe   Bco Cheque (Nome)       Moeda"
	     cCAB1 := OemToAnsi(STR0063)

      EndIf
      
   Else

      /*
         Possiveis conteudos do combo de MV_PAR08
         Banco Dep(Nome)
         Bco Dep(Cod)   
         Bco. Orig.     
      */
      If MV_PAR08 == 1
         //"* Codigo    Nombre                      Numero         Fecha     Estado    Fch.Vcto./    Importe    Banco Dep.(Nombre)      Moneda *"
         cCAB1 := OemToAnsi(STR0024)
      ElseIf MV_PAR08 == 2     
         //"* Codigo    Nombre                      Numero         Fecha     Estado    Fch.Vcto./    Importe    Banco Dep.(Bco/Age/Cta) Moneda *"
	     cCAB1 := OemToAnsi(STR0025)
      Else
         //"* Codigo    Nombre                      Numero         Fecha     Estado    Fch.Vcto./    Importe    Banco Ori.(Bco/Age/Cta) Moneda *"
	     cCAB1 := OemToAnsi(STR0026)
      Endif

   EndIf

Else

	If MV_PAR08 == 1
        //"* Codigo    Nombre                      Numero         Fecha     Estado    Fch.Vcto./    Importe    Banco Dep.(Nombre)      Moneda *"
    	cCAB1 := OemToAnsi(STR0024)
    ElseIf MV_PAR08 == 2     
        //"* Codigo    Nombre                      Numero         Fecha     Estado    Fch.Vcto./    Importe    Banco Dep.(Bco/Age/Cta) Moneda *"
	    cCAB1 := OemToAnsi(STR0025)
    Else
        //"* Codigo    Nombre                      Numero         Fecha     Estado    Fch.Vcto./    Importe    Banco Ori.(Bco/Age/Cta) Moneda *"
	    cCAB1 := OemToAnsi(STR0026)
    Endif
    
EndIF

cCAB2 := OemToAnsi(STR0027)  //"*                                      (RCBO/CHQ)      Emision             Clearing                                                *"
//"*** Listado de Cheques a acreditar entre el "," a ",
cTITC := OemToAnsi(STR0028)+DTOC(MV_PAR05)+OemToAnsi(STR0029)+DTOC(MV_PAR06)+" ***"
cTAM  := "M"

RptStatus( { || ImpSE1() } , cTIT )

Set Filter To
Set Device To Screen
										 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apresenta relatorio na tela	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer TO 
	dbCommitAll()
	OurSpool(cNOMREL)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Indice de SE1 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SE1" )
RetIndex( "SE1" )
Set Filter To

dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga o arquivo temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cInd += OrdBagExt()

If File( cInd )
   FErase( cInd )
EndIf

MS_FLUSH()

RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ IMPSE1   ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do relatorio                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IMPSE1()

dbSelectArea( "SE1" )

SetRegua( RECCOUNT() )

SETPRC(0,0)

If UPPER( ALLTRIM( aDRIVER[5] ) ) <> "CHR(32)"
	@ 000,000 PSAY &(alltrim(aDRIVER[5]))
EndIf

nGERIMP := 0

nMesAnt	 :=	Month(SE1->E1_VENCTO)
nYearAnt :=	Year(SE1->E1_VENCTO)
cCliAnt	 :=	SE1->E1_CLIENTE
nTotCli	 :=	0.00
nTotMes	 :=	0.00

WHILE !EOF() .AND. !lABORTPRINT .AND. ( nMesAnt > 0 )
	INCREGUA()
	cCLI    := SE1->E1_CLIENTE
	cLOJA   := SE1->E1_LOJA

	dbSelectArea( "SA1" )
	dbSeek( xFILIAL("SA1")+cCLI+cLOJA )

	cRAZ := SUBS( SA1->A1_NOME, 1, 23 )

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Quebras x Selecao de Ordem ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[8]==1 // Ordenado por vencto

		If (nMesAnt	<> Month(SE1->E1_VENCTO) .OR. nYearAnt<>Year(SE1->E1_VENCTO))

			If cPaisLoc $ "VEN"
				@nLi,	010 PSAY OemToAnsi(STR0030) + aMes[nMesAnt] +OemToAnsi(STR0059)+GETMV("MV_MOEDA1")+") "+ TransForm(nTotMes,TM(nTotMes,14,MsDecimais(1)))  //"Totales Mes de "," (en BOLIVAR) "
			ELSE
				@nLi,	048 PSAY OemToAnsi(STR0030) + aMes[nMesAnt]+" ("+OemToAnsi(STR0059)+GETMV("MV_MOEDAP1")+") "  //"Totales Mes de "," (en PESO) "
				@nLI,	101 PSAY TransForm(nTotMes,TM(nTotMes,14,MsDecimais(1)))
			Endif

			nLi	:=	nLi + 2

			nTotMes	 :=	0.00
			nMesAnt	 :=	Month(SE1->E1_VENCTO)
			nYearAnt :=	Year(SE1->E1_VENCTO)
			
			If nMesAnt == 0
			   Exit
			EndIf
			
		Endif

	Elseif aReturn[8]==2 //Ordenado por Cliente

		If cCliAnt <> SE1->E1_CLIENTE
			@nLi,	010 PSAY OemToAnsi(STR0032) + cCliAnt + TransForm(nTotCli,"@R 999,999,999.99")  //"Total a acreditar del cliente  ",
			nLi	:=	nLi	+	2
			cCliAnt	:=	SE1->E1_CLIENTE
			nTotCli	:=	0.00
		Endif

	Endif

	dbSelectArea( "SE1" )

	If lCAB
		nLI := CABEC(cTITC,cCAB1,cCAB2,cPROGRAMA,cTAM)
		nLI := nLI + 2
		lCAB := .F.
		lIMP := .T.
	EndIf

	@ nLI,000 PSAY cCLI+"/"+cLOJA               

	If Len(cCli) > 11
		nLi++
	Endif	                          

	@ nLI,015 PSAY cRAZ
	@ nLI,041 PSAY SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
	@ nLI,067 PSAY SE1->E1_EMISSAO

    If SE1->E1_STATUS == "R"
       @ nLI,081 PSAY OemToAnsi(STR0033)  // "Rechazado"
       @ nLI,091 PSAY SE1->E1_VENCTO
    ElseIf SE1->E1_DTACRED >= dDataBase
       @ nLI,081 PSAY OemToAnsi(STR0034)  // "Clearing"
       @ nLI,091 PSAY SE1->E1_DTACRED
    ElseIf SE1->E1_VENCTO < dDataBase
       @ nLI,081 PSAY OemToAnsi(STR0035)  // "Vencido"
       @ nLI,091 PSAY SE1->E1_VENCTO
    Else
       @ nLI,081 PSAY OemToAnsi(STR0036)  // "En Fecha"
       @ nLI,091 PSAY SE1->E1_VENCTO
    EndIf

	@ nLI,101 PSAY SE1->E1_VALOR PICTURE TM(SE1->E1_VALOR,13)

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Determinao conteudo da String cBanco ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    FIR88BCO()
   
	@ nLI,115 PSAY cBANCO
	@ nLI,145 PSAY AllTrim( GetMV("MV_MOEDA"+STR(SE1->E1_MOEDA,1) ) )

	nGERIMP  := nGERIMP  + SE1->E1_VLCRUZ
	nTotMes	:=	nTotMes + SE1->E1_VLCRUZ
	nTotCli	:=	nTotCli + SE1->E1_VLCRUZ
	nLI := nLI + 1

	If nLI > 54
		lCAB := .T.
	EndIf

	dbSelectArea( "SE1" )
	dbSkip()
	
Enddo

IF lAbortPrint

	@ 00,001 PSAY OemToAnsi(STR0040)  // "+++ CANCELADO POR EL OPERADOR +++"

ELSE

  If nMesAnt > 0 

	   If cPaisLoc $ "VEN"
		  	If aReturn[8]==1 // Ordenado por vencto
				@nLi,	048 PSAY OemToAnsi(STR0041) + aMes[nMesAnt] +OemToAnsi(STR0059)+GETMV("MV_MOEDA1")+") "//+ TransForm(nTotMes,Tm(nTotMes,14,MsDecimais(1)))  //"Totales Mes de "," (en BOLIVARES) "
				@nLI, 101 PSAY nTotMes PICTURE Tm(nTotMes,14,MsDecimais(1))
				nLi	:=	nLi + 1
			Elseif aReturn[8]==2 //Ordenado por Cliente
				@nLi,	048 PSAY OemToAnsi(STR0060)+ GETMV("MV_MOEDA1")+") "+ cCliAnt + "     "  //+ TransForm(nTotCli,Tm(nTotCli,14,MsDecimais(1)))  //"Total a acreditar del cliente (en BOLIVARES"
				@nLI, 101 PSAY nTotCli PICTURE Tm(nTotCli,14,MsDecimais(1))
				nLi	:=	nLi	+	1
			Endif
			IF lIMP
				nLI := nLI + 1
				@ nLI,048 PSAY OemToAnsi(STR0061)+GETMV("MV_MOEDA1")+")"  // "TOTAL GENERAL.....(EN BOLIVARES "
				@ nLI,101 PSAY nGERIMP PICTURE TM(nGERIMP,14,MsDecimais(1))
			END
		ELSE
		  	If aReturn[8]==1 // Ordenado por vencto
				@nLi,	048 PSAY OemToAnsi(STR0041) + aMes[nMesAnt] +" ("+OemToAnsi(STR0059)+GETMV("MV_MOEDAP1")+") "//+ TransForm(nTotMes,Tm(nTotMes,14,MsDecimais(1)))  //"Totales Mes de "," (en PESOS) "
				@nLI, 101 PSAY nTotMes PICTURE Tm(nTotMes,14,MsDecimais(1))
				nLi	:=	nLi + 1
			Elseif aReturn[8]==2 //Ordenado por Cliente
				@nLi,	048 PSAY OemToAnsi(STR0032) +" ("+OemToAnsi(STR0059)+GETMV("MV_MOEDAP1")+") " + cCliAnt //+ TransForm(nTotCli,Tm(nTotCli,14,MsDecimais(1)))  //"Total a acreditar del cliente (en "
				@nLI, 101 PSAY nTotCli PICTURE Tm(nTotCli,14,MsDecimais(1))
				nLi	:=	nLi	+	1
			Endif
			IF lIMP
				nLI := nLI + 1
				@ nLI,048 PSAY OemToAnsi(STR0061)+GETMV("MV_MOEDAP1")  // "TOTAL GENERAL.....(EN : "
				@ nLI,101 PSAY nGERIMP PICTURE TM(nGERIMP,14,MsDecimais(1))
			END
		Endif

  EndIf 

ENDIF

RODA(0,GETMV("MV_RODAPE"),cTAM)

RETURN NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FIR88BCO ³ Autor ³ Carlos E. Chigres     ³ Data ³ 10/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Trazer o banco na impressao conforme a parametrizacao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum, mas cBanco eh declarada Private ...                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FIR88BCO()

//--- Ambiente
Local aOrigin := GetArea()


/*
Possiveis conteudos do combo de MV_PAR14
Bco Dep(Cod)   
Banco Dep(Nome)
*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Requisitos Entidades Bancarias - Julho de 2012 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc == "ARG" .And. AliasInDic( "FJN" ) .And. SE1->( FieldPos( "E1_POSTAL" ) ) > 0

   //--- Verifica se deve levar em conta os Parametros de Entidades Bancarias
   If MV_PAR09 == 1                                                 

      If MV_PAR14 == 1        // Por Codigo

         cBanco := SE1->E1_BCOCHQ + "/" + SE1->E1_AGECHQ + "/" + SE1->E1_POSTAL
      
      ElseIf MV_PAR14 == 2   // Por Nome

         //--- Tabela Entidades Bancarias
         dbSelectArea( "FJN" )
         //--- Filia + Banco + Agencia
         dbSetOrder(1) 
         //
         dbSeek( xFilial( "FJN" ) + SE1->E1_BCOCHQ + SE1->E1_AGECHQ ) 
         //
         cBanco := SubStr( Posicione( "FJO", 1, xFilial("FJO") + FJN->FJN_COD, "FJO_NOME"), 1, 25 )

      EndIf  

   Else

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Tratamento Default ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      FIR88DFT()

   EndIf
      
Else
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Tratamento Default ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   FIR88DFT()
	
EndIf

RestArea( aOrigin )

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FIR88DFT ³ Autor ³ Carlos E. Chigres     ³ Data ³ 06/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tratamento Default, antes de Entidades Bancarias           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ String com a Descricao                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum, mas cBanco eh declarada Private ...                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FIR88DFT()

//--- Ambiente
Local aOrigin := GetArea()

/*
Possiveis conteudos do combo de MV_PAR08
Banco Dep(Nome)
Bco Dep(Cod)   
Bco. Orig.     
*/

If MV_PAR08 == 3
	
   //--- Recibos de Cobranca
   dbSelectArea("SEL")
   //--- EL_FILIAL + EL_SERIE + EL_RECIBO + EL_TIPODOC + EL_PREFIXO + EL_NUMERO + EL_PARCELA + EL_TIPO                                           
   dbSetOrder( 8 )
   //
   dbSeek( xFILIAL("SEL") + SE1->E1_SERREC + SE1->E1_RECIBO + "CH" + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA )
                                       
	If Found() .And. !Empty( EL_BCOCHQ )

		cBANCO := SUBS(TABELA("95",SEL->EL_BCOCHQ,.F.),1,20)
		cBanco := If(Empty(cBanco),If(Empty(SEL->EL_OBSBCO),SEL->EL_BCOCHQ+"/" +SEL->EL_AGECHQ+"/"+Right(Alltrim(SEL->EL_CTACHQ),8),SEL->EL_OBSBCO),cBanco)
	
	ElseIf !Empty( SE1->E1_BCOCHQ )
	
		cBANCO := SUBS(TABELA("95",SE1->E1_BCOCHQ,.F.),1,20)
		cBanco := If(Empty(cBanco),SE1->E1_BCOCHQ+"/" +SE1->E1_AGECHQ+"/"+Right(Alltrim(SE1->E1_AGECHQ),8),cBanco)
	
	Else

		cBanco	:=	 OemToAnsi(STR0037)      // "No registrado"
	
	Endif
	
Else
	
	If Empty( SE1->E1_PORTADO )
	
		cBanco := OemToAnsi(STR0038)   // "En Cartera"
	
	Else
	
		If SE1->E1_PORTADO $ GetMV("MV_CARTEIR")
	
			cBanco := OemToAnsi(STR0039) + SE1->E1_PORTADO    // "Caja "
	
		Else
	
			If MV_PAR08 == 1
	
               dbSelectArea( "SA6" )
               //--- A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON 
               dbSetOrder(1) 
	
			   If dbSeek( xFilial( "SA6" ) + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA ) 
	
				  cBanco := SUBSTR( SA6->A6_NREDUZ,1,27 )
	
			   EndIf
	
			Else
	
				cBanco := SE1->E1_PORTADO + "/" + SE1->E1_AGEDEP + "/" + Right(Alltrim(SE1->E1_CONTA),8)
	
			EndIf
	
		EndIf
	
	EndIf
	
EndIf              
	
RestArea( aOrigin )

Return Nil



Static Function CriaSX1(cPerg)  // Crear Preguntas 

/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
especificaciones, 
*/
// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado

 
xPutSx1(cPerg,"09","Do Banco ?","De banco" 		,"From Bank ?"			,"mv_ch09","C",TamSX3("A6_COD")[1],0,0,"G","","SA6","","","mv_par09","","","","","","","","","","","","","","","","","","","","")
xPutSx1(cPerg,"10","Da Agencia ?","De agencia"	,"From Bank Office ?"	,"mv_ch10","C",TamSX3("A6_AGENCIA")[1],0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","","","","","")
xPutSx1(cPerg,"11","Da Conta ?","De cuenta"		,"From C. Account ?"	,"mv_ch11","C",TamSX3("A6_NUMCON")[1],0,0,"G","","","","",,"mv_par11","","","","","","","","","","","","","","","","","","","","")

xPutSx1(cPerg,"12","Ate Banco ?","A banco" 		,"To Bank ?"			,"mv_ch12","C",TamSX3("A6_COD")[1],0,0,"G","","SA6","","","mv_par12","","","","","","","","","","","","","","","","","","","","")
xPutSx1(cPerg,"13","Ate Agencia ?","A agencia"	,"To Bank Office ?"	,"mv_ch13","C",TamSX3("A6_AGENCIA")[1],0,0,"G","","","","","mv_par13","","","","","","","","","","","","","","","","","","","","")
xPutSx1(cPerg,"14","Ate Conta ?","A cuenta"		,"To C. Account ?"	,"mv_ch14","C",TamSX3("A6_NUMCON")[1],0,0,"G","","","","",,"mv_par14","","","","","","","","","","","","","","","","","","","","")

return


Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica
     
     Local aArea          := GetArea()
     Local aCabec     := {}
     Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
     Local titulo     := oReport:Title()
     Local page := oReport:Page()

// __LOGOEMP__ imprime el logo de la empresa 

     aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar + if(comparador==1," ",RptFolha+" "+cvaltochar(page));
                    , " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + cChar + RptEmiss + " " + Dtoc(dDataBase);
                    , "Hora: "+ cvaltochar(TIME()) ;
                    , "Empresa: "+ SM0->M0_FILIAL + " " }             
     RestArea( aArea )
Return aCabec

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return
