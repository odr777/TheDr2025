#include 'Protheus.ch'
#include "rwmake.ch"
#include 'tdsBirt.ch'
#include 'birtdataset.ch'

/*
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||Programa  | PEDCOM01  |Edson    ,  Denar      | Data |  15/08/2019     |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||Descricao | Llama pedido de compra PEDCOM01	                		  |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||Uso       | TdeP Horeb                                                 |||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
*/

user function PEDCOM01()

	local oReport
	cPerg   := "PEDCOM01"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)

	if  FUNNAME() $ 'MATA121' // pregunta si estoy ejecutando desde pedido de compra
		dbSelectArea("SX1")
		dbSetOrder(1)

		If dbSeek("PEDCOM01  "+"01")
			RecLock("SX1",.F.)
			SX1->X1_CNT01 := SC7->C7_NUM
			MsUnLock()
		EndIf
		DEFINE user_REPORT oReport NAME PEDCOM01 TITLE "Pedido de Compra" EXCLUSIVE
	else
		DEFINE user_REPORT oReport NAME PEDCOM01 TITLE "Pedido de Compra" ASKPAR EXCLUSIVE
	endIf

	ACTIVATE REPORT oReport LAYOUT PEDCOM01 FORMAT HTML

return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSX1(cPerg,"01","Nro Pedido"	, "Nro Pedido"		,"Nro Pedido"		,"MV_CH1","C",tamSX3("C7_NUM")[1],0,0,"G","","SC7","","","MV_PAR01",""       ,""            ,""        ,""     ,"SC7"   ,"")
	// xPutSX1(cPerg,"02","¿Ate Pedido?" 	, "¿A Pedido?"		,"¿A Pedido?"		,"MV_CH2","C",tamSX3("C7_NUM")[1],0,0,"G","","SC7","","","MV_PAR02",""       ,""            ,""        ,""     ,"SC7"   ,"")
	// xPutSX1(cPerg,"03","¿De Data?" 		, "¿De Fecha?"		,"¿From Date?"		,"MV_CH3","D",08,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	// xPutSX1(cPerg,"04","¿Ate Data?" 	, "¿A Fecha?"		,"¿To Date?"		,"MV_CH4","D",08,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	//xPutSX1(cPerg,"05","Qual Moeda?"	,"¿Que Moneda?"		,"Which Currency?"	,"MV_CH5","N",1,0,1,"C" ,"","MV_PAR05","Moeda 1","Moneda 1","Currency 1","","","Moeda 2","Moneda 2","Currency 2","","", "S","","","","")
	//xPutSX1(cPerg,"05","Qual Moeda ?"   ,"¿Que Moneda ?"    ,"Which Currency ?" ,"MV_CH5","N",1,0,1,"C" ,"","MV_PAR05" ,"Moeda 1","Moneda 1","Currency 1","","","Moeda 2","Moneda 2","Currency 2","","", "Moeda 3","Moneda 3","Currency 3","","","Moeda 4","Moneda 4","Currency 4","","","Moeda 5","Moneda 5","Currency 5" ,"","","S","","","","")

	//xPutSX1(cPerg,"03","Qual Moeda?" , "¿Que Moneda?","Which Currency?" ,"MV_CH5","N",1,0,0,"C","","","","" ,"MV_PAR05","Moeda 1","Moneda 1","Currency 1","","Moeda 2","Moneda 2","Currency 2","Year","Year","Year")
	xPutSX1(cPerg,"02","Qual Moeda?" , "¿Que Moneda?","Which Currency?" ,"MV_CH5","N",1,0,0,"C","","","","" ,"MV_PAR02","Moeda 1","Moneda 1","Currency 1","","Moeda 2","Moneda 2","Currency 2","Moeda 3","Moneda 3","Currency 3","Moeda 4","Moneda 4","Currency 4","Moeda 5","Moneda 5","Currency 5")

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

	// Ajusta o tamanho do grupo. Ajuste emergencial para validao dos fontes.
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
