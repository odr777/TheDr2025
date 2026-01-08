#INCLUDE "RWMAKE.CH"
//Punto de Entrada para Agregar un botón en el toolbar al PC MATA120
User Function LOCXPE01
Local _aButton:={}
Local aEnt:={}
Local nOpcX := 0                                                  
                           
if aCfgNF[1] == 54
   _aButton := {{'bmpord1',{|| U_XLxA462TN()}, " Sol. Almacén", "  Sol. Almacén"}}
   _aButton := {{'bmpord1',{|| U_XLxA103ForF4()}, " PC o PO", "  PC o PO"}}
end
if aCfgNF[1] == 51 .or. aCfgNF[1] == 53
   _aButton := {{'LxDocOri',{|| LxDocOri()}, "Facturas", "Facturas"}}
endif


Return(_aButton)
