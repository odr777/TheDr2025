#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ HP015    º Autor ³                    º Data ³  20/12/07   º±±
±±°Modificado por Moises Flores 14/12/16 								  °±±
±±°Adición de campos valor Bs,$us Y Usuario para SAGITARIO SRL.           °±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime nota de traspaso.                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SAGITARIO                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UHP015(cDoc, nMoeda)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private titulo  := "TRANSFERENCIA ENTRE DEPOSITOS"
Private cDesc1  := "Ese programa tiene por objetivo imprimir informe "
Private cDesc2  := "de acuerdo con parámetros informados por el usuario."
Private cDesc3  := titulo
Private cPict   := ""
Private Cabec2  := ""
Private imprime := .T.
Private aOrd    := {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private Tamanho     := "G"
Private limite      := 220 //IIf(Tamanho == "P", 080, IIf(Tamanho == "M", 132, 220))
Private Nomeprog    := "HP015"
Private nTipo       := 15
Private aReturn     :={"Zebrado", 1,"Administracao", 2, 2, 1, "",0 } //"Zebrado"###"Administracao" {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
private  cPerg      := "HP015"
Private cbtxt       := Space(10)
Private cbcont      := 0
Private CONTFL      := 1
Private m_pag       := 1
Private wnrel       := Nomeprog
Private cString     := "SD3"
Private nLin    := 0
Private Cabec1  := ""
Private cOr		:=""     
//Private lExeAut	:= If(!Empty(lAuto),lAuto,.F.)

criasx1(cPerg)
                      
If !SD3->D3_CF $ 'RE4|DE4'          
	Alert("Este NO es un documento de Transferencia")
	Return
Endif
If Alltrim(Upper(FunName())) == 'MATA261'
	SX1->(DbSetOrder(1))
   	If SX1->(DbSeek(AllTrim(cPerg)+Space(5)+"01"))
    	Reclock('SX1',.F.)
      	X1_CNT01 := SD3->D3_DOC
     	SX1->(MsUnlock())
 	Endif
Endif
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg, .T.)
          
wnrel := SetPrint(cString, NomeProg,Iif(Alltrim(Upper(FunName())) == 'MATA261',"",cPerg),@titulo, cDesc1, cDesc2, cDesc3, .F.,.F., .T., Tamanho,, .F.)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn, cString,,,,1)
If nLastKey == 27
	Return
Endif
nTipo := IIf(aReturn[4] == 1, 15, 18)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1, Cabec2, Titulo, nLin)}, Titulo)
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³                    º Data ³  20/12/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1, Cabec2, Titulo, nLin)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cArea   := GetArea()
Local cFcEmi   := ""
Local nValor   := 0
Local nTotal   := 0
Local nTotGer  := 0
Local cUsuario := ""
Local cArmOri  := ""
Local cArmDest := ""
Local nTotLin  := 27
Local cQuery   := ""     
Local cOr:=""
_nContIt := 80
_nPag := 0     
NLIN  := 0 
I	  := 1
cDoc:=SD3->D3_DOC
SD3->(DbSetOrder(8))
SD3->(DbGoTop())
SD3->(DbSeek(xFilial("SD3")+cDoc))
Do While SD3->(!eof()) .AND. SD3->D3_DOC == cDoc
	If lAbortPrint
		@nLin, 0 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If SD3->D3_TM <> '999'
	   SD3->(DbSkip())
	End    
	
	// Monta y ejecuta query.   
	// cQuery :=" SELECT  D3_UOBSER OBS, D3_ITEM, "
	cQuery :=" SELECT   D3_ITEM, "
	cQuery +="  SUBSTRING (D.D3_EMISSAO ,7,2)+'/'+SUBSTRING (D.D3_EMISSAO ,5,2)+'/'+SUBSTRING (D.D3_EMISSAO ,1,4) FECHA, "
	cQuery +="  D.D3_EMISSAO EMISION,   	"
	cQuery +="  CONVERT(INT,SUBSTRING(D.D3_EMISSAO,7,2)) DIA, CONVERT(INT,SUBSTRING(D.D3_EMISSAO,5,2)) MES,   "
	cQuery +="  CONVERT(INT,SUBSTRING(D.D3_EMISSAO,1,4)) ANIO,     "
	cQuery +="  D.D3_FILIAL SUCURSAL,   "
	cQuery +="  D.D3_DOC NRO_DOC,   "
	cQuery +="  D.D3_COD COD_PROD,   " 
	cQuery +="  B.B1_DESC DESC_PROD,  " 
	cQuery +="  D.D3_LOCAL DEP_ORI,  " 
	cQuery +="  D.D3_QUANT CANT,      "
	cQuery +="  B.B1_UM UM,       "
	cQuery +=" (SELECT   D3.R_E_C_N_O_ "    
	cQuery +=" FROM " + RetSqlName("SD3") + " D3 " 
	cQuery +=" WHERE D3.D_E_L_E_T_ != '*' "    
	cQuery +=" AND   D3.D3_ESTORNO = ' '  "
	cQuery +="  AND   D3.D3_TM = '499' "  
	cQuery +="  AND   D3.D3_CF='DE4' "  
	cQuery +="  AND   D3.D3_FILIAL = D.D3_FILIAL   "   
	cQuery +="  AND   D3.D3_NUMSEQ='" + SD3->D3_NUMSEQ + "'"
	cQuery +="  AND   D3.D3_DOC='" + MV_PAR01 + "') REGISTRO "  
	// cQuery +="  AND   D3.D3_DOC='" + MV_PAR01 + "') REGISTRO, "  
	// cQuery +="  D.D3_USUARIO USUARIO  "  			
	cQuery +=" FROM " + RetSqlName("SD3") + "  D, " 
	cQuery += RetSqlName("SB1") + " B  "
	cQuery +=" WHERE D.D_E_L_E_T_ != '*' " 
	cQuery +=" AND   D.D3_COD = B.B1_COD "
	cQuery +=" AND   D.D3_ESTORNO = '  ' "   
	cQuery +=" AND   D.D3_TM = '999' "      
	cQuery +=" AND   D.D3_CF='RE4'   "
	cQuery +=" AND   D.D3_TM = '999' "
	cQuery +=" AND   D.D3_CF='RE4' "     
	cQuery +=" AND   D.D3_DOC='" + MV_PAR01 + "'"
	cQuery +=" AND   D.D3_NUMSEQ='" + SD3->D3_NUMSEQ + "'"
	cQuery +=" AND   D.D3_FILIAL ='" + xFilial("SD3") + "'"
	MEMOWRITE("TRASPASO.SQL",cQuery)
	IF SELECT("TRANSF") > 0
	  TRANSF->(DBCLOSEAREA())
	END
	TCQUERY cQuery NEW ALIAS "TRANSF"
	dbSelectArea("TRANSF")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nContIt > 60  
       _nPag++
	   If _nPag > 1
          @ nLin,00 PSAY REPLICATE('-',limite) 
          nLin+=2
	      @ nLin, 000 PSAY PadC("****** CONTINUA EN LA SIGUIENTE PAGINA *******", 132)
          nLin+=3
          @ nLin, 115 PSAY 'Pag.:' + Str(_nPag-1,2) 
          nLin+=2
          @ nLin,00 PSAY ''
	   End         
	   nLin:=CABHP()    
		
		dbSelectArea("TRANSF")
	   
	   _nContIt := 0
	Endif        
   
    _nRegAtu:=SD3->(Recno())
	SD3->(DbGoTo(TRANSF->REGISTRO))
	@nLin, 000 PSAY Padr(AllTrim(COD_PROD), 15)
	@nLin, 018 PSAY Left(DESC_PROD, 30)
	@nLin, 053 PSAY Padr(SD3->D3_COD, 15)
	@nLin, 070 PSAY Left(POSICIONE("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_DESC"), 30)
	@nLin, 105 PSAY DEP_ORI 
	@nLin, 113 PSAY SD3->D3_LOCAL 
	@nLin, 123 PSAY SD3->D3_CUSTO1  // aumenta por moshe
	@nLin, 137 PSAY SD3->D3_CUSTO2  // aumenta por moshe
	@nLin, 148 PSAY CANT PICTURE PESQPICT('SD3','D3_QUANT') // 124
	// @nLin, 163 PSAY OBS // 138
    dFecha := STOD(Emision)
	nLin++
	
	cUsuario:= "USUARIO"
	nTotGer += nTotal
	_nContIt++
	
	// Salta dos registros para imprimir solamente los destinos.
	DbSelectArea("SD3")
	SD3->(DbGoTo(_nRegAtu))
	dbSkip()  
	I++
