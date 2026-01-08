#include 'protheus.ch'
#include 'parmtype.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  ºAutor  ³Jorge Saavedra      º Data ³  17/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta Decimales en Lista de Precio, Presupuesto, Pedidos de Ventas º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function CalPrecio()
	nPosVal  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_PRCVEN" })
	nPosRaz  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_URAZON" })
	nPosBas  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="DA1_PRCBAS" })
	If aCols[n][nPosBas] == 0
		//aCols[n][nPosBas]   := ROUND(aCols[n][nPosVal] / aCols[n][nPosRaz],5)
	else
		aCols[n][nPosRaz] := ROUND(aCols[n][nPosVal] / aCols[n][nPosBas],4)
		RunTrigger(2,n,nil,,"DA1_PRCBAS")
	end
return .T.

//Ajusta el precio de Venta a 2 Decimales en el Pedido de Venta
User Function RedPed(cCampo)
	Local aArea		:= GetArea()
	Local i
	Local lVenFut	:= FWIsInCallStack("U_GERVTAFUT")
	Local lConsprod := FWIsInCallStack("U_ConsProd")
	Local aAda1 := {}
	Local k
	Local lAutomato := IsBlind()

	if !lAutomato

		IF !lVenFut
			nPosCan  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_QTDVEN" })
			nPosPro  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRODUTO" })
			nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRCVEN" })
			nPosTot  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_VALOR" })
			nPosPru  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRUNIT" }) //precio lista
			nPosPdesc  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_DESCONT" }) //porcentaje desc
			nPValDes  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})  ///valor descuento

			IF (IIF(Type("ALTERA") == "U", .F., ALTERA) .OR. FWIsInCallStack("A410COPIA")) .and. cCampo $ "C6_QTDVEN" ///cuando copia pero agrega por linea
				DbSelectArea('SB1')
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+aCols[n][nPosPro],.f.)
					IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1
						nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

						If nTC2 > 0

							aAda1 = gtLisPreco(aCols[n][nPosPro],nTC2) ///traer precio bs

							if len(aAda1) > 0

								acols[n][nPosPre] := round(aAda1[1][3],2)   //precio venta
								acols[n][nPosPru] := round(aAda1[1][3],2)   ///precio lista
								acols[n][nPosTot] := round(acols[n][nPosCan] * acols[n][nPosPre],2)

								////ajuste para descuento cabecera
								nValPDesc := acols[n][nPosPdesc]  /// porcentaje
								aCols[n,nPValDes] := 0
								nxValDes := 0

								nxPreco := u_FtDescItem(u_FtDescCab(aCols[n,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[n,nPosPre],acols[n][nPosCan],@acols[n][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

								acols[n][nPosPre] := round(nxPreco,2)   //precio venta
								acols[n][nPosTot] := round(acols[n][nPosCan] * acols[n][nPosPre],2)
								acols[n][nPosPdesc] := round(nValPDesc,2)
								acols[n][nPValDes] := round(nxValDes,2)
							endif

						endif
					ELSE

						acols[n][nPosPre] := round(acols[n][nPosPre],2)
						acols[n][nPosTot]  := round(acols[n][nPosCan] * acols[n][nPosPre],2)

					endif
				endif

				oGetDad:refresh()

				RestArea( aArea )

				Return &("M->"+cCampo)
			elseif (IIF(Type("INCLUI") == "U", .F., INCLUI) .AND. !FWIsInCallStack("A410COPIA")) .and. cCampo $ "C6_QTDVEN"
				DbSelectArea('SB1')
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+aCols[n][nPosPro],.f.)
					IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1
						nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

						If nTC2 > 0

							aAda1 = gtLisPreco(aCols[n][nPosPro],nTC2) ///traer precio bs

							if len(aAda1) > 0

								acols[n][nPosPre] := round(aAda1[1][3],2)   //precio venta
								acols[n][nPosPru] := round(aAda1[1][3],2)   ///precio lista
								acols[n][nPosTot] := round(acols[n][nPosCan] * acols[n][nPosPre],2)

								////ajuste para descuento cabecera
								nValPDesc := acols[n][nPosPdesc]  /// porcentaje
								aCols[n,nPValDes] := 0
								nxValDes := 0

								nxPreco := u_FtDescItem(u_FtDescCab(aCols[n,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[n,nPosPre],acols[n][nPosCan],@acols[n][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

								acols[n][nPosPre] := round(nxPreco,2)   //precio venta
								acols[n][nPosTot] := round(acols[n][nPosCan] * acols[n][nPosPre],2)
								acols[n][nPosPdesc] := round(nValPDesc,2)
								acols[n][nPValDes] := round(nxValDes,2)

							endif

						endif
					ELSE

						acols[n][nPosPre] := round(acols[n][nPosPre],2)
						acols[n][nPosTot]  := round(acols[n][nPosCan] * acols[n][nPosPre],2)

					endif
				endif

				oGetDad:refresh()

				RestArea( aArea )

				Return &("M->"+cCampo)
			endif

			IF IIF(Type("INCLUI") == "U", .F., INCLUI) .and. cCampo $ "C5_CLIENTE"  ///si cambio de cliente

				for i:=1 to Len(aCols)
					DbSelectArea('SB1')
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

						IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

							nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

							If nTC2 > 0

								aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

								if len(aAda1) > 0

									acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
									acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

									nValPDesc := acols[i][nPosPdesc]  /// porcentaje
									aCols[n,nPValDes] := 0
									nxValDes := 0

									nxPreco := u_FtDescItem(u_FtDescCab(aCols[i,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[i,nPosPre],acols[i][nPosCan],@acols[i][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

									acols[i][nPosPre] := round(nxPreco,2)   //precio venta
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)
									acols[i][nPosPdesc] := round(nValPDesc,2)
									acols[i][nPValDes] := round(nxValDes,2)

									for k:=1 to Len(aCols)

										aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

										if len(aAda1) > 0

											DbSelectArea('SB1')
											DbSetOrder(1)
											If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)

												IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

													acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
													acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

													nValPDesc := acols[k][nPosPdesc]  /// porcentaje
													aCols[k,nPValDes] := 0
													nxValDes := 0

													nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

													acols[k][nPosPre] := round(nxPreco,2)   //precio venta
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
													acols[k][nPosPdesc] := round(nValPDesc,2)
													acols[k][nPValDes] := round(nxValDes,2)
												endif
											endif
										endif

									next k

								endif

							endif
						ELSE

							acols[i][nPosPre] := round(acols[i][nPosPre],2)
							acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

						endif
					endif
				Next
				oGetDad:refresh()
				RestArea( aArea )
				Return &("M->"+cCampo)
			ENDIF

			IF IIF(Type("ALTERA") == "U", .F., ALTERA) .and. (cCampo $ "C5_CLIENTE" .or. cCampo $ "C5_CONDPAG")  ///si cambio de cliente

				for i:=1 to Len(aCols)
					DbSelectArea('SB1')
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

						IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

							nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

							If nTC2 > 0

								aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

								if len(aAda1) > 0

									acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
									acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

									nValPDesc := acols[i][nPosPdesc]  /// porcentaje
									aCols[i,nPValDes] := 0
									nxValDes := 0

									nxPreco := u_FtDescItem(u_FtDescCab(aCols[i,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[i,nPosPre],acols[i][nPosCan],@acols[i][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

									acols[i][nPosPre] := round(nxPreco,2)   //precio venta
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)
									acols[i][nPosPdesc] := round(nValPDesc,2)
									acols[i][nPValDes] := round(nxValDes,2)

									for k:=1 to Len(aCols)

										aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

										if len(aAda1) > 0

											DbSelectArea('SB1')
											DbSetOrder(1)
											If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)

												IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

													acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
													acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

													nValPDesc := acols[k][nPosPdesc]  /// porcentaje
													aCols[k,nPValDes] := 0
													nxValDes := 0

													nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

													acols[k][nPosPre] := round(nxPreco,2)   //precio venta
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
													acols[k][nPosPdesc] := round(nValPDesc,2)
													acols[k][nPValDes] := round(nxValDes,2)
												endif
											endif
										endif

									next k

								endif

							endif
						ELSE

							acols[i][nPosPre] := round(acols[i][nPosPre],2)
							acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

						endif
					endif
				Next
				oGetDad:refresh()
				RestArea( aArea )
				Return &("M->"+cCampo)
			ENDIF

			IF IIF(Type("INCLUI") == "U", .F., INCLUI) .and. ( cCampo $ "C5_CONDPAG")  ///si cambio de cliente

				for i:=1 to Len(aCols)
					DbSelectArea('SB1')
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

						IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

							nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

							If nTC2 > 0

								aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

								if len(aAda1) > 0

									acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
									acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

									nValPDesc := acols[i][nPosPdesc]  /// porcentaje
									aCols[i,nPValDes] := 0
									nxValDes := 0

									nxPreco := u_FtDescItem(u_FtDescCab(aCols[i,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[i,nPosPre],acols[i][nPosCan],@acols[i][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

									acols[i][nPosPre] := round(nxPreco,2)   //precio venta
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)
									acols[i][nPosPdesc] := round(nValPDesc,2)
									acols[i][nPValDes] := round(nxValDes,2)

									for k:=1 to Len(aCols)

										aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

										if len(aAda1) > 0

											DbSelectArea('SB1')
											DbSetOrder(1)
											If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)

												IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

													acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
													acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

													nValPDesc := acols[k][nPosPdesc]  /// porcentaje
													aCols[k,nPValDes] := 0
													nxValDes := 0

													nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

													acols[k][nPosPre] := round(nxPreco,2)   //precio venta
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
													acols[k][nPosPdesc] := round(nValPDesc,2)
													acols[k][nPValDes] := round(nxValDes,2)
												endif
											endif
										endif

									next k

								endif

							endif
						ELSE

							acols[i][nPosPre] := round(acols[i][nPosPre],2)
							acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

						endif
					endif
				Next
				oGetDad:refresh()
				RestArea( aArea )
				Return &("M->"+cCampo)
			ENDIF

			IF (IIF(Type("INCLUI") == "U", .F., INCLUI) .OR. IIF(Type("ALTERA") == "U", .F., ALTERA)) .and. ( cCampo $ "C5_DESC1")

				for i:=1 to Len(aCols)
					DbSelectArea('SB1')
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

						IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

							nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

							If nTC2 > 0

								aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

								if len(aAda1) > 0

									acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
									acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

									nValPDesc := acols[i][nPosPdesc]  /// porcentaje
									aCols[i,nPValDes] := 0
									nxValDes := 0

									nxPreco := u_FtDescItem(u_FtDescCab(aCols[i,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[i,nPosPre],acols[i][nPosCan],@acols[i][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

									acols[i][nPosPre] := round(nxPreco,2)   //precio venta
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)
									acols[i][nPosPdesc] := round(nValPDesc,2)
									acols[i][nPValDes] := round(nxValDes,2)

									for k:=1 to Len(aCols)

										aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

										if len(aAda1) > 0

											DbSelectArea('SB1')
											DbSetOrder(1)
											If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)

												IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

													acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
													acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

													nValPDesc := acols[k][nPosPdesc]  /// porcentaje
													aCols[k,nPValDes] := 0
													nxValDes := 0

													nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

													acols[k][nPosPre] := round(nxPreco,2)   //precio venta
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
													acols[k][nPosPdesc] := round(nValPDesc,2)
													acols[k][nPValDes] := round(nxValDes,2)
												endif
											endif
										endif

									next k

								endif

							endif
						ELSE

							acols[i][nPosPre] := round(acols[i][nPosPre],2)
							acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

						endif
					endif
				Next

				oGetDad:refresh()
				RestArea( aArea )
				Return &("M->"+cCampo)
			ENDIF

			IF (IIF(Type("INCLUI") == "U", .F., INCLUI) .OR. IIF(Type("ALTERA") == "U", .F., ALTERA)) .and. ( cCampo $ "C5_TABELA")

				for i:=1 to Len(aCols)
					DbSelectArea('SB1')
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

						IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

							nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

							If nTC2 > 0

								aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

								if len(aAda1) > 0

									acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
									acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

									nValPDesc := acols[i][nPosPdesc]  /// porcentaje
									aCols[i,nPValDes] := 0
									nxValDes := 0

									nxPreco := u_FtDescItem(u_FtDescCab(aCols[i,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[i,nPosPre],acols[i][nPosCan],@acols[i][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

									acols[i][nPosPre] := round(nxPreco,2)   //precio venta
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)
									acols[i][nPosPdesc] := round(nValPDesc,2)
									acols[i][nPValDes] := round(nxValDes,2)

									for k:=1 to Len(aCols)

										aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

										if len(aAda1) > 0

											DbSelectArea('SB1')
											DbSetOrder(1)
											If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)

												IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

													acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
													acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

													nValPDesc := acols[k][nPosPdesc]  /// porcentaje
													aCols[k,nPValDes] := 0
													nxValDes := 0

													nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

													acols[k][nPosPre] := round(nxPreco,2)   //precio venta
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
													acols[k][nPosPdesc] := round(nValPDesc,2)
													acols[k][nPValDes] := round(nxValDes,2)
												endif
											endif
										endif

									next k

								endif

							endif
						ELSE

							acols[i][nPosPre] := round(acols[i][nPosPre],2)
							acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

						endif
					endif
				Next

				oGetDad:refresh()
				RestArea( aArea )
				Return &("M->"+cCampo)
			ENDIF

			IF IIF(Type("INCLUI") == "U", .F., INCLUI) .and. cCampo $ "C6_PRODUTO" .and. !lConsprod ///si cambio de cliente

				for i:=1 to Len(aCols)
					DbSelectArea('SB1')
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

						IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

							nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

							If nTC2 > 0

								aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

								if len(aAda1) > 0

									acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
									acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

									nValPDesc := acols[i][nPosPdesc]  /// porcentaje
									aCols[n,nPValDes] := 0
									nxValDes := 0

									nxPreco := u_FtDescItem(u_FtDescCab(aCols[i,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[i,nPosPre],acols[i][nPosCan],@acols[i][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

									acols[i][nPosPre] := round(nxPreco,2)   //precio venta
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)
									acols[i][nPosPdesc] := round(nValPDesc,2)
									acols[i][nPValDes] := round(nxValDes,2)

									for k:=1 to Len(aCols)

										aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

										if len(aAda1) > 0

											DbSelectArea('SB1')
											DbSetOrder(1)
											If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)

												IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

													acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
													acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

													nValPDesc := acols[k][nPosPdesc]  /// porcentaje
													aCols[k,nPValDes] := 0
													nxValDes := 0

													nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

													acols[k][nPosPre] := round(nxPreco,2)   //precio venta
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
													acols[k][nPosPdesc] := round(nValPDesc,2)
													acols[k][nPValDes] := round(nxValDes,2)
												endif
											endif
										endif

									next k

								endif

							endif
						ELSE

							acols[i][nPosPre] := round(acols[i][nPosPre],2)
							acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

						endif
					endif
				Next
				oGetDad:refresh()
				RestArea( aArea )
				Return &("M->"+cCampo)
			ENDIF

			IF IIF(Type("ALTERA") == "U", .F., ALTERA) .and. cCampo $ "C6_PRODUTO" .and. !lConsprod ///si cambio de cliente

				for i:=1 to Len(aCols)
					DbSelectArea('SB1')
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

						IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

							nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

							If nTC2 > 0

								aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

								if len(aAda1) > 0

									acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
									acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

									nValPDesc := acols[i][nPosPdesc]  /// porcentaje
									aCols[n,nPValDes] := 0
									nxValDes := 0

									nxPreco := u_FtDescItem(u_FtDescCab(aCols[i,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[i,nPosPre],acols[i][nPosCan],@acols[i][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

									acols[i][nPosPre] := round(nxPreco,2)   //precio venta
									acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)
									acols[i][nPosPdesc] := round(nValPDesc,2)
									acols[i][nPValDes] := round(nxValDes,2)

									for k:=1 to Len(aCols)

										aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

										if len(aAda1) > 0

											DbSelectArea('SB1')
											DbSetOrder(1)
											If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)

												IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

													acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
													acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

													nValPDesc := acols[k][nPosPdesc]  /// porcentaje
													aCols[k,nPValDes] := 0
													nxValDes := 0

													nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

													acols[k][nPosPre] := round(nxPreco,2)   //precio venta
													acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
													acols[k][nPosPdesc] := round(nValPDesc,2)
													acols[k][nPValDes] := round(nxValDes,2)
												endif
											endif
										endif

									next k

								endif

							endif
						ELSE

							acols[i][nPosPre] := round(acols[i][nPosPre],2)
							acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

						endif
					endif
				Next
				oGetDad:refresh()
				RestArea( aArea )
				Return &("M->"+cCampo)
			ENDIF

			for i:=1 to Len(aCols)
				DbSelectArea('SB1')
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

					IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

						nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

						If nTC2 > 0

							aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

							if len(aAda1) > 0

								acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
								acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
								acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

								nValPDesc := acols[i][nPosPdesc]  /// porcentaje
								aCols[n,nPValDes] := 0
								nxValDes := 0

								nxPreco := u_FtDescItem(u_FtDescCab(aCols[i,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[i,nPosPre],acols[i][nPosCan],@acols[i][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

								acols[i][nPosPre] := round(nxPreco,2)   //precio venta
								acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)
								acols[i][nPosPdesc] := round(nValPDesc,2)
								acols[i][nPValDes] := round(nxValDes,2)

								for k:=1 to Len(aCols)

									aAda1 = gtLisPreco(aCols[k][nPosPro],nTC2) ///traer precio bs

									if len(aAda1) > 0

										DbSelectArea('SB1')
										DbSetOrder(1)
										If DbSeek(xFilial("SB1")+aCols[k][nPosPro],.f.)

											IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1

												acols[k][nPosPre] := round(aAda1[1][3],2)   //precio venta
												acols[k][nPosPru] := round(aAda1[1][3],2)   ///precio lista
												acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)

												nValPDesc := acols[k][nPosPdesc]  /// porcentaje
												aCols[k,nPValDes] := 0
												nxValDes := 0

												nxPreco := u_FtDescItem(u_FtDescCab(aCols[k,nPosPru],{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4}),@aCols[k,nPosPre],acols[k][nPosCan],@acols[k][nPosTot],@nValPDesc,@nxValDes,@nxValDes,1,,NIL)

												acols[k][nPosPre] := round(nxPreco,2)   //precio venta
												acols[k][nPosTot] := round(acols[k][nPosCan] * acols[k][nPosPre],2)
												acols[k][nPosPdesc] := round(nValPDesc,2)
												acols[k][nPValDes] := round(nxValDes,2)
											endif
										endif
									endif

								next k

							endif

						endif
					ELSE

						acols[i][nPosPre] := round(acols[i][nPosPre],2)
						acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

					endif
				endif
			Next
			oGetDad:refresh()
		ENDIF

	endif
	RestArea( aArea )
Return &("M->"+cCampo)

Static Function gtLisPreco(_cProduto,nTC)
	Local _cArea:=GetArea()
	Local cAliasQry	:= GetNextAlias()
	Local aColsDa1	:={}
	Local cQuery := ""

	cQuery += "SELECT "
	cQuery += "DA1_CODPRO,DA1_CODTAB,1 DA1_MOEDA, "
	cQuery += "(SELECT TOP 1 ZRA_NUMERO FROM " + RetSqlName("ZRA") + " WHERE D_E_L_E_T_ <> '*' AND ZRA_RAZON = DA1_URAZON) AS ZRA_NUMERO, "
	cQuery += "CASE WHEN DA1_MOEDA = 1 THEN DA1_PRCVEN ELSE ROUND(DA1_PRCVEN*"+ cValToChar(nTC) +",5) END DA1_PRCVEN "
	cQuery += "FROM DA1010 DA1 "
	cQuery += "WHERE DA1_FILIAL = '"+ xFilial("DA1") +"' and "
	cQuery += "      DA1_CODPRO = '"+_cProduto+"' and "
	cQuery += "      DA1.D_E_L_E_T_ = '' "
	IIF(FUNNAME() $ "MATA415",cQuery += " AND DA1_CODTAB = '" + M->CJ_TABELA+ "' ",cQuery += " AND DA1_CODTAB = '" + M->C5_TABELA+ "' ")

	cQuery += "ORDER BY DA1_CODTAB,R_E_C_N_O_ DESC "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	DbSelectArea(cAliasQry)

	(cAliasQry)->(DbGoTop())
	While ( !Eof() )
		aAdd(aColsDa1,{(cAliasQry)->DA1_CODTAB,;
			(cAliasQry)->DA1_MOEDA,;
			(cAliasQry)->DA1_PRCVEN})

		(cAliasQry)->(dbSkip())
	enddo

	(cAliasQry)->(dbCloseArea())

	RestArea(_cArea)

return aColsDa1

//Ajusta el precio de Venta a 2 Decimales en el Presupuesto
User Function RedPre(cCampo)   ////AL CAMBIAR CLIENTE ENTRA ACA   AL CAMBIAR CANTIDAD TAMBIEN ENTRA ACA
	Local aArea		:= GetArea()
	Local aAreaTmp1:= TMP1->(GetArea())
	Local nX
	Local nDcDescont	:= GetSx3Cache("CK_DESCONT","X3_DECIMAL")

	IF IIF(Type("ALTERA") == "U", .F., ALTERA) .and. cCampo $ "CK_QTDVEN"  //si es alteracion y cambio desde producto DESDE CK_QTDVEN

		cxProduto := TMP1->CK_PRODUTO
		cxItem := TMP1->CK_ITEM

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())

			DbSelectArea('SB1')
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				///UBICAMOS SOLO LA LINEA QUE VAMOS A CAMBIAR PARA QUE NO CAMBIE TODO!
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1 .AND. ALLTRIM(TMP1->CK_PRODUTO) == ALLTRIM(cxProduto) .AND. cxItem == TMP1->CK_ITEM

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))
							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")
							TMP1->CK_PRCVEN := nPrcVen
							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPrcVen)*TMP1->CK_QTDVEN
							TMP1->CK_DESCONT:= NoRound((1-(nPrcVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	IF IIF(Type("INCLUI") == "U", .F., INCLUI) .and. cCampo $ "CK_QTDVEN"  //si es inclusion y cambio desde producto DESDE CK_QTDVEN

		cxProduto := TMP1->CK_PRODUTO
		cxItem := TMP1->CK_ITEM

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())

			DbSelectArea('SB1')
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				///UBICAMOS SOLO LA LINEA QUE VAMOS A CAMBIAR PARA QUE NO CAMBIE TODO!
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1 .AND. ALLTRIM(TMP1->CK_PRODUTO) == ALLTRIM(cxProduto) .AND. cxItem == TMP1->CK_ITEM

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							//AJUSTE PARA DESCUENTOS
							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))
							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")
							TMP1->CK_PRCVEN := nPrcVen
							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPrcVen)*TMP1->CK_QTDVEN
							TMP1->CK_DESCONT:= NoRound((1-(nPrcVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)

						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	IF (IIF(Type("ALTERA") == "U", .F., ALTERA) .OR. IIF(Type("INCLUI") == "U", .F., INCLUI)) .and. cCampo $ "CJ_CLIENTE"
		dbSelectArea("TMP1")
		dbGotop()
		While (!Eof())

			TMP1->CK_PRCVEN:= round(TMP1->CK_PRCVEN,2)
			TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
			dbSelectArea("TMP1")
			dbSkip()
		EndDo

		RestArea(aAreaTmp1)
		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	ENDIF

	IF IIF(Type("INCLUI") == "U", .F., INCLUI) .and. cCampo $ "CJ_DESC1"  //si es alteracion y cambio desde producto DESDE CK_QTDVEN

		cxProduto := TMP1->CK_PRODUTO
		cxItem := TMP1->CK_ITEM

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())

			DbSelectArea('SB1')
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				///UBICAMOS SOLO LA LINEA QUE VAMOS A CAMBIAR PARA QUE NO CAMBIE TODO!
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1 .AND. ALLTRIM(TMP1->CK_PRODUTO) == ALLTRIM(cxProduto) .AND. cxItem == TMP1->CK_ITEM

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))
							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")
							TMP1->CK_PRCVEN := nPrcVen
							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPrcVen)*TMP1->CK_QTDVEN
							TMP1->CK_DESCONT:= NoRound((1-(nPrcVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)

						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	IF IIF(Type("INCLUI") == "U", .F., INCLUI) .and. cCampo $ "CJ_LOJA"  //si es inclusion y cambio desde producto DESDE CK_QTDVEN

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())  ///recorremos todo y ajustamos todo cuando es en cabecera

			DbSelectArea('SB1')
			DbSetOrder(1)

			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				///UBICAMOS SOLO LA LINEA QUE VAMOS A CAMBIAR PARA QUE NO CAMBIE TODO!
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							//AJUSTE PARA DESCUENTOS
							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))
							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")
							TMP1->CK_PRCVEN := nPrcVen
							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPrcVen)*TMP1->CK_QTDVEN
							TMP1->CK_DESCONT:= NoRound((1-(nPrcVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)

						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	IF IIF(Type("ALTERA") == "U", .F., ALTERA) .and. cCampo $ "CJ_LOJA"  //si es MODIFICAR y cambio desde producto DESDE LOJA

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())  ///recorremos todo y ajustamos todo cuando es en cabecera

			DbSelectArea('SB1')
			DbSetOrder(1)

			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				///UBICAMOS SOLO LA LINEA QUE VAMOS A CAMBIAR PARA QUE NO CAMBIE TODO!
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0  //////REVISAR EL ORDEN PARA VER POR QUE NO ACTUALIZA CORRECTAMENTE AL MODIFICAR

							////primero deberiamos guardar el historial de lo que hay en la linea y luego actualizar

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							//AJUSTE PARA DESCUENTOS
							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)   ////SI HAY DESCUENTO EN CABECERA SINO 174.13
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))  //174.13* (1 - 14.98 / 100 ) = 0.1498 0.8502 148.045326

							nPnoredVen := nPrcVen   ///148.045326

							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")  ///REDONDEAR AHI O DESPUES?  148.05

							TMP1->CK_PRCVEN := nPrcVen

							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")   ///7402.5
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPnoredVen)*TMP1->CK_QTDVEN

							TMP1->CK_DESCONT:= NoRound((1-(nPnoredVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)  ///0.8502

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)

						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	IF IIF(Type("INCLUI") == "U", .F., INCLUI) .and. cCampo $ "CJ_TABELA"  //si es inclusion y cambio desde producto DESDE CK_QTDVEN

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())  ///recorremos todo y ajustamos todo cuando es en cabecera

			DbSelectArea('SB1')
			DbSetOrder(1)

			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				///UBICAMOS SOLO LA LINEA QUE VAMOS A CAMBIAR PARA QUE NO CAMBIE TODO!
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							//AJUSTE PARA DESCUENTOS
							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))
							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")
							TMP1->CK_PRCVEN := nPrcVen
							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPrcVen)*TMP1->CK_QTDVEN
							TMP1->CK_DESCONT:= NoRound((1-(nPrcVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)

						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	IF IIF(Type("ALTERA") == "U", .F., ALTERA) .and. cCampo $ "CJ_TABELA"  //si es MODIFICAR y cambio desde producto DESDE LOJA

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())  ///recorremos todo y ajustamos todo cuando es en cabecera

			DbSelectArea('SB1')
			DbSetOrder(1)

			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				///UBICAMOS SOLO LA LINEA QUE VAMOS A CAMBIAR PARA QUE NO CAMBIE TODO!
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0  //////REVISAR EL ORDEN PARA VER POR QUE NO ACTUALIZA CORRECTAMENTE AL MODIFICAR

							////primero deberiamos guardar el historial de lo que hay en la linea y luego actualizar

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							//AJUSTE PARA DESCUENTOS
							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)   ////SI HAY DESCUENTO EN CABECERA SINO 174.13
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))  //174.13* (1 - 14.98 / 100 ) = 0.1498 0.8502 148.045326

							nPnoredVen := nPrcVen   ///148.045326

							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")  ///REDONDEAR AHI O DESPUES?  148.05

							TMP1->CK_PRCVEN := nPrcVen

							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")   ///7402.5
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPnoredVen)*TMP1->CK_QTDVEN

							TMP1->CK_DESCONT:= NoRound((1-(nPnoredVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)  ///0.8502

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)

						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	/////AL INCLUIR PRESUPUESTO
	dbSelectArea("TMP1")
	dbGotop()

	While (!Eof())

		DbSelectArea('SB1')
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
			IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1

				nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

				If nTC2 > 0

					aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

					if len(aAda1) > 0

						TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
						TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
						TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

					endif

				endif

			ELSE
				TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
				TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
			ENDIF
		ENDIF

		dbSelectArea("TMP1")
		dbSkip()
	EndDo
	RestArea(aAreaTmp1)

	oDlg := GetWndDefault()

	For nX := 1 To Len(oDlg:aControls)
		If ValType(oDlg:aControls[nX]) <> "U"
			oDlg:aControls[nX]:ReFresh()
		EndIf
	Next nX

	RestArea(aAreaTmp1)
	RestArea( aArea )

Return &("M->"+cCampo)

//Ajusta el precio de Venta a 2 Decimales en el Presupuesto solo trae precio
User Function RedPre2(cCampo)  ///AL CAMBIAR PRODUCTO EN LINEA ENTRA ACA
	Local aArea		:= GetArea()
	Local aAreaTmp1:= TMP1->(GetArea())
	Local nX
	Local nDcDescont	:= GetSx3Cache("CK_DESCONT","X3_DECIMAL")

	IF IIF(Type("ALTERA") == "U", .F., ALTERA) .and. cCampo $ "CK_PRODUTO"  //si es alteracion y cambio desde producto

		cxProduto := TMP1->CK_PRODUTO
		cxItem := TMP1->CK_ITEM

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())

			DbSelectArea('SB1')
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1 .AND. ALLTRIM(TMP1->CK_PRODUTO) == ALLTRIM(M->CK_PRODUTO) .AND. cxItem == TMP1->CK_ITEM

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))
							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")
							TMP1->CK_PRCVEN := nPrcVen
							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPrcVen)*TMP1->CK_QTDVEN
							TMP1->CK_DESCONT:= NoRound((1-(nPrcVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)

						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	IF IIF(Type("INCLUI") == "U", .F., INCLUI) .and. cCampo $ "CK_PRODUTO"  //si es alteracion y cambio desde producto

		cxProduto := TMP1->CK_PRODUTO
		cxItem := TMP1->CK_ITEM

		dbSelectArea("TMP1")
		dbGotop()

		While (!Eof())

			DbSelectArea('SB1')
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
				IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1 .AND. ALLTRIM(TMP1->CK_PRODUTO) == ALLTRIM(M->CK_PRODUTO) .AND. cxItem == TMP1->CK_ITEM

					nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

					If nTC2 > 0

						aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

						if len(aAda1) > 0

							TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
							TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
							TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

							nPrcVen := TMP1->CK_PRUNIT

							nPrcVen := u_xA415PrcDes(nPrcVen)
							nPrcVen := (nPrcVen*(1-TMP1->CK_DESCONT/100))
							nPrcVen := a410Arred(nPrcVen,"CK_PRCVEN")
							TMP1->CK_PRCVEN := nPrcVen
							TMP1->CK_VALOR  := A410Arred(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,"CK_VALOR")
							TMP1->CK_VALDESC:= (u_xA415PrcDes(TMP1->CK_PRUNIT)-nPrcVen)*TMP1->CK_QTDVEN
							TMP1->CK_DESCONT:= NoRound((1-(nPrcVen/u_xA415PrcDes(TMP1->CK_PRUNIT)))*100, nDcDescont)

							TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
							TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
						endif

					endif

				ELSE
					TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
					TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
				ENDIF
			ENDIF

			dbSelectArea("TMP1")
			dbSkip()
		EndDo
		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

		RestArea(aAreaTmp1)
		RestArea( aArea )

		Return &("M->"+cCampo)
	endif

	dbSelectArea("TMP1")
	dbGotop()
	While (!Eof())

		DbSelectArea('SB1')
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+TMP1->CK_PRODUTO,.f.)
			IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->CJ_MOEDA == 1

				nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

				If nTC2 > 0

					aAda1 = gtLisPreco(TMP1->CK_PRODUTO,nTC2) ///traer precio bs

					if len(aAda1) > 0

						TMP1->CK_PRCVEN := round(aAda1[1][3],2)   //precio venta
						TMP1->CK_PRUNIT := round(aAda1[1][3],2)   ///precio lista
						TMP1->CK_VALOR := round(TMP1->CK_QTDVEN * TMP1->CK_PRCVEN,2)

					endif

				endif

			ELSE
				TMP1->CK_PRCVEN := round(TMP1->CK_PRCVEN,2)
				TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
			ENDIF
		ENDIF

		dbSelectArea("TMP1")
		dbSkip()
	EndDo
	RestArea(aAreaTmp1)

	oDlg := GetWndDefault()

	For nX := 1 To Len(oDlg:aControls)
		If ValType(oDlg:aControls[nX]) <> "U"
			oDlg:aControls[nX]:ReFresh()
		EndIf
	Next nX

	RestArea(aAreaTmp1)
	RestArea( aArea )

Return &("M->"+cCampo)

User Function RedPre3(cCampo)
	Local aArea		:= GetArea()
	Local aAreaTmp1:= TMP1->(GetArea())
	Local nX

	nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="CK_PRCVEN" })

	dbSelectArea("TMP1")
	dbGotop()
	While (!Eof())

		TMP1->CK_PRCVEN:= round(TMP1->CK_PRCVEN,2)
		TMP1->CK_VALOR  := round(TMP1->CK_PRCVEN * TMP1->CK_QTDVEN,2)
		dbSelectArea("TMP1")
		dbSkip()
	EndDo
	RestArea(aAreaTmp1)
	oDlg := GetWndDefault()

	For nX := 1 To Len(oDlg:aControls)
		If ValType(oDlg:aControls[nX]) <> "U"
			oDlg:aControls[nX]:ReFresh()
		EndIf
	Next nX

	RestArea(aAreaTmp1)
	RestArea( aArea )
Return &("M->"+cCampo)

//Ajusta el precio de Venta a 2 Decimales en el Pedido de Venta
User Function RedPed2(cCampo)
	Local aArea		:= GetArea()
	Local i
	Local lVenFut	:= FWIsInCallStack("U_GERVTAFUT")
	Local aAda1 := {}
	Local lAutomato := IsBlind()

	if !lAutomato
		IF !lVenFut
			nPosCan  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_QTDVEN" })
			nPosPro  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRODUTO" })
			nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRCVEN" })
			nPosTot  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_VALOR" })
			nPosPru  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRUNIT" }) //precio lista

			for i:=1 to Len(aCols)
				DbSelectArea('SB1')
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+aCols[i][nPosPro],.f.)

					IF (SB1->B1_XIMPORT == "S" .OR. EMPTY(SB1->B1_XIMPORT)) .and. M->C5_MOEDA == 1  ///preguntamos para ver la tasa auxiliar

						nTC2 = POSICIONE("SM2",1,DATE(),"M2_MOEDA5")///TRAER TASA DE CAMBIO 2

						If nTC2 > 0

							aAda1 = gtLisPreco(aCols[i][nPosPro],nTC2) ///traer precio bs

							if len(aAda1) > 0

								acols[i][nPosPre] := round(aAda1[1][3],2)   //precio venta
								acols[i][nPosPru] := round(aAda1[1][3],2)   ///precio lista
								acols[i][nPosTot] := round(acols[i][nPosCan] * acols[i][nPosPre],2)

							endif

						endif
					ELSE

						acols[i][nPosPre] := round(acols[i][nPosPre],2)
						acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)

					endif
				endif
			Next
			oGetDad:refresh()
		ENDIF

	endif

	RestArea( aArea )
