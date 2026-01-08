#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

/*/{Protheus.doc} MT110TEL
PE
@type function
@version 1.0
@author luiz fael
@since 29/08/2022
@return variant, nILL
/*/
User function MT110TEL()
	Local oNewDialog 	:= PARAMIXB[1]
	Local aPosGet 		:= PARAMIXB[2]
	Local nOpcx 		:= PARAMIXB[3]
	Local nPos 	 		:= 64
	Local aPos			:= Array(8)

	If Alltrim(FunName()) == "MATA110"
		If nOpcx == 3
			Public cCampana	 := CriaVar('C1_CAMPANA')
			Public cCampdes  := CriaVar('C1_CAMPDES')
			Public cCampro	 := CriaVar('C1_CAMPRO')
			Public cCamprod	 := CriaVar('C1_CAMPROD')
			Public cChapa	 := CriaVar('C1_XCHAPA')
		Else
			Public cCampana	 := SC1->C1_CAMPANA
			Public cCampdes	 := SC1->C1_CAMPDES
			Public cCampro	 := SC1->C1_CAMPRO
			Public cCamprod	 := SC1->C1_CAMPROD
			Public cChapa	 := SC1->C1_XCHAPA
		Endif

		aadd(aPosGet[1],031)	//aPosGet[1,07]
		aPos[1]	:= 31;aPos[2]	:= 108;aPos[3]	:= 149;aPos[4]	:= 312;aPos[5]	:= 421;aPos[6]	:= 462;aPos[7]	:= 633;aPos[8]	:= 674
		//-------------------------------------------------------------------------------------------//
		@ nPos,aPos[1] 	SAY FWX3Titulo("C1_CAMPANA");
			SIZE 40,9;
			PIXEL Of oNewDialog
		//-------------------------------------------------------------------------------------------//
		@ nPos,aPos[2] 	MSGET cCampana;
			PICTURE PesqPict("SC1","C1_CAMPANA");
			WHEN INCLUI .OR. ALTERA;
			F3 "ZZK";
			VALID U_CampDes(oNewDialog,cCampana,'',@cCampdes,'');
			SIZE 40,9;
			PIXEL Of oNewDialog
		//-------------------------------------------------------------------------------------------//
		@ nPos,aPos[3]	MSGET cCampdes;
			PICTURE PesqPict("SC1","C1_CAMPDES");
			WHEN .F.;
			SIZE 90,9;
			PIXEL Of oNewDialog
		//-------------------------------------------------------------------------------------------//
		@ nPos,aPos[4]	SAY FWX3Titulo("C1_CAMPRO");
			SIZE 40,9;
			PIXEL Of oNewDialog
		//-------------------------------------------------------------------------------------------//
		@ nPos,aPos[5]	MSGET cCampro;
			PICTURE PesqPict("SC1","C1_CAMPRO");
			WHEN INCLUI .OR. ALTERA;
			F3 "ZZL";
			VALID U_CampDes(oNewDialog,cCampana,cCampro,@cCampdes,@cCamprod);
			WHEN !Empty(cCampana);
			SIZE 40,9;
			PIXEL Of oNewDialog
		//-------------------------------------------------------------------------------------------//
		//cCamprod := IIF(!Empty(cCampro),ZZL->ZZL_DESC,'')
		@ nPos,aPos[6]	MSGET cCamprod;
			PICTURE PesqPict("SC1","C1_CAMPROD");
			WHEN .F.;
			SIZE 90,9;
			PIXEL Of oNewDialog
		//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
		@ nPos,aPos[7]   SAY;
			'No. Placa';
			PIXEL;
			SIZE 45,10;
			Of oNewDialog
		@ nPos,aPos[8]  MSGET cChapa;
			F3 CpoRetF3("C1_XCHAPA");
			Picture PesqPict("SC1","C1_XCHAPA");
			When VisualSX3("C1_XCHAPA") .And. CheckSX3("C1_XCHAPA",cChapa) ;
			WHEN  (INCLUI .or. ALTERA);
			Of oNewDialog PIXEL HASBUTTON
		//-------------------------------------------------------------------------------------------//
	EndIf
Return

