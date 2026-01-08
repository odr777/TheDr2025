#Include 'Protheus.ch'

#Include 'FWMVCDEF.ch'

/*/{Protheus.doc} User Function MT311ROT
    Punto de entrada para imprimr la solicitud de transferencia
    
    https://tdn.totvs.com/display/public/PROT/TVRS86_DT_NOVO_PE_SOLICITACAO_TRANSFERENCIA
    https://tdn.totvs.com/display/public/PROT/PEST07671_PONTO_DE_ENTRADA_MT311ROT

    @type  Function
    @author user
    @since 27/08/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function MT311ROT()


Local aRet := Paramixb // Array contendo os botoes padroes da rotina.


// Tratamento no array aRet para adicionar novos botoes e retorno do novo array.

ADD OPTION aRet TITLE "Imprimir Solicitud." ACTION "U_RELSOL01" OPERATION 4 ACCESS 0

Return aRet

