#include 'protheus.ch'
#include 'parmtype.ch'

/**
*
* @author: Denar Terrazas Parada
* @since: 13/03/2020
* @description: Punto de entrada para: modificar el concepto de atrasos de acuerdo a la siguiente tabla:
*				-----------------------------
*				|Atraso			| Descuento |
*				|---------------------------|
*				|30 - 89 Min.	| 1/2 día	|
*				|90 - 119 Min.	| 1 día		|
*				|120 - 239 Min.	| 2 días	|
*				|>= 240 Min.	| 3 días	|
*				-----------------------------
* @parameter: N/A
* @return: N/A
* @use: ECCI
* @routine: PONM070.PRX - Consolida Resultados
* @help: https://tdn.totvs.com/pages/releaseview.action?pageId=6082544
*/
user function PONCALD()
	Local aArea		:= getArea()
	Local cDSRCodFol:= '0055'//Concepto de Atraso con descuento
	Local cATRCod	:= GetAdvFVal("SRV","RV_COD", xFilial("SRV") + cDSRCodFol, 2, "")
	Private cMatDe	:= MV_PAR10
	Private cMatAte	:= MV_PAR11

	If(SRA->RA_MAT >= cMatDe .AND. SRA->RA_MAT <= cMatAte)
		dbSelectArea("SPB")
		SPB->(dbSetOrder(2))//PB_FILIAL+PB_MAT+PB_PD+DTOS(PB_DATA)+PB_CC+PB_DEPTO+PB_POSTO+PB_CODFUNC
		If(!Empty(cATRCod))
			If(SPB->(dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + cATRCod + DTOS(dDataBase))))
				RECLOCK("SPB", .F.)
				If(SPB->PB_HORAS >= (30/100) .AND. SPB->PB_HORAS <= (89/100))
					SPB->PB_HORAS:= 0.5//Medio día de descuento
				ElseIf(SPB->PB_HORAS >= (90/100) .AND. SPB->PB_HORAS <= (119/100))
					SPB->PB_HORAS:= 1//1 día de descuento
				ElseIf(SPB->PB_HORAS >= (120/100) .AND. SPB->PB_HORAS <= (239/100))
					SPB->PB_HORAS:= 2//2 día de descuento
				ElseIf(SPB->PB_HORAS >= (240/100))
					SPB->PB_HORAS:= 3//3 día de descuento
				Else
					DBDELETE()
				EndIf
				SPB->(MSUNLOCK())
			EndIF
		EndIf
		SPB->(dbCloseArea())
	EndIf
	restArea(aArea)
return
