	
#Include "Protheus.ch"

/*/{Protheus.doc} User Function FA090POS
    Obtiene la información del cheque de manera automática luego de dar la opción automática.

    @type  Function
    @author user
    @since 25/05/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

User function FA090POS()
Local aDados := {}
// E2_BCOCHQ, E2_AGECHQ,E2_CTACHQ,E2_VENCTO
aadd(aDados, SE2->E2_BCOCHQ )
aadd(aDados, SE2->E2_AGECHQ )
aadd(aDados, SE2->E2_CTACHQ )
aadd(aDados, "")
dVencIni	:= SE2->E2_VENCTO// Adiciona la fecha de vencimiento correcta.
dVencFim	:=SE2->E2_VENCTO // Adiciona la fecha de vencimiento correcta.
// Alert ("Tratamento das variáveis concluído com sucesso!")
Return aDados