Return &("M->"+cCampo)

//Ajusta el precio de Venta a 2 Decimales en el Pedido de Venta
User Function RedPed3(cCampo)
	Local aArea		:= GetArea()
	Local i
	Local lAutomato := IsBlind()

	if !lAutomato
		nPosCan  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_QTDVEN" })
		nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_PRCVEN" })
		nPosTot  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="C6_VALOR" })

		for i:=1 to Len(aCols)
			acols[i][nPosPre] := round(acols[i][nPosPre],2)
			acols[i][nPosTot]  := round(acols[i][nPosCan] * acols[i][nPosPre],2)
		Next
		oGetDad:refresh()

	endif
	RestArea( aArea )
Return &("M->"+cCampo)

user Function FtDescCab(nPrcLista,aDesconto,nMoeda)
	Local nPrcVen := nPrcLista
	Local nX      := 0

	For nX := 1 To Len(aDesconto)
		If aDesconto[nX] <> 0
			nPrcVen := nPrcVen * ( 1 - ( aDesconto[nX]/100 ) )
		EndIf
	Next nX
	nPrcVen := A410Arred(nPrcVen,"D2_PRCVEN",nMoeda)

Return(nPrcVen)

user Function FtDescItem(nPrUnit,nPrcVen,nQtdVen,nTotal,nPerc,nDesc,nDescOri,nTipo,nQtdAnt,nMoeda)
	Local nPreco := 0
	Local nValTot:= 0
	DEFAULT nTipo    := 1
	DEFAULT nQtdAnt  := nQtdVen
	//Calculo o Preco de Lista quando nao houver tabela de preco

	If nPrUnit == 0
		nPrUnit += nPrcVen + a410Arred(nDescOri/nQtdAnt,"D2_PRCVEN")
	EndIf

	//Calcula o novo preco de Venda
	If nTipo == 1
		nPreco := A410Arred(nPrUnit * (1-(nPerc/100)),"D2_PRCVEN",nMoeda)
	Else
		nDesc  := a410Arred(nDesc/nQtdVen,"D2_PRCVEN")
		nPreco := A410Arred(nPrUnit-nDesc,"D2_PRCVEN",nMoeda)
	EndIf
	nTotal := A410Arred(nPreco* nQtdVen,"D2_TOTAL",nMoeda)
	nValTot:= A410Arred(nPrUnit * nQtdVen,"D2_DESCON")

	//Calculo dos descontos

	If cPaisLoc != "BRA"
		If nPrUnit == 0
			nDesc := 0
			nPerc := 0
		Else
			nDesc := A410Arred(nValTot-nTotal,"D2_DESCON")
			If nTipo<>1
				nPerc := A410Arred((1-(nPreco/nPrUnit))*100,"C6_DESCONT")
			EndIf
		EndIf
	Else
		nDesc := A410Arred(nValTot-nTotal,"D2_DESCON")
		If nTipo<>1
			nPerc := A410Arred((1-(nPreco/nPrUnit))*100,"C6_DESCONT")
		EndIf
	EndIf
Return(nPreco)

user Function xA410ReCalc(lDescCab,lBenefPodT)
	Local aArea		:= GetArea()
	Local aAreaSX3	:= SX3->(GetArea())
	Local aCont    := {}
	Local aStruSC6 := {}
	Local aDadosCfo := {}
	Local cAliasQry:= ""
	Local cAltPreco:= GetNewPar( "MV_ALTPREC", "T" )
	Local cCliTab  := ""
	Local cLojaTab := ""
	Local lAltPreco:= .F.
	Local nDesc		:= 0
	Local ni		:= 0
	Local nTmp	:=	1
	Local nx		:= 0
	Local nCntFor 	:= 0
	Local nPCFOP 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF" })
	Local nPTes		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
	Local nPProd	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
	Local nPPrUnit	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
	Local nPPrcVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
	Local nPDescon	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
	Local nPVlDesc	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
	Local nPQtdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
	Local nPValor	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
	Local nPLoteCtl	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
	Local nPNumLote	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
	Local nPItem	:= GDFieldPos( "C6_ITEM" )
	Local nPGrdQtd	:= 0
	Local nPGrdPrc	:= 0
	Local nPGrdTot	:= 0
	Local nPGrdVDe	:= 0
	Local nPGrdPrU	:= 0
	Local nVlrTabela:= 0
	Local nScan    := 0
	Local nLinha	:= 0
	Local nColuna	:= 0
	Local lGrade	:= MaGrade()
	Local lGradeReal:= .F.
	Local cProduto	:= ""
	Local lCondPg   := (ReadVar()=="M->C5_CONDPAG")  //SI CAMPO ES CONDIFIO
	Local lCondTab  := .F. 							// Verifica se a condicao escolhida esta na tabela de precos
	Local nDescont	:= 0
	Local nDecDesc  := 0
	Local lFtRegraDesc := IsInCallStack("FtRegraDesc")	//Para validar se a chamada da função A410ReCalc() está vindo da Regra de Desconto ou do valid do campo
	Local lTabCli   := (SuperGetMv("MV_TABCENT",.F.,"2") == "1")
	Local lGrdMult  := "MATA410" $ SuperGetMV("MV_GRDMULT",.F.,"")

	// Indica se o preco unitario sera arredondado em 0 casas decimais ou nao. Se .T. respeita MV_CENT (Apenas Chile).
	Local lPrcDec   := SuperGetMV("MV_PRCDEC",,.F.)

	//Tratamento para opcionais
	Local lOpcPadrao	:= SuperGetMv("MV_REPGOPC",.F.,"N") == "N"
	Local nPOpcional	:= aScan(aHeader,{|x| AllTrim(x[2])==IIf(lOpcPadrao,"C6_OPC","C6_MOPC")})
	Local cOpcional		:= ""
	Local cOpc			:= ""
	Local nVlrOpc		:= 0

	DEFAULT lDescCab := GetNewPar("MV_PVRECAL",.F.) //Desabilita o recalculo automatico do Pedido de Venda.
	DEFAULT lBenefPodT := .F.

	l410Auto := If (Type("l410Auto") == "U", .F., l410Auto)

	If Type("lShowOpc") == "L"
		lShowOpc := .T.
	EndIf

	//Corrige o preco de tabela e preco unitario p/ tab.alterada    ³

	If (M->C5_TIPO == "N" .And. !("M->C5_CLIENT"==Alltrim(ReadVar()).Or."M->C5_LOJAENT"==ReadVar()) .And. !lBenefPodT  ) .Or.;
			(M->C5_TIPO == "N" .And. lTabCli)

		nTmp	:=	n
		For nCntFor := 1 to Len(aCols)

			nVlrOpc := 0


			// Verifica se deve atualizar os precos conforme a regra

			lAltPreco := .T.

			If lAltPreco

				//Verifica se eh grade para calcular o valor total por item da grade

				cProduto	:= aCols[nCntFor][nPProd]
				lGradeReal	:= ( lGrade .And. MatGrdPrrf(@cProduto) )

				cCliTab   := M->C5_CLIENTE
				cLojaTab  := M->C5_LOJACLI

				If !lDescCab
					If !(lGrdMult .And. lGrade .And. lGradeReal)  ////trae precio lista
						nVlrTabela := A410Tabela(	aCols[nCntFor][nPProd],;
							M->C5_TABELA,;
							nCntFor,;
							aCols[nCntFor][nPQtdVen],;
							cCliTab,;
							cLojaTab,;
							If(nPLoteCtl>0,aCols[nCntFor][nPLoteCtl],""),;
								If(nPNumLote>0,aCols[nCntFor][nPNumLote],"")	)

							EndIf
						Else
							nVlrTabela := aCols[nCntFor][nPPrUnit]
						EndIf

						If !(lGrdMult .And. lGrade .And. lGradeReal)///entra

							If ( nPPrUnit > 0 )
								aCols[nCntFor][nPPrUnit] := nVlrTabela
							EndIf

							n	:=	nCntFor   ////que linea
							nDescont := FtRegraDesc(1)  ///trae regla descuento

							If nDescont > 0	.Or. (nDescont == 0 .And. aCols[nCntFor,nPDescon] > 0)
								aCols[nCntFor,nPDescon] := nDescont
							EndIf
							///descuento por item
							If ( nPDescon > 0 .And. nPVlDesc > 0 .And. nPPrcVen > 0 .And. nPValor > 0 .And. nPPrUnit>0 )
								aCols[nCntFor][nPPrcVen] := FtDescItem(If(aCols[nCntFor][nPPrUnit] == 0, aCols[nCntFor][nPPrUnit],@aCols[nCntFor][nPPrcVen]),;
									@aCols[nCntFor,nPPrcVen],;
									aCols[nCntFor,nPQtdVen],;
									@aCols[nCntFor,nPValor],;
									@aCols[nCntFor,nPDescon],;
									@aCols[nCntFor,nPVlDesc],;
									@aCols[nCntFor,nPVlDesc],1,,If(cPaisLoc $ "CHI|PAR" .And. lPrcDec,M->C5_MOEDA,NIL))
							EndIf
						EndIf

						If lGrade .And. lGradeReal .And. Type("oGrade")=="O" .And. Len(oGrade:aColsGrade) > 0
							If !lGrdMult
								aCols[nCntFor,nPValor] := 0
								nPGrdQtd := oGrade:GetFieldGrdPos("C6_QTDVEN")
								For nLinha := 1 To Len(oGrade:aColsGrade[nCntFor])
									For nColuna := 2 To Len(oGrade:aHeadGrade[nCntFor])
										If ( oGrade:aColsGrade[nCntFor,nLinha,nColuna][nPGrdQtd] <> 0 )
											aCols[nCntFor,nPValor]  += a410Arred( oGrade:aColsGrade[nCntFor,nLinha,nColuna][nPGrdQtd]*aCols[nCntFor,nPPrcVen],"C6_VALOR",If(cPaisLoc $ "CHI|PAR" .And. lPrcDec,M->C5_MOEDA,NIL))
										Endif
									Next nColuna
								Next nLinha
							Else
								n	:=	nCntFor
								oGrade:cProdRef := aCols[nCntFor][nPProd]
								oGrade:nPosLinO := n
								aCols[n,nPValor] := 0
								nPGrdQtd := oGrade:GetFieldGrdPos("C6_QTDVEN")
								nPGrdPrc := oGrade:GetFieldGrdPos("C6_PRCVEN")
								nPGrdTot := oGrade:GetFieldGrdPos("C6_VALOR")
								nPGrdVDe := oGrade:GetFieldGrdPos("C6_VALDESC")
								nPGrdPrU := oGrade:GetFieldGrdPos("C6_PRUNIT")
								For nLinha := 1 To Len(oGrade:aColsGrade[n])
									For nColuna := 2 To Len(oGrade:aHeadGrade[n])
										If ( oGrade:aColsGrade[n,nLinha,nColuna,nPGrdQtd] <> 0 )
											nVlrTabela := A410Tabela(oGrade:GetNameProd(,nLinha,nColuna),;
												M->C5_TABELA,;
												nCntFor,;
												oGrade:aColsFieldByName("C6_QTDVEN",,nLinha,nColuna),;
												cCliTab,;
												cLojaTab,;
												,;
												,;
												,;
												,;
												,;
												oGrade:aColsGrade[n,nLinha,nColuna,oGrade:GetFieldGrdPos("C6_OPC")])

											If nVlrTabela <> 0
												oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrU] := nVlrTabela
												oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc] := FtDescCab(nVlrTabela,{M->C5_DESC1,M->C5_DESC2,M->C5_DESC3,M->C5_DESC4},If(cPaisLoc $ "CHI|PAR" .And. lPrcDec,M->C5_MOEDA,NIL))
												oGrade:aColsGrade[n,nLinha,nColuna,nPGrdVDe] := A410Arred((nVlrTabela - oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc])*oGrade:aColsGrade[n,nLinha,nColuna,nPGrdQtd],"C6_VALOR")
												oGrade:aColsGrade[n,nLinha,nColuna,nPGrdTot] := A410Arred(oGrade:aColsGrade[n,nLinha,nColuna,nPGrdQtd] * oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc],"C6_VALOR")
											EndIf
										Endif
									Next nColuna
								Next nLinha

								aCols[n,nPPrcVen] := oGrade:SomaGrade("C6_PRCVEN",n)
								aCols[n,nPDescon] := FtRegraDesc(1)

								If ( nPDescon > 0 .And. nPVlDesc > 0 .And. nPPrcVen > 0 .And. nPValor > 0 .And. nPPrUnit>0 )
									For nLinha := 1 To Len(oGrade:aColsGrade[n])
										For nColuna := 2 To Len(oGrade:aHeadGrade[n])
											oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc] := FtDescItem(0,;
												@oGrade:aColsGrade[n,nLinha,nColuna,nPGrdPrc],;
												oGrade:aColsGrade[n,nLinha,nColuna,nPGrdQtd],;
												@oGrade:aColsGrade[n,nLinha,nColuna,nPGrdTot],;
												@aCols[nCntFor,nPDescon],;
												@oGrade:aColsGrade[n,nLinha,nColuna,nPGrdVDe],;
												0,1,,If(cPaisLoc $ "CHI|PAR" .And. lPrcDec,M->C5_MOEDA,NIL))
										Next nColuna
									Next nLinha
								EndIf
								aCols[n,nPPrcVen] := oGrade:SomaGrade("C6_PRCVEN",n)
								aCols[n,nPValor] := oGrade:SomaGrade("C6_VALOR",n)
								aCols[n,nPVlDesc] := oGrade:SomaGrade("C6_VALDESC",n)
							EndIf
						EndIf
					EndIf

				Next nCntFor
				n	:=	nTmp
			EndIf

			If Type('oGetDad:oBrowse')<>"U"
				oGetDad:oBrowse:Refresh()
				Ma410Rodap()
			Endif

			RestArea(aAreaSX3)
			RestArea(aArea)
			Return(.T.)

user Function xA415PrcDes(nPrcLista)

	nPrcLista := FtDescCab(nPrcLista,{M->CJ_DESC1,M->CJ_DESC2,M->CJ_DESC3,M->CJ_DESC4})

Return(nPrcLista)
