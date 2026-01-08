//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zTiraZeros
Função que tira zeros a esquerda de uma variável caracter
@author Atilio
@since 19/07/2017
@version undefined
@param cTexto, characters, Texto que terá zeros a esquerda retirados
@type function
@example Exemplos abaixo:
    u_zTiraZeros("00000090") //Retorna "90"
    u_zTiraZeros("00000909") //Retorna "909"
    u_zTiraZeros("0000909A") //Retorna "909A"
    u_zTiraZeros("000909AB") //Retorna "909AB"
/*/
 
User Function zTiraZeros(cTexto)
    Local aArea     := GetArea()
    Local cRetorno  := ""
    Local lContinua := .T.
    Default cTexto  := ""
 
    //Pegando o texto atual
    cRetorno := Alltrim(cTexto)
 
    //Enquanto existir zeros a esquerda
    While lContinua
        //Se a priemira posição for diferente de 0 ou não existir mais texto de retorno, encerra o laço
        If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
            lContinua := .f.
        EndIf
         
        //Se for continuar o processo, pega da próxima posição até o fim
        If lContinua
            cRetorno := Substr(cRetorno, 2, Len(cRetorno))
        EndIf
    EndDo
     
    RestArea(aArea)
Return cRetorno
