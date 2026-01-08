#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"
#INCLUDE 'RWMAKE.CH'

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma OM010DA1  ºAutor  ³ERICK ETCHEVERRY º   º Date 20/02/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Desarrollo actualiza precio en hijas y incluye en hijas     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                        	   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function OM010DA1()
	Local nTipo := PARAMIXB[1]
	Local nOpc := PARAMIXB[2]  //1 INC   4 ALT   5 DEL
	Local oModel := FwModelActive()
	Local oGrid := oModel:GetModel("DA1DETAIL")///grid de items
	Local oMdl2DA1 := oModel:GetModel("DA1DETAIL2")///grid de items
	Local cDepPadre := alltrim(FWFldGet("DA0_DEPTAB")) //campo si tiene padre
	Local cPadreTab := alltrim(FWFldGet("DA0_CODTAB")) //campo si tiene padre
	Local aCols := oGrid:aCols
	//Local aCols2 := oMdl2DA1:aCols

	if nOpc == 4

		if empty(cDepPadre) //si no tiene padre entra
			if Type("lFilhos") == "U" //si existe la variable
				lFilho:= lfindFilio(cPadreTab) //si tiene hijos
				if lFilho
					Public lFilhos := lFilho
					If oGrid:SeekLine({{"DA1_ITEM",DA1->DA1_ITEM},{"DA1_CODPRO",DA1->DA1_CODPRO}})
						if oGrid:IsInserted() //si encontro un producto nuevo
							cCodProd:= DA1->DA1_CODPRO
							nPrcVen := DA1->DA1_PRCVEN
							nMoeda := DA1->DA1_MOEDA
							aFilos := getFilos(cPadreTab,nPrcVen)///tablas hijos con valores para insertar

							if !empty(aFilos)
								for i:= 1 to len(aFilos)
									dbSelectArea("DA1")
									RecLock("DA1",.t.)
									DA1->DA1_FILIAL := xFilial("DA1")
									DA1->DA1_ITEM := Soma1(aFilos[i][2])
									DA1->DA1_CODPRO := cCodProd
									DA1->DA1_CODTAB := aFilos[i][1]  //la que trae
									DA1->DA1_PRCVEN := aFilos[i][3]
									DA1->DA1_DATVIG := dDataBase
									DA1->DA1_ATIVO := "1" // Sim
									DA1->DA1_TPOPER := "4" // todas as operações
									DA1->DA1_QTDLOT := 999999.99
									DA1->DA1_INDLOT := STRZERO(999999, TamSx3("DA1_INDLOT")[1]-3 ) + ".99"
									DA1->DA1_MOEDA := nMoeda
									MsUnLock()
								next i
							endif
						elseif oGrid:IsUpdated()
							upListaPrc(cPadreTab,DA1->DA1_CODPRO,DA1->DA1_PRCVEN) // actualizando el producto
						endif
					endif
				endif
			elseif lFilhos //luego para otro producto para no hacer el query de buscar hijo n veces
				//upListaPrc(cPadreTab,DA1->DA1_CODPRO,DA1->DA1_PRCVEN) // actualizando el producto
				If oGrid:SeekLine({{"DA1_ITEM",DA1->DA1_ITEM},{"DA1_CODPRO",DA1->DA1_CODPRO}})
					if oGrid:IsInserted() //si encontro un producto nuevo
						cCodProd:= DA1->DA1_CODPRO
						nPrcVen := DA1->DA1_PRCVEN
						aFilos := getFilos(cPadreTab,nPrcVen)
						if !empty(aFilos)
							for i:= 1 to len(aFilos)
								dbSelectArea("DA1")
								RecLock("DA1",.t.)
								DA1->DA1_FILIAL := xFilial("DA1")
								DA1->DA1_ITEM := Soma1(aFilos[i][2])
								DA1->DA1_CODPROD := cCodProd
								DA1->DA1_CODTAB := aFilos[i][1]  //la que trae
								DA1->DA1_PRCVEN := aFilos[i][3]
								DA1->DA1_DATVIG := dDataBase
								DA1->DA1_ATIVO := "1" // Sim
								DA1->DA1_TPOPER := "4" // todas as operações
								DA1->DA1_QTDLOT := 999999.99
								DA1->DA1_INDLOT := STRZERO(999999, TamSx3("DA1_INDLOT")[1]-3 ) + ".99"
								DA1->DA1_MOEDA := 1
								MsUnLock()
							next i
						endif
					elseif oGrid:IsUpdated()
						upListaPrc(cPadreTab,DA1->DA1_CODPRO,DA1->DA1_PRCVEN) // actualizando el producto
					endif
				endif
			endif
		endif
	endif

return
//tendra hijos?
static function lfindFilio(cCodTab)
	Local cQuery	:= ""
	Local lRetu := .f.

	If Select("VW_filio") > 0
		dbSelectArea("VW_filio")
		dbCloseArea()
	Endif

	/*
	SELECT COUNT(*) FROM DA0010 DA0
	JOIN DA0010 DA02 ON
	DA02.DA0_DEPTAB = DA0.DA0_CODTAB
	WHERE DA0.DA0_CODTAB = '010'
	*/

	cQuery := "	SELECT COUNT(*) LFIL "
	cQuery += " FROM " + RetSqlName("DA0") + " DA0 "
	cQuery += " JOIN " + RetSqlName("DA0") + " DA02 "
	cQuery += " ON DA02.DA0_DEPTAB = DA0.DA0_CODTAB AND DA02.D_E_L_E_T_ = '' "
	cQuery += " WHERE DA0.DA0_CODTAB = '" + cCodTab + "' AND DA0.D_E_L_E_T_ = '' "

	TCQuery cQuery New Alias "VW_filio"

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	if VW_filio->LFIL > 0
		lRetu = .t.
	ENDIF

	VW_filio->(DbCloseArea())

	//ALERT(lRetu)
