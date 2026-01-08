#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ getInPed ³ Autor ³ Nahim Terrazas					  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida si la condicion de pago es Valida, dependiendo del tipo de cliente ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MODCONPAG()
	Local aArea    := GetArea()
	Local cResp:=.F.
	Local cCondpag:=""
	Local cTipoCli:="3" //por defecto 3

	Local cPrio1:=0
	Local cPrio2:=0

	/* anterior
	cCondpag:=M->C5_CONDPAG
	cCond := POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND")	
	if cCondpag <= cCond
		//Alert("OK")
		cResp=.T.
	else
		Alert("Solo es permitido seleccionar una Condición de Pago menor")
		cResp=.F.
	endif
	fin anterior */

	cCondpag:=M->C5_CONDPAG
	cClient:=M->C5_CLIENTE
	cLoja:=M->C5_LOJACLI
	cCond := POSICIONE("SA1",1,XFILIAL("SA1")+cClient+cLoja,"A1_COND")
	cTipoCli := POSICIONE("SA1",1,XFILIAL("SA1")+cClient+cLoja,"A1_UACTLP")	

	cUctipo := POSICIONE("SA1", 1, XFILIAL("SA1"+cClient+cLoja), "A1_UCTIPO") //para determinar si el cliente es DGAN	

	cPrio1:= POSICIONE("SE4", 1, XFILIAL("SE4")+cCondpag,"E4_UPRIO")
	cPrio2:= POSICIONE("SE4", 1, XFILIAL("SE4")+cCond,"E4_UPRIO")

	cResp:=.T.
	
	// si la nueva condicion es mayor a la condicion actual Y Tipo Cliente Esta vacio => NO puede subir
	if cPrio1 > cPrio2 .and. Alltrim(cTipoCli)==""
		Alert("Solo es permitido seleccionar una Condición de Pago menor para Clientes con tipo: "+Alltrim(cTipoCli) )
		cResp=.F.	
	end if	
	


	// si la nueva condicion es mayor a la condicion actual Y Tipo Cliente Plazo Fijo => NO puede subir
	if val(cCondpag) != val(cCond) .and. cTipoCli=="3"
		Alert("No esta permitido cambiar la Condición de Pago para Clientes Plazo Fijo")
		cResp=.F.	
	end if

	//si el cliente es DGAN y la condicion es contado Efectivo => Rechazamos
	if cUctipo =="1" .and. cCondpag == "002"
		Alert("No esta permitido Contado Efectivo para clientes DGAN")
		cResp=.F.		
	end if

	RestArea(aArea)

	
RETURN cResp
