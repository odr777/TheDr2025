#INCLUDE "PROTHEUS.CH"
#Include 'topConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncreSal  บAutor  ณDenar Terrazas	 บFecha ณ  27/05/2021 	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Incremento Salarial.						     		  	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia		                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

#DEFINE NPOSFIL		1	//Sucursal
#DEFINE NPOSMAT		2	//Matrํcula
#DEFINE NPOSNOME	3	//Nombre

User Function IncreSal()
	Local aArea			:= getArea()
	Local cTitulo		:= "Incremento SMN/Salarial"
	Local cPerg			:= "IncreSal"   // elija el Nombre de la pregunta
	Local aDados			:= {}
	Local nX

	Private cAliasFun	:= GetNextAlias()
	Private nSMN		:= 0 // Salario Mํnimo Nacional
	Private cDeSuc
	Private cASuc
	Private cDeMat
	Private cAMat
	Private nIncSal
	Private dFecha

	Private cLogGenerado:= ""
	Private dDataIni
	Private dDataFim
	Private nDuracao
	Private cTipoAFa

	CriaSX1(cPerg)
	lAcepta := pergunte(cPerg,.T.)
	If(!lAcepta)
		return
	EndIf

	cDeSuc	:= MV_PAR01
	cASuc	:= MV_PAR02
	cDeMat	:= MV_PAR03
	cAMat	:= MV_PAR04
	nIncSal	:= MV_PAR05
	dFecha	:= MV_PAR06

	//Validaciones a las Preguntas
	If(Empty(cASuc))
		Aviso(cTitulo,"No se ha informado el segundo parแmetro de Sucursal.",{'Ok'})
		return
	EndIf

	If(Empty(cAMat))
		Aviso(cTitulo,"No se ha informado el segundo parแmetro de Matrํcula.",{'Ok'})
		return
	EndIf

	If(Empty(dFecha))
		Aviso(cTitulo,"No se ha informado la fecha del Incremento.",{'Ok'})
		return
	EndIf

	nSMN:= VAL(ALLTRIM(GetAdvFVal("RCC", "RCC_CONTEU", xFilial('RCC') + 'S005' + '    ' + '      ' + '001', 1, "0")))

	If(nSMN <= 0)
		Aviso(cTitulo,"Revisar el valor del nuevo salario mํnimo en Mantenimiento de Tablas.",{'Ok'})
		return
	EndIf

	BeginSql alias cAliasFun

		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME
		FROM %table:SRA% SRA
		WHERE SRA.RA_FILIAL BETWEEN %Exp:cDeSuc% AND %Exp:cASuc%
		AND SRA.RA_MAT BETWEEN %Exp:cDeMat% AND %Exp:cAMat%
		AND SRA.RA_SALARIO < %Exp:nSMN%
		AND SRA.RA_SITFOLH <> 'D'
		AND SRA.%notDel%

	EndSql

	cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.T.)//   usar este en esste caso cuando es BEGIN SQL

	(cAliasFun)->( dbGoTop())
	Do While (cAliasFun)->(!Eof())
		AADD(aDados, {(cAliasFun)->RA_FILIAL, (cAliasFun)->RA_MAT, (cAliasFun)->RA_NOME})
		(cAliasFun)->(DbSkip())
	EndDo

	nCantEmp:= Len(aDados)

	lConfirmado:= confirmar(nCantEmp)
	if(!lConfirmado)
		return
	EndIf

	for nX := 1 to nCantEmp
		UpdateSRA(aDados[nX])
	next nX

	Aviso("Proceso ejecutado con ้xito!",cLogGenerado,{"Ok"},,,,,.T.)
	(cAliasFun)->( dbCloseArea())

	restArea(aArea)
return

