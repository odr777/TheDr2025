#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"

#DEFINE AUCCC		1
#DEFINE AFECHA		2
#DEFINE ADOC  		3
#DEFINE ASERIE		4
#DEFINE APEDIDO		5
#DEFINE ACODCLI		6
#DEFINE ACLIENTE 	7
#DEFINE ALOJA		8
#DEFINE ATC			9
#DEFINE AALMEST		10

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ PCPAMUL  º Autor ³ Erick Etcheverry 	   º Data ³  28/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ REPORTE asignacion multiple 	 				  	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PCPAMUL()
	Local oReport
	Local cPerg := "PCPAMUL"
	If FindFunction("TRepInUse") .And. TRepInUse()
		//	pergunte("RGtoImport",.T.)
		CriaSX1(cPerg)	// Si no esta creada la crea

		Pergunte(cPerg,.f.)

		oReport := ReportDef()
		oReport:PrintDialog()
	Endif
Return Nil

Static Function ReportDef()
	Local oReport
	Local oSection1
	Local cPerg
	cPerg := "PCPAMUL"

	oReport := TReport():New("PCPAMUL","Asignacion multiple",cPerg,{|oReport| ReportPrint(oReport)},;
	"Este programa tiene como objetivo imprimir las asignaciones multiple")

	oReport:ShowParamPage()
	oReport:SetLandscape(.T.)
	oReport:lParamPage := .F.
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 7

	pergunte(cPerg,.F.)

	oSection2 := TRSection():New(oReport,"Asignacion de reservas",,)
	TRCell():New(oSection2,"FECHA_OP","SD4","FECHA_OP",PesqPict("SF2","F2_EMISSAO"),10)
	TRCell():New(oSection2,"PROD_TERMINADO","SD4",,)
	TRCell():New(oSection2,"ORDEN_PRODUCCION","SD4",,"",)
	TRCell():New(oSection2,"COMPONENTE","SD4",,"",)
	TRCell():New(oSection2,"DEPOSITO_RESERVA","SD4",,"",)
	TRCell():New(oSection2,"ALM_ESTANDAR","SB1",,"",)
	TRCell():New(oSection2,"SALDO","SD4",,"",)
	TRCell():New(oSection2,"RESERVA","SD4",,"",)
	TRCell():New(oSection2,"DISP","SD4",,"",)
	TRCell():New(oSection2,"RESERVA_POR_PROD","SD4",,,)
	TRCell():New(oSection2,"OBSERVACION","SD4",,,)

Return oReport

Static Function ReportPrint(oReport)
	Local oSection2  := oReport:Section(1)
	Local aDados[17]

	oSection2:Cell("FECHA_OP"):SetBlock( { || aDados[AUCCC] })
	oSection2:Cell("PROD_TERMINADO"):SetBlock( { || aDados[AFECHA] })
	oSection2:Cell("ORDEN_PRODUCCION"):SetBlock( { || aDados[ADOC] })
	oSection2:Cell("COMPONENTE"):SetBlock( { || aDados[ASERIE] })
	oSection2:Cell("DEPOSITO_RESERVA"):SetBlock( { || aDados[APEDIDO] })
	oSection2:Cell("SALDO"):SetBlock( { || aDados[ACODCLI] })
	oSection2:Cell("RESERVA"):SetBlock( { || aDados[ACLIENTE] })
	oSection2:Cell("DISP"):SetBlock( { || aDados[ALOJA] })
	oSection2:Cell("RESERVA_POR_PROD"):SetBlock( { || aDados[ATC] })
	oSection2:Cell("ALM_ESTANDAR"):SetBlock( { || aDados[AALMEST] })
	

	// *************** oSection2 **********************
	oSection2:Init()
	aFill(aDados,nil)

	cQuery2:= " SELECT B1_LOCPAD ALM_ESTANDAR, D4_DATA AS FECHA_OP,D4_PRODUTO AS PROD_TERMINADO,D4_OP AS ORDEN_PRODUCCION,D4_COD AS COMPONENTE, "
	cQuery2+= " D4_LOCAL AS DEPOSITO_RESERVA,B2_QATU AS SALDO,B2_QEMP AS RESERVA,(B2_QATU-B2_QEMP) AS DISP,B2_QEMP,D4_QUANT AS RESERVA_POR_PROD "
	cQuery2+= " FROM "+ RetSQLname('SB2') + " SB2 INNER JOIN "+ RetSQLname('SD4') + " SD4 "
	cQuery2+= " ON (B2_COD=D4_COD AND B2_LOCAL=D4_LOCAL) AND SD4.D_E_L_E_T_=''"
	cQuery2+= " INNER JOIN "+ RetSQLname('SB1') + " SB1 ON B1_COD = D4_COD "
	cQuery2+= " WHERE SB2.D_E_L_E_T_='' "
	cQuery2+= " AND D4_COD NOT LIKE 'ZZZ%' "
	cQuery2+= " AND D4_COD BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery2+= " AND D4_DATA BETWEEN '" + DTOS(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "
	cQuery2+= " AND D4_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery2+= " AND D4_OP BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery2+= " ORDER BY  D4_OP,B1_LOCPAD , D4_PRODUTO, D4_LOCAL "

	If __CUSERID = '000000'
		aviso("",cQuery2,{'ok'},,,,,.t.)
	EndIf
	cQuery2 := ChangeQuery(cQuery2)

	TCQUERY cQuery2 NEW ALIAS "TMP2"

	IF TMP2->(!EOF()) .AND. TMP2->(!BOF())
		TMP2->(dbGoTop())
	end

	oReport:SetMeter(TMP2->(RecCount()))
	nValMerc := 0
	i:=0

	nTotSu = 0
	nTotDes = 0
	nTotNet = 0
	nTotNetBs = 0

	While TMP2->(!Eof())
		aDados[AUCCC] :=  STOD(TMP2->FECHA_OP)
		aDados[AFECHA] := TMP2->PROD_TERMINADO
		aDados[ADOC] :=   TMP2->ORDEN_PRODUCCION
		aDados[ASERIE] := TMP2->COMPONENTE
		aDados[APEDIDO] :=    TMP2->DEPOSITO_RESERVA
		aDados[ACODCLI] :=    TMP2->SALDO
		aDados[ACLIENTE] :=    TMP2->RESERVA
		aDados[ALOJA] := TMP2->DISP
		aDados[ATC] := TMP2->RESERVA_POR_PROD
		aDados[AALMEST] := TMP2->ALM_ESTANDAR

		/*nTotSu +=	aDados[ATOTVE]
		nTotDes += aDados[ATOTDES]
		nTotNet += aDados[AVTANET]
		nTotNetBs += aDados[AVTANETBS]*/

		oSection2:PrintLine()
		aFill(aDados,nil)

		i++
		TMP2->(DbSkip())       // Avanza el puntero del registro en el archivo

	End
	/*nRow := oReport:Row()
	oReport:PrintText(Replicate("_",250), nRow, 10) // TOTAL GASTOS DE IMPORTACION)

	oReport:SkipLine()

	aDados[ADPOSTO] := "TOTAL GENERAL : "
	aDados[ATOTVE] := nTotSu
	aDados[ATOTDES] := nTotDes
	aDados[AVTANET] := nTotNet
	aDados[AVTANETBS] := nTotNetBs

	oSection2:PrintLine()
	aFill(aDados,nil)
	oReport:SkipLine()*/
	oReport:IncMeter()

	oSection2:Finish()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga indice ou consulta(Query)                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP

	TMP2->(dbCloseArea())

	#ENDIF
	oReport:EndPage()

Return Nil

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	Local aArea := GetArea()
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.
	Local cKey

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

Static Function CriaSX1(cPerg)  // Crear Preguntas
	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De sucursal Origen ?","De sucursal Origen ?","De sucursal Origen ?","mv_ch1","C",4,0,0,"G","","SM0","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A Sucursal Destino ?","A Sucursal Destino ?","A Sucursal Destino ?","mv_ch2","C",4,0,0,"G","","SM0","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De fecha ?","De fecha ?","De fecha ?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A fecha ?","A fecha ?","A fecha ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De Ord.Prd ?","De Ord.Prd?","De Ord.Prd?",         "mv_ch5","C",14,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Ord. Prod?","A Ord. Prod?","A Ord. Prod?",         "mv_ch6","C",14,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De Componente?","De Componente?","De Componente?",         "mv_ch7","C",30,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A Componente?","A Componente?","A Componente?",         "mv_ch8","C",30,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")

return
