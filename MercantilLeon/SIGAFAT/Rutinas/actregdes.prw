#include "Topconn.ch"
#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} User Function ACTRGDES
    A Partir de el me

    @type  Actualiza Regla de descuento de cliente
    @author user
    @since 29/01/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ACTRGDES(cCliente,cloja,cAtClien,cAtLoja,nOpcX)
	default cCliente := '10741 '
	default cloja := '01'
	default cAtClien := '10741 '
	default cAtLoja := '01'
	default nOpcX := 4
	Private lMsErroAuto    := .F. // Indica se houve erro na execução da rotina automática
	Private lMsHelpAuto	  := .T. // Gera mensagem de erro como aquivo .LOG na system


	_cQuery := " SELECT ACO_CODREG,ACO_DESCRI,ACO_CODCLI, "
	_cQuery += " ACO_LOJA,ACO_MOEDA,ACO_TPHORA,ACO_HORADE,ACO_HORATE,ACO_DATDE, DESCUENTOS.*,ACP.* "
	_cQuery += " FROM "
	_cQuery += " ( "
	_cQuery += " SELECT COALESCE(SD2B.D2_DESC, 0) D2_DESC, SD2B.D2_COD, D2_CLIENTE+D2_LOJA D2_CLIENTE "
	_cQuery += " FROM " + RetSqlName("SD2") + " SD2B JOIN "
	_cQuery += " ( SELECT MAX(SD2.R_E_C_N_O_) RECNO
	_cQuery += " FROM " + RetSqlName("SF2") + " SF2
	_cQuery += " JOIN " + RetSqlName("SD2") + " SD2 ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE "
	_cQuery += " AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA "
	_cQuery += " WHERE SF2.F2_CLIENTE between '" + cCliente + "' AND '" + cAtClien + "' "
	_cQuery += "	AND SF2.F2_LOJA between '" + cloja + "' AND '" + cAtLoja + "' "
	_cQuery += "	AND SF2.D_E_L_E_T_ = '' "
	_cQuery += "	AND SD2.D_E_L_E_T_ = '' "
	_cQuery += " 	AND	SF2.F2_FILIAL = '" + xfilial("SF2") + "' "
	_cQuery += "	GROUP BY SD2.D2_COD "
	_cQuery += "	) RECNS ON  SD2B.R_E_C_N_O_ = RECNO "
	_cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON SD2B.D2_COD = SB1.B1_COD AND SB1.D_E_L_E_T_ = '' AND B1_MSBLQL <> 1 ) DESCUENTOS"
	// Buscando Regla de descuento que cohincida con el cliente
	_cQuery += " JOIN " + RetSqlName("ACO") + " ACO "
	_cQuery += " ON ACO_CODCLI = '" + cCliente + "' "
	_cQuery += " AND ACO_LOJA >= '" + cloja + "' "
	_cQuery += " AND ACO_LOJA <= '" + cAtLoja + "' "
	_cQuery += " AND ACO_FILIAL = '" + xfilial("ACO") + "' AND ACO.D_E_L_E_T_ = '' "
	_cQuery += " LEFT JOIN  "
	_cQuery +=  RetSqlName("ACP") + " ACP ON ACP_CODREG = ACO_CODREG AND ACP.D_E_L_E_T_ LIKE '' "

	_cQuery += " AND DESCUENTOS.D2_CLIENTE = ACO_CODCLI + ACO_LOJA AND D2_COD = ACP_CODPRO"
	_cQuery += " AND ACP.ACP_CODPRO = DESCUENTOS.D2_COD "
	_cQuery += " ORDER BY ACP_ITEM DESC "

	If __CUSERID = '000000'
		aviso("AVISO",_cQuery,{'ok'},,,,,.t.)
	EndIf

	If Select("strSQL")>0 // cerar el áre
		strSQL->(dbCloseArea())
	End

	TcQuery _cQuery New Alias "strSQL"


	if nOpcX == 4   //////modificar

		if ! strSQL->(EoF()) // si tiene valor
			cCurrentCli  := strSQL->ACO_CODCLI
			cCurrentLoja := strSQL->ACO_LOJA
			aCabecalho   := {}
			aadd(aCabecalho, {"ACO_CODREG", strSQL->ACO_CODREG,Nil})
			aLinha 	:= {}
			While ! strSQL->(EoF()) // Mientras siga teniendo valores
				if cCurrentCli ==  strSQL->ACO_CODCLI // mismo cliente aumenta la lista
					if empty(strSQL->ACP_CODPRO) // producto nuevo
						aItens := {}
						aAdd(aItens,{"ACP_CODPRO" ,strSQL->D2_COD, NIL})
						aAdd(aItens,{"ACP_PERDES" ,strSQL->D2_DESC, NIL})
						aAdd(aLinha ,aItens) // CRIA NOVO
					else // alteración de producto
						aItens := {}
						aadd(aItens,{"LINPOS",     "ACP_ITEM",strSQL->ACP_ITEM })
						aadd(aItens,{"AUTDELETA",  "N",Nil})
						aAdd(aItens,{"ACP_CODPRO" ,strSQL->D2_COD, NIL})
						aAdd(aItens,{"ACP_PERDES" ,strSQL->D2_DESC, NIL})
						aAdd(aLinha ,aItens) // ALTERA
					endif
				else // Incluye Registro y cambia Cliente

				endif
				strSQL->(DbSkip())
			enddo
			//
			MSExecAuto({|X,Y,Z| FATA080(X,Y,Z)}, aCabecalho, aLinha, nOpcX) // MODIFICAR

			If !lMsErroAuto
				MsgInfo("Descuentos actualizados con éxito","Descuento actualizados éxito")
				ConOut("Alterada com sucesso! " + "SM0032")

			Else
				MostraErro()
				MsgInfo("Error en la alteración","Error en la alteración")
				ConOut("Erro na alteração!")
			EndIf
		else
			alert("No se encontró Reglas de descuentos")
		endif
	endif