/**
* @author: Denar Terrazas Parada
* @since: 27/05/2021
* @description: Funcion que actualiza el valor del campo RA_SALARIO
* @parameters: aDados -> Array {Sucursal, Matricula, Nombre}
*/
Static Function UpdateSRA(aDados)
	Local aArea := getArea()

	dbSelectArea("SRA")
	SRA->( dbSetOrder(1) )//RA_FILIAL+RA_MAT+RA_NOME

	If( SRA->( dbSeek( aDados[NPOSFIL] + aDados[NPOSMAT] ) ) )
		RECLOCK("SRA", .F.)
		nSalAnt:= SRA->RA_SALARIO
		SRA->RA_SALARIO := nSMN
		insertSR3(aDados[NPOSFIL], aDados[NPOSMAT])
		SRA->(MSUNLOCK())
		cLogGenerado+= aDados[NPOSMAT] + " - " + TRIM(aDados[NPOSNOME]) + " - de Bs. " + cvaltochar(nSalAnt) + " a Bs. " + cvaltochar(nSMN)  + CRLF
	EndIF
	SRA->( dbCloseArea() )

	restArea(aArea)

Return

/**
* @author: Denar Terrazas Parada
* @since: 27/05/2021
* @description: Funcion que inserta el cambio de salario en el historial(tabla SR3)
* @parameters:	cFil -> Sucursal del funcionario
* 				cMat -> Matrํcula del funcionario
*/
static function insertSR3(cFil, cMat)
	Local aArea := getArea()

	ReClock ( "SR3",.T.)
	SR3->R3_FILIAL	:= cFil
	SR3->R3_MAT		:= cMat
	SR3->R3_DATA	:= dFecha
	SR3->R3_SEQ		:= '1'
	SR3->R3_TIPO	:= "003"
	SR3->R3_PD		:= "000"
	SR3->R3_DESCPD	:= "SUELDO BASE (U)"
	SR3->R3_VALOR	:= nSMN

	SR3->(MSUNLOCK())
	restArea(aArea)
return

/**
*
* @author: Denar Terrazas Parada
* @since: 29/01/2021
* @description: Funci๓n que retorna el aumento que determina si el tama๑o de impresi๓n serแ carta u oficio
* @parameters:	nCantEmp -> Cantidad de Funcionarios a Procesar
				nSMN -> Salario con el que se va a actualizar
*/
static function confirmar(nCantEmp)
	Local nOpcSi	:= 2
	Local nOpcNo	:= 1
	Local cTitulo	:= "ฟEstแ seguro que desea continuar?"
	Local cTexto	:= ""
	Local lRet		:= .F.
	Local nOpcAviso := nOpcNo

	cTexto	+= "Se actualizarแ el salario a un total de: " + cvaltochar(nCantEmp) + " funcionarios." + CRLF
	cTexto	+= "El nuevo salario serแ de: Bs. " + cvaltochar(nSMN) + CRLF
	cTexto	+= "ฟEstแ seguro que desea continuar?"

	nOpcAviso:= Aviso(cTitulo, cTexto, {'No', 'Si'})

	If(nOpcAviso == nOpcSi)
		lRet:= .T.
	EndIf

return lRet

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","ฟDe Sucursal?"			, "ฟDe Sucursal?"			,"ฟDe Sucursal?"			,"MV_CH1","C",04,0,0,"G","Pertence(fValidFil()) .AND. NaoVazio()","FWSM0","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","ฟA Sucursal?"			, "ฟA Sucursal?"			,"ฟA Sucursal?"				,"MV_CH2","C",04,0,0,"G","Pertence(fValidFil()) .AND. NaoVazio()","FWSM0","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","ฟDe Matrํcula?"			, "ฟDe Matrํcula?"			,"ฟDe Matrํcula?"			,"MV_CH3","C",06,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","ฟA Matrํcula?"			, "ฟA Matrํcula?"			,"ฟA Matrํcula?"			,"MV_CH4","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","ฟ% Incremento Salarial?", "ฟ% Incremento Salarial?"	,"ฟ% Incremento Salarial?"	,"MV_CH5","N",05,2,0,"G","","","","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","ฟDe Fecha?"				, "ฟDe Fecha?"				,"ฟDe Fecha?"				,"MV_CH6","D",08,0,0,"G","NaoVazio()","","","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")

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
