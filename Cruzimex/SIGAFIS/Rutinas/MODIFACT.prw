#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MODIFACT    ³ Autor ³Erick Etcheverry     ³ Data ³15.06.2018³±±
±±³						  	      ³Denar Terrazas						   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³MenuBrowse con filtro para alterar factura de compra	 	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MODIFACT()
	LOCAL cFechaFis := DTOS(GETMV("MV_DATAFIS"))   //fecha de cierre fiscal
	Local cExprFilTop := "F1_EMISSAO > '" + cFechaFis + "' AND F1_ESPECIE = 'NF' "
	private aCfgNF := MontaCfgNf(10,{""},.T.)  // et  monta array a visualizar
	Private cCadastro := "Factura"
	
	Private aRotina := {{"Alterar","U_ALTERFAT()",0,4}}
	
	
	dbSelectArea("SF1")
	dbSetOrder(1)
	//SET FILTER TO E1_SALDO>0
	AADD(aRotina,{"Visualiza","LocxDlgNF(aCfgNF,2)",0,2})//et  compras LocxNF.prw function visualiza 
	MBrowse( 6 , 1 , 22 , 75 , "SF1" , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL;
	 , NIL , NIL , NIL , NIL , NIL , cExprFilTop ) 
	 
return
