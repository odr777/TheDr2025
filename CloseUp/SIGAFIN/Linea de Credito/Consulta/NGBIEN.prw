#Include 'Protheus.ch'

User Function NGBIEN()
	Local oDlg, oLbx
	Local aCpos  := {}
	Local aRet   := {}
	Local cQuery := ""
	Local cAlias := GetNextAlias()
	Local lRet   := .F.

	cQuery := " SELECT NG_GRUPO,NG_DESCRIC,NG_FILIAL "
	cQuery +=   " FROM " + RetSqlName("SNG") + " SNG "
	cQuery +=  " WHERE NG_GRUPO IN('1000','2000','4000','6000','9997','9998','9999') AND SNG.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	While (cAlias)->(!Eof())
		aAdd(aCpos,{(cAlias)->(NG_GRUPO), (cAlias)->(NG_DESCRIC), (cAlias)->(NG_FILIAL)})
		(cAlias)->(dbSkip())
	End
	(cAlias)->(dbCloseArea())

	If Len(aCpos) < 1
		aAdd(aCpos,{" "," "," "})
	EndIf

	DEFINE MSDIALOG oDlg TITLE /*STR0083*/ "Roteiro de operações" FROM 0,0 TO 240,500 PIXEL

	@ 10,10 LISTBOX oLbx FIELDS HEADER 'Grupo' /*"Roteiro"*/, 'Descripcion' /*"Produto"*/, 'Filial' SIZE 230,95 OF oDlg PIXEL

	oLbx:SetArray( aCpos )
	oLbx:bLine     := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2], aCpos[oLbx:nAt,3]}}
	oLbx:bLDblClick := {|| {oDlg:End(), lRet:=.T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,3]}}}

	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (oDlg:End(), lRet:=.T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,3]})  ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER

	If Len(aRet) > 0 .And. lRet
		If Empty(aRet[1])
			lRet := .F.
		Else
			SNG->(dbSetOrder(1))
			SNG->(dbSeek(xFilial("SNG")+aRet[1]))
		EndIf
	EndIf
Return lRet