#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include 'tdsBirt.ch'
#include 'birtdataset.ch'

/*
----------------------------------------------------------------------------
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------------------------------------------------------+||
|| Programa  | CCarta  Birt         | Edson Data | 20/12/2019             ||
||+----------------------------------------------------------------------+||
|| Descricao | CARTA DE CONCILIACION DE CLIENTE              		      ||
||+----------------------------------------------------------------------+||
||+----------------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
----------------------------------------------------------------------------
*/

user function CCarta()

	local oReport
	cPerg   := "CCarta"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)

	DEFINE user_REPORT oReport NAME CCarta TITLE "REPORTE CARTE DE CONCILIACION" ASKPAR EXCLUSIVE

	ACTIVATE REPORT oReport LAYOUT CCarta FORMAT HTML

return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	
	xPutSx1(cPerg,"01","Cliente?","Cliente?","Cliente?",         "mv_ch1","C",06,0,0,"G","","SA1","","","MV_PAR01",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"02","De tienda?","De tienda?","De tienda?",         "mv_ch1","C",02,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,"","")	
	xPutSx1(cPerg,"03","A tienda?","A tienda?","A tienda?",         "mv_ch2","C",02,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"04","Fecha Corte","Fecha Corte","Fecha Corte",         "mv_ch1","D",08,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"05","Nombre Responsable","Nombre Responsable","Nombre Responsable",         "mv_ch1","C",40,0,0,"G","","","","","MV_PAR05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","Cargo Responsable","Cargo Responsable","Cargo Responsable",         "mv_ch2","C",40,0,0,"G","","","","","MV_PAR06",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"07","Imprimir Logo"   ,"Imprimir Logo" ,"Imprimir Logo"   ,"MV_CH1","N",1,0,0,"C","","","","" ,"MV_PAR07","si","si","si","","no","no","no")
	xPutSX1(cPerg,"08","Imprimir Saldo"   ,"Imprimir Saldo" ,"Imprimir Saldo"   ,"MV_CH1","N",1,0,0,"C","","","","" ,"MV_PAR08","si","si","si","","no","no","no")
	
	
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

	cPyme  := Iif( cPyme   == Nil, " ", cPyme)
	cF3    := Iif( cF3     == NIl, " ", cF3)
	cGrpSxg:= Iif( cGrpSxg == Nil, " ", cGrpSxg)
	cCnt01 := Iif( cCnt01  == Nil, "" , cCnt01)
	cHelp  := Iif( cHelp   == Nil, "" , cHelp)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	
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
			SX1->(MsUnlock())
		EndIf
	Endif

	RestArea( aArea )

Return