#INCLUDE "RWMAKE.CH"
#Include 'Protheus.ch'
#Include "Topconn.ch"
//REGISTRA ORDEN DE SEGUIMIENTO DE CONTADOR DEL BIEN
// Borrar
user function LOCXPE28()
//	ALERT("LOCXPE28")
	IF FUNNAME() == "MATA102N"
		// estoy posicionado en la SD1
		// TODO realizar validación para que sea cuando se borre
		// APunte de producción
		getATF(SD1->D1_CLVL,xFilial("SF1")) //ITEM OBTENIDO POR CLASE VALOR
		if ! VW_CPX->(EoF())

			ArrTeste := {}
			AADD(Arrteste, GetSXENum("FNA", "FNA_IDMOV")) //IDMOV
			AADD(Arrteste, '001') //ITMOV
			//AADD(Arrteste, ctod('20191113'))//DATA   dEmissa
			AADD(Arrteste, SF1->F1_EMISSAO)
			AADD(Arrteste, 'P9') ///TIPO APUNTE
			AADD(Arrteste, SF1->F1_EMISSAO) //PERIODO INICIAL
			AADD(Arrteste, SF1->F1_EMISSAO) //PERIODO FINAL
			AADD(Arrteste, SD1->D1_UHORAEQ) // cantidad de horas D1_UHORAEQ
			AADD(Arrteste, VW_CPX->N3_CBASE)// N3_CBASE
			AADD(Arrteste, VW_CPX->N3_ITEM)// N3_ITEM
			AADD(Arrteste, VW_CPX->N3_TIPO)// N3_TIPO
			AADD(Arrteste, VW_CPX->N3_SEQ)

			VW_CPX->(DbCloseArea())

			U_AF110EXC(Arrteste) // EJECUTA FUNCIÓN DE APUNTE DE PRODUCCIÓN INVERSO
			
			//      MT830DEL(nUhrinie,nUhrfine,nUhoraeq,dUdtptd,cClval)
			U_MT830DEL(SD1->D1_UHRINIE,SD1->D1_UHRFINE,SD1->D1_UHORAEQ,SF1->F1_EMISSAO,SD1->D1_CLVL) // EJECUTA FUNCIÓN DE APUNTE DE PRODUCCIÓN INVERSO

			ConfirmSx8()
		ENDIF
	ENDIF
	// vamos a

RETURN

//carga atf
static function getATF(cCvl,cFilla)
	Local cQuery	:= ""

	If Select("VW_CPX") > 0
		dbSelectArea("VW_CPX")
		dbCloseArea()
	Endif

	/*SELECT N3_FILIAL,N3_CBASE,N3_ITEM,N3_TIPO,N3_SEQ FROM SN3010
	WHERE N3_CLVL = 'CVLTESTE   '
	AND N3_FILIAL = '0101'*/

	cQuery := "	SELECT N3_FILIAL,N3_CBASE,N3_ITEM,N3_TIPO,N3_SEQ "
	cQuery += "  FROM " + RetSqlName("SN3") + " SN3 "
	cQuery += "  WHERE N3_CLVL = '" + cCvl + "' "
	cQuery += "  AND N3_FILIAL = '" + cFilla + "' AND SN3.D_E_L_E_T_ = '' "

	TCQuery cQuery New Alias "VW_CPX"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return