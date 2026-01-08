#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ GETDIFFEC  												  º±±
±±ºAutor 	 ³ Omar Delgadillo Robles  									  º±±
±±ºFecha 	 ³ 27/08/2018												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ Devuelve la diferencia entre dos fechas en base al         º±±
±±º          ³ año calendario(365/366 días).                              º±±
±±º          ³ El resultado lo devuelve en un arreglo.                    º±±
±±º          ³ Se cambio de nombre de GETDIFFEC a DiffYMD365.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia                                   		  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// U_GETDIFFEC(CTOD("01/01/2018"),CTOD("03/01/2018"))
// u_zArrToTxt(U_GETDIFFEC(CTOD("01/01/2018"),CTOD("03/01/2018")))

user function DiffYMD365(DDESDE, DHASTA)

	// DIFERENCIA EN AñOS
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
