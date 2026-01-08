#INCLUDE "Protheus.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CT105QRY ³ Autor ³ Omar Delgadillo       ³ Data ³ 17.12.21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Punto de entrada para agregar campos personalizados al     ³±±
±±³          ³ asiento contable 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ GLOBAL                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function CT105QRY()
    cQuery := ParamIXB[1]  // RECEBE A QUERY DO SISTEMA
    lAglut := ParamIXB[2]  // RECEBE O PARÂMETRO DO SISTEMA SE AGLUTINA = .T. SE NÃO AGLUTINA = .F.
    If  lAglut
        //ADCIONANDO CAMPO CTK_INFOR ADCIONADO VIA CONFIGURADOR NA TABELA CTK PELO USUARIO
        cQuery  :=   StrTran( cQuery, "FROM", ", CTK_CODFOR, CTK_XLOJA, CTK_XNUM, CTK_XSERIE, CTK_XESPEC, CTK_XUSINC, CTK_XMOD, CTK_XORDPA, CTK_XREVER, CTK_XBANCO, CTK_XAGENC FROM" )
        cQuery  :=   StrTran( cQuery, "ORDER BY", ", CTK_CODFOR, CTK_XLOJA, CTK_XNUM, CTK_XSERIE, CTK_XESPEC, CTK_XUSINC, CTK_XMOD, CTK_XORDPA, CTK_XREVER, CTK_XBANCO, CTK_XAGENC ORDER BY" ) 
    EndIf
 
Return cQuery 
