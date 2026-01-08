
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

/*/{Protheus.doc} User Function MC030IDE
    LOCALIZAÇÃO   :  Function CW030Brow - Função que que monta a tela da consulta. O objetivo deste ponto de entrada é permitir ao usuário customizar a estrutura do arquivo (.DBF) temporário criado para exibir os dados da consulta em tela.
    EM QUE PONTO :  No momento em que a estrutura do arquivo (.DBF) é criada, constando  as informações da estrutura dos campos a serem  exibidas em tela; o usuário pode aumentar ou diminuir o tamanho de qualquer campo desta estrutura.
    Utilizado para mostrar la descripciones de los movimientos
    kardex
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
User Function MC030IDE()

Local aStruct:= ParamIXB[1]

//Custo Medio Gerencial Brasil
Aadd(aStruct,{ "TESDESCRI", "C",20,0 })
Aadd(aStruct,{ "CFODESCRI", "C",40,0 })
//Aadd(aStruct,{ "CQUANTBR", "C",18,0 })

// Aadd(aHeader, {'',						'FLAGBR',		"", 05,0, ,USADO,'C','SD3', ''}) 
Aadd(aHeader, {'Desc. TES',	'HTESDESCRI',	"", 20,0, ,USADO,'C','SD3', ''}) 
Aadd(aHeader, {'Desc. CFO',	'HCFODESCRI',	"", 40,0, ,USADO,'C','SD3', ''}) 
//Aadd(aHeader, {'Qde Gerencial BR',		'CMQUANTBR',	"", 18,0, ,USADO,'C','SD3', ''}) 


// //Custo medio gerencial Price Protections
// Aadd(aStruct,{ "CMEDIOG", "C",18,0 })
// Aadd(aStruct,{ "CTOTALG", "C",18,0 })
// //Aadd(aStruct,{ "CQUANT", "C",18,0 })

// Aadd(aHeader, {'',						'FLAG',		"", 05,0, ,USADO,'C','SD3', ''}) // 'Custo Medio'
// Aadd(aHeader, {'Unitário Gerencial',	'CMVUNIT',	"", 18,0, ,USADO,'C','SD3', ''}) // 'Custo Medio'
// Aadd(aHeader, {'Total Gerencial',		'CMVTOT',	"", 18,0, ,USADO,'C','SD3', ''}) // 'Custo Total'  
//Aadd(aHeader, {'Qde Gerencial',			'CMQUANT',	"", 18,0, ,USADO,'C','SD3', ''}) // 'Custo Total'  
 

Return aStruct
