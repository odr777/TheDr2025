#include "rwmake.ch"
#include "protheus.ch"

User function creaZN1()

	//AxCadastro("ZN1"," Registro de Avaluos ",".T.",".T.")

	/*
	USER FUNCTION mBrwSA2()
	*/

	LOCAL cAlias := "ZN1"

	PRIVATE cCadastro := "Archivo de Avaluos"

	PRIVATE aRotina     := { }

	AADD(aRotina, { "Buscar", "AxPesqui", 0, 1 })

	AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })

	//AADD(aRotina, { "Incluir"      , "AxInclui(, , , , , , 'msgyesno('Valida','Valida?')', , , , , , , )"   , 0, 3 })
	AADD(aRotina, { "Incluir"      , "AxInclui"   , 0, 3 })

	AADD(aRotina, { "Modificar"     , "AxAltera"  , 0, 4 })

	AADD(aRotina, { "Borrar"     , "AxDeleta" , 0, 5 })

	AADD(aRotina, { "Actualizar Bien"     , "U_ActAvlAf" , 0, 6 })

	dbSelectArea(cAlias)

	dbSetOrder(1)

	mBrowse(6, 1, 22, 75, cAlias)

Return

user function ActAvlAf()

	If MsgYesNo( 'Confirma actualización del valor comercial del bien?', 'Valor comercial' )
		dbSelectArea('SN1')
		dbSetOrder(1)
		if dbSeek(xfilial('SN1')+ZN1->ZN1_CBASE+ZN1->ZN1_ITEM)
			RecLock("SN1",.F.)
			SN1->N1_VLCOMER := ZN1->ZN1_VLCOME
			//SN1->N1_UVLHIPO := ZN1->ZN1_UVLHIP
			MsUnLock()
			MsgInfo( 'Actualizado el valor comercial del bien', 'Valor comercial' )
		else
			MsgInfo( 'No se encontró el bien', 'Valor comercial' )
		endif

	Else

		MsgInfo( 'No se actualizó valor comercial el bien', 'Valor comercial' )

	Endif

return
