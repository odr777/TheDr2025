#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#Define ENTER "<BR>"  // SALTO DE LÍNEA (RETORNO DE CARRO + AVANCE DE LÍNEA)
#INCLUDE "FWEVENTVIEWCONSTS.CH"

/*/{Protheus.doc} User Function M415GRV
    (long_description)
    @type  Function
    @author user
    @since 20/01/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function M415GRV(param_name)
    nOption :=  Paramixb[1] // 1 inclusión | 2 modificación | 3 exclusion
    if nOption == 1
        	cBody := " <H3>Nueva Solicitud: " + SCJ->CJ_NUM + "</H3>" + ENTER
        // cMessagem += " SUCURSAL: " + SC7->C7_FILIAL + ENTER
        cNombreCli := GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,1,"") // quitando dado que daba problemas (tomaba otro cliente 21/0/2020)
        cBody += " Cliente: " + SCJ->CJ_CLIENTE + " - "+ cNombreCli + ENTER
        cSubject := "E-Commerce ML - Presupuesto: " + SCJ->CJ_NUM
        // cMessagem += " CENTRO DE COSTO: " + SC7->C7_CC + ENTER
        // cMessagem += " CLASE DE VALOR: " + SC7->C7_CLVL + ENTER
        // cMessagem += " OBSERVACIONES: " + SC7->C7_OBS + ENTER
        // cMessagem += " OBSERVACIONES DE MANTENIMIENTO: " + SC7->C7_OBSM + ENTER
        // cMessagem += " EN ESPERA DE APROBACION " + ENTER
        // EventInsert(FW_EV_CHANEL_ENVIRONMENT, FW_EV_CATEGORY_MODULES, cEventID,FW_EV_LEVEL_INFO,""/*cCargo*/,"Nuevo pedido de compra nro: "+ SC7->C7_NUM,cMessagem,.T.)
        // U_EnviarMail("mcuevas@ciabol.com.bo,lcalvo@ciabol.com.bo,nbeltran@ciabol.com.bo,mugarte@ciabol.com.bo,jbaptista@ciabol.com.bo","fcastillo@ciabol.com.bo", "SISTEMA TOTVS: Se creo un Pedido de Compra",nil,cMessagem)
        // EnviarMail(cEnvia,cCc, cAssunto,cAnexos,cMensagem)
        // U_EnviarMail("denar.terrazas@totvs.com.br","nahim.parada@totvs.com.br", "E-Commerce ML nuevo Presupuesto: " + SCJ->CJ_NUM ,nil,cMessagem)
        // U_SendEmail("totvs.erp.bolivia@gmail.com","nahim.parada@totvs.com.br",cSubject,cBody)
        conout("enviando mail")
        startjob("u_SendEmail",getenvserver(),.F.,"ecommerce@mercantilleon.com","hugo.flores@mercantilleon.com.br;flavio.estatuti@mercantilleon.com",cSubject,cBody)
        // conout("TERMINO DE LLAMAR")
        // StartJob('U_ipcjobs',GetEnvServer(),.F.)
    endif

Return 
