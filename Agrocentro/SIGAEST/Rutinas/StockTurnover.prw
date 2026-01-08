#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} StockTurnover
	(#17627799)
	@type  User Function
	@author Jim Bravo
	@since 17/08/2023
	@version 1.0
/*/

User Function StockTurnover()
  Local _aCab1    := {}
  Local _aItem1   := {}
  Local _aItem2   := {}
  Local _aItem3   := {}
  Local _aTotItem := {}
  //Local dFecha    := CToD("  /  /  ")
  
  Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
  Private lMsErroAuto := .f. //necessario a criacao
  
  //Private _acod:={"1","MP1"}
  //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0001" MODULO "EST"
  
  _aCab1 := {{"D3_DOC"    , NextNumero("SD3",2,"D3_DOC",.T.) , NIL},;
            {"D3_CC"      , "516"                            , NIL},;
            {"D3_TM"      , "513"                            , NIL},;
            {"D3_EMISSAO" , dDataBase                        , NIL}}
  
  _aItem1 := {{"D3_COD"   , "LUBVAR00001" , NIL},;
              {"D3_QUANT" , 3             , NIL},;
              {"D3_UM"    , "L"           , NIL},;
              {"D3_LOCAL" , "01"          , NIL}}
              /*{"D3_CUSTO1",  23.2668,       NIL},;
              {"D3_LOCALIZ", " ",           NIL},;
              {"D3_NUMSERI", " ",           NIL},;
              {"D3_NUMLOTE", " ",           NIL},;            
              {"D3_DTVALID", dFecha,        NIL},;
              {"D3_CONTA",   " ",           NIL}}*/
              
  _aItem2 := {{"D3_COD"   , "LUBVAR00001" , NIL},;
              {"D3_QUANT" , 6             , NIL},;
              {"D3_UM"    , "L"           , NIL},;
              {"D3_LOCAL" , "01"          , NIL}}
              /*{"D3_CUSTO1",  23.2668,       NIL},;
              {"D3_LOCALIZ", " ",           NIL},;
              {"D3_NUMSERI", " ",           NIL},;
              {"D3_NUMLOTE", " ",           NIL},;            
              {"D3_DTVALID", dFecha,        NIL},;
              {"D3_CONTA",   " ",           NIL}}*/

    _aItem3 := {{"D3_COD"  , "LUBVAR00001" , NIL},;
               {"D3_QUANT" , 9             , NIL},;
               {"D3_UM"    , "L"           , NIL},;
               {"D3_LOCAL" , "01"          , NIL}}
              /*{"D3_CUSTO1",  23.2668,       NIL},;
              {"D3_LOCALIZ", " ",           NIL},;
              {"D3_NUMSERI", " ",           NIL},;
              {"D3_NUMLOTE", " ",           NIL},;            
              {"D3_DTVALID", dFecha,        NIL},;
              {"D3_CONTA",   " ",           NIL}}*/

  aAdd( _aTotItem, _aItem1)

  If MsgYesNo("¿Desea mas de 1 item?", "StockTurnOver_PIMS")
    aAdd( _aTotItem, _aItem2)
    aAdd( _aTotItem, _aItem3)
  EndIf 

  MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_aTotItem,3)
  //MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
  
  If lMsErroAuto
    MostraErro() // Sempre que o micro comeca a apitar esta ocorrendo um erro desta forma
    AutoGrLog( " No se pudo importar : "  )
    DisarmTransaction()
    Break
  Else
    AutoGrLog( " Movimiento ingresado: "  )
  EndIf

Return
