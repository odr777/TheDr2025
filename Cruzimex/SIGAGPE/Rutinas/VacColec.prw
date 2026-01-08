#INCLUDE "PROTHEUS.CH"
#Include 'topConn.ch'
#DEFINE VIGENTES	" A*FT"
#DEFINE DESPEDIDOS	"**D**"
#DEFINE TODOS		" ADFT"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVacColec  บAutor  ณNahim Terrazas	 บFecha ณ  18/11/2019 	บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ejecuta vacaciones empleado por empleado.			  	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia		                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VacColec()
	Local cTitulo:= "Vacaciones Colectivas"
	local nReg,nX
	Private cAliasFun := GetNextAlias()
	Private cConcepto
	Private cTipoAFa
	Private cLogGenerado := ""
	cPerg   := "VACCOLEC"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)
	cGenera := pergunte(cPerg,.T.)

	nTamProc := GetSx3Cache( "RCJ_CODIGO", "X3_TAMANHO" )
	cProcesso := MV_PAR01
	nSituacao  	:= MV_PAR14

	cSitQuery	:= ""
	if(val(nSituacao) == 1)//Empleados vigentes
		cSituacao:= VIGENTES
	elseIf(val(nSituacao) == 2)//Empleado despedidos
		cSituacao:= DESPEDIDOS
	else//Todos los empleados
		cSituacao:= TODOS
	endIf
	//If !Empty(cSituacao)
	For nReg:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cSituacao)
			cSitQuery += ","
		Endif
	Next nReg
	cSitQuery := "%" + cSitQuery + "%"

	cCatQuery	:= ""
	//If !Empty(cSituacao)
	cCategoria := MV_PAR15
	For nReg:=1 to Len(cCategoria)
		cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cCategoria)
			cCatQuery += ","
		Endif
	Next nReg
	cCatQuery := "%" + cCatQuery + "%"

	For nX := 1 to Len(Alltrim(cProcesso)) Step 5
		If Len(Subs(cProcesso,nX,5)) < nTamProc
			cAuxPrc := Subs(cProcesso,nX,5) + Space(nTamProc - Len(Subs(cProcesso,nX,5)))
		Else
			cAuxPrc := Subs(cProcesso,nX,5)
		EndIf
		//		cProcs += "'" + cAuxPrc + "',"
	Next nX
	//	cProcs := "%" + Substr( cProcs, 1, Len(cProcs)-1) + "%"

	BeginSql alias cAliasFun

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,
		SRA.RA_NOME,	SRA.RA_NOMECMP, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,		SRA.RA_SALARIO,		SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,		SRA.RA_CIC,  		SRA.RA_UFCI,			SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,		SRA.RA_ADMISSA,		SRA.RA_CODFUNC,	SRA.RA_SEGUROS,
		SRA.RA_TNOTRAB,			SRA.RA_PROCES,		SRA.RA_HRSMES,		SRA.RA_CARGO
		FROM %table:SRA% SRA
		WHERE SRA.RA_PROCES = %Exp:MV_PAR01% AND
		SRA.RA_FILIAL BETWEEN %Exp:MV_PAR02% AND %Exp:MV_PAR03% AND
		SRA.RA_MAT    BETWEEN %Exp:MV_PAR04% AND %Exp:MV_PAR05% AND
		SRA.RA_CC     BETWEEN %Exp:MV_PAR06%  AND %Exp:MV_PAR07%  AND
		SRA.RA_DEPTO BETWEEN %Exp:MV_PAR08% AND %Exp:MV_PAR09% AND
		SRA.RA_TNOTRAB     BETWEEN %Exp:MV_PAR10%  AND %Exp:MV_PAR11%  AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRA.%notDel%

	EndSql

	// obtiene informaci๓n Concepto de vacaciones y tipo afa
	cConcepto := GetAdvFVal("SRV","RV_COD",xFilial("SRV")+"0072",2,"")
	//	RCM_FILIAL+RCM_PD
	cTipoAFa := GetAdvFVal("RCM","RCM_TIPO",xFilial("RCM")+cConcepto,3,"")

	cQuery:=GetLastQuery()