//     aCabecalho   := {}
//    aadd(aCabecalho, {"ACO_CODREG",   "000001",                         Nil})
//     aLinha 	:= {}
// 	// aAdd(aItens,{"ACP_CODPRO" ,"T1EC/T-KT", NIL})
// 	// aAdd(aItens,{"ACP_PERDES" , 15), NIL}) 
// 	// aAdd(aLinha ,aItens) // atualizando
// 	// aAdd(aItens,{"ACP_CODPRO" , "T1I+1EC/T", NIL})
// 	// aAdd(aItens,{"ACP_PERDES" , 15), NIL})   //
// 	// aAdd(aLinha ,aItens) // atualizando


//     aItens := {}
//     aadd(aItens,{"LINPOS",     "ACP_ITEM",     '001'})
//     aadd(aItens,{"AUTDELETA",  "N",            Nil})
//    	aAdd(aItens,{"ACP_CODPRO" ,"T1EC/T-KT", NIL})
// 	aAdd(aItens,{"ACP_PERDES" , 14, NIL}) 
// 	aAdd(aLinha ,aItens) // ALTERA

//     aItens := {}
// 	aAdd(aItens,{"ACP_CODPRO" ,"TREF-AB        T", NIL})
// 	aAdd(aItens,{"ACP_PERDES" , 15, NIL}) 
// 	aAdd(aLinha ,aItens) // CRIA NOVO

//     // aItens := {}
// 	// aAdd(aItens,{"ACP_CODPRO" , "1-13X48-F7-K-1", NIL})
// 	// aAdd(aItens,{"ACP_PERDES" , 15, NIL})   //
// 	// aAdd(aLinha ,aItens) // atualizando
//     // aItens := {}
// 	// aAdd(aItens,{"ACP_CODPRO" , "BAN 09X13 HAM-4               ", NIL})
// 	// aAdd(aItens,{"ACP_PERDES" , 12, NIL})   //
// 	// aAdd(aLinha ,aItens) // atualizando
//     // BAN 27X48 MULTICOLOR SI-8     

//     MSExecAuto({|X,Y,Z| FATA080(X,Y,Z)}, aCabecalho, aLinha, nOpcion) // MODIFICAR

//    If !lMsErroAuto
//       ConOut("Alterada com sucesso! " + "SM0032")
//    Else
//       ConOut("Erro na alteração!")
//    EndIf

Return
