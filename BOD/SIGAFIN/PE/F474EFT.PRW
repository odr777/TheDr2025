#INCLUDE 'TOTVS.CH'
#INCLUDE "PROTHEUS.CH"
  
/*/{Protheus.doc} F474EFT
Aplicar regras de efetivação dos movimentos dos registros do extrato bancário na importação do arquivo de extratos.
 
@type       Function
@author     TOTVS
@since      31/08/2023
@return     Nil
/*/
User Function  F474EFT()
    Local oMovAPI:= PARAMIXB[1] as Json

    If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON STD",oMovAPI,{'Ok'},,,,,.t.)
	endif
    //Aplique aqui as regras para que um determinado registro da SIG seja efetivado na FK5/SE5
    //A tabela SIG está posicionada no registro que acabou de gravar, de onde podem ser obtidos os dados para validação e efetivação nos movimentos bancários do Protheus.
 
Return
