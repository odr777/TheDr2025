#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  บAutor  ณErick Etcheverry      		 บ Data ณ  02/02/24   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Actualiza valores al copiar PV				    	 	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Mercantil                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION MT410CPY()
	Local aArea := GetArea()
	Local lRet := .T.
	Local nPosQTDVEN := GDFIELDPOS("C6_QTDVEN")
	Local nPosPRCVEN := GDFIELDPOS("C6_PRCVEN")
	Local nPosPro  := GDFIELDPOS("C6_PRODUTO")
	Local nPosPru  := GDFIELDPOS("C6_PRUNIT")
	Local nPosTot  := GDFIELDPOS("C6_VALOR")
	Local nx := 0
	Local k

	nPosCan  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_QTDVEN" })
	nPosPro  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRODUTO" })
	nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRCVEN" })
	nPosTot  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_VALOR" })
	nPosPru  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRUNIT" }) //precio lista
	nPosPdesc  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_DESCONT" }) //porcentaje desc
	nPValDes  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})  ///valor descuento


	if nPosQTDVEN <> 0 .AND. nPosPRCVEN <> 0 .AND. nPosPro <> 0 .AND. nPosPru <> 0 .AND. nPosTot <> 0
		For nx := 1 To Len(aCols)

			DbSelectArea('SB1')
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+aCols[nx][nPosPro],.f.)

				if (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(aCols[nx][nPosPro],nTC2) ///traer precio bs

						if len(aAda1) > 0

							acols[nx][nPosPre] := round(aAda1[1][3],2)   //precio venta
							acols[nx][nPosPru] := round(aAda1[1][3],2)   ///precio lista
							acols[nx][nPosTot] := round(acols[nx][nPosCan] * acols[nx][nPosPre],2)

							nValPDesc := acols[nx][nPosPdesc]  /// porcentaje
							aCols[nx,nPValDes] := 0
							nxValDes := 0

							nxPreco := u_FtDescItem(u_FtDescCab(aCols[nx,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[nx,nPosPre],acols[nx][nPosCan],@acols[nx][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

							acols[nx][nPosPre] := round(nxPreco,2)   //precio venta
							acols[nx][nPosTot] := round(acols[nx][nPosCan] * acols[nx][nPosPre],2)
							acols[nx][nPosPdesc] := round(nValPDesc,2)
							acols[nx][nPValDes] := round(nxValDes,2)

							for k:=1 to Len(aCols)

								aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

								if len(aAda1) > 0

									DbSelectArea('SB1')
									DbSetOrder(1)
									If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)
										if (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

											acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
											acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
											acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

											nValPDesc := acols[k][nPosPdesc]  /// porcentaje
											aCols[k,nPValDes] := 0
											nxValDes := 0

											nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

											acols[k][nPosPre] := round(nxPreco,2)   //precio venta
											acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
											acols[k][nPosPdesc] := round(nValPDesc,2)
											acols[k][nPValDes] := round(nxValDes,2)
										endif
									endif
								endif
							next k

						endif

					endif

				endif

			endif

		Next nx
	endif

	M->C5_USRREG := USRRETNAME(RETCODUSR())
	M->C5_UPVFUT := '      '

	RestArea(aArea)
RETURN lRet

Static Function gtLisPreco(_cProduto,nTC)
	Local _cArea:=GetArea()
	Local cAliasQry	:= GetNextAlias()
	Local aColsDa1	:={}
	Local cQuery := ""

	cQuery += "SELECT "
	cQuery += "DA1_CODPRO,DA1_CODTAB,1 DA1_MOEDA, "
	cQuery += "(SELECT TOP 1 ZRA_NUMERO FROM " + RetSqlName("ZRA") + " WHERE D_E_L_E_T_ <> '*' AND ZRA_RAZON = DA1_URAZON) AS ZRA_NUMERO, "
	cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_PRCVEN ELSE ROUND(DA1_PRCVEN*"+ cValToChar(nTC) +",5) END DA1_PRCVEN "
	cQuery += "FROM DA1010 DA1 "
	cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
	cQuery += "      DA1_CODPRO = '"+_cProduto+"' and "
	cQuery += "      DA1.D_E_L_E_T_ = '' "
	IIF(FUNNAME() $ "MATA415",cQuery += " AND DA1_CODTAB = '" + M->CJ_TABELA+ "' ",cQuery += " AND DA1_CODTAB = '" + M->C5_TABELA+ "' ")

	cQuery += "ORDER BY DA1_CODTAB,R_E_C_N_O_ DESC "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	DbSelectArea(cAliasQry)

	(cAliasQry)->(DbGoTop())
	While (cAliasQry)->(!EOF())
		aAdd(aColsDa1,{(cAliasQry)->DA1_CODTAB,;
			(cAliasQry)->DA1_MOEDA,;
			(cAliasQry)->DA1_PRCVEN})

		(cAliasQry)->(dbSkip())
	enddo

	(cAliasQry)->(dbCloseArea())

	RestArea(_cArea)

return aColsDa1
