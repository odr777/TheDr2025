

/*/{Protheus.doc} User Function runatdes
    @type      
    @author Nahim Terrazas
    @since 04/02/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function runatdes()
    cPerg := "RUTATDES"
    CriaSX1(cPerg) // crea pregunta
    if Pergunte(cPerg,.T.)
        U_ACTRGDES(MV_PAR01,MV_PAR03,MV_PAR02,MV_PAR04,4) // precisa ser creado
    endif
Return 



Static Function CriaSX1(cPerg)  // Crear Preguntas
	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De cliente ?","De cliente ?","De cliente ?","mv_ch2","C",6,0,0,"G","","CLI","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A cliente ?","A cliente ?","A cliente ?","mv_ch2","C",6,0,0,"G","","CLI","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"03","¿De Tienda?" 		, "¿De Tienda?"			,"¿De Tienda?"		,"MV_CH5","C",02,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Tienda?" 		, "¿A Tienda?"			,"¿A Tienda?"		,"MV_CH6","C",02,0,0,"G","NaoVazio()","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	// xPutSx1(cPerg,"04","De Recibo ?","De Recibo ?","De Recibo ?","mv_ch2","C",6,0,0,"G","","CLI","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	// xPutSx1(cPerg,"05","A Recibo ?","A Recibo ?","A Recibo ?","mv_ch2","C",6,0,0,"G","","CLI","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	// xPutSx1(cPerg,"06","De fecha digitacion ?","De fecha digitacion ?","De fecha digitacion ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	// xPutSx1(cPerg,"07","A fecha digitacion ?","A fecha digitacion ?","A fecha digitacion ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	// xPutSX1(cPerg,"08","Cual moneda ?" , "Cual moneda ?" ,"Cual moneda ?" ,"MV_CH01","N",1,0,0,"C","","","","","mv_par08","Moneda 1","Moneda 1","Moneda 1","","Moneda 2","Moneda 2","Moneda 2","Moneda 3","Moneda 3","Moneda 3","Moneda 4","Moneda 4","Moneda 4","Moneda 5","Moneda 5","Moneda 5")
	// xPutSx1(cPerg,"09","De serie ?","De serie ?","De serie ?",         "mv_ch7","C",3,0,0,"G","","RN","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	// xPutSx1(cPerg,"10","A serie ?","A serie ?","A serie ?",         "mv_ch8","C",3,0,0,"G","","RN","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	// xPutSX1(cPerg,"11","Otras monedas?" , "Imprimir por?" ,"Imprimir por?" ,"MV_CH01","N",1,0,0,"C","","","","","mv_par11","Convertir","Convertir","Convertir","","No imprimir","No imprimir","No imprimir")
	// xPutSx1(cPerg,"12","Fecha emision ?","Fecha emision ?","Fecha emision ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par12",""       ,""            ,""        ,""     ,"","")
	// xPutSx1(cPerg,"13","A Fecha emision ?","A Fecha emision ?","A Fecha emision ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par13",""       ,""            ,""        ,""     ,"","")
	// xPutSx1(cPerg,"14","¿De Banco?" 	, "¿De Banco?"   ,"¿De Banco?"	 ,"MV_CH5","C",3 ,0,0,"G","","A62"	,""	,""	,"MV_PAR14",""       ,""            ,""        ,""     ,,"")
	// xPutSx1(cPerg,"15","A Banco?" 	, "A Banco?"   ,"A Banco?"	 ,"MV_CH6","C",3 ,0,0,"G","","A62"	,""	,""	,"MV_PAR15",""       ,""            ,""        ,""     ,,"")
	
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
