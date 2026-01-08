
#include "TOTVS.ch"
#Define ENTER "<BR>"  // SALTO DE LINEA (RETORNO DE CARRO + AVANCE DE LiNEA)

/*
-----------------------------------------------------------------------------
|  Programa: FINA580     Autor: Fernando CastillO        Fecha: 18-08-2020  |
-----------------------------------------------------------------------------
| Descripciùn: Permite enviar notificaciones a correos de destino cada      |
|              vez que se hace una Liberaciùn para Bajas (Aprob. de Pago)   |
-----------------------------------------------------------------------------
| Ambientes    MP12BIB / MP12PRD                                            |
-----------------------------------------------------------------------------
| Uso          FINA580 (PUNTO DE ENTRADA EN LA FUNCION                      |
-----------------------------------------------------------------------------
| Empresa      CIABOL                                                       |
-----------------------------------------------------------------------------
*/
User Function FINA580()    
cListaDest := GETMV('MV_MAILLB')	// Lista de Correos de Destino
cListaCC   := GETMV('MV_MAILLBC')	// Lista de Correos para enviar Con Copia

//   Aviso("Informacion PE MT120APV","Se Genero el PC: "+SC7->C7_NUM,{"Ok"},,"Atencion")
//	cEventID := "062"
//	EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,"",ctitulo,cMesagem,.T.)
	cMessagem := " <H3>SE HIZO LA LIBERACION PARA PAGO DEL DOCUMENTO: " + SE2->E2_NUM + "</H3>" + ENTER 
    cMessagem += " SUCURSAL: " + SE2->E2_FILIAL + ENTER
	cMessagem += " USUARIO APROBADOR: " + SE2->E2_USUALIB + ENTER
	cMessagem += " TIPO: " + SE2->E2_TIPO + ENTER
	cMessagem += " MODALIDAD: " + SE2->E2_NATUREZ + ENTER
	cMessagem += " PROVEEDOR: " + SE2->E2_FORNECE + " - " + SE2->E2_NOMFOR + ENTER
	cMessagem += " FECHA EMISION: " + DTOC(SE2->E2_EMISSAO) + ENTER
	cMessagem += " FECHA VENCIMIENTO: " + DTOC(SE2->E2_VENCREA) + ENTER

	if SE2->E2_MOEDA == 1
		cMessagem += " VALOR PAGO: " + cValToChar(SE2->E2_VALOR) + " BOLIVIANOS " + ENTER
        //cMessagem += " VALOR PAGO     : " + Transform(SE2->E2_VALOR,"@E 9.999.999.99") + " BOLIVIANOS " + ENTER
	elseif SE2->E2_MOEDA == 2
		cMessagem += " VALOR: " + cValToChar(SE2->E2_VALOR) + " DOLARES " + ENTER
	else	
		cMessagem += " VALOR PAGO: " + cValToChar(SE2->E2_VALOR) + " EUROS " + ENTER
	endif

	cMessagem += " DETALLE: " + SE2->E2_HIST + ENTER + " "
	cMessagem += " <H4>EN ESPERA DE ORDEN DE PAGO </H4>" + ENTER

    if AllTrim(SE2->E2_USUALIB) <> "" .And. SE2->E2_EMISSAO > CTOD("30/06/2020")
	    U_EnviarMail(cListaDest, cListaCC, "SISTEMA TOTVS: Se realizù la Liberaciùn para Bajas (Aprobaciùn de PAGOS)",nil,cMessagem)
    endif
//	MSGINFO( "Mensaje enviado a los correos definidos", "INFORMACION" )
//  MsgStop("Rotina desabilitada devido ao Controle de Alùadas de Aprovaùùo."+CRLF+;
//		    "Por favor, utilize a rotina de Aprovaùùo de Documentos de Alùada.","Workflow de Pagamentos")	

Return(.T.)
