#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT462MNU ºAutor  ³TdeP Horeb S.R.L.º Data ³  29/05/2017     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada que adiciona un boton para imprimir        º±±
±±º          ³de acuerdo a una rutina en especifica 					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIB                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT462MNU()

	If FwIsAdmin() .and. SuperGetMV("MV_UACTAVI",.F.,.F.) //Si perteneces al grupo de Administradores y El parámetro de aviso de PE está activado
	Aviso("MV_UACTAVI","MV_UACTAVI Activo - ProcName: "+ProcName(),{'ok'},,,,,.t.)
	ENDIF

	Do Case
		Case FUNNAME() == 'MATA462TN' //Transferencia
		//	AADD(AROTINA,{ 'Imprimir',"U_REMITSUC()"     , 0 , 5})

			AADD(AROTINA,{ 'Imprimir',"U_TRAINV" , 0 , 5})

		If aCfgNf[1]==54 //Transferencia de Entrada
			AAdd(aRotina,{ "Leyenda"  ,"LocxLegenda()",0 , 2,0,.F.} )
			//AAdd(aCores,{  ' F2_TIPODOC=="54"' , 'BR_LARANJA'})
			AAdd(aCores,{  'U_IsTransPend() .AND.F2_TIPODOC=="54"' , 'BR_LARANJA'})
			AAdd(aCores,{  '!U_IsTransPend() .AND. F2_TIPODOC	==	"54"'    		, 'BR_PRETO'}) 		// Remito transf.
			//AAdd(aCores,{  "F2_DOC=='EDU-SAL-0001'", 'BR_LARANJA'})
		Endif
		//	 	AADD(AROTINA,{ 'Imp. Transf. Serie',"U_TRASERIE" , 0 , 5})
		CASE FUNNAME()='MATA462N' // Remito
			AADD(AROTINA,{ 'Impr Nota Entrega',"U_IMPRENTA(F2_DOC,F2_DOC,F2_SERIE,1)", 0 , 5})
		Case FUNNAME()$'MATA102N|MATA462N'
			AADD(AROTINA,{ 'Imprimir',"U_IMPREMITO()"     , 0 , 5})
			// AADD(AROTINA,{ 'Imprimir PTD.',"U_ParDiGra()"     , 0 , 5})
			//AADD(AROTINA,{ 'Impr Nota Entrega',"U_IMPRENTA(F2_DOC,F2_DOC,F2_SERIE,1)", 0 , 5})
			//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
			//AADD(AROTINA,{ 'Conocimiento',"U_CONOC_REM()"     , 0 , 5})
		Case FUNNAME()=='MATA101N' //Factura de Entrada
			AADD(AROTINA,{ 'Imprimir',"U_FacEnt()"     , 0 , 5})
			AADD(AROTINA, {'Conocimiento' ,"MsDocument", 0 , 4 , 0 , NIL})		// "Conocimiento"
			//AADD(AROTINA,{ 'Imprimir Cert',"U_IMPCERTIF()"     , 0 , 5})
		Case FUNNAME() == 'MATA467N'
			//AADD(AROTINA,{ 'Cobro',"U_FactQR()"     , 0 , 5})
			//AADD(AROTINA,{ 'Imprimir Factura',"U_GFATI301(F2_DOC,F2_DOC,F2_SERIE,1)"     , 0 , 9})
			AADD(AROTINA,{ 'Imprimir Facturas',"U_impFactura(F2_DOC,F2_SERIE,F2_ESPECIE)"     , 0 , 9})
			// AADD(AROTINA,{ 'Imp. Plan de Pago',"U_PlanPag(F2_CLIENTE,F2_DOC,F2_EMISSAO)"     , 0 , 9})
	EndCase

Return

/*user function impnopv()

	U_FACTLOCAL(SF2->F2_DOC,SF2->F2_DOC,SF2->F2_SERIE,1,"ORIGINAL")
	//U_FACTLOCAL(SF2->F2_DOC,SF2->F2_DOC,SF2->F2_SERIE,1,"COPIA")
	//U_FACTLOCAL(SF2->F2_DOC,SF2->F2_DOC,SF2->F2_SERIE,1,"COPIA")

return*/
