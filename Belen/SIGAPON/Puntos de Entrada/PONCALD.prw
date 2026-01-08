#include 'protheus.ch'
#include 'parmtype.ch'

/**
*
* @author: Denar Terrazas Parada
* @since: 13/03/2020
* @description: Punto de entrada para:
*				- Modificar el concepto que se genera para el pago Dominical con el nro de domingos del mes
* @parameter: N/A
* @return: N/A
* @use: Industrias Belen
* @routine: PONM070.PRX - Consolida Resultados
* @help: https://tdn.totvs.com/pages/releaseview.action?pageId=6082544
*/
user function PONCALD()
	Local aArea		:= getArea()
	Local cDSRCodFol:= '0779'	//Identificador Dominical
	Local cPDDOM	:= GetAdvFVal("SRV","RV_COD", xFilial("SRV") + cDSRCodFol, 2, "")
	Private cMatDe	:= MV_PAR10
	Private cMatAte	:= MV_PAR11
	Private cPeriodo:= MV_PAR02

	If(Empty(SRA->RA_DEMISSA))
		If(SRA->RA_MAT >= cMatDe .AND. SRA->RA_MAT <= cMatAte)
			dbSelectArea("SPB")
			SPB->(dbSetOrder(1))//PB_FILIAL+PB_MAT+PB_PD+PB_CC+PB_DEPTO+PB_POSTO+PB_CODFUNC
			If(!Empty(cPDDOM))
				If(SPB->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cPDDOM)))
					RECLOCK("SPB", .F.)
					SPB->PB_HORAS := getDomingos()
					SPB->(MSUNLOCK())
				EndIF
			EndIf
			SPB->(dbCloseArea())
		EndIf
	EndIf
	restArea(aArea)
return

/**
*
* @author: Denar Terrazas Parada
* @since: 13/03/2020
* @description: Funcion que obtiene el nro de domingos en el mes.
* @parameter: 	N/A
*/
static function getDomingos()
	Local nRet		:= 0
	Local dDataIni	:= STOD(cPeriodo + '01')
	Local dDataFim	:= MV_PAR20
	Local dData		:= dDataIni

	If(SUBSTRING(DTOS(SRA->RA_ADMISSA), 1, 6) == cPeriodo)
		dData:= SRA->RA_ADMISSA
	EndIf

	While(dData <= dDataFim)
		If(DOW(dData) == 1)
			nRet+= 1
		EndIf
		dData += 1
	EndDo

return nRet
