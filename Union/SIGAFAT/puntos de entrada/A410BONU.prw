#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410BONU  ºAutor  ³ERICK ETCHEVERRY   ºFecha ³  07/08/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Permite identificar los productos bonificadores       º±±
±±º          ³ y alterar el descuento			                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function A410BONU()
	Local __aCols := PARAMIXB[1] ///acols
	Local aPosic  := PARAMIXB[2] // posiciones producto qtdad tes en la tela
	Local aBonus := {}
	Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
	Local nDesc    := aScan(aHeader,{|x| AllTrim(x[2])=='C6_DESCONT' })
	Local nValDes  := aScan(aHeader,{|x| AllTrim(x[2])=='C6_VALDESC' })
	Local nPrunit  := aScan(aHeader,{|x| AllTrim(x[2])=='C6_PRUNIT' })
	Local nPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=='C6_PRCVEN' })
	Local nQtdven  := aScan(aHeader,{|x| AllTrim(x[2])=='C6_QTDVEN' })
	Local nValtot  := aScan(aHeader,{|x| AllTrim(x[2])=='C6_VALOR' })

	aAreaSE4 := SE4->(GetArea())
	SE4->(DbSetOrder(1))
	SE4->(DbSeek( xFilial("SE4") + M->C5_CONDPAG ))
	aBonus := FtRgrBonus(aCols,{aPosic[1],aPosic[2],aPosic[3]},M->C5_CLIENTE,M->C5_LOJACLI,M->C5_TABELA,M->C5_CONDPAG,SE4->E4_FORMA)//trae las reglas que bonificaron fata090.prx
	SE4->(RestArea(aAreaSE4))

	nY := Len(aBonus)
	If nY > 0
		For nX := 1 To nY
			aProds := aBoniffn(aBonus[nX][4]) //paso la regla que creo la bonificacion

			if !empty(aProds)
				for i:= 1 to len(aProds)
					for z:= 1 to len(aCols)
						if alltrim(aCols[z][nPProd]) == alltrim(aProds[i])
							aCols[z][nDesc]:= 0
							aCols[z][nValDes]:= 0
							aCols[z][nPrcVen]:= aCols[i][nPrunit] //actualizando valores
							aCols[z][nValtot]:= aCols[i][nQtdven]*aCols[i][nPrunit]

						endif
					next z
				next i
			endif
		Next nX
	EndIf

return aBonus

STATIC FUNCTION aBoniffn(cCodReg)
	LOCAL cQuery:= ""
	LOCAL aProds:= {}
	Local aArea	:= GetArea()

	cQuery := "SELECT ACR_CODPRO"
	cQuery += " FROM " + RetSqlName("ACR") + " ACR "
	cQuery += " INNER JOIN " + RetSqlName("ACQ") + " ACQ ON ACQ_FILIAL=ACR_FILIAL AND ACQ_CODREG = ACR_CODREG AND ACQ.D_E_L_E_T_=' '"
	cQuery += " WHERE ACR_FILIAL = '"+XFILIAL("ACR")+"' "
	cQuery += " AND ACR_CODREG = '" + cCodReg + "' "
	cQuery += " AND ACR.D_E_L_E_T_=' ' "

	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//aviso("",cQuery,{'ok'},,,,,.t.)
	TCQuery cQuery New Alias "QRY_SEL"

	if !QRY_SEL->(EoF())
		while !QRY_SEL->(EoF())
			aadd(aProds,QRY_SEL->ACR_CODPRO)
			QRY_SEL->(dbskip())
		enddo
	endif

	//Aviso("Array IVA",u_zArrToTxt(aRecnos, .T.),{'ok'},,,,,.t.)

	QRY_SEL->(DbCloseArea())
	RestArea(aArea)

RETURN(aProds)