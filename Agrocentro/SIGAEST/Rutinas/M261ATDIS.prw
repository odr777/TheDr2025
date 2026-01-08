/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  M261ATDIS  ºAutor  ³Erick Etcheverry  ºFecha ³  11/30/2023   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rutina para actulizar disparador de campo x a              º±±
campo  D3_XGERULT                                                         º±±              
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M261ATDIS
    Local nPosGerult := Ascan(Aheader,{|x| AllTrim(x[2]) == "D3_XGERULT" })
	Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="D3_COD"})
    Local nPosLocal := aScan(aHeader,{|x| AllTrim(x[2])=="D3_LOCAL"})
    Local nPosLote := aScan(aHeader,{|x| AllTrim(x[2])=="D3_LOTECTL"})
    Local nPosValid := aScan(aHeader,{|x| AllTrim(x[2])=="D3_DTVALID"})
    Local nPerGer := 0

    if nPosGerult > 0 .and. nPProduto > 0 .and. nPosLocal > 0 .and. nPosLote > 0 .and. nPosValid > 0

        nPerGer = POSICIONE("SB8",1,XFILIAL("SB8")+aCols[n][nPProduto]+aCols[n][nPosLocal];
        +DTOS(aCols[n][nPosValid])+aCols[n][nPosLote],"B8_XGERULT")

        aCols[n][nPosGerult] := nPerGer

    endif

return nPerGer
