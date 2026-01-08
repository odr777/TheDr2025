#Include "Protheus.ch"

//Posicoes do Array  ASE2
#DEFINE _SALDO    5
#DEFINE _SALDO1   6
#DEFINE _PREFIXO  9
#DEFINE _RECNO   13
#DEFINE _PAGAR   21

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F085ARRSE2 ºAutor  ³EDUAR ANDIA        º Data ³  11/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE -Validação do painel de ordem de pagamento 		  	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia /Unión Agronegocios                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F085ARRSE2
Local aSE2	:= ParamIxb[1]
Local lRet	:= .T.
Local nI	:= 0
Local aTits	:= {}
Local aCXP	:= {}

If Len(aSE2)>0
	If Len(aSE2[1])>0
		If Len(aSE2[1][1])>0
			aTits := aSE2[1][1]			
		Endif
	Endif
Endif

For nI := 1 To Len(aTits)
	aCXP := aTits[nI]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Titulos Provisorios no se tiene que Pagar                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aCXP[_PREFIXO]$ "PLZ|PRV"
		If aCXP[_RECNO]> 0
			SE2->(MsGoTo(aCXP[_RECNO]  ))
			If AllTrim(SE2->E2_TIPO) $ "NF|NDP"
				If SE2->E2_PREFIXO $ "PLZ" .AND. AllTrim(SE2->E2_ORIGEM) $ "FINA050"
					Aviso("AVISO - F085ARRSE2","No se puede hacer pagos de Titulos provisorios de Seguro de Polizas",{"OK"})
					/*
					aSE2[1][1][nI][_SALDO] := 0
					aSE2[1][1][nI][_SALDO1]:= 0
					aSE2[1][1][nI][_PAGAR] := 0
					*/
				Endif
				If SE2->E2_PREFIXO $ "PRV" .AND. AllTrim(SE2->E2_ORIGEM) $ "MATA100"
					Aviso("AVISO - F085ARRSE2","No se puede hacer pagos de Titulos provisorios",{"OK"})
				Endif
			Endif
		Endif		
	EndIf
Next nI

Return(aSE2)
