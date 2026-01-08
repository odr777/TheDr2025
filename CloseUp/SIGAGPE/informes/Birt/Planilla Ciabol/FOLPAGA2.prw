#include 'Protheus.ch'
#include "rwmake.ch"
#include 'tdsBirt.ch'
#include 'birtdataset.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FOLPAGAM  ³Denar Terrazas		 º Data ³  15/02/2019     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Llama Planilla de sueldos FOLPAGAM	                	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP Horeb                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FOLPAGA2()

local oReport
cPerg   := "FOLPAGA2"   // elija el Nombre de la pregunta
CriaSX1(cPerg)

DEFINE user_REPORT oReport NAME FOLPAGA2 TITLE "Planilla de sueldos" ASKPAR EXCLUSIVE

ACTIVATE REPORT oReport LAYOUT FOLPAGA2 FORMAT HTML

return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	//xPutSX1(cPerg,"01","¿Proceso?"	, "¿Proceso?"	,"¿Proceso?"	,"MV_CH1","C",50,0,0,"G","fListProc(NIL,NIL,10)","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"01","¿Proceso?"	, "¿Proceso?"	,"¿Proceso?"	,"MV_CH1","C",05,0,0,"G","","RCJ","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	//xPutSX1(cPerg,"02","¿Procedimiento?", "¿Procedimiento?"	,"¿Procedimiento?"	,"MV_CH2","C",30,0,0,"G","fRoteiro()","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿Procedimiento?", "¿Procedimiento?"	,"¿Procedimiento?"	,"MV_CH2","C",03,0,0,"G","","SRY","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿Mes/Año Competenc. (MMYYYY)?" 		, "¿Mes/Año Competenc. (MMYYYY)?"		,"¿Mes/Año Competenc. (MMYYYY)?"		,"MV_CH3","C",06,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	
	xPutSX1(cPerg,"04","¿N° Pago?" 		, "¿N° Pago?"		,"¿N° Pago?"		,"MV_CH4","C",02,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	
	xPutSX1(cPerg,"05","¿De Sucursal?"	, "¿De Sucursal?"	,"¿De Sucursal?"	,"MV_CH5","C",04,0,0,"G","","SM0","033","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿A Sucursal?" 	, "¿A Sucursal?"	,"¿A Sucursal?"		,"MV_CH6","C",04,0,0,"G","","SM0","033","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿De Centro de costo?" , "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH7","C",11,0,0,"G","","CTT","004","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿A Centro de costo?" 	, "¿A Centro de costo?"	,"¿A Centro de costo?"	,"MV_CH8","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿De Matrícula?" , "¿De Matrícula?"	,"¿De Matrícula?"	,"MV_CH9","C",06,0,0,"G","","SRA","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿A Matrícula?" 	, "¿A Matrícula?"	,"¿A Matrícula?"	,"MV_CHA","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	/*xPutSX1(cPerg,"10","¿De Nombre?" , "¿De Nombre?"	,"¿De Nombre?"	,"MV_CH10","C",30,0,0,"G","","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿A Nombre?" 	, "¿A Nombre?"	,"¿A Nombre?"	,"MV_CH11","C",30,0,0,"G","NaoVazio()","","","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")*/
	
	//xPutSX1(cPerg,"10","¿Situaciones por imprimir?" , "¿Situaciones por imprimir?"	,"¿Situaciones por imprimir?"	,"MV_CH10","C",05,0,0,"G","fSituacao()","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿Situaciones por imprimir?"	, "¿Situaciones por imprimir?"	,"¿Situaciones por imprimir?"	,"MV_CHB","N",01,0,0,"C","","","","","MV_PAR11","Vigentes","Vigentes","Vigentes","","Despedidos","Despedidos","Despedidos"	,"Todos","Todos","Todos")
	
	xPutSX1(cPerg,"12","¿Categorías por imprimir?" 	, "¿Categorías por imprimir?"	,"¿Categorías por imprimir?"	,"MV_CHC","C",15,0,0,"G","fCategoria()","","","","MV_PAR12",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"13","¿Permanente/Eventual?" , "¿Permanente/Eventual?"	,"¿Permanente/Eventual?"	,"MV_CHD","C",01,0,0,"C","","","","","MV_PAR13","Permanente","Permanente","Permanente","","Eventual","Eventual","Eventual")
	xPutSX1(cPerg,"14","¿Nombre del Empleador?" 	, "¿Nombre del Empleador?"	,"¿Nombre del Empleador?"	,"MV_CHE","C",30,0,0,"G","","","","","MV_PAR14",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"15","¿Nº Doc. de Identidad?" , "¿Nº Doc. de Identidad?"	,"¿Nº Doc. de Identidad?"	,"MV_CHF","C",16,0,0,"G","","","","","MV_PAR15",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"16","¿Orden?"		, "¿Orden?"			,"¿Orden?"			,"MV_CHG","N",01,0,0,"C","","","","","MV_PAR16","Sucursal+Matric.","Sucursal+Matric.","Sucursal+Matric.","","Sucursal+C.Costo","Sucursal+C.Costo","Sucursal+C.Costo"	,"Apellido Paterno","Apellido Paterno","Apellido Paterno")
	xPutSX1(cPerg,"17","¿Agrupar Por?"		, "¿Agrupar Por?"			,"¿Agrupar Por?"			,"MV_CHH","N",01,0,0,"C","","","","","MV_PAR17","Empresa","Empresa","Empresa","","Sucursal","Sucursal","Sucursal","C.Costo","C.Costo","C.Costo")
	xPutSX1(cPerg,"18","Tipo Ciabol"		, "Tipo Ciabol"			,"Tipo Ciabol"			,"MV_CHH","N",01,0,0,"C","","","","","MV_PAR18","Normal","Normal","Normal","","Consultor","Consultor","Consultor","Eventual","Eventual","Eventual","Formal","Formal","Formal")

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
