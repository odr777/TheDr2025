#INCLUDE "Protheus.ch"

/*/{Protheus.doc} MT110GRV
PE
@type function
@version 1.0
@author Luiz Fael
@since 21/11/2022
@return variant, Nill
/*/
User Function MT110GRV()
/*
	DO CASE
	CASE TYPE( "cCampana" ) == "U"
		cCampana := ""
	CASE TYPE( "cCampdes" ) == "U"
		cCampdes := ""
	CASE TYPE( "cCampro" ) == "U"
		cCampro := ""
	CASE TYPE( "cCamprod" ) == "U"
		cCamprod := ""
	CASE TYPE( "cChapa" ) == "U"
		cChapa := ""
	ENDCASE
*/

IF ALLTRIM( FunName() )  == "MATA110"
	RecLock("SC1",.F.)
	SC1->C1_CAMPANA	:= cCampana
	SC1->C1_CAMPDES	:= cCampdes
	SC1->C1_CAMPRO	:= cCampro
	SC1->C1_CAMPROD	:= cCamprod
	SC1->C1_XCHAPA  := cChapa
	SC1->(MsUnlock())
ENDIF

Return
