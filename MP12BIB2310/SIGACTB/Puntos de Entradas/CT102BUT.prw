
/*/{Protheus.doc}
    punto de entrada para agregar botones a 
    rutina del browser de asientos contables automáticos
    @type  Function
    @author Nahim Terrazas
    @since 26/08/2021
    @version version
    @see (links_or_references)
    /*/

User Function CT102BUT()
Local aBotao := {}

aAdd(aBotao, {'Imprime Asiento',"U_CtbcR070()",   0 , 3    })
Return(aBotao)

//User Function CopyLct()
//	U_CTBI001(.T.)          Alert("Neste ponto devera ser implementada a rotina de copia customizada pelo cliente")
//Return 