return lRetu
///actualiza precios en todas las hijas
static Function upListaPrc(cPadreTab,cCodProd,nNewPrec)
	Local aArea	:= GetArea()
	Local cQuery := ""
	Local lRet := .f.
	Local nUpPrecoList := nNewPrec
	Local StrSql:=""

	/*UPDATE DA1
	SET DA1_PRCVEN = (10 * (DA0_PERLIS/100))+ 10
	FROM DA1010 DA1
	JOIN DA0010 DA0
	ON DA0_FILIAL = DA1_FILIAL AND DA1_CODTAB = DA0_CODTAB AND DA0_DEPTAB = '010'
	WHERE
	DA1_FILIAL = '01'  AND DA1_CODPRO = '000035'*/

	StrSql:=" UPDATE DA1 "
	StrSql+=" SET DA1_PRCVEN = (CAST('" + CVALTOCHAR(nUpPrecoList) + "' AS FLOAT) * (DA0_PERLIS/100)) + CAST('" + CVALTOCHAR(nUpPrecoList) + "'AS FLOAT), "
	StrSql+=" DA1_UPRCVA = DA1_PRCVEN "
	StrSql+=" FROM " + RETSQLNAME('DA1')+ " DA1 "
	StrSql+=" JOIN " + RETSQLNAME('DA0')+ " DA0 "
	StrSql+=" ON DA0_FILIAL = DA1_FILIAL AND DA1_CODTAB = DA0_CODTAB AND DA0_DEPTAB = '" + cPadreTab + "'"
	StrSql+=" WHERE "
	StrSql+=" DA1_FILIAL = '" + xfilial("DA1") + "' AND DA1_CODPRO = '" + cCodProd + "'"

	If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
		//     MsgAlert("ERROR AL ACTUALIZAR EL COSTO EN CQ")
		aviso("ERROR AL ACTUALIZAR EL COSTO EN CQ",StrSql + TCSQLError(),{'ok'},,,,,.t.)
		return .F.
	EndIf

	DA1->(DbCloseArea())
	RestArea(aArea)
Return
///entrega todas las hijas
static function getFilos(cCodTab,nPrvn)
	Local cQuery	:= ""
	Local lRetu := .f.
	Local aArea	:= GetArea()
	Local aFilos := {}

	If Select("VW_filos") > 0
		dbSelectArea("VW_filos")
		dbCloseArea()
	Endif
	//ALERT(VALTYPE(nPrvn))
	/*
	SELECT DA00.DA0_CODTAB,MAX(DA1_ITEM)DA1_ITEM,
	(CAST('7' AS FLOAT) * (DA00.DA0_PERLIS/100)) + CAST('7'AS FLOAT)DA1_PRCVEN
	FROM DA0010 DA00
	JOIN DA0010 DA0
	ON DA0.DA0_CODTAB = DA00.DA0_DEPTAB
	JOIN DA1010
	ON DA00.DA0_CODTAB = DA1_CODTAB
	WHERE DA00.DA0_DEPTAB = '004'
	GROUP BY DA00.DA0_CODTAB,DA00.DA0_PERLIS
	*/

	cQuery := "	SELECT DA00.DA0_CODTAB,MAX(DA1_ITEM)DA1_ITEM, "
	cQuery += " (" + CVALTOCHAR(nPrvn) + " * (DA00.DA0_PERLIS/100)) + " + CVALTOCHAR(nPrvn) + " DA1_PRCVEN "
	cQuery += " FROM " + RetSqlName("DA0") + " DA00 "
	cQuery += " JOIN " + RetSqlName("DA0") + " DA0 "
	cQuery += " ON DA0.DA0_CODTAB = DA00.DA0_DEPTAB AND DA0.D_E_L_E_T_ = '' "
	cQuery += " JOIN " + RetSqlName("DA1") + " DA1 "
	cQuery += " ON DA00.DA0_CODTAB = DA1_CODTAB "
	cQuery += " WHERE DA00.DA0_DEPTAB = '" + cCodTab + "' AND DA00.D_E_L_E_T_ = '' "
	cQuery += " GROUP BY DA00.DA0_CODTAB,DA00.DA0_PERLIS "

	TCQuery cQuery New Alias "VW_filos"

	If __CUSERID = '000000'
		Aviso("PRECOLIST",cQuery,{'ok'},,,,,.t.)
	EndIf

	while !VW_filos->(EoF())
		aadd(aFilos,{VW_filos->DA0_CODTAB,VW_filos->DA1_ITEM,VW_filos->DA1_PRCVEN})
		VW_filos->(dbSkip())
	ENDDO

	VW_filos->(DbCloseArea())
	RestArea(aArea)
return aFilos