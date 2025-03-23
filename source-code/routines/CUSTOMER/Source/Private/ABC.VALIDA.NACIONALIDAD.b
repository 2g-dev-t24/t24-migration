* @ValidationCode : MjoyMDg3MjEzNzE4OkNwMTI1MjoxNzQyNTAxODc1MzUyOkx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Mar 2025 17:17:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Luis Capra
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.VALIDA.NACIONALIDAD
*----------------------------------------------------------------
* Descripcion  : Rutina para validar bloqueo de pa�s en la tabla COUNTRY
*----------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING ST.Config
    $USING EB.LocalReferences

    IF EB.SystemTables.getMessage() NE 'VAL' THEN

        GOSUB INIT
        GOSUB OPEN.FILES

        IF Y.ID.COUNTRY THEN
            Y.COUNTRY.REC = ST.Config.Country.Read(Y.ID.COUNTRY,ERR.COUNTRY)
            IF Y.COUNTRY.REC THEN
                Y.BLOQUEO = Y.COUNTRY.REC<ST.Config.Country.EbCouHighRisk>
                IF Y.BLOQUEO EQ 'SI' THEN
                    Y.ERROR = 'EL PAIS SELECCIONADO NO ES PERMITIDO'
                    EB.SystemTables.setEtext(Y.ERROR)
                    EB.ErrorProcessing.StoreEndError()
                    RETURN
                END
            END ELSE
                Y.ERROR = 'NO EXISTE REGISTRO DEL PAIS'
                EB.SystemTables.setEtext(Y.ERROR)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END

RETURN

***********
OPEN.FILES:
***********

    FN.COUNTRY = 'F.COUNTRY'
    F.COUNTRY = ''
    EB.DataAccess.Opf(FN.COUNTRY,F.COUNTRY)

RETURN

*****
INIT:
*****

    Y.ID.COUNTRY = EB.SystemTables.getComi()
    Y.BLOQUEO = ''


RETURN

END
