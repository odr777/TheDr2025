#include 'protheus.ch'
#include 'parmtype.ch'
#DEFINE H_OK		1

/*/{Protheus.doc} User Function F085NOSHW
	Función que verifica que el anticipo esté relacionado con un pedido
	de compra que esté liberado (solicitado por Ciabol)
	@type  Function
	@author Nahim Terrazas
	@since 13/10/2021
	@version 1
	/*/

User Function F085NOSHW()
Local lRet := .T.
local ni
private nPedComA
if 'GENERAR PA' $ CCADASTRO
	cPerg   := "PEDCCANT"   // choose the question
	CriaSX1(cPerg)
    pergunte(cPerg,.t.)
    lBloqueado := GetAdvFVal("SC7","C7_CONAPRO",xFilial("SC7")+MV_PAR01,1,"")=="B"
    if lBloqueado // si está bloqueado muestra un mensaje de alerta y borra los ok del array de pagos 
        For ni := 1 to Len(aPagos)
			aPagos[ni][H_OK] = 0
			// If aPagos[ni][H_OK] <> 1  // se !ok
			// 	Loop
			// EndIf
		Next
		alert("Favor indicar un pedido de compra liberado")
    endif

endif 


Return lRet



Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	// xPutSX1(cPerg,"01","From Date" , "From Date","From Date","MV_CH4","D",8,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,"","")
	// xPutSX1(cPerg,"02","To Date" , "To Date","To Date" ,"MV_CH1","D",8,0,0,"G","","","",""   ,"MV_PAR02",""       ,""            ,""        ,""     ,"","")
	// xPutSX1(cPerg,"03","type"    , "type","type" ,"MV_CH1","N",8,0,0,"C","","","",""         ,"MV_PAR03","week","week","week","","month","month","month","Year","Year","Year")
    xPutSX1(cPerg,"01","Ped. Compra" , "Ped. Compra","Ped. Compra","MV_CH1","C",06,0,0,"G","","SC7","","","MV_PAR01",""       ,""            ,""        ,""     ,"SC7","")
	
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

