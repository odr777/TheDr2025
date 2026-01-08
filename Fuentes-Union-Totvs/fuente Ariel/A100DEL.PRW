#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
//--------------------------------------------------------------------
/*/{Protheus.doc} A100DEL
@description VALIDA SE SERA EFETUADA EXCLUSAO DE NF
	O P.E. e' chamado antes de qualquer atualizacao na exclusao e deve ser utilizado para validar.
	se a exclusao deve ser efetuada ou nao.
	Programa Fonte:	MATA103.PRW
	Retorno
	URET(qualquer)
	Logico. Se verdadeiro(.T.) prossegue com exclusao. Se falso(.F.) abandona exclusao.
@param
@author Ariel Dominguez Vargas 
@since  04/02/2023
@obs:
@version MP12.1.27 
/*/
//--------------------------------------------------------------------

// Objetivo: Validar que las Facturas se Borren
User Function A100DEL()
	Local lRet := .T.

	If ( AllTrim( FunName() ) == "MATA101N" ) .AND. SF1->F1_TIPODOC = "10" 
		lRet := PuedeBorrar()
	EndIf

Return lRet

//Función que busca si tiene titulos dados de baja
// en realidada solo buscaremos en SE2 si el saldo es menos al valor, con esto se sobreentiende que tiene baja
Static Function PuedeBorrar()
	Local lRet := .T.

	Local aArea := GetArea()
	Local cArea := GetNextAlias()

	BeginSql Alias cArea

		SELECT E2_VALOR,E2_SALDO FROM %table:SE2% SE2
				WHERE SE2.%NotDEL% 
			   		AND %Exp: SF1->F1_FILIAL% 	= E2_FILIAL  
					AND %Exp: SF1->F1_SERIE%  	= E2_PREFIXO 
					AND %Exp: SF1->F1_DOC% 		= E2_NUM  
					AND %Exp: SF1->F1_FORNECE% 	= E2_FORNECE 
					AND %Exp: SF1->F1_LOJA%   	= E2_LOJA    
					AND %Exp: SF1->F1_DTDIGIT%	= E2_EMIS1 
					
	EndSql
	
	DbSelectArea(cArea) 
	DbGoTop()
	If !Eof()
		If (cArea)->E2_SALDO < (cArea)->E2_VALOR
			lRet := .F.
			alert("No puede borrar una factura cuya CxP haya sido dada de baja")
		EndIf
	EndIf
    DbCloseArea()
	RestArea(aArea)

Return lRet