EndDo
If _nPag > 0  
	@ nLin, 00 PSAY REPLICATE('-',limite)
	nLin+=3
	
	@nLin, 000 PSAY "Elaborado Por: " + Upper(cUsuario)
	@nLin, 050 PSAY "Entregado Por: "
	@nLin, 100 PSAY "Recibido Por: "
	@ If(nLin < 31,31,62), 115 PSAY 'Pag.:' + Str(_nPag,2) 
End
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
TRANSF->(dbCloseArea())    
RestArea(_cArea)
Return
Static Function CabHP()
SetPrc(0,0)                  
@ 000,00 PSAY CHR(15)
@ 000,00 PSAY SM0->M0_NOMECOM
@ 001,114 PSAY 'Fecha: '+dtoc(stod(TRANSF->Emision))
Titulo := "TRANSFERENCIA ENTRE DEPOSITOS - Nr. " + AllTrim(SD3->D3_DOC) + " " + IIf(MV_PAR02 == 1, "(en Bolivianos)", "(en Dolar)")
@ 002,000 PSAY PADC(titulo,110)     
@ 002,114 PSAY 'Hora: ' + Time()    // hora
@ 003,00 PSAY 'Usuario: '+ SD3->D3_USUARIO
nLin:=06
nLin+=1
@ nLin,00 PSAY REPLICATE('-',limite)
nLin+=1
//         **************** Rula de desarrollo ****************
     //                  10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180
     //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	 //         999999 9999999999 xxxxxxxxxxxxxxxxxx 99/99/99 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx 9,999,999.9999 9,999,999.99  999,999,999.99
@ nLin,00 PSAY "PROD ORIGEM       DESCR ORIGEM                       PROD DESTINO     DESCR DESTINO                      DP ORI  DP DEST   VALOR Bs.     VALOR $us.      CANTIDAD"
// @ nLin,00 PSAY "PROD ORIGEM       DESCR ORIGEM                       PROD DESTINO     DESCR DESTINO                      DP ORI  DP DEST   VALOR Bs.     VALOR $us.      CANTIDAD   OBSERVACIONES"
nLin+=1
@ nLin,00 PSAY REPLICATE('-',limite)
nLin+=1
Return(nLin)





Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	/*
	Código del proveedor Inicial y Final (F1_FORNECE)
	Tienda del Proveedor Inicial y final (F1_LOJA)
	Fecha de digitación Inicial y Final (F1_DTDIGIT)
	Fecha de emisión Inicial y Final (F1_EMISSAO)
	Importación Inicial y Final (F1_HAWB)
	Nro de Documento Inicial y Final (F1_DOC)
	Serie del Doc Inicial y Final (F1_SERIE)
	*/
	xPutSX1(cPerg,"01","¿De Documento?" 	, "¿De Documento?"		,"¿De Documento?"	,"MV_CHD","C",18,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")

return

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
