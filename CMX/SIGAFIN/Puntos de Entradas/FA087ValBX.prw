#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA087ValBX  ³ Autor ³ Denar Terrazas  	³ Data ³ 28/12/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Punto de entrada									    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BOLIVIA                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FA087ValBX()
	Local aDatos:= PARAMIXB
	Local nSaldoBs:= 0
	Local nSaldoDl:= 0
	Local cDescBs:= "Valor en Bs."
	Local cDescDl:= "Valor en $US"
	Local cDesc:= "Conversión"
	Local nTasaDl:= aTaxa[2]	//Tasa de la moneda 2
	//	Private oPAux:= oPPagto
	nSaldoBs:= aDatos[6] //* nTasaDl	//Se convierte a Bs.

//	If(SE1->E1_MOEDA == 2)	//Si la moneda es Dolar
//		cDescDl:= " "
//		nSaldoBs:= aDatos[6] * nTasaDl	//Se convierte a Bs.
//		@ 98,120 SAY cDesc /*cDescBs*/ SIZE 53,07 OF oPPagto PIXEL
//		@ 98,162 MSGET oSaldo VAR nSaldoBs  SIZE 61, 10 OF oPPagto PIXEL When .F. Picture "@E 999,999,999,999.99"
//	else
//		cDescBs:= " "
//		nSaldoDl:= aDatos[6] / nTasaDl	//Se convierte a $US
//		@ 98,120 SAY cDesc /*cDescDl*/ SIZE 53,07 OF oPPagto PIXEL
//		@ 98,162 MSGET oSaldo VAR nSaldoDl  SIZE 61, 10 OF oPPagto PIXEL When .F. Picture "@E 999,999,999,999.99"
//
//	endif*/
//		@ 108,140 SAY "108,140" /*cDescDl*/ SIZE 53,07 OF oPPagto PIXEL
		@ 118,150 SAY "Dif. Cambio: " + CVALTOCHAR(nSaldoBs )/*cDescDl*/ SIZE 53,07 OF oPPagto PIXEL
//		@ 148,160 SAY "148,160" /*cDescDl*/ SIZE 53,07 OF oPPagto PIXEL

	//	@ nT1,004 SAY OemToAnsi( "calcular a Dólares")  SIZE 53,07 OF oPPagto PIXEL //"Titulo"
	//	@ nT1,046 MSGET oNumTit Var &cNum 	SIZE 115, 10 OF oPPagto PIXEL HASBUTTON WHEN .F. //Picture cMasc3
	//		@ nT1,162 MSGET oValRec VAR nValRec 	SIZE 66, 10 OF oPPagto PIXEL HASBUTTON  WHEN .F. Picture cMasc3
	oLBBaixa:Refresh()
	oValRec:Refresh()

	DEFINE SBUTTON FROM 150,190  TYPE 18  ACTION (calcDolDif()) OF oPPagto When .T.

	//	oPPagto:= oPAux
	//	oPPagto:Refresh()
	//	@ 20,120 SAY OemToAnsi( STR0032 )  SIZE 53,07 OF oPPagto PIXEL //"= a Receber"
	//	@ 20,162 MSGET oSaldo VAR nSaldo  SIZE 66, 10 OF oPPagto PIXEL When .F. Picture cMasc3 //"@E 999,999,999,999.99"

return aDatos

static function calcDolDif()

	if SE1->E1_MOEDA == 1
		aLinBaixa[2][2]:= round(nSaldo / aLinMoed[2][2],2) // nSaldo +nRetCfg
		aLinBaixa[1][2]:= 0 //aLinBaixa[1][2] / 6.96//nSaldo +nRetCfg
		nValRec := round(aLinBaixa[2][2],2) * aLinMoed[2][2]
		if nValRec < nSaldo // si paga centavos menos
			nDescont := nSaldo - nValRec // calcula el valor del descuento
			nSaldo := nSaldo - nDescont  // actualiza o saldo
		elseif nValRec > nSaldo // si paga centavos menos
			nMulta := nValRec - nSaldo // calcula el valor de la multa
			nSaldo := nSaldo + nMulta // actualiza el saldo
		endif
	else
		aLinBaixa[1][2]:= round(nSaldo * aLinMoed[2][2],2) // nSaldo +nRetCfg
		aLinBaixa[2][2]:= 0 //aLinBaixa[1][2] / 6.96//nSaldo +nRetCfg
		nValRec := round(aLinBaixa[1][2],2) / aLinMoed[2][2]
	/*	if nValRec < nSaldo // si paga centavos menos
			nDescont := nSaldo - nValRec // calcula el valor del descuento
			nSaldo := nSaldo - nDescont  // actualiza o saldo
		elseif nValRec > nSaldo // si paga centavos menos
			nMulta := nValRec - nSaldo // calcula el valor de la multa
			nSaldo := nSaldo + nMulta // actualiza el saldo
		endif */
	endif
	oLBBaixa:Refresh()
	oValRec:Refresh()

return