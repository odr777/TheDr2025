#include 'protheus.ch'
#include 'parmtype.ch'

user function F087ABXOK()
Local lRet:= .T.
Local _nJuros:= nJuros

//nJuros := round(nJuros, 2)
//nValRec := round(nValRec, 2)
//nMulta := round(nMulta, 2)
//nDescont := round(nDescont, 2)
//nSaldo := round(nSaldo, 2)
//nValorBx := round(nValorBx, 2)

	If round(_nJuros,2) <> round(fa070Juros(Max(SE1->E1_MOEDA,1)),2)
		Msginfo("No puede modificar el campo Intereses")
		nJuros:= round(fa070Juros(Max(SE1->E1_MOEDA,1)),2)
		nSaldo := SE1->E1_SALDO+nJuros
		For nI := 1 To nQtMoedas
			aLinBaixa[nI]:={SuperGetMV("MV_MOEDA"+Alltrim(Str(nI))),aLinSE1[oLBSE1:nAt][anPosMoed[nI]]}
		Next nI
		oJuros:Refresh()
		oSaldo:Refresh()
		oLBBaixa:SetArray(aLinBaixa)
		oLBBaixa:bLine	:= { || {aLinBaixa[oLBBaixa:nAT][1],;
		Transform(aLinBaixa[oLBBaixa:nAT][2],PesqPict("SE1","E1_VALOR",18)) }}
		oLBBaixa:Refresh()
		
		oDescont:Disable()
		oMulta:Disable()
		oJuros:Disable()
		lRet:= .F.
	EndIf
return lRet