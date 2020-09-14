GO

DECLARE @VCB tinyint, @Limite int, @TipoActualiza char(1)
SELECT @VCB = MIN(NumActualiza) FROM ActualizaTitles --Asignacion dinamica de los valores de la VCB y su limite (independiente de la cantidad de filas)
SELECT @Limite = MAX(NumActualiza) FROM ActualizaTitles
--Si MAX(NumActualiza) no existe, no devolvera NULL, sino que @Limite se quedara como estaba
--pub_id es foreign key


WHILE @VCB <= @Limite

	BEGIN
		

		SELECT @TipoActualiza = TipoActualiza FROM ActualizaTitles

		PRINT @VCB
		--Para controlar en que iteracion se encuentra el programa
		--Almacenar variable

		IF @TipoActualiza = 'I'

			BEGIN

				INSERT INTO titles(title_id, title, [type], pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
				(SELECT 
					A.title_id,
					A.title,
					A.[type],
						(SELECT pub_id 
						 FROM publishers
						 WHERE pub_id = A.pub_id),
					A.price,
					A.advance,
					A.royalty,
					A.ytd_sales,
					A.notes,
					A.pubdate

				FROM ActualizaTitles AS A
				WHERE NumActualiza = @VCB)

			END

		

		ELSE IF @TipoActualiza = 'U'

				 BEGIN

				 --Aqui haz un UPDATE FROM
					UPDATE titles

					--Si los datos con los que voy a sustituir son NULL, la columna se quedara
					--tal y como esta, es decir, se hara SET title = title

					SET title = ISNULL((SELECT title
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), title),

						[type] = ISNULL((SELECT [type]
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), [type]),

						pub_id = ISNULL((SELECT pub_id
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), pub_id),
										  
						price = ISNULL((SELECT price
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), price),

						advance = ISNULL((SELECT advance
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), advance),

						royalty = ISNULL((SELECT royalty
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), royalty),

						ytd_sales = ISNULL((SELECT ytd_sales
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), ytd_sales),

						notes = ISNULL((SELECT notes
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), notes),

						pubdate = ISNULL((SELECT pubdate
										  FROM ActualizaTitles
										  WHERE NumActualiza = @VCB), pubdate)


					WHERE title_id = (SELECT title_id 
									FROM ActualizaTitles
									WHERE NumActualiza = @VCB)

				 END
				 
				 
		ELSE IF @TipoActualiza = 'D'

			BEGIN

				DELETE FROM titles
				WHERE (title_id = (SELECT title_id 
								   FROM ActualizaTitles
								   WHERE NumActualiza = @VCB))
								   
			END

		--Actualizamos la VCB.
		SELECT @VCB = MIN(NumActualiza) FROM ActualizaTitles
		WHERE @VCB < NumActualiza
		--Asi se salta al siguiente NumActualiza incluso habiendo saltos de mas de una unidad entre los numeros
	END
GO