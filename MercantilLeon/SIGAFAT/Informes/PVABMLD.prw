#include "totvs.ch"
#include 'parmtype.ch'
#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor ³	Query	: EET			 				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ejemplo Base de TREPORT() EET		 	   					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ REPOBASE()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Global														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³24/08/2016³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function PVABMLD()
	Local oReport
	PRIVATE cPerg   := "PVABMLD"   // elija el Nombre de la pregunta
	criasx1(cPerg)

	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Reporte de pedidos abiertos por producto"

	pergunte(cperg, .F.)
	oReport	 := TReport():New("PVABMLD",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte de pedidos abiertos por producto")

	oSection := TRSection():New(oReport,"Ventas",{"SN4"})
	oReport:SetTotalInLine(.F.)

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"C5_NUM"	,"SC5","PEDIDO",,10)
	TRCell():New(oSection,"C5_CLIENTE","SC5","COD CLIENTE",,6)
	TRCell():New(oSection,"A1_NOME"	,"SA1","CLIENTE",,TamSX3("A1_NOME")[1])
	TRCell():New(oSection,"C5_VEND1"	,"SC5","COD.VENDEDOR",,6)
	TRCell():New(oSection,"A3_NOME"	,"SA3","VENDEDOR",,TamSX3("A1_NOME")[1])
	TRCell():New(oSection,"C5_USRREG"	,"SC5","USUARIO",,18)
	TRCell():New(oSection,"C6_TES"		,"SC5","TIPO SALIDA",,3)
	TRCell():New(oSection,"C5_EMISSAO"	,"SC5","FECHA",PesqPict("SC5","C5_EMISSAO"))
	TRCell():New(oSection,"C5_DOCGER"	,"SC5","DOC. A GENERAR",,12)
	TRCell():New(oSection,"CANTIDAD","SC6","CANTIDAD",PesqPict("SC6","C6_QTDVEN"),TamSX3("C6_QTDVEN")[1])
	TRCell():New(oSection,"CENTREGA","SC6","CANT. ENTREGADA",PesqPict("SC6","C6_QTDVEN"),TamSX3("C6_QTDVEN")[1])

	TRCell():New(oSection,"C6_LOCAL","SC6","DEPOSITO",,TamSX3("C6_LOCAL")[1])
	TRCell():New(oSection,"C6_PRODUTO","SC6","COD PRODUCTO",,TamSX3("C6_PRODUTO")[1])
	TRCell():New(oSection,"B1_UCODFAB","SB1","COD FABRICA",,TamSX3("B1_UCODFAB")[1])
	TRCell():New(oSection,"B1_GRUPO","SB1","GRUPO",,TamSX3("B1_GRUPO")[1])
	TRCell():New(oSection,"B1_ESPECIF","SB1","DESC ESPECIFICA",,TamSX3("B1_ESPECIF")[1])
	TRCell():New(oSection,"B1_UESPEC2","SB1","DESC ESPECIF 2",,TamSX3("B1_UESPEC2")[1])
	TRCell():New(oSection,"C5_UOBSERV","SC5","OBSERVACION",,TamSX3("C5_UOBSERV")[1])

	

Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local aDados[20]

	oSection:Cell("C5_NUM"):SetBlock( { || aDados[1] })
	oSection:Cell("C5_CLIENTE"):SetBlock( { || aDados[2] })
	oSection:Cell("A1_NOME"):SetBlock( { || aDados[3] })
	oSection:Cell("C5_VEND1"):SetBlock( { || aDados[4] })
	oSection:Cell("A3_NOME"):SetBlock( { || aDados[5] })
	oSection:Cell("C5_USRREG"):SetBlock( { || aDados[6] })
	oSection:Cell("C6_TES"):SetBlock( { || aDados[7] })
	oSection:Cell("C5_EMISSAO"):SetBlock( { || aDados[8] })
	oSection:Cell("C5_DOCGER"):SetBlock( { || aDados[9] })
	oSection:Cell("CANTIDAD"):SetBlock( { || aDados[10] })
	oSection:Cell("CENTREGA"):SetBlock( { || aDados[11] })

	oSection:Cell("C6_LOCAL"):SetBlock( { || aDados[12] })
	oSection:Cell("C6_PRODUTO"):SetBlock( { || aDados[13] })
	oSection:Cell("B1_UCODFAB"):SetBlock( { || aDados[14] })
	oSection:Cell("B1_GRUPO"):SetBlock( { || aDados[15] })
	oSection:Cell("B1_ESPECIF"):SetBlock( { || aDados[16] })
	oSection:Cell("B1_UESPEC2"):SetBlock( { || aDados[17] })
	oSection:Cell("C5_UOBSERV"):SetBlock( { || aDados[18] })

	#IFDEF TOP
	// Query
	oSection:Init()
	aFill(aDados,nil)

	BeginSql alias "QRYC5PVA"
	 
	SELECT C5_NUM,
	C5_CLIENTE,A1_NOME,
	C5_VEND1,A3_NOME ,C5_USRREG,C6_TES ,C5_EMISSAO,CASE C5_DOCGER WHEN '1' THEN 'FACTURA'
	WHEN '2' THEN 'REMITO' WHEN '3' THEN 'VENTA FUTURA' ELSE '' END C5_DOCGER,SUM(C6_QTDVEN) CANTIDAD, SUM(C6_QTDENT) CENTREGA,
	C6_LOCAL,C6_PRODUTO,B1_UCODFAB,B1_GRUPO,B1_ESPECIF,B1_UESPEC2,C5_UOBSERV
	FROM
	%table:SC5% SC5 (NOLOCK)
	JOIN
	%table:SC6% SC6 (NOLOCK)
	ON C6_NUM = C5_NUM AND C5_CLIENTE = C6_CLI AND C6_LOJA = C5_LOJACLI AND C5_FILIAL = C6_FILIAL
	AND C6_LOCAL BETWEEN %exp:MV_PAR05%  AND %exp:MV_PAR06% 
	AND C6_TES BETWEEN %exp:MV_PAR13%  AND %exp:MV_PAR14% 
	AND C6_QTDENT <> C6_QTDVEN
	AND SC6.%notdel%
	LEFT JOIN
	%table:SA3% SA3 (NOLOCK)
	ON A3_COD = C5_VEND1 AND SA3.%notdel%
	LEFT JOIN
	%table:SA1% SA1 (NOLOCK)
	ON A1_COD = C5_CLIENTE AND SA1.%notdel%
	JOIN %table:SB1% SB1 (NOLOCK) ON B1_COD = C6_PRODUTO AND SB1.%notdel%
	AND B1_GRUPO BETWEEN %exp:MV_PAR03%  AND %exp:MV_PAR04% 
	AND B1_COD BETWEEN %exp:MV_PAR01%  AND %exp:MV_PAR02% 
	WHERE 
	C5_EMISSAO BETWEEN %exp:MV_PAR11%  AND %exp:MV_PAR12%  AND SC5.%notdel%
	AND C5_VEND1 BETWEEN %exp:MV_PAR07%  AND %exp:MV_PAR08% 
	AND C5_CLIENTE BETWEEN %exp:MV_PAR09%  AND %exp:MV_PAR10% 
	GROUP BY C5_NUM,
	C5_CLIENTE,A1_NOME,
	C5_VEND1,A3_NOME,C5_USRREG,C6_TES,C5_EMISSAO,C5_DOCGER,C6_LOCAL,C6_PRODUTO,B1_UCODFAB,B1_GRUPO,B1_ESPECIF,B1_UESPEC2,C5_UOBSERV
	ORDER BY SC5.C5_NUM,SC5.C5_EMISSAO
	
	EndSql

	//cQuery:=GetLastQuery()

	/*If __CUSERID = '000000'
		aviso("",cvaltochar(cQuery[2]`````),{'ok'},,,,,.t.)
	EndIf*/

	//nSub:= 0
	//nSubCant := 0

	While QRYC5PVA->(!Eof())

		aDados[1]:= alltrim(QRYC5PVA->C5_NUM)

		aDados[2]:= alltrim(QRYC5PVA->C5_CLIENTE)
		aDados[3]:= alltrim(QRYC5PVA->A1_NOME)

		aDados[4]:= QRYC5PVA->C5_VEND1
		aDados[5]:= QRYC5PVA->A3_NOME
		aDados[6]:= QRYC5PVA->C5_USRREG
		aDados[7]:= QRYC5PVA->C6_TES
		aDados[8]:= STOD(QRYC5PVA->C5_EMISSAO)
		aDados[9]:= QRYC5PVA->C5_DOCGER
		aDados[10]:= QRYC5PVA->CANTIDAD
		aDados[11]:= QRYC5PVA->CENTREGA
		aDados[12]:= QRYC5PVA->C6_LOCAL
		aDados[13]:= QRYC5PVA->C6_PRODUTO
		aDados[14]:= QRYC5PVA->B1_UCODFAB
		aDados[15]:= QRYC5PVA->B1_GRUPO
		aDados[16]:= QRYC5PVA->B1_ESPECIF
		aDados[17]:= QRYC5PVA->B1_UESPEC2
		aDados[18]:= QRYC5PVA->C5_UOBSERV
		

		//nSub += QRYC5PVA->CENTREGA
		//nSubCant += QRYC5PVA->CANTIDAD


		oSection:PrintLine()
		aFill(aDados,nil)
		QRYC5PVA->(DbSkip())

	enddo

	/*cLinha := Replicate("_",400)
	nRow := oReport:Row()
	oReport:PrintText(cLinha, nRow, 20)
	oReport:SkipLine()
	aDados[1] := "Producto:"
	aDados[3] := MV_PAR01 + " - "  + Posicione("SB1",1,xFilial("SB1") + MV_PAR01 ,"B1_ESPECIF")
	aDados[4] := "Total a entregar: "
	aDados[9] := nSubCant - nSub
	oSection:PrintLine()
	aFill(aDados,nil)*/


	#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	oSection:Finish()

	QRYC5PVA->(dbCloseArea())

	oReport:EndPage()

Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSx1(cPerg,"01","De Producto?","De Producto?","De Producto?",         "mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A Producto?","A Producto?","A Producto?",         "mv_ch1","C",15,0,0,"G","","SB1","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"03","De grupo ?","De grupo?","De grupo?",         "mv_ch5","C",04,0,0,"G","","SBM","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A grupo?","A grupo?","A grupo?",         "mv_ch6","C",04,0,0,"G","","SBM","","","mv_par04   ",""       ,""            ,""        ,""     ,"","")
    
	xPutSx1(cPerg,"05","De Deposito ?","De Deposito ?","De Deposito ?", "mv_ch7","C",2,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Deposito ?","A Deposito ?","A Deposito	 ?",  "mv_ch8","C",2,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"07","De vendedor?","De vendedor?","De vendedor?",         "mv_ch1","C",06,0,0,"G","","SA3","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A vendedor?","A vendedor?","A vendedor?",         "mv_ch2","C",06,0,0,"G","","SA3","","","mv_par08",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"09","De cliente?","De cliente?","De cliente?",         "mv_ch1","C",06,0,0,"G","","SA1","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A cliente?","A cliente?","A cliente?",         "mv_ch2","C",06,0,0,"G","","SA1","","","mv_par10",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"11","De fecha?","De fecha?","De fecha?",         "mv_ch1","D",08,0,0,"G","","","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A fecha?","A fecha?","A fecha?",         "mv_ch2","D",08,0,0,"G","","","","","mv_par12",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"13","De tes?","De tes?","De tes?",         "mv_ch1","C",03,0,0,"G","","SF4","","","mv_par13",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"14","A tes?","A tes?","A tes?",         "mv_ch2","C",03,0,0,"G","","SF4","","","mv_par14",""       ,""            ,""        ,""     ,"","")
	
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
