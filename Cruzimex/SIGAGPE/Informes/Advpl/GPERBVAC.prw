#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

#DEFINE CODFOLVAC	'0072'//Codfol de concepto de vacacion

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ GPERBVAC ณDenar Terrazas				   บ Data ณ 19/06/2019บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Boleta de vacaciones                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ                                                            บฑฑ
ฑฑฬออออออออออุอออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TdeP                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function GPERBVAC(cId)
	Local cTitulo:= "Boleta de vacaci๓n"
	Local cPerg := "GPERBVAC"
	Local bImprimir:= .F.
	Private oPrint	:= NIL
	Private oFont10	:= NIL

	CriaSX1(cPerg)
	if(cId == NIL)
		PERGUNTE(cPerg, .T.)
	else
		PERGUNTE(cPerg, .F.)
	endIf

	oPrint := TMSPrinter():New(cTitulo)
	oPrint:Setup()
	oPrint:SetCurrentPrinterInUse()
	oPrint:SetPortrait()
	oPrint:setPaperSize(DMPAPER_LETTER)

	DEFINE FONT oFont08	NAME "Arial" SIZE 0,08 OF oPrint
	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 OF oPrint
	DEFINE FONT oFont09N NAME "Arial" SIZE 0,09 Bold OF oPrint
	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrint
	DEFINE FONT oFont10N NAME "Arial" SIZE 0,10 Bold  OF oPrint
	DEFINE FONT oFont105N NAME "Arial" SIZE 0,10.5 Bold  OF oPrint
	DEFINE FONT oFont11 NAME "Arial" SIZE 0,11 OF oPrint
	DEFINE FONT oFont11N NAME "Arial" SIZE 0,11 Bold  OF oPrint
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrint
	DEFINE FONT oFont12N NAME "Arial" SIZE 0,12 Bold  OF oPrint
	DEFINE FONT oFont13 NAME "Arial" SIZE 0,13 OF oPrint
	DEFINE FONT oFont13N NAME "Arial" SIZE 0,13 Bold  OF oPrint
	DEFINE FONT oFont15 NAME "Arial" SIZE 0,15 OF oPrint
	DEFINE FONT oFont15N NAME "Arial" SIZE 0,15 Bold  OF oPrint
	DEFINE FONT oFont20N NAME "Arial" SIZE 0,20 Bold  OF oPrint
	DEFINE FONT oFont24N NAME "Arial" SIZE 0,24 Bold  OF oPrint
	DEFINE FONT oFont32N NAME "Arial" SIZE 0,32 OF oPrint
	DEFINE FONT oFont40N NAME "Arial" SIZE 0,40 OF oPrint

	ejecQuery(cId,cTitulo,bImprimir)
return

