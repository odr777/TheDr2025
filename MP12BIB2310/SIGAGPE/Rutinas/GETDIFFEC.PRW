#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'

/*
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕ"±±
±±∫Programa  ≥ GETDIFFEC  												  ∫±±
±±∫Autor 	 ≥ Omar Delgadillo Robles  									  ∫±±
±±∫Fecha 	 ≥ 27/08/2018												  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±Descripcion≥ Devuelve la diferencia entre dos fechas en base al         ∫±±
±±∫          ≥ aÒo calendario(365/366 dÌas).                              ∫±±
±±∫          ≥ El resultado lo devuelve en un arreglo.                    ∫±±
±±∫          ≥ Se cambio de nombre de GETDIFFEC a DiffYMD365.			  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Bolivia                                   		  		  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
// U_GETDIFFEC(CTOD("01/01/2018"),CTOD("03/01/2018"))
// u_zArrToTxt(U_GETDIFFEC(CTOD("01/01/2018"),CTOD("03/01/2018")))

user function DiffYMD365(DDESDE, DHASTA)

	// DIFERENCIA EN AÒOS
	NDIFANHOS = YEAR(DHASTA)-YEAR(DDESDE)
	IF (YearSum(DDESDE,NDIFANHOS)>DHASTA)
		NDIFANHOS --
	ENDIF
	DNUEVODESDE := YearSum(DDESDE, NDIFANHOS)

	// DIFERENCIA EN MESES
	MESDESDE := Month(DNUEVODESDE)
	MESHASTA := Month(DHASTA)

	DIFMESES := 12
	If(Day(DHASTA) >= Day(DNUEVODESDE) )
		DIFMESES := 0
	EndIf
	IF (MESDESDE < MESHASTA)
		DIFMESES := MESHASTA - MESDESDE
	ENDIF
	IF (MESDESDE > MESHASTA)
		DIFMESES := 12 + MESHASTA - MESDESDE
	ENDIF

	IF (MonthSum(DNUEVODESDE,DIFMESES)>DHASTA)
		DIFMESES--
	ENDIF
	DNUEVODESDE := MonthSum(DNUEVODESDE,DIFMESES)

	// DIFERENCIA EN DIAS
	DIFDIAS :=0
	WHILE (DNUEVODESDE<DHASTA)
		DIFDIAS++
		DNUEVODESDE := DaySum(DNUEVODESDE, 1)
	END
	ARESPUESTA := {NDIFANHOS, DIFMESES, DIFDIAS}
RETURN  ARESPUESTA

/**
*
* @author: Omar Delgadillo Robles
* @since: 11/04/2024
* @description: Funcion que devuelve la cantidad de meses completos entre 2 fechas. 
*               Ejemplo: entre el 3/oct al 20/dic solo hay 1 mes completo que es noviembre.
* @parameters:	DDESDE -> Fecha desde
*				DHASTA -> Fecha hasta
*/

user function getMesCom(DDESDE, DHASTA)

	// DIFERENCIA EN AÒOS
	IF DDESDE <> FirstDate(DDESDE)  ///si no es el primer dia que lo vuelva primer dia
		DNUEVODESDE := FirstDate(MonthSum(DDESDE,1))
	else////quiere decir que ya tiene el primer dia del mes
		DNUEVODESDE := DDESDE
	ENDIF

	NDIFANHOS = YEAR(DHASTA)-YEAR(DNUEVODESDE)
	IF (YearSum(DNUEVODESDE,NDIFANHOS)>DHASTA)
		NDIFANHOS --
	ENDIF
	DNUEVODESDE := YearSum(DDESDE, NDIFANHOS)

	// DIFERENCIA EN MESES
	MESDESDE := Month(DNUEVODESDE)
	MESHASTA := Month(DHASTA)

	DIFMESES := 12
	If(Day(DHASTA) >= Day(DNUEVODESDE) )
		DIFMESES := 0
	EndIf
	IF (MESDESDE < MESHASTA)
		DIFMESES := MESHASTA - MESDESDE
	ENDIF
	IF (MESDESDE > MESHASTA)
		DIFMESES := 12 + MESHASTA - MESDESDE
	ENDIF

	IF (MonthSum(DNUEVODESDE,DIFMESES)>DHASTA)
		DIFMESES--
	ENDIF

	NRESPUESTA := (NDIFANHOS*12) + DIFMESES

RETURN  NRESPUESTA
