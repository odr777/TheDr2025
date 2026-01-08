#Include "Protheus.ch"
#Include "Rwmake.ch"
/*
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
11111111111111111111111111111111111111111111111111111111111111111111111111111
11IMMMMMMMMMMQMMMMMMMMMMKMMMMMMMQMMMMMMMMMMMMMMMMMMMMKMMMMMMQMMMMMMMMMMMMM;11
11:Programa  3 FA086FLT  :Autor  3EDUAR ANDIA	    : Data 3  30/07/2019  :11
11LMMMMMMMMMMXMMMMMMMMMMJMMMMMMMOMMMMMMMMMMMMMMMMMMMMJMMMMMMOMMMMMMMMMMMMM911
11:Desc.     3 PE Filtro na rotina "Cancelar Ordem de Pagamento""         :11
11:Desc.     3 Pelo Fornecedor											  :11
11LMMMMMMMMMMXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM911
11:Uso       3 BOLIVIA\Unisn Agronegocios S.A.                            :11
11HMMMMMMMMMMOMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM<11
11111111111111111111111111111111111111111111111111111111111111111111111111111
_____________________________________________________________________________
*/

User Function FA086FLT
Local cResultPE := ""

If Type("mv_par07")=="C" .AND. Type("mv_par08")=="C" 	
	
	If !Empty(mv_par07)
		cResultPE := " AND EK_FORNECE >= '" + mv_par07 + "' AND EK_FORNECE <= '" + mv_par08 + "' "
	Else
		cResultPE := .F.
	Endif
Endif

Return(cResultPE)