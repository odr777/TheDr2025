#include 'protheus.ch'
#include 'parmtype.ch'

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  PE  ºAutor  ³ERICK ETCHEVERRY	       Fecha 23/07/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ Programa para copia de cliente UNION                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MA030ROT()
	aRetorno := {}
	AAdd( aRetorno, { "Copia", "u_a30copia()", 2, 0 } )
Return( aRetorno )

user function a30copia()
	Local aAlias := SA1->(GetArea())
	Local aCpos := {"A1_LOJA","A1_END","A1_TIPO","A1_PESSOA","A1_NOME","A1_CGC","A1_NREDUZ","A1_UNOMFAC","A1_UNITFAC","A1_EST","A1_MUN","A1_CONTA";
	,"A1_UCTAANT","A1_UCTIPO","A1_UCAPPAT","A1_UCAPMAT","A1_UCNOM","A1_TIPDOC","A1_UCELULA","A1_CODSEG","A1_UCODANT","A1_ULOJANT","A1_NATUREZ","A1_UCCC";
	,"A1_VEND","A1_ENDCOB","A1_COND","A1_TABELA","A1_OBSERV","A1_PAIS","A1_COMPLEM","A1_EMAIL","A1_TEL","A1_CONTATO","A1_DTNASC","A1_BARRIO","A1_ENDREC"}


	AxInclui("SA1", SA1->(Recno()), 3,,"u_carregaMenu()" ,aCpos,, .F., ,,,,,.T.,,,,,)
return

user function carregaMenu()
	M->A1_COD := SA1->A1_COD
	M->A1_TIPO := SA1->A1_TIPO
	M->A1_PESSOA := SA1->A1_PESSOA
	M->A1_NOME := SA1->A1_NOME
	M->A1_CGC := SA1->A1_CGC
	M->A1_NREDUZ := SA1->A1_NREDUZ
	M->A1_UNOMFAC := SA1->A1_UNOMFAC
	M->A1_UNITFAC := SA1->A1_UNITFAC
	M->A1_EST := SA1->A1_EST
	M->A1_MUN := SA1->A1_MUN
	M->A1_CONTA := SA1->A1_CONTA
	M->A1_UCTAANT := SA1->A1_UCTAANT
	M->A1_UCTIPO := SA1->A1_UCTIPO
	M->A1_UCAPPAT := SA1->A1_UCAPPAT
	M->A1_UCAPMAT := SA1->A1_UCAPMAT
	M->A1_UCNOM := SA1->A1_UCNOM
	M->A1_TIPDOC := SA1->A1_TIPDOC
	M->A1_UCELULA := SA1->A1_UCELULA
	M->A1_CODSEG := SA1->A1_CODSEG
	M->A1_UCODANT := SA1->A1_UCODANT
	M->A1_ULOJANT := SA1->A1_ULOJANT
	M->A1_NATUREZ := SA1->A1_NATUREZ
	M->A1_UCCC := SA1->A1_UCCC
	M->A1_VEND := SA1->A1_VEND
	M->A1_ENDCOB := SA1->A1_ENDCOB
	M->A1_COND := SA1->A1_COND
	M->A1_TABELA := SA1->A1_TABELA
	M->A1_OBSERV := SA1->A1_OBSERV
	M->A1_PAIS := SA1->A1_PAIS
	M->A1_MSBLQL := SA1->A1_MSBLQL
	M->A1_COMPLEM := SA1->A1_COMPLEM
	M->A1_EMAIL := SA1->A1_EMAIL
	M->A1_TEL := SA1->A1_TEL
	M->A1_CONTATO := SA1->A1_CONTATO
	M->A1_DTNASC := SA1->A1_DTNASC
	M->A1_ENDREC := SA1->A1_ENDREC
return
