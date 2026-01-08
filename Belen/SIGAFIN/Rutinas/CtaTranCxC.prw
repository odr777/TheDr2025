#Include "Protheus.ch"
#Include "Topconn.ch"  

#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetCuenta  ºAutor  ³EDUAR ANDIA	   	 º Data ³ 04/03/2020  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica Diferencia Cambiaria T.C. de la Transf. Bancaria  º±±
±±º          ³ vs T.C. Actual (SM2)                            		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \ Belén 		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CtaTranCxC(cTipo)
Local aArea := GetArea()
Local cCta	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ De Moeda 1 (Bs) a Moeda 2 (Usd)		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cTipo == "NCC"
	If AllTrim(SE1->E1_TIPO)=="NCC"
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			cCta := SA1->A1_UCTAANT 
		Endif
	Endif
	/*
	If AllTrim(SE1->E1_TIPO)=="RA"		
		cCta := xGetCta() 		
	Endif
	*/
Endif

If cTipo == "RA"
	/*
	If AllTrim(SE1->E1_TIPO)=="RA"
		SA1->(DbSetOrder(1))
		If SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
			cCta := SA1->A1_UCTAANT 
		Endif
	Endif
	*/
	If AllTrim(SE1->E1_TIPO)=="NCC"		
		cCta := xGetCta() 		
	Endif
Endif

Return(cCta)



//+-------------------------------------+
//|xGetCta		|
//+-------------------------------------+
Static Function xGetCta()
Local cRetCta 	:= ""
Local cQuery	:= ""
Local cAliasTRB := GetNextAlias()

cQuery := " SELECT A1_UCTAANT,SE1.R_E_C_N_O_ SE1RECNO" 
cQuery += " FROM " + RetSqlName("SE1") + " SE1 	"
cQuery += " INNER JOIN "+ RetSqlName("SA1") + " SA1 "
cQuery += " 	ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND SA1.D_E_L_E_T_ <> '*'	"
cQuery += " WHERE SE1.D_E_L_E_T_ <> '*'	"
cQuery += " AND E1_NUMSOL = '"+ SE1->E1_NUMSOL +"'"
cQuery += " AND E1_TIPO <> '"+ SE1->E1_TIPO +"'"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)
DbSelectArea(cAliasTRB)
        
If (cAliasTRB)->(!Eof())
	cRetCta := (cAliasTRB)->(A1_UCTAANT)
	
	SE1->(DbGoTo((cAliasTRB)->(SE1RECNO)))
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
EndIf
(cAliasTRB)->(DbCloseArea())

Return(cRetCta)

