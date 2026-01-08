
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*/{Protheus.doc} User Function MC030ARR
    (long_description)
    @type  Function
    @author user
    @since 08/06/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MC030ARR()
    Local aParam1	:= PARAMIXB[1]//Array com os dados da linha a ser listada no kardex
    Local aParam2	:= PARAMIXB[2]//Nome da tabela posicionada
    aAdd( aParam1, " " )
    aAdd( aParam1, " " )
    // aAdd( aParam1, "valor3 " )
    // aAdd( aParam1, "valor4" )
    aParam1 := getDescrip(aParam1, aParam2)

Return aParam1





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetCMGBR  ºAutor  ³Microsiga           º Data ³  16/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina utilizada para retornar o Custo Gerencial 		  º±±
±±º          ³ 				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP       	                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function getDescrip(aParam1, cAliasMov)


Local aArea := GetArea()
Local aRet	:= {}
Local aPP	:= {}
Local nX	:= 0
Local nY	:= 0
Local aAux	:= {}


Default aRet 		:= {}
Default cAliasMov   := "" 

//Recebe o Array com os dados do Kardex
aRet := aParam1


//Preenchimento da linha do Kardex, com os dados movimento
If ValType( aRet[1] ) == "D"


	
	If Alltrim(cAliasMov) == "SD1"   
		//CMG BR
		aRet[13]	:= GetAdvFVal("SF4","F4_TEXTO",xFilial("SF4")+SD1->D1_TES,1,"") // Transform( SD1->D1_YCMGBR / SD1->D1_QUANT, PesqPict( "SB2", "B2_CM1" ) )
		aRet[14]	:= "" // Transform( SD1->D1_YCMGBR, PesqPict( "SD1", "D1_CUSTO" ) )
		
	ElseIf Alltrim(cAliasMov) == "SD2"
		
		aRet[13]	:= GetAdvFVal("SF4","F4_TEXTO",xFilial("SF4")+SD2->D2_TES,1,"") // Transform( SD1->D1_YCMGBR / SD1->D1_QUANT, PesqPict( "SB2", "B2_CM1" ) )
		aRet[14]	:= "" // Transform( SD1->D1_YCMGBR, PesqPict( "SD1", "D1_CUSTO" ) )
        		
	ElseIf Alltrim(cAliasMov) == "SD3"
                    // Posicione("SF5",1,SD3->D3_TM,"F5_TEXTO")
		aRet[13]	:= GetAdvFVal("SF5","F5_TEXTO",xFilial("SF4")+SD3->D3_TM,1,"") // Transform( SD1->D1_YCMGBR / SD1->D1_QUANT, PesqPict( "SB2", "B2_CM1" ) )
        cDescr := ""
        DO CASE
            CASE SD3->D3_CF == 'RE0'                                                                                    
                cDescr := "Requisição manual.                                                             "
            CASE SD3->D3_CF == 'RE1'
                cDescr := "Requisição automática.                                                         "
            CASE SD3->D3_CF == 'RE2'
                cDescr := "Requisição automática de material de apropriação indireta.                     "
            CASE SD3->D3_CF == 'RE3'
                cDescr := "Transferência em geral.	                                                      "
            CASE SD3->D3_CF == 'RE3'
                cDescr := "Requisição ao Armazém de Processo (MV_LOCPROC)                                 "
            CASE SD3->D3_CF == 'RE4'
                cDescr := "Requisição por transferência.                                                  "
            CASE SD3->D3_CF == 'RE5'
                cDescr := "Requisição informando OP na nota fiscal de entrada.                            "
            CASE SD3->D3_CF == 'RE6'
                cDescr := "Requisição valorizada.                                                         "
            CASE SD3->D3_CF == 'RE7'
                cDescr := "Requisição para transferência de um para “N”.                                  "
            CASE SD3->D3_CF == 'RE9'
                cDescr := "Requisição para OP sem agregar custo.                                          "
            CASE SD3->D3_CF == 'DE0'
                cDescr := "Devolução manual.                                                              "
            CASE SD3->D3_CF == 'DE1'
                cDescr := "Devolução automática - estorno da produção.                                    "
            CASE SD3->D3_CF == 'DE2'
                cDescr := "Devolução automática de material de apropriação indireta - estorno da produção."
            CASE SD3->D3_CF == 'DE3'
                cDescr := "Estorno de transferência para local de apropriação indireta.                   "
            CASE SD3->D3_CF == 'DE*'
                cDescr := "Devolução do Armazém de Processo (MV_LOCPROC)                                  "
            CASE SD3->D3_CF == 'DE4'
                cDescr := "Devolução de transferência entre locais.                                       "
            CASE SD3->D3_CF == 'DE5'
                cDescr := "Devolução de material apropriado em OP – (exclusão de nota fiscal de entrada). "
            CASE SD3->D3_CF == 'DE6'
                cDescr := "Devolução valorizada.                                                          "
            CASE SD3->D3_CF == 'DE7'
                cDescr := "Devolução de transferência de um para “N”.                                     "
            CASE SD3->D3_CF == 'DE9'
                cDescr := "Devolução para OP sem agregar custo.                                           "
            CASE SD3->D3_CF == 'PR0'
                cDescr := "Produção manual.                                                               "
            CASE SD3->D3_CF == 'PR1'
                cDescr := "Produção automática.                                                           "
            CASE SD3->D3_CF == 'ER0'
                cDescr := "Estorno de produção manual.                                                    "
            CASE SD3->D3_CF == 'ER1'
                cDescr := "Estorno de produção automática.                                                "
        ENDCASE    
        aRet[14] := cDescr
	EndIf
endif

RestArea(aArea)
Return aRet
