#include "TOTVS.ch"
#include "adprint.ch"

/*/{Protheus.doc} fSayDado
Imprime dados
@type function
@version 1.0
@author Luiz Fael
@since 10/01/2023
@param oPrn, object, objeto Impressao
@param nLinha, numeric, Linha
@param nCol, numeric, coluna
@param nQtLin, numeric, soma linha
@param oFonte, object, fontes carac
@param cTit, character, titulos
@param cCampo, character, campo
@param aDados, array, dados
@param nOpc, numeric, opcçãp
@return variant, Retorno
/*/
User Function fSayDado(oPrn,nLinha,nCol,nQtLin,oFonte,cTit,cCampo,aDados,nOpc)
	Local  nPos 	:= 0
	Local  cRet		:= ''
	default nLinha	:= 0
	default nCol	:= 0
	default nQtLin	:= 0
	default cTit	:= ''
	default cAlias	:= ''
	default cCampo	:= ''
	default aDados	:= {}
	default nOpc	:= 0
	If nOpc == 9 // imprime texto
		nLinha += nQtLin
		oPrn:Say(nLinha,nCol,cTit, oFonte)
	Else
		nPos := Ascan(aDados,{|x,y| x[1]==cCampo})
		If nPos <> 0
			If nOpc == 1 //Imprime o titulo da matrix
				nLinha += nQtLin
				oPrn:Say(nLinha,nCol,aDados[nPos][03]	, oFonte)
			ElseIf nOpc == 2 //Imprime o conteudo da matrix
				nLinha += nQtLin
				If aDados[nPos][04] == 'C'
					aDados[nPos][02] := Alltrim(aDados[nPos][02])
				ElseIf aDados[nPos][04] == 'N'
					aDados[nPos][02] := TRANSFORM(aDados[nPos][02],aDados[nPos][05])
				ElseIf aDados[nPos][04] == 'D'
					aDados[nPos][02] := DTOC(aDados[nPos][02])
				ElseIf aDados[nPos][04] == 'L'
					If aDados[nPos][02]
						aDados[nPos][02] := 'V'
					Else
						aDados[nPos][02] := 'F'
					Endif
				EndIf
				oPrn:Say(nLinha,nCol,cTit+aDados[nPos][02]	, oFonte)
			ElseIf nOpc == 3
				//retorna somente o conteudo da matrix
				cRet := aDados[nPos][02]
			EndIf
		EndIf
	EndIf
Return(cRet)
