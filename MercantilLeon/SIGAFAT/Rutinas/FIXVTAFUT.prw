#include 'protheus.ch'
#include 'parmtype.ch'


//PUnto de entrada que se ejecuta despues de grabar el documento(SF1 y SD1)
//Sirve para actualizar los costos
//--- Jorge Saavedra

USER FUNCTION FIXVTAFUT
	Local aArea			:= getArea()
	Local cAliasQry		:= GetNextAlias()
	Local cQuery		:= ""
    Local cResposta := ""

	cQuery += "SELECT  TOP " + SuperGetMV("MV_XCVTAFU", .F., "20")
	cQuery += " * FROM PVFUT "
	cQuery += "ORDER BY PED_FACT "
	/*cQuery += " 		SC5.C5_FILIAL     = '" +cxFilial+ "' "
	cQuery += "         AND SC5.C5_NUM    = '" +cxNumFut+ "' "
	cQuery += "         AND SC5.C5_CLIENTE    <> '" +cxCli+ "' "
	cQuery += "         AND SC5.D_E_L_E_T_ = ' ' "*/

	//aviso("Query",cQuery,{'Ok'},,,,,.t.)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

	IF (cAliasQry)->( !EOF() ) ///trae algo
        WHILE (cAliasQry)->( !EOF() )
            dbSelectArea("SC5")                            // * Pedidos de Venda
		    dbSetOrder(1)
		    dbSeek(xFilial("SC5")+(cAliasQry)->PED_FACT)

            cResposta += U_GERVTAFUT((cAliasQry)->PED_ENTREGA,.t.) ///RETORNEMOS LA VARIABLE PARA IR CONCATENANDO

			SC5->(DbCloseArea())

            (cAliasQry)->(dbskip())
        enddo
	EnDIF

	(cAliasQry)->(DbCloseArea())

    Aviso("",cResposta,{'ok'},,,,,.t.)

	restArea(aArea)

return
