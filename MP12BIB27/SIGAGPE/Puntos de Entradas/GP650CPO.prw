#INCLUDE 'PROTHEUS.CH'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Modifica el historial del título en la	³
//³ integración con el financiero.      	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function GP650CPO()
	Local aArea  := GetArea()
	Local cDes  
	
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1)) 
	SRA->(DbGoTop())
	
	//Posicionando en la matrícula
	If SRA->(DbSeek(FWxFilial("SRA") + RC1->RC1_MAT))		
		cDes := Substr(RC1->RC1_MAT + " " + SRA->RA_NOME,1,30) 	
		RC1->RC1_DESCRI := cDes 
	EndIf
	
	RestArea(aArea)
Return()