#INCLUDE "RWMAKE.CH"
//Punto de Entrada para Agregar un botón en el toolbar al PC MATA120
User Function LOCXPE01
Local _aButton:={}
Local aEnt:={}
Local nOpcX := 0                                                  
                           
if aCfgNF[1] == 54
   _aButton := {{'bmpord1',{|| U_XLxA462TN()}, " Sol. Almacén", "  Sol. Almacén"}}
end


Return(_aButton)