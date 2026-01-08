#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ A143EXCLUI  º Autor ³ Erick Etcheverry  º Data ³  28/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ PE al borrar despachos		 				  	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                       	            	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user function A143EXCLUI()
	Local nPNota := aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'DBB_DOC'})
	Local nPSerie := aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'DBB_SERIE'})
	Local nPosFornec := aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'DBB_FORNEC'})
	Local nPLoja := aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'DBB_LOJA'})

	for i := 1 to len(aCols)
		cDocx := aCols[i][nPNota]
		cSerx := aCols[i][nPSerie]
		cProvx := aCols[i][nPosFornec]
		cLojx := aCols[i][nPLoja]

		if len(alltrim(aCols[i][nPNota])) >= 3 .and. substr(alltrim(aCols[i][nPNota]),len(alltrim(aCols[i][nPNota]))-2,len(alltrim(aCols[i][nPNota]))) $ "-DP"  ////si es SF1 EXTERNA
			///MARCAR SF1 para saber que se jalo temporalmente
			//if aCols[len(aCols)][Len(aHeader1)+1] ///ultima linea que valida si esta activa o eliminada   .t. activa .f. eliminada
			DbSelectArea("SF1")
			SF1->(DbSetOrder(1))
			If SF1->(DbSeek(xFilial("SF1")+cDocx+cSerx+cProvx+cLojx))
				if SF1->F1_UFLAGRA == "S" ///ya esta grabado retorna para no dejar grabar
					RecLock('SF1',.F.)	//Modificando el item Grabado por el Disparador
					SF1->F1_UFLAGRA := ""
					SF1->(MsUnlock())
				ENDIF

			Endif
		endif
	next i
return .t.
