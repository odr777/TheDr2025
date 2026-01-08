#Include 'Protheus.ch'

#Include 'FWMVCDEF.ch'


User Function MT311ROT()


Local aRet := Paramixb // Array contendo os botoes padroes da rotina.


// Tratamento no array aRet para adicionar novos botoes e retorno do novo array.

ADD OPTION aRet TITLE "Imprimir Solicitud." ACTION "U_RELSOL01" OPERATION 4 ACCESS 0

Return aRet

