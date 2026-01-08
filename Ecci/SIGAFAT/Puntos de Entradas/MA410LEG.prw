#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA410LEG บAutor  ณ Walter C. Silva (Boli) บ Data ณ 09/28/04บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E. para ajustar cores do Browse de Pedido de Vendas con- บฑฑ
ฑฑบ          ณ templando o Bloqueio por Margem.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA410LEG()        

_aCores:=PARAMIXB
AADD(_aCores,{"BR_BRANCO","Pedido de venta aprobado parcial"})
AADD(_aCores,{"BR_PINK","Pedido de venta para Entrega Futura"})
//AADD(_aCores,{"BR_VERDE_ESCURO","Pedido de venta con anticipo (RA)"})
AADD(_aCores,{"BR_CANCEL","Pedido en Consignacion Finalizado en Remito"})     
//AADD(_aCores,{"BR_AZUL_CLARO","Pedido de venta con Ch้que sin cobro"})  
aAdd(_aCores,{'BR_PRETO'   , "Pedido de Ventas con Bloqueo de stock" })
aAdd(_aCores,{'BR_VIOLETA' , "Pedido de Ventas con Bloqueo de cr้dito" })
//aAdd(_aCores,{'BR_MARRON' , "Pedido de Ventas al cr้dito liberado" })

Return(_aCores)