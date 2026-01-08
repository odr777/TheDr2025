#INCLUDE 'RWMAKE.CH'          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA416PV ºAutor  ³Nain Terrazasº Data ³23/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada despues de Aprobacion de presupuestoº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercnatil                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA416PV    

	//Aviso("P.E.: MTA416PV "+SCK->CK_PRODUTO,"Depósito"+SCK->CK_LOCAL,{"OK"})
	//Se ejecuta despues de la aprobación de Presupuesto y es por Item
Local _n
nPosCnt		:= Ascan(_aHeader, {|x|Alltrim(x[2])=="C6_QTDVEN"})
nPosPro		:= Ascan(_aHeader, {|x|Alltrim(x[2])=="C6_PRODUTO"})
nPosLoc		:= Ascan(_aHeader, {|x|Alltrim(x[2])=="C6_LOCAL"})
nPosTes		:= Ascan(_aHeader, {|x|Alltrim(x[2])=="C6_TES"})
nGetStock   := 0

for _n:=1 to Len(_aCols)
	IF _aCols[_n][nPosTes] <> '800'
//		nGetStock:= U_GetStockNeg(SCK->CK_PRODUTO, SCK->CK_LOCAL, SCK->CK_QTDVEN)
		nGetStock:= U_GetStockNeg(_aCols[_n][nPosPro], _aCols[_n][nPosLoc], _aCols[_n][nPosCnt])
		IF nGetStock <  _aCols[_n][nPosCnt]
			aviso("ALERTA PE:MTA416PV",_aCols[_n][nPosPro]+": Este producto NO permite Stock Negativo, Se creará el PV con Cantidad Menor al Presupuesto",{'ok'},,,,,.t.)
			_aCols[_n][nPosCnt] := nGetStock
		Endif
		IF nGetStock = 0
			M->C5_CLIENTE := " "
		Endif
	EndIf
Next

Return
