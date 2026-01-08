#include "rwmake.ch"
#include "protheus.ch"

/*volverlo igual que zn1
adicionar activo a las boletas fuera de linea
cambia status automatico despues de grabar
*/
User function creaZEH()
	LOCAL cAlias := "ZEH"
	PRIVATE cCadastro := "Registro de Polizas y Boletas de garantia"
	PRIVATE aRotina     := { }

	AADD(aRotina, { "Buscar", "AxPesqui", 0, 1 })
	AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })
	AADD(aRotina, { "Incluir"      , "u_incZEH"   , 0, 3 })
	AADD(aRotina, { "Modificar"     , "AxAltera"  , 0, 4 })
	AADD(aRotina, { "Borrar"     , "u_delZEH" , 0, 5 })
	//AADD(aRotina, { "Actualizar Bien"     , "U_ActAvlAf" , 0, 6 })
	AADD(aRotina, { "Incluir Activo Boleta", "U_AFBOL001",0,2,0,.T.})   //"IncluirActivoxLC"/
	AADD(aRotina, { "Retirar Activo Boleta", "U_AFBOL002",0,2,0,.F.})   //"ExcluirActivoxLC"
	AADD(aRotina, { "Visualizar Activos Boleta", "U_AFBOL004",0,2,0,.F.})   //"VisualizarActivoxLC"
	AADD(aRotina,{"Imprimir Garantias", "U_IMPGARA",0,2,0,.F.} )

	dbSelectArea(cAlias)

	dbSetOrder(1)

	mBrowse(6, 1, 22, 75, cAlias)

Return

user Function ZEHAtuVl()

	Local lRetorno := .F.
	Local aTxMoedas := {}

	Aadd(aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1")})
	nC := 4//MoedFin()

	For nA	:=	2	To nC
		cMoedaTx	:=	Str(nA,IIf(nA <= 9,1,2))
		If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
			Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
		Else
			Exit
		Endif
	Next

	If M->ZEH_MOEDA >= 1 .And. M->ZEH_MOEDA <= 4 //MoedFin()
		lRetorno := .T.
		M->ZEH_VLCRUZ := M->ZEH_VALOR * aTxMoedas[M->ZEH_MOEDA][2]
		M->ZEH_SALDO  := M->ZEH_VALOR
	Else
		msgalert('Elegir moneda','Favor digitar moneda valida')
		lRetorno := .F.
	EndIf

Return lRetorno

user Function ZEHAtuTipo()

	If M->ZEH_APLEMP == 'BOL'
		lRetorno := .T.
		M->ZEH_UGRUPO := 'BO'
	Else
		If M->ZEH_APLEMP == 'POL'
			lRetorno := .T.
			M->ZEH_UGRUPO := 'PO'
		Else
			msgalert('Elegir modelo','Favor elegir modelo de transacción')
			M->ZEH_UGRUPO := ''
			lRetorno := .F.
		EndIf
	Endif
return lRetorno

user function incZEH()

	nOpcao := AxInclui('ZEH', 0, 3)
	If nOpcao == 1
		SA6->(dbSetOrder(1))
		SA6->(dbGoTop())
		if SA6->(dbSeek(xfilial("SA6")+ZEH->ZEH_BANCO+ZEH->ZEH_AGENCI+ZEH->ZEH_CONTA))
			nValorLin := 0
			nValorOP := 0
			if SA6->A6_MOEDA == 1
				nValorLin = SA6->A6_USLDLIN - iif(ZEH->ZEH_MOEDA == 1,ZEH->ZEH_VALOR,xMoeda(ZEH->ZEH_VALOR,2,1,ZEH->ZEH_DATA,2))  //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
			else              //banco esta en dolares
				nValorLin = SA6->A6_USLDLIN - iif(ZEH->ZEH_MOEDA == 2,ZEH->ZEH_VALOR,xMoeda(ZEH->ZEH_VALOR,1,2,ZEH->ZEH_DATA,2) )  //xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02)
			endif
			RecLock("SA6", .F.)
			SA6->A6_USLDLIN = nValorLin
			MSUnlock()
		endif
	EndIf
return

user function delZEH()

	nOpcao := AxDeleta("ZEH", ZEH->( Recno() ), 5) //AxInclui('ZEH', 0, 3)
	If nOpcao == 2
		SA6->(dbSetOrder(1))
		SA6->(dbGoTop())
		if SA6->(dbSeek(xfilial("SA6")+ZEH->ZEH_BANCO+ZEH->ZEH_AGENCI+ZEH->ZEH_CONTA))
			nValorLin := 0
			nValorOP := 0
			if SA6->A6_MOEDA == 1
				nValorLin = SA6->A6_USLDLIN + iif(ZEH->ZEH_MOEDA == 1,ZEH->ZEH_VALOR,xMoeda(ZEH->ZEH_VALOR,2,1,ZEH->ZEH_DATA,2))  //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
			else              //banco esta en dolares
				nValorLin = SA6->A6_USLDLIN + iif(ZEH->ZEH_MOEDA == 2,ZEH->ZEH_VALOR,xMoeda(ZEH->ZEH_VALOR,1,2,ZEH->ZEH_DATA,2) )  //xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02)
			endif
			RecLock("SA6", .F.)
			SA6->A6_USLDLIN = nValorLin
			MSUnlock()
		endif
	EndIf
return
