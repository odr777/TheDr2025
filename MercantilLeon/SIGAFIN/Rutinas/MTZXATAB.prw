//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTZXATAB   บ Autor ณ Erick Etcheverry   บ Fecha ณ  26/02/21 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescripcion ณ Punto de Entrada Validar en la Rutina de Cobranza Diversa บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณBASE BOLIVIA                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MTZXATAB()
Local oBrowse  // Instanciamento da Classe de Browse  

oBrowse := FWMBrowse():New()  
 
// Defini็ใo da tabela do Browse  
oBrowse:SetAlias('ZXA')  

 
// Titulo da Browse  
oBrowse:SetDescription('Registro periodo bloqueado')  
 
// Opcionalmente pode ser desligado a exibi็ใo dos detalhes //oBrowse:DisableDetails()  
 
// Ativa็ใo da Classe  
oBrowse:Activate()  
 
Return NIL  

Static Function MenuDef()  
 
Local aRotina := {}  
 
aAdd( aRotina, { 'Visualizar', 'VIEWDEF.MTZXATAB', 0, 2, 0, NIL } )  ///.nombre del fuente
aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.MTZXATAB', 0, 3, 0, NIL } )  
aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.MTZXATAB', 0, 4, 0, NIL } )  
aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.MTZXATAB', 0, 5, 0, NIL } )  
aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.MTZXATAB', 0, 8, 0, NIL } )  
aAdd( aRotina, { 'Copiar'    , 'VIEWDEF.MTZXATAB', 0, 9, 0, NIL } )  
 
Return aRotina

Static Function ModelDef()  
 
 
// Cria a estrutura a ser usada no Modelo de Dados  
Local oStruZA0 := FWFormStruct( 1, 'ZXA' )  
Local oModel // Modelo de dados que serแ construํdo  
 
 
// Cria o objeto do Modelo de Dados  
oModel := MPFormModel():New('COMP011M' )  
 
 
// Adiciona ao modelo um componente de formulแrio  
oModel:AddFields( 'ZA0MASTER', /*cOwner*/, oStruZA0)  

oModel:SetPrimaryKey({'ZXA_FILIAL','ZXA_CODIGO'})
 
 
// Adiciona a descri็ใo do Modelo de Dados  
oModel:SetDescription( 'Modelo de datos de periodo bloqueado' )  
 
 
// Adiciona a descri็ใo do Componente do Modelo de Dados  
oModel:GetModel( 'ZA0MASTER' ):SetDescription( 'Datos de periodo bloqueado' )  
 
 
// Retorna el Modelo de datos  
Return oModel 
 
Static Function ViewDef()  
// Crea un objeto de Modelo de datos basado en el ModelDef() del fuente informado  

 
Local oModel := FWLoadModel( 'MTZXATAB' )  ////el nombre del fuente
 
// Crea la estructura a ser utilizada en el View  
Local oStruZA0 := FWFormStruct( 2, 'ZXA' )  
 
// Interfaz de visualizaci๓n 
Local oView  
// Crea el objeto del View  
oView := FWFormView():New()  
 
// Define cual es el Modelo de datos que serแ utilizado en la View  
oView:SetModel( oModel )  
// Adiciona en nuestra View un control de tipo formulแrio  
// (antigua Enchoice)  
 
oView:AddField( 'VIEW_ZA0', oStruZA0, 'ZA0MASTER' )  
 
// Crea un "box" horizontal para recibir alg๚n elemento de la view  
oView:CreateHorizontalBox( 'TELA' , 100 )  
// Relaciona el identificador (ID) de la View como "box"  
oView:SetOwnerView( 'VIEW_ZA0', 'TELA' )  
// Retorna el objeto de la View creado 
  
Return oView
