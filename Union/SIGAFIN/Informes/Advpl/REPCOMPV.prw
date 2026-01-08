#include "totvs.ch"
#include 'parmtype.ch'
#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor ³	Query	: Nicolas						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Compensaciones de cuentas por pagar							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ REPCOMPV()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Union														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			 ³07/01/2020³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function REPCOMPV()
	Local oReport
	Private cPerg   := "REPCOMPV"   // elija el nombre de la pregunta

	Pergunte(cPerg,.T.)
	oReport := ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local cNombreProg := "Informe compensacion"
	criasx1(cPerg)
	// ULTIMO RECIBO = ""
	oReport	 := TReport():New("repcompv",cNombreProg,cPerg,{|oReport| PrintReport(oReport)},"Informe compensación")
	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera
	
	oSection := TRSection():New(oReport,"Compensacion",{"SE1"})
	oReport:SetTotalInLine(.F.)

	//Comienzan a elegir los campos que desean Mostrar

	/* TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold) */

	TRCell():New(oSection,"EK_ORDPAGO"	,"SEL","COMPENSACION")
	TRCell():New(oSection,"EK_PREFIXO"	,"SEL","PREF")
	TRCell():New(oSection,"EK_NUMERO"	,"SEL","NUMERO")
	TRCell():New(oSection,"EK_TIPO"		,"SEL","TIPO")
	// TRCell():New(oSection,"EK_CLIORIG"	,"SEL","CODIGO DE CLIENTE - TIENDA")
	TRCell():New(oSection,"E2_NOMFOR"	,"SEL","NOMBRE PROVEEDOR")
	TRCell():New(oSection,"E2_VALOR"	,"SE1","VALOR ORIGEN TITULO","@E 9,999,999,999.99",/*Tamanho*/,/*lPixel*/,{|| xMoeda(QRYSEK->E2_VALOR,QRYSEK->E2_MOEDA,MV_PAR07,DDATABASE) })
	TRCell():New(oSection,"EK_ANTERIOR"	,"SEL","SALDO ANTERIOR","@E 9,999,999,999.99",/*Tamanho*/,/*lPixel*/,{|| 0 })
	TRCell():New(oSection,"EK_VALOR"	,"SEL","VALOR COMPENSADO","@E 9,999,999,999.99",/*Tamanho*/,/*lPixel*/,{|| xMoeda(QRYSEK->EK_VALOR,val(QRYSEK->EK_MOEDA),MV_PAR07,DDATABASE) })
	TRCell():New(oSection,"EK_VALOR"	,"SEL","SALDO DEL TITULO","@E 9,999,999,999.99",/*Tamanho*/,/*lPixel*/,{|| xMoeda(QRYSEK->E2_VALOR,QRYSEK->E2_MOEDA,MV_PAR07,DDATABASE) - xMoeda(QRYSEK->EK_VALOR,val(QRYSEK->EK_MOEDA),MV_PAR07,DDATABASE) })
	 	 
	oBreak = TRBreak():New(oSection,oSection:Cell("EK_ORDPAGO"),"Total de la compensacion")
	TRFunction():New(oSection:Cell("EK_VALOR") ,NIL,"SUM",oBreak,/*cTitle*/,"@E 9,999,999,999.99",{|| iif(alltrim(EK_TIPO) $'PA|NCP', xMoeda(EK_VALOR,val(EK_MOEDA),MV_PAR07,DDATABASE),0) },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local cFiltro  := ""

	#IFDEF TOP
		// Query
		oSection:BeginQuery()
		BeginSql alias "QRYSEK"
	
			SELECT 
				0 EK_ANTERIOR, 
				EK_MOEDA, 
				EK_NUM, 
				EK_ORDPAGO, 
				EK_PREFIXO, 
				0 EK_SALDO, 
				EK_TIPO, 
				EK_VALOR, 
				E2_MOEDA, 
				E2_NOMFOR, 
				E2_VALOR 
			FROM
				%table:SEK% SEK 
			LEFT JOIN 
				%table:SE2% SE2 
				ON EK_NUM = E2_NUM 
				AND EK_PARCELA = E2_PARCELA 
				AND EK_FORNECE = E2_FORNECE 
				AND EK_LOJA = E2_LOJA
			WHERE 
				SEK.%notdel% 
				AND SE2.%notdel%
				AND EK_FORNECE BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% 
				AND EK_ORDPAGO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% 
				AND EK_EMISSAO BETWEEN %exp:dtos(MV_PAR05)% AND %exp:dtos(MV_PAR06)%
			ORDER BY 
				EK_ORDPAGO
	
		EndSql
	
		oSection:EndQuery()
	#ELSE
		//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	oSection:Print()
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	// xPutSx1(cPerg,"01","De proveedor?","De proveedor?","De proveedor?",         "mv_ch1","C",06,0,0,"G","","SA1","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"01","De proveedor?","De proveedor?","De proveedor?",         "mv_ch1","C",06,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A proveedor?","A proveedor?","A proveedor?",         "mv_ch2","C",06,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De orden de pago?","De orden de pago?","De orden de pago?",         "mv_ch1","C",06,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A orden de pago?","A orden de pago?","A orden de pago?",         "mv_ch2","C",06,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De fecha?","De fecha ?","De fecha ?",         "mv_ch1","D",08,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A fecha?","A fecha ?","A fecha?",         "mv_ch2","D",08,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"07","Qual Moeda?"   ,"¿Que Moneda?" ,"Which Currency?"   ,"MV_CH2","N",1,0,0,"C","","","","" ,"MV_PAR07","Moeda 1","Moneda 1","Currency 1","","Moeda 2","Moneda 2","Currency 2")
//	xPutSx1(cPerg,"08","De serie?","De serie?","De serie?",         "mv_ch1","C",03,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
//	xPutSx1(cPerg,"09","A serie?","A serie?","A serie?",         "mv_ch2","C",03,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,"","")
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

Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica
     Local aArea          := GetArea()
     Local aCabec     := {}
     Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
     Local titulo     := oReport:Title()
     Local page := oReport:Page()
     currency := GETMV("MV_MOEDA" + ALLTRIM(CVALTOCHAR(MV_PAR07)))

// __LOGOEMP__ imprime el logo de la empresa 

     aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar ; // + if(comparador==1," ",RptFolha+" "+cvaltochar(page));
                    , " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + currency + "        " + cChar + RptEmiss + " " + Dtoc(dDataBase);
                    , "Hora: "+ cvaltochar(TIME()) ;
                    , " " }             
     RestArea( aArea )
Return aCabec