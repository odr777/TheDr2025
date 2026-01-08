#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³GetCCH    ºAuthor ³Jorge Saavedra           º Date ³  22/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que cambia automaticamente Datos(Valor,Beneficiarioº±±
±±º          ³ Nro. de Rendicion)  de la Caja Chica, al momento de hacer  º±±
±±º          ³ la rendición desde la Factura de Entrada						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ BASE BOLIVIA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GetCCH()
	Local nX := 1

	If Upper(Funname())== 'MATA101N'
		If !Empty(cCxCaixa)
			IF SELECT('Rendicion') > 0           //Verifica se o alias OC esta aberto
				Rendicion->(DbCloseArea())       //Fecha o alias OC
			END

			IF SELECT('Duplicado') > 0           //Verifica se o alias OC esta aberto
				Duplicado->(DbCloseArea())       //Fecha o alias OC
			END



			cQuery:= "SELECT "+ iif(ALLTRIM(TCGetDB())$"MSSQL","ISNULL","NVL") +"(MAX(EU_NRREND),0) AS NRO FROM " + RetSqlName('SEU')
			cQuery+= " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO='00'"
			cQuery+= " AND EU_FILIAL='" + XFILIAL('SEU')+ "'"
			TCQUERY cQuery NEW ALIAS "Rendicion"

			If Rendicion->(!EOF()) .AND. Rendicion->(!BOF())
				IF !EMPTY(Rendicion->NRO)
					cCxRendic:=StrZero(val(Rendicion->NRO),10,0)

					if(ALLTRIM(TCGetDB())$"MSSQL")
						cQuery:= "SELECT  top 1 * FROM " + RetSqlName('SEU')
						cQuery+= " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO IN ('00','10') "
						cQuery +=" AND EU_FILIAL='" + XFILIAL('SEU')+ "'ORDER BY R_E_C_N_O_ DESC"
					else
						cQuery:= "SELECT  * FROM " + RetSqlName('SEU')
						cQuery+= " Where EU_CAIXA='"+ cCxCaixa + "' AND D_E_L_E_T_ <> '*' AND EU_TIPO IN ('00','10') "
						cQuery +=" AND EU_FILIAL='" + XFILIAL('SEU')+ "' AND ROWNUM=1 ORDER BY R_E_C_N_O_ DESC"
					end



					TCQUERY cQuery NEW ALIAS "Duplicado"

					If Duplicado->(!EOF()) .AND. Duplicado->(!BOF())

						If Duplicado->EU_TIPO == '10'
							cCxRendic:=StrZero(Val(cCxRendic) + 1,10,0)
						END

					ELSE
						cCxRendic:=StrZero(Val(cCxRendic) + 1,10,0)
					End
				Else
					cCxRendic:=StrZero( 1,10,0)

				END
			Else
				cCxRendic:=StrZero( 1,10,0)
			END
			nPosTotal  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TOTAL'     } )
			nPosDesc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALDESC'     } )
			nPosVl3	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALIMP3'     } )
			nPosVl7 := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALIMP7'     } )
			nPosVl6 := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALIMP6'     } )
			nPosVl8 := Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_VALIMP8'     } )
			nPosTes  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'D1_TES'     } )

			nValor:=0
			For nX := 1 To LEN(aCols)
				////vamos a recorrer siempre y cuando no este borrado
				if ! aCols[nX][Len(aCols[nX])]
					IF POSICIONE('SF4',1,XFILIAL('SF4')+aCols[nX][nPosTes],'F4_XRETEN') $ "2"
						nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc] - aCols[nX][nPosVl3] - aCols[nX][nPosVl7] - aCols[nX][nPosVl6] - aCols[nX][nPosVl8]
					ELSE
						nValor:= nValor +aCols[nX][nPosTotal] - aCols[nX][nPosDesc]
					ENDIF
				endif
			Next nX

			nCxValor:=nValor

			cCxBenef:=POSICIONE('SET',1,XFILIAL('SET')+cCxCaixa,'ET_NOME')
		End

	End

Return .T.


