#Include "Protheus.ch"
#Include "Rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA087COL ºAutor  ³EDUAR ANDIA	    º Data ³  19/06/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para poder modificar os campos no Lisbox do SE1         º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA087COL
Local aCpos 	:= {}
Local c_Alias 	:= "SE1"

aCpos	:= {"E1_CLIENTE","E1_LOJA"		,"E1_NOMCLI"	,;
			"E1_PREFIXO","E1_NUM"		,"E1_PARCELA"	,"E1_TIPO"		,"E1_EMISSAO"	, ;			
			"E1_MOEDA"	,"E1_VALOR"		,"E1_SALDO"		,"E1_DESCONT"	,"E1_JUROS"		, ;
			"E1_MULTA" 	,"E1_NATUREZ"	,"E1_ORIGEM"	,"E1_VENCREA"	}			

			//"E1_NATUREZ","E1_MOEDA"	,"E1_VALOR"	,"E1_SALDO" 	,"E1_VENCREA"		}
			
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek(c_Alias,.F.)
Do While !EOF() .And. X3_ARQUIVO == Alltrim(c_Alias)
	If x3uso(x3_usado) .And. cNivel >= X3_NIVEL .And. AScan(aCpos,Alltrim(X3_CAMPO))==0
		
		If SX3->X3_CAMPO $ "E1_XXX"
		Else
			//AAdd(aCpos,X3_CAMPO)	//EA 23/10/2019
		Endif
	Endif
	DbSkip()
Enddo

Return(aCpos)