#Include "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALCODCTRLºAutor  ³EDUAR ANDIA TAPIA   ºFecha ³  09/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función que valida el campo F1_CODCTR                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Union Agronegocios                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ValCodCtrl
Local cSep		:= "-"
Local cCadena 	:= ""
Local cCadAux 	:= ""	//Cadena (texto) sin Separadores.
     
DbSelectArea("SX3")
DbSetOrder(2)
SX3->(MsSeek("F1_CODCTR"))

cString := Alltrim(M->F1_CODCTR)

If Empty(cString) .OR. cString == '0'
	//Para pasar de campo (Simular que no hubieran ingresado al campo)
	Return(.T.)
Endif
//If lCompra
	//Para No Aplicar el Validador de campo en Facturas de Entrada - Compra
  //	Return(.T.)
//Endif
/* para colocar 3 en el campo Cod de control
If lGastos
	If M->F1_UCOCAN=="02"   
		cCadena := '3'
		M->F1_CODCTR := cCadena + Space (SX3->X3_TAMANHO - Len(cCadena))
		Return(.T.)
	Endif
Endif
*/    
For nI := 1 To Len(cString)
	cChar	:= Substr(cString,nI,1)	
	If cChar $"0|1|2|3|4|5|6|7|8|9|A|B|C|D|E|F|-"
	Else
		Aviso("Código invalido","Favor digitar caracteres:"+Chr(13)+Chr(10)+"0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F",{"OK"})
		Return(.F.)
	Endif
	If cChar <> cSep				
		cCadena += cChar
		cCadAux += cChar		
		If (Len(cCadAux)%2) == 0  .AND. (Len(cString)-nI) >= 2
			cCadena += cSep
		Endif
	Endif
Next nI
//Aviso("ValCodCtrl","cCadena: '"+cCadena+"'",{"OK"})          
If Len(cCadena) < 11 .OR. Len(cCadena) > 14
	Aviso("Código invalido","Favor digitar al menos 8~10 caracteres",{"OK"})
	Return(.F.)
Endif

M->F1_CODCTR := cCadena + Space (SX3->X3_TAMANHO - Len(cCadena))

Return(.T.)
