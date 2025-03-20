*-----------------------------------------------------------------------------
* <Rating>30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.VALIDA.NACIONALIDAD
*----------------------------------------------------------------
* Descripcion  : Rutina para validar bloqueo de país en la tabla COUNTRY
*----------------------------------------------------------------

    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.Display
    $USING ST.Config

    IF EB.SystemTables.getMessage() NE 'VAL' THEN

        GOSUB INIT
        GOSUB OPEN.FILES

        IF Y.ID.COUNTRY THEN
            Y.COUNTRY.REC = ST.Config.Country.Read(Y.ID.COUNTRY,ERR.COUNTRY) 
            IF Y.COUNTRY.REC THEN
                Y.LOCAL.REF = Y.COUNTRY.REC<ST.Config.Country.EbCouLocalRef>
                Y.BLOQUEO = Y.LOCAL.REF<1,Y.POS.LOCKED>
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

    EB.LocalReferences.GetLocRef("COUNTRY","LOCKED",Y.POS.LOCKED)

    RETURN

END
