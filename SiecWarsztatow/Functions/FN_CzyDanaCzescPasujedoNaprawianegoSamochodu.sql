/****** Object:  UserDefinedFunction [dbo].[CzyDanaCzescPasujeDoNaprawianegoSamochodu]    Script Date: 09.01.2021 01:21:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[CzyDanaCzescPasujeDoNaprawianegoSamochodu] (@CzescId INT)
	RETURNS BIT
	AS 
	BEGIN

	IF NOT EXISTS
	(
		SELECT *
				FROM dbo.Czesc AS C
				JOIN dbo.CzescDoNaprawy AS CN on C.id = CN.czesc_id
				JOIN dbo.Naprawa AS N on CN.naprawa_id = N.id
				JOIN Zlecenie AS Z ON N.zlecenie_id = Z.id
				JOIN Samochod AS S ON Z.samochod_id = S.id
				JOIN Model AS M ON S.model_id = M.id
				JOIN Typ_nadwozia AS TN ON S.typNadwozia_id = TN.id
				WHERE M.id = (SELECT CzesciSamochodu.model_id
								FROM Czesc JOIN CzesciSamochodu ON Czesc.id = CzesciSamochodu.czesc_id
								WHERE CzesciSamochodu.id = @CzescId
							)
				AND TN.id = (	SELECT CzesciSamochodu.typNadwozia_id
								FROM Czesc JOIN CzesciSamochodu ON Czesc.id = CzesciSamochodu.czesc_id
								WHERE CzesciSamochodu.id = @CzescId
							)
	)
	BEGIN
		RETURN 0
	END

	RETURN 1
END