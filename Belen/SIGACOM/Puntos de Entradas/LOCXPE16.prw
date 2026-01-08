#Include 'Protheus.ch'
#Include "Topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ LocxPe16 ³ Autor ³ TdeP               ³ Fecha³ 30/09/2017  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Punto de Entrada paga validar en OK rutinas LocxNF         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis  ³ LocxPe16( void )                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. o .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MP12BIB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Ninguno                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
[16] - Apos as validações da rotina TudOk
*/

User Function LOCXPE16()
	Local _lRet:= .T.
	local nX
	local ny
	local nz

	//Valida que el Valor registro en Caja Chica sea igual al Valor de la Factura de Entrada
	IF alltrim(FunName()) $ "MATA101N"
		nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'     } )
		nPosTotal  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TOTAL'     } )
		nPosDesc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } )
		nPosImp  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_UIMPEXE'     } )
		If upper(M->F1_SERIE)=='CCH'
			nValor:=0
			For nX := 1 To LEN(aCols)
				nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc]
			Next nX
			IF nValor<> nCxValor
				Alert('El Valor de la Caja Chica NO es igual a la Factura')
				_lRet:= .F.
			END

			//--------------- Actualizamos el Nro de Rendicion por Caja Chica -------------------//
			if Type("cCxCaixa")<>'U'
				If !Empty(cCxCaixa)
					For nz := 1 To LEN(aCols)
						If (POSICIONE('SF4',1,XFILIAL('SF4')+aCols[nz][nPosTes],'F4_XCCH') == "N") //NO DEJA USAR TES DE CCH EN BELEN
							_lRet = .f.
							Alert('No se esta usando una TES de caja chica')
							Return _lRet
						End
					Next nz


					IF SELECT('Rendicion') > 0           //Verifica se o alias OC esta aberto
						Rendicion->(DbCloseArea())       //Fecha o alias OC
					END

					cQuery:= "SELECT COUNT(EU_CAIXA)AS NRO FROM " + RetSqlName('SEU')
					cQuery+= " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO='10'"

					TCQUERY cQuery NEW ALIAS "Rendicion"

					If Rendicion->(!EOF()) .AND. Rendicion->(!BOF())
						IF !EMPTY(Rendicion->NRO)
							cCxRendic:=StrZero(Rendicion->NRO,10,0)
						END
					END
				End
			End
			
		End

		If upper(M->F1_SERIE)<>'CCH' ///SI ES FACTURA NORMAL
			// F4_XCCH=’S’
			For ny := 1 To LEN(aCols)
				If (POSICIONE('SF4',1,XFILIAL('SF4')+aCols[ny][nPosTes],'F4_XCCH') == "S") //NO DEJA USAR TES DE CCH EN BELEN
					_lRet = .f.
					Alert('Se esta usando una TES de caja chica')
					Exit
				End
			Next ny
		ENDIF
	End

	//Alert("Finalizó LOCXPE16")

Return _lRet

