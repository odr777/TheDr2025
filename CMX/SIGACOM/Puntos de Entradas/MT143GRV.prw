#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ MT143GRV  º Autor ³ Erick Etcheverry    º Data ³  28/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ PE al grabar lineas o modificaciones del despacho            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user function MT143GRV()
	Local nPNota    := aScan(aHeader1,{|x| AllTrim(x[2])=="DBB_DOC"})
	Local nPSerie   := aScan(aHeader1,{|x| AllTrim(x[2])=="DBB_SERIE"})
	Local nPosFornec:= aScan(aHeader1,{|x| AllTrim(x[2])=="DBB_FORNEC"})
	Local nPLoja    := aScan(aHeader1,{|x| AllTrim(x[2])=="DBB_LOJA"})
	Local nOpcxa := paramixb[1]
	Local xret := .t.

	if nOpcxa == 4 ////modificar
		for i := 1 to len(aCols)
			cDocx := aCols[i][nPNota]
			cSerx := aCols[i][nPSerie]
			cProvx := aCols[i][nPosFornec]
			cLojx := aCols[i][nPLoja]

			if len(alltrim(aCols[i][nPNota])) >= 3 .and. substr(alltrim(aCols[i][nPNota]),len(alltrim(aCols[i][nPNota]))-2,len(alltrim(aCols[i][nPNota]))) $ "-DP"////si es SF1 EXTERNA
				///MARCAR SF1 para saber que se jalo temporalmente
				if !aCols[i][Len(aHeader1)+1] ///ultima linea que valida si esta activa o eliminada   .f. activa .t. eliminada
					DbSelectArea("SF1")
					SF1->(DbSetOrder(1))
					cDocx := substr(alltrim(cDocx),1,len(alltrim(aCols[i][nPNota]))-3)+ space(18-len(substr(alltrim(cDocx),1,len(alltrim(aCols[i][nPNota]))-3)))
					If SF1->(DbSeek(xFilial("SF1")+cDocx+cSerx+cProvx+cLojx))
						/*if SF1->F1_UFLAGRA == "S" ///ya esta grabado retorna para no dejar grabar
						xret := .f.
						MSGINFO( "Suprima los gastos externos o presione anular en el despacho" , "Gastos externos ya grabados"  )
						else
						RecLock('SF1',.F.)	//Modificando el item Grabado por el Disparador
						SF1->F1_UFLAGRA := "S"
						SF1->(MsUnlock())
						ENDIF*/

						RecLock('SF1',.F.)	//Modificando el item Grabado por el Disparador
						SF1->F1_UFLAGRA := "S"
						SF1->(MsUnlock())

					Endif
				else////si es eliminada tiene que desmarcar
					DbSelectArea("SF1")
					SF1->(DbSetOrder(1))
					cDocx := substr(alltrim(cDocx),1,len(alltrim(aCols[i][nPNota]))-3)+ space(18-len(substr(alltrim(cDocx),1,len(alltrim(aCols[i][nPNota]))-3)))
					If SF1->(DbSeek(xFilial("SF1")+cDocx+cSerx+cProvx+cLojx))
						RecLock('SF1',.F.)	//Modificando el item Grabado por el Disparador
						SF1->F1_UFLAGRA := ""
						SF1->(MsUnlock())
					Endif
				endif
			endif
		next i
	endif

return xret