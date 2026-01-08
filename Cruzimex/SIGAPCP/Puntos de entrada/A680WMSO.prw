#Include "Protheus.ch"
/*O ponto de entrada 'A680WMSO', permite informar o código do serviço, endereço e estrutura física
quando o produto a ser produzido possuir integração com o módulo WMS. Ao passar essas informações
por intermédio do PE, automaticamente será inibida a visualização da tela
que solicita a digitação dessas informações.
MATA680.PRX

Nahim 06/03/2020 

*/

User Function A680WMSO()

	Local _cProduto   := PARAMIXB[1]
	Local _cOp        := PARAMIXB[2]
	Local _cIdMov     := PARAMIXB[3]
	Local _aRet       := {}
	//	If Trim(Upper(_cProduto))==''   //
	//	FUNNAME() $ ''
	//	-- Customizações do Cliente
	AAdd( _aRet, PadR('001'   ,TamSX3('DB_SERVIC' )[1]) )   //
	//	-- Serviço
	AAdd( _aRet, PadR('A'  ,TamSX3('DB_LOCALIZ')[1]) ) //
	//	-- Endereço
//	AAdd( _aRet, PadR('000003',TamSX3('DB_ESTFIS' )[1]) ) //
	//	-- Estrutura Física

	//	EndIf

Return(_aRet)