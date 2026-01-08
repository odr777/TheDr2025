#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³CRDCRIABUT  ºAuthor ³Yamyl Saavedra    º Date ³  23/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de entrada para adicionar mais rotinas                º±±
±±º          ³al cadastro de clientes en SIGACRD                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ CIMA                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRDCRIABUT()
	Local  aBotoes := {}
	Public lPeVfd1 := .T.
	Public lCalif  := .T.
	
	Private lRetor := .T.
	
	cGruNiv2  := GetNewPar("MV_CRDNVL2",'000003')
	If ALTERA .And. !U_UserPertGrp(cGruNiv2)
		AAdd(aBotoes,{ "bmpord1", {|| Processa({||U_CalifSco()},"Analizar") }, "Analizar" } )
	ENDIF
	AAdd(aBotoes,{ "bmpord1", {|| Processa({||MsDocument('SA1', SA1->(RECNO())},"Conocimiento") }, "Conocimiento" } )
//	AAdd(aBotoes,{ "bmpord1", {|| Processa({||MsDocument('SA1', SA1->(RECNO())},"Conocimiento") }, "Conocimiento" } )
//	AAdd(aBotoes,{ "bmpord1", {|| Processa({||MsDocument('SA1', SA1->(RECNO())},"Conocimiento") }, "Conocimiento" } )
//	AADD(AROTINA, {'Conocimiento', 	"MsDocument", 0, 4 } )
Return(aBotoes)