#include "totvs.ch"
#include 'parmtype.ch'
#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor ³	Query	: Nicolas						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Compensaciones de cuentas por cobrar							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ REPCOMP()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Union														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			 ³06/01/2020³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function REPCOMP()
	Local oReport
	Private cPerg   := "REPCOMP"   // elija el nombre de la pregunta

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
	oReport	 := TReport():New("repcompe",cNombreProg,cPerg,{|oReport| PrintReport(oReport)},"Informe compensación")
	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera
	
	oSection := TRSection():New(oReport,"Compensacion",{"SE1"})
	oReport:SetTotalInLine(.F.)

	//Comienzan a elegir los campos que desean Mostrar

	/* TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold) */

	TRCell():New(oSection,"EL_RECIBO"	,"SEL","RECIBO",,9)
	TRCell():New(oSection,"EL_PREFIXO"	,"SEL","PREF")
	TRCell():New(oSection,"EL_NUMERO"	,"SEL","NUMERO")
	TRCell():New(oSection,"EL_TIPO"		,"SEL","TIPO")
	TRCell():New(oSection,"EL_CLIORIG"	,"SEL","CODIGO DE CLIENTE - TIENDA")
	// TRCell():New(oSection,"EL_PREFIXO"	,"SEL","NOMBRE PROVEEDOR")
	TRCell():New(oSection,"E1_VALOR"	,"SE1","VALOR ORIGEN TITULO","@E 9,999,999,999.99",/*Tamanho*/,/*lPixel*/,{|| xMoeda(QRYSEL->E1_VALOR,QRYSEL->E1_MOEDA,MV_PAR07,DDATABASE) })
	TRCell():New(oSection,"EL_ANTERIOR"	,"SEL","SALDO ANTERIOR","@E 9,999,999,999.99",/*Tamanho*/,/*lPixel*/,{|| 0 })
	TRCell():New(oSection,"EL_VALOR"	,"SEL","VALOR COMPENSADO","@E 9,999,999,999.99",/*Tamanho*/,/*lPixel*/,{|| xMoeda(QRYSEL->EL_VALOR,val(QRYSEL->EL_MOEDA),MV_PAR07,DDATABASE) })
	TRCell():New(oSection,"EL_VALOR"	,"SEL","SALDO DEL TITULO","@E 9,999,999,999.99",/*Tamanho*/,/*lPixel*/,{|| xMoeda(QRYSEL->E1_VALOR,QRYSEL->E1_MOEDA,MV_PAR07,DDATABASE) - xMoeda(QRYSEL->EL_VALOR,val(QRYSEL->EL_MOEDA),MV_PAR07,DDATABASE) })
	 	 
	oBreak = TRBreak():New(oSection,oSection:Cell("EL_RECIBO"),"Total de la compensacion")
	TRFunction():New(oSection:Cell("EL_VALOR") ,NIL,"SUM",oBreak,/*cTitle*/,"@E 9,999,999,999.99",{|| iif(alltrim(EL_TIPO) $'RA|NCC', xMoeda(EL_VALOR,val(EL_MOEDA),MV_PAR07,DDATABASE),0) },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
Return oReport

//Static Function prevAmount(cReceipt)
//	cQuery2 := "SELECT EL_CLIORIG + '-' + EL_LOJORIG EL_CLIORIG, EL_MOEDA, EL_NUMERO, EL_PREFIXO, EL_RECIBO, 0 EL_SALDO, EL_TIPO, EL_VALOR,E1_VALOR, E1_MOEDA, E1_SALDO, 0 ANTERIOR " +;
//		" FROM SEL010 SEL JOIN SE1010 SE1 ON EL_FILIAL = E1_FILIAL AND EL_NUMERO = E1_NUM AND EL_CLIORIG = E1_CLIENTE " +;
//		" WHERE SEL.D_E_L_E_T_ = '' AND SE1.D_E_L_E_T_ = '' AND EL_CLIORIG = '000222' AND EL_RECIBO < cReceipt " +;
//		" ORDER BY SEL.EL_RECIBO, SEL.EL_TIPO DESC"
//
//	cQuery2 := ChangeQuery(cQuery2)
//	
//	TCQUERY cQuery2 NEW ALIAS "TMP2"
//	
//	if TMP2->(!EOF()) .AND. TMP2->(!BOF())
//		TMP2->(dbGoTop())
//	end
//	
//	i:=0
//	nAmount := 0
//	
//	While TMP2->(!Eof())
//		if alltrim(EL_TIPO) $'RA|NCC'
//			nAmount += xMoeda(TMP2->EL_VALOR,val(TMP2->EL_MOEDA),MV_PAR07,DDATABASE)
//		endif
//	
//		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo
//	End
//Return

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local cFiltro  := ""

	#IFDEF TOP
		// Query
		oSection:BeginQuery()
		BeginSql alias "QRYSEL"
	
			SELECT 
				E1_MOEDA, 
				E1_VALOR, 
				0 EL_ANTERIOR, 
				EL_CLIORIG + '-' + EL_LOJORIG EL_CLIORIG, 
				EL_MOEDA, 
				EL_NUMERO, 
				EL_PREFIXO, 
				EL_RECIBO + EL_SERIE EL_RECIBO, 
				0 EL_SALDO, 
				EL_TIPO, 
				EL_VALOR 
			FROM 
				%table:SEL% SEL 
			JOIN 
				%table:SE1% SE1 
				ON EL_FILIAL = E1_FILIAL 
				AND EL_NUMERO = E1_NUM 
				AND EL_PARCELA = E1_PARCELA 
				AND EL_CLIORIG = E1_CLIENTE 
			WHERE 
				SEL.%notdel% 
				AND SE1.%notdel% 
				AND EL_CLIORIG BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% 
				AND EL_RECIBO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% 
				AND EL_EMISSAO BETWEEN %exp:dtos(MV_PAR05)% AND %exp:dtos(MV_PAR06)% 
				AND EL_SERIE BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09% 
			ORDER BY 
				EL_RECIBO, 
				EL_TIPO DESC
	
		EndSql
	
		oSection:EndQuery()
	#ELSE
		// Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF
	
	If __CUSERID = '000000'
		cQuery:=GetLastQuery()
		aviso("",cvaltochar(cQuery[2]`````),{'ok'},,,,,.t.)
	EndIf

	oSection:Print()
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSx1(cPerg,"01","De cliente?","De cliente?","De cliente?",         "mv_ch1","C",06,0,0,"G","","SA1","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A cliente?","A cliente?","A cliente?",         "mv_ch2","C",06,0,0,"G","","SA1","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De recibo?","De recibo?","De recibo?",         "mv_ch1","C",06,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A recibo?","A recibo?","A recibo?",         "mv_ch2","C",06,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De fecha?","De fecha ?","De fecha ?",         "mv_ch1","D",08,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A fecha?","A fecha ?","A fecha?",         "mv_ch2","D",08,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"07","Qual Moeda?"   ,"¿Que Moneda?" ,"Which Currency?"   ,"MV_CH2","N",1,0,0,"C","","","","" ,"MV_PAR07","Moeda 1","Moneda 1","Currency 1","","Moeda 2","Moneda 2","Currency 2")
	xPutSx1(cPerg,"08","De serie?","De serie?","De serie?",         "mv_ch1","C",03,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","A serie?","A serie?","A serie?",         "mv_ch2","C",03,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,"","")
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