static function ejecQuery(cId,cTitulo,bImprimir)
	Local aDados   := {}
	Local bSw	   := .T.
	Local cMsgFat  := ""
	Local NextArea := GetNextAlias()
	Local cSql	   := ""

	cSql	:= " SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CODFUNC, RA_ADMISSA, R8_DATAINI, R8_DATAFIM, R8_DURACAO, "
	cSql	+= " R8_DTBLEG, R8_DATA, R8_NUMID, R8_CODMEMO, RJ_DESC, CTT_DESC01, R8_PD, R8_TIPOAFA, RV_CODFOL "
	cSql	+= " FROM " + RetSqlName("SRA") + " SRA "
	cSql	+= " JOIN " + RetSqlName("SR8") + " SR8 ON SRA.RA_FILIAL = R8_FILIAL AND SRA.RA_MAT = SR8.R8_MAT "
	cSql	+= " JOIN " + RetSqlName("SRJ") + " SRJ ON SRA.RA_CODFUNC = RJ_FUNCAO "
	cSql	+= " JOIN " + RetSqlName("CTT") + " CTT ON SRA.RA_CC = CTT.CTT_CUSTO "
	cSql	+= " JOIN " + RetSqlName("SRV") + " SRV ON SR8.R8_PD = SRV.RV_COD "
	if(cId == NIL)
		cSql	+= " WHERE RA_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"
		cSql	+= " AND RA_MAT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
		cSql	+= " AND SR8.R8_DATAINI BETWEEN '" + DTOS(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "'"
	else
		cSql	+= " WHERE R8_NUMID = '" + cId + "'"
	endIf
	cSql	+= " AND SRA.D_E_L_E_T_ <> '*' "
	cSql	+= " AND SR8.D_E_L_E_T_ <> '*' "
	cSql	+= " AND SRJ.D_E_L_E_T_ <> '*' "
	cSql	+= " AND CTT.D_E_L_E_T_ <> '*' "

	//aviso("",cSql,{'ok'},,,,,.t.)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	While !Eof()

		AADD(aDados, RA_MAT)		  		//1
		AADD(aDados, RA_CIC)		  		//2
		AADD(aDados, RA_CODFUNC)		  	//3
		AADD(aDados, RA_ADMISSA)		  	//4
		AADD(aDados, R8_DATAINI)		  	//5
		AADD(aDados, R8_DATAFIM)		  	//6
		AADD(aDados, R8_DURACAO)		  	//7
		AADD(aDados, R8_DTBLEG)		  		//8
		AADD(aDados, R8_DATA)		  		//9
		AADD(aDados, R8_NUMID)		  		//10
		AADD(aDados, R8_CODMEMO)		  	//11
		AADD(aDados, RA_NOME)		  		//12
		AADD(aDados, RJ_DESC)		  		//13
		AADD(aDados, saldoVac(RA_FILIAL, RA_MAT))	//14
		AADD(aDados, CTT_DESC01)		  		//15
		cPdDesc:= TRIM(Posicione("RCM", 1, xFilial("RCM") + R8_TIPOAFA, "RCM->RCM_DESCRI"))
		AADD(aDados, cPdDesc)	//16
		AADD(aDados, RV_CODFOL)	//17
		AADD(aDados, RA_FILIAL)	//18

		oPrint:StartPage()
		impBoleta(0, aDados)
		//impBoleta(1600, aDados)//Copia en la misma Hoja
		oPrint:EndPage()

		dbSelectArea(NextArea)
		aDados:={}
		DbSkip()
	EndDo
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
	oPrint:Refresh()
	If bImprimir
		oPrint:Print()
	Else
		oPrint:Preview()
	EndIf

	oPrint:End()//Fin de la impresion

return

Static Function impBoleta(nLinB, aDados)
	Local i
	Local cStartPath:= GetSrvProfString("Startpath","")
	Local cFLogo	:= cStartPath + "lgrl" + TRIM(SM0->M0_CODFIL) + ".bmp" 

	oPrint:Say(nLinB + 220, 840 ,"PARTE"  ,oFont13N)
	oPrint:Say(nLinB + 340, 840 ,aDados[16]  ,oFont13N)

	oPrint:Box(nLinB + 100 , 50 , nLinB + 500 , 2500) // cuadro
	oPrint:Box(nLinB + 100 , 800, nLinB + 500 , 800) // line
	oPrint:Box(nLinB + 100 , 1700,nLinB + 500 , 1700) // line

	//cuadros
	oPrint:Box(nLinB + 500, 50 , nLinB + 1350 , 2500)

	//line horizontal
	oPrint:Box(nLinB + 700 , 50 ,nLinB + 700, 2500)
	oPrint:Box(nLinB + 900 , 50 ,nLinB + 900, 2500)
	oPrint:Box(nLinB + 1050 , 50 ,nLinB + 1050, 2500)

	oPrint:Say(nLinB + 180, 80 ,TRIM(FWCompanyName()) ,oFont09)
	
	oPrint:SayBitmap(nLinB+260,090, cFLogo,500,170)
	

	oPrint:Say(nLinB + 220, 1750 ,"Nro. Parte: " ,oFont11N)
	oPrint:Say(nLinB + 220, 2000 , aDados[10] ,oFont11)
	oPrint:Say(nLinB + 320, 1750 ,"Fecha parte: " ,oFont11N)
	oPrint:Say(nLinB + 320, 2035 ,DTOC(STOD(aDados[9])),oFont11)

	//cNrEmplea := posicione("RCC",1,xFilial("RCC") + "S007","RCC_CONTEU")
	//cNrEmplea := SubStr(cNrEmplea,11,10)
	//oPrint:Say(nLinB + 280, 80 ,"Nro. Patronal :  "+ Alltrim(cNrEmplea) ,oFont09)

	oPrint:Say(nLinB + 550, 80 ,"Empleado : ",oFont09N)
	oPrint:Say(nLinB + 550, 300 , aDados[1] + "   " + aDados[12] ,oFont09)

	oPrint:Say(nLinB + 550 , 1800 ,"Fecha de Ingreso : " ,oFont09N)
	oPrint:Say(nLinB + 550 , 2100 , DTOC(STOD(aDados[4])) , oFont09)

	oPrint:Say(nLinB + 630, 80 ,"Funci๓n : ",oFont09N)
	oPrint:Say(nLinB + 630, 300 ,Alltrim(aDados[13]) ,oFont09)

	oPrint:Say(nLinB + 630, 900 ,"C. Costo : ",oFont09N)
	oPrint:Say(nLinB + 630, 1120 ,Alltrim(aDados[15]) ,oFont09)

	oPrint:Say(nLinB + 630, 2000 ,"CI : "+ aDados[2],oFont09)

	oPrint:Say(nLinB + 750, 80 ,"Desde el :" ,oFont09N)
	oPrint:Say(nLinB + 750, 250 ,DTOC(STOD(aDados[5])),oFont09)
	oPrint:Say(nLinB + 750, 900 ,"Hasta el :" ,oFont09N)
	oPrint:Say(nLinB + 750, 1050 ,DTOC(STOD(aDados[6])),oFont09)

	oPrint:Say(nLinB + 830, 80 ,"Nro. de Dias :" ,oFont09N)
	oPrint:Say(nLinB + 830, 300 , TRIM(cValtoChar(aDados[7])) ,oFont09)

	IF(aDados[17] == CODFOLVAC)
		oPrint:Say(nLinB + 830, 900 ,"Nuevo Saldo : " ,oFont09N)
		oPrint:Say(nLinB + 830, 1300 , cValToChar(aDados[14]) ,oFont09)

		oPrint:Say(nLinB + 830, 1800 ,"Gesti๓n de vacaci๓n :" ,oFont09N)
	endIf

	oPrint:Say(nLinB + 950, 80 ,"Fecha Autorizaci๓n : " ,oFont09N)
	oPrint:Say(nLinB + 950, 430 ,DTOC(STOD(aDados[9])),oFont09)

	//	oPrint:Say(nLinB + 1100 , 1800 ,"Fecha de Ingreso : " ,oFont09N)
	//	oPrint:Say(nLinB + 1100 , 2100 , DTOC(STOD(aDados[4])) , oFont09)
	oPrint:Say(nLinB + 1100, 80 ,"Observaci๓n: " ,oFont09N)
	//     getObs(filial, codigoMemo)
	aObs:= getObs(aDados[18], aDados[11])
	nLine:= 0
	for i:= 1 to Len(aObs)
		oPrint:Say(nLinB + 1100 + nLine , 310 , aObs[i] , oFont09)
		nLine+= 30
	next i
	//	oPrint:Say(nLinB + 1260, 80 ,"A CUENTA DE VACACIำN. DIAS DE SALDO : " + cValToChar(aDados[14]) ,oFont09N)

	oPrint:Box(nLinB + 1500 , 50 , nLinB + 1500, 575)
	oPrint:Say(nLinB + 1530 , 100 ,"Registrado por " + UsrRetName(RetCodUsr()) ,oFont09N)
	oPrint:Box(nLinB + 1500 , 650 , nLinB + 1500, 1215)
	oPrint:Say(nLinB + 1530 , 810 ,"Autorizado por" ,oFont09N)
	oPrint:Box(nLinB + 1500 , 1285 ,nLinB + 1500, 1850)
	oPrint:Say(nLinB + 1530 , 1495 ,"VO.BO" ,oFont09N)
	oPrint:Box(nLinB + 1500 , 1925 ,nLinB + 1500, 2500)
	oPrint:Say(nLinB + 1530 , 2105  ,"Empleado(a)" ,oFont09N)

Return Nil

/**
*
* @author: Denar Terrazas Parada
* @since: 09/05/2019
* @description: Funcion que devuelve el saldo de vacaciones
* @parametro: cSuc -> Sucursal del empleado
cMat -> Matricula del empleado
*/
static function saldoVac(cSuc, cMat)
	Local aArea:= getArea()
	Local nRet:= 0
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
		SELECT (COALESCE(SUM(RF_DFERVAT),0) + COALESCE(SUM(RF_DFERAAT),0) - COALESCE(SUM(R8_DURACAO),0)) SALDO
		FROM %table:SRF% SRF
		LEFT JOIN %table:SR8% SR8 ON SRF.RF_FILIAL = SR8.R8_FILIAL AND SRF.RF_MAT = SR8.R8_MAT AND SR8.%notdel%
		WHERE RF_FILIAL = %exp:cSuc%
		AND RF_MAT = %exp:cMat%
		AND SRF.%notdel%
	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		nRet:= (OrdenConsul)->SALDO
	endIf
	restArea(aArea)
return nRet

/**
*
* @author: Denar Terrazas Parada
* @since: 10/07/2019
* @description: Funcion que devuelve las observaciones dadas en la ausencia
* @parametro: cSuc -> Sucursal del empleado
cCodMemo -> Codigo del campo memo donde se guarda las observaciones
*/
static function getObs(cSuc, cCodMemo)
	Local aArea:= getArea()
	Local cTexto:= ""
	Local aRet:= {}

	dbSelectArea("RDY")
	RDY-> (dbSetOrder(2))
	if ( RDY-> (dbSeek(cSuc + cCodMemo)) )
		while ( RDY->(!Eof()) .and. cSuc == RDY->RDY_FILTAB .and. cCodMemo == RDY->RDY_CHAVE)
			cTexto+= TRIM(RDY-> RDY_TEXTO) + " "
			RDY->(dbSkip())
			if(RDY->(EOF()))
				AADD(aRet, TRIM(cTexto))
			else
				cTexto+= TRIM(RDY-> RDY_TEXTO)
				AADD(aRet, TRIM(cTexto))
				cTexto:= ""
				RDY->(dbSkip())
			endif
		Enddo
	endIf
	RDY-> (dbCloseArea())
	restArea(aArea)
return aRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg, "01", "Filial De ?" , "ฟDe Sucursal ?", "Branch From ?", "MV_CH1","C",04,0,0,"G","","SM0","033","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "02", "Filial Ate ?" , "ฟA Sucursal ?", "Branch to ?", "MV_CH2","C",04,0,0,"G","naovazio()","SM0","033","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "03", "Matricula De ?" , "ฟDe matricula ?", "Registration From ?", "MV_CH3","C",06,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "04", "Matricula Ate ?" , "ฟA matricula ?", "Registration To ?", "MV_CH4","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "05", "Data De ?" , "ฟDe Fecha ?", "From Date ?", "MV_CH5","D",08,0,0,"G","NaoVazio()","","","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg, "06", "Data Ate ?" , "ฟA Fecha ?", "To Date ?", "MV_CH6","D",08,0,0,"G","NaoVazio()","","","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
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

	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
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