//	Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.T.)//   usar este en esste caso cuando es BEGIN SQL

	(cAliasFun)->( dbGoTop())
	Do While (cAliasFun)->(!Eof())
		// probando con el empleado
		U_GP240INC()
		(cAliasFun)->(DbSkip())
	EndDo

	if !empty(cLogGenerado)
		Aviso("Log",cLogGenerado,{"si"},,,,,.T.)//   usar este en esste caso cuando es BEGIN SQL
	else
		Aviso(cTitulo,"Proceso ejecutado con ้xito!",{'Ok'})
	endif

return

/*
User Function GP240INC()
Local aCampos := {}
Local aItens := {}
Local aCposCab := {}

PRIVATE lMsErroAuto := .F.

aAdd(aCposCab, {"RA_FILIAL", (cAliasFun)->RA_FILIAL, NIL})
aAdd(aCposCab, {"RA_MAT", (cAliasFun)->RA_MAT}, NIL)

AADD(aCampos , {"R8_FILIAL" ,(cAliasFun)->RA_FILIAL, NIL})
AADD(aCampos , {"R8_MAT" , (cAliasFun)->RA_MAT , NIL})
AADD(aCampos , {"R8_DATA" , DATE() , NIL}) // DESDE QUE SE APROBำ LA
AADD(aCampos , {"R8_TIPOAFA" ,cTipoAfa , NIL}) // VEO QUE ESTม CON 'VAC'
AADD(aCampos , {"R8_PD" , cConcepto , NIL}) // '005' SRV sacar de la SRV
AADD(aCampos , {"R8_DATAINI", MV_PAR12 , NIL})
AADD(aCampos , {"R8_DURACAO" , MV_PAR13 , NIL})
//	AADD(aCampos , {"R8_DATAFIM", DATE()+1 , NIL}) en teorํa deberํa calcularlo
if empty((cAliasFun)->R8_SEQ)
AADD(aCampos , {"R8_SEQ", "001" , NIL})
ELSE
AADD(aCampos , {"R8_SEQ", (cAliasFun)->R8_SEQ, NIL})
ENDIF

aAdd(aItens , aCampos)

MsExecAuto( { |a,x,y,z| Gpea240(a,x,y,z)}, NIL , aCposCab , aItens , 3) // 3 - Incluir, 4 - alterar

If lMsErroAuto
cLogGenerado += "Error en Empleado " + (cAliasFun)->RA_FILIAL + " - " + (cAliasFun)->RA_MAT
alert(MostraErro())
Endif

Return
*/

User Function GP240INC()
	Local oModel    := Nil
	Local oSubMdl   := Nil
	Local nI 		:= 0
	Local aCab 		:= {}
	Local aItem		:= {}
	Local aItens	:={}
	Local aSeek		:= {}
	Local nTam		:= TamSx3("R8_SEQ")[1]
	Local nSeq		:= 0
	Local nOp		:= 3

	//	Local cRAFilial := "01"
	//	Local cMat      := "00010"
	Local dToday    := Date()

	Private cProcesso := ""

	//aEval({'SRA','SR8'},{|x|CHKFILE(x)})
	aEval({'SR8'},{|x|CHKFILE(x)})

	oModel := FWLoadModel("GPEA240")
	oModel:SetOperation(nOp)
	SRA->(dbGoTop())
	SRA->(DbSetOrder(1))
	If(SRA->(DbSeek( (cAliasFun)->RA_FILIAL + (cAliasFun)->RA_MAT))) // Se posiciona sobre el registro correcto
		if(oModel:Activate())
			oSubMdl := oModel:GetModel("GPEA240_SR8")
			if(oSubMdl:Length() > 1)
				nSeq := oSubMdl:AddLine()
			else
				if(oSubMdl:IsInserted())
					nSeq := 1
				else
					nSeq := oSubMdl:AddLine()
				endIf
			endIf
			//			nSeq := 1
			oSubMdl:SetValue("R8_FILIAL", (cAliasFun)->RA_FILIAL)
			oSubMdl:SetValue("R8_MAT"   , (cAliasFun)->RA_MAT)
			oSubMdl:SetValue("R8_DATA"  , dToday)
			oSubMdl:SetValue("R8_SEQ"   , StrZero(nSeq,nTam))
			oSubMdl:SetValue("R8_TIPOAFA"   , cTipoAfa)
			oSubMdl:SetValue("R8_PD"        , cConcepto)
			oSubMdl:SetValue("R8_DATAINI"   , MV_PAR12)
			//oSubMdl:SetValue("R8_DATAFIM"   , dToday)
			oSubMdl:SetValue("R8_DURACAO"   , MV_PAR13)
			oSubMdl:SetValue("R8_PROCES"    , (cAliasFun)->RA_PROCES)
			//			oSubMdl:SetValue("R8_PER"       , "201909")
			//		oSubMdl:SetValue("R8_PER"       , AnoMes(MV_PAR12))
			//			oSubMdl
			//oSubMdl:SetValue("R8_NUMPAGO"   , "01")

			if(oModel:VldData())
				//				alert("COMMIT DATA")
				//				U_zArrToTxt(oSubMdl:acols[1],,)
				oModel:CommitData()
			else
				aLog := oModel:GetErrorMessage()
				/*
				[1] ExpC: Id do submodelo de origem
				[2] ExpC: Id do campo de origem
				[3] ExpC: Id do submodelo de erro
				[4] ExpC: Id do campo de erro
				[5] ExpC: Id do erro
				[6] ExpC: mensagem do erro
				[7] ExpC: mensagem da solu็ใo
				[8] ExpX: Valor atribuido
				[9] ExpX: Valor anterior
				*/
				cLogGenerado+= "ERROR MATRICULA - " + (cAliasFun)->RA_MAT + " " + U_zArrToTxt( aLog ,,)//aLog[6] + " --> " + aLog[7]
				aEval(aLog,{|x|ConOut(x)})
			endIf
		endIf
	else
		cLogGenerado+= "No se encontr๓ la matrํcula : " + (cAliasFun)->RA_MAT//	aLog[6] + " --> " + aLog[7]
	endif

Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","ฟProceso?" 				, "ฟProceso?"				,"ฟProceso?"			,"MV_CH1","C",05,0,0,"G","","RCJ","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","ฟDe Sucursal?"			, "ฟDe Sucursal?"			,"ฟDe Sucursal?"		,"MV_CH2","C",04,0,0,"G","","SM0","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","ฟA Sucursal?" 			, "ฟA Sucursal?"			,"ฟA Sucursal?"			,"MV_CH3","C",04,0,0,"G","","SM0","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","ฟDe Matrํcula?" 		, "ฟDe Matrํcula?"			,"ฟDe Matrํcula?"		,"MV_CH4","C",06,0,0,"G","","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","ฟA Matrํcula?" 			, "ฟA Matrํcula?"			,"ฟA Matrํcula?"		,"MV_CH5","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","ฟDe Centro de costo?" 	, "ฟDe Centro de costo?"	,"ฟDe Centro de costo?"	,"MV_CH6","C",11,0,0,"G","","CTT","004","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","ฟA Centro de costo?" 	, "ฟA Centro de costo?"		,"ฟA Centro de costo?"	,"MV_CH7","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","ฟDe Departamento?" 		, "ฟDe Departamento?"		,"ฟDe Departamento?"	,"MV_CH8","C",09,0,0,"G","","SQB","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","ฟA Departamento?" 		, "ฟA Departamento?"		,"ฟA Departamento?"		,"MV_CH9","C",09,0,0,"G","NaoVazio()","SQB","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","ฟDe Turno?" 			, "ฟDe Turno?"				,"ฟDe Turno?"			,"MV_CHA","C",03,0,0,"G","","SR6","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","ฟA Turno?" 				, "ฟA Turno?"				,"ฟA Turno?"			,"MV_CHB","C",03,0,0,"G","NaoVazio()","SR6","","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"12","ฟDe Fecha?" 			, "ฟDe Fecha?"				,"ฟDe Fecha?"			,"MV_CHE","D",08,0,0,"G","","","","","MV_PAR12",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"13","Dํas de Vacaciones" 				, "Dํas de Vacaciones"				,"Dํas de Vacaciones"			,"MV_CHF","N",03,0,0,"G","","","","","MV_PAR13",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"14","ฟSituaciones por imprimir?" , "ฟSituaciones por imprimir?"	,"ฟSituaciones por imprimir?"	,"MV_CH10","C",05,0,0,"G","fSituacao()","","","","MV_PAR14",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"15","ฟCategorํas por imprimir?" 	, "ฟCategorํas por imprimir?"	,"ฟCategorํas por imprimir?"	,"MV_CHC","C",15,0,0,"G","fCategoria()","","","","MV_PAR15",""       ,""            ,""        ,""     ,""   ,"")

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