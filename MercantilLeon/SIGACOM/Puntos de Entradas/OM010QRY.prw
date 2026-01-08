


/*/{Protheus.doc} User Function OM010QRY
    Función encargada de realizar el filtro en el sistema ML.

    @type  Function OM010QRY
    @author user
    @since 17/11/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see https://tdn.totvs.com/display/public/PROT/OM010FIL+-+Filtro+do+Arquivo+de+Produtos+--+16447
    /*/
User Function OM010QRY()
    Local cQuery:=""
    local cPregunta := 'OM010QRY'
    LOCAL aArea := GetArea("SX1")

    // local aArea = GetArea()
    CriaSX1(cPregunta)
    PERGUNTE(cPregunta,.t.)
    cQuery := "SELECT DA1.*,DA1.R_E_C_N_O_ DA1RECNO, B1_DESC, B1_PRV1 FROM "
    cQuery += RetSqlName("DA1")+ " DA1 "
    cQuery += "LEFT JOIN " +RetSqlName("SB1")+ " SB1  "
    cQuery += "  ON SB1.B1_FILIAL  = '"+xFilial("SB1")+"'"
    cQuery += "  AND SB1.B1_COD     = DA1.DA1_CODPRO"
    cQuery += "  AND SB1.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE DA1.DA1_FILIAL = '"+xFilial("DA1")+"'"
    cQuery += "  AND DA1.DA1_CODTAB = '"+DA0->DA0_CODTAB+"'"
	cQuery += "and SB1.B1_COD >= '"+ mv_par03 +"' AND "
	cQuery += " SB1.B1_COD <= '" + mv_par04 + "' AND "
	cQuery += " SB1.B1_GRUPO >= '" + mv_par05 + "' AND "
	cQuery += " SB1.B1_GRUPO <= '" + mv_par06 + "'  "
    if mv_par07 == 1 // considera filtro despacho
        cQuery += " AND DA1.DA1_CODPRO IN (SELECT DBC_CODPRO FROM DBC010 WHERE DBC_HAWB BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "')"
    endif
    cQuery += "  AND DA1.D_E_L_E_T_ = ' ' "
    cQuery += "  UNION "
    cQuery += "  SELECT "
    cQuery += "     DA1.*,   "
    cQuery += "     DA1.R_E_C_N_O_ DA1RECNO,                                  "
    cQuery += "     B1_DESC, "
    cQuery += "     B1_PRV1 "
    cQuery += "  FROM       "
    cQuery += "     " +RetSqlName("DA1")+ " DA1      "
    cQuery += "     LEFT JOIN                                                 "
    cQuery += "        " +RetSqlName("SB1")+ " SB1                            "
    cQuery += "  ON SB1.B1_FILIAL  = '"+xFilial("SB1")+"'"
    cQuery += "        AND SB1.B1_COD = DA1.DA1_CODPRO                        "
    cQuery += "        AND SB1.D_E_L_E_T_ = ' '                               "
    cQuery += "     WHERE DA1.DA1_FILIAL = '"+xFilial("DA1")+"'"
    cQuery += "     AND DA1.DA1_CODTAB = '"+DA0->DA0_CODTAB+"'"
    cQuery += "     AND DA1.D_E_L_E_T_ = ' '                                  "
    cQuery += "     AND     "
    cQuery += "     DA1.DA1_ITEM IN ( SELECT MAX(DA1_ITEM) FROM " +RetSqlName("DA1")+ " DA12   "
    cQuery += "     WHERE DA12.DA1_FILIAL = '"+xFilial("DA1")+"'"
    cQuery += "     AND DA12.DA1_CODTAB = '"+DA0->DA0_CODTAB+"'"              "
    cQuery += "      ) "
    cQuery += "ORDER BY "+SqlOrder(DA1->(IndexKey()))

    // aviso("",cQuery,{'ok'},,,,,.t.)




    RestArea(aArea)

Return cQuery




Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

    xPutSX1(cPerg,"01","¿De Nro de despacho?"	, "¿De Nro de despacho?"	,"¿De Nro de despacho?"	,"MV_CH1","C",20,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
    xPutSX1(cPerg,"02","¿A Nro de despacho?" 	, "¿A Nro de despacho?"	,"¿A Nro de despacho?"	,"MV_CH2","C",20,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSx1(cPerg,"03","De Producto ?","De Producto ?","De Producto ?","mv_ch3","C",TamSx3("B1_COD")[01],0,0,"G","","SB1","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A Producto ?","A Producto ?","A Producto ?","mv_ch4","C",TamSx3("B1_COD")[01],0,0,"G","","SB1","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De grupo ?","De grupo?","De grupo?",         "mv_ch5","C",04,0,0,"G","","SBM","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A grupo?","A grupo?","A grupo?",         "mv_ch6","C",04,0,0,"G","","SBM","","","mv_par06   ",""       ,""            ,""        ,""     ,"","")
    xPutSx1(cPerg,"07","Considera Filtro despacho?","Considera Filtro despacho?","Considera Filtro despacho?","mv_chb",;
"N",1,0,0,"C","","","","S","mv_par07","Sim","Si","Yes","","Nao","No","No","","","","","","","","","","","","")
	// xPutSx1(cPerg,"07","Considera Filtro despacho?","Considera Filtro despacho?","Considera Filtro despacho?",         "mv_ch6","C",04,0,0,"G","","","","","mv_par07   ",""       ,""            ,""        ,""     ,"","")

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
