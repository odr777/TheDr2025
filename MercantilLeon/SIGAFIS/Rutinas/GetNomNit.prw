#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

user function GetNomNit(cDoc,cSerie,cCliente,cLoja,_cFilial)
Local aDatos:={}
Local cQuery:=""	

	IF SELECT('datos') > 0           //Verifica se o alias OC esta aberto
		datos->(DbCloseArea())       //Fecha o alias OC
	END
		
	cQuery:= " Select * FROM  " + RetSqlName("SF2")
	cQuery += " where CONVERT(INT,F2_DOC) =" + str(VAL(cDoc))
	cQuery += " and F2_SERIE ='"+ cSerie +"'"
	cQuery += " and F2_CLIENTE ='"+ cCliente +"'"
	cQuery += " and F2_LOJA ='"+ cLoja +"'"
	cQuery += " and F2_FILIAL ='"+ _cFilial +"'"
	cQuery += " AND F2_ESPECIE='NF ' AND D_E_L_E_T_<>'*' "
	TCQUERY cQuery NEW ALIAS "datos"
	
	If datos->(!EOF()) .AND. datos->(!BOF())
	  IF !EMPTY(datos->F2_UNOMCLI)
			AADD(aDatos,alltrim(datos->F2_UNOMCLI))
			AADD(aDatos,alltrim((datos->F2_UNITCLI)))
			AADD(aDatos,(datos->F2_MOEDA))  
			AADD(aDatos,(datos->F2_VALBRUT)) 
			AADD(aDatos,(datos->F2_EMISSAO))
			AADD(aDatos,(datos->F2_DESCONT)) 
			AADD(aDatos,(datos->F2_NODIA))   
				
	  END
	END
return aDatos

user function GetProNit(cDoc,cSerie,cProveedor,cLoja,_cFilial)
Local aDatos:={}
Local cQuery:=""	

	IF SELECT('datos') > 0           //Verifica se o alias OC esta aberto
		datos->(DbCloseArea())       //Fecha o alias OC
	END
		
	cQuery:= " Select * FROM  " + RetSqlName("SF1")
	cQuery += " where LTRIM(RTRIM(F1_DOC)) ='" + ALLTRIM(cDoc) +"'"
	cQuery += " and F1_SERIE ='"+ cSerie +"'"
	cQuery += " and F1_FORNECE ='"+ cProveedor +"'"
	cQuery += " and F1_LOJA ='"+ cLoja +"'"
	cQuery += " and F1_FILIAL ='"+ _cFilial +"'"
	cQuery += " AND F1_ESPECIE='NF ' AND D_E_L_E_T_<>'*' "
	TCQUERY cQuery NEW ALIAS "datos"
	
	If datos->(!EOF()) .AND. datos->(!BOF())
	  IF !EMPTY(datos->F1_UNOMBRE)
			AADD(aDatos,alltrim(datos->F1_UNOMBRE))
			AADD(aDatos,alltrim((datos->F1_UNIT)))
			AADD(aDatos,(datos->F1_UPOLIZA))  
				
	  END
	END
return aDatos