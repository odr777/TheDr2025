
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
		aRet[14]	:= "" // Transform( SD1->D1_YCMGBR, PesqPict( "SD1", "D1_CUSTO" ) )
    
	EndIf
endif

RestArea(aArea)
Return aRet
