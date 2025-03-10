*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
*   Fecha: Mayo 2015
*   Autor: Omar Basabe.
*
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.HABILITA.DIR.CUS(Y.NUM.ANIOS)

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences

    GOSUB POS.LOCALES
    GOSUB PROCESO
*    CALL REBUILD.SCREEN
    RETURN

*************
POS.LOCALES:
**********************
    NOM.CAMPOS     = "CALLE.ANT#DIR.NUM.EXT.ANT#DIR.NUM.INT.ANT#DIR.COD.POS.ANT#DIR.COLONIA.ANT#DIR.DEL.MUN.ANT#DIR.CD.EDO.ANT#DIR.PAIS.ANT"
    POS.CAMP.LOCAL = ""


    EB.LocalReferences.GetLocRef("CUSTOMER",NOM.CAMPOS,POS.CAMP.LOCAL)


    Y.POS.CALLE.ANT       = FIELD(POS.CAMP.LOCAL,"#",1)
    Y.POS.DIR.NUM.EXT.ANT = FIELD(POS.CAMP.LOCAL,"#",2)
    Y.POS.DIR.NUM.INT.ANT = FIELD(POS.CAMP.LOCAL,"#",3)
    Y.POS.DIR.COD.POS.ANT = FIELD(POS.CAMP.LOCAL,"#",4)
    Y.POS.DIR.COLONIA.ANT = FIELD(POS.CAMP.LOCAL,"#",5)
    Y.POS.DIR.DEL.MUN.ANT = FIELD(POS.CAMP.LOCAL,"#",6)
    Y.POS.DIR.CD.EDO.ANT  = FIELD(POS.CAMP.LOCAL,"#",7)
    Y.POS.DIR.PAIS.ANT    = FIELD(POS.CAMP.LOCAL,"#",8)

    RETURN

*************
PROCESO:
**********************
*    IF MESSAGE EQ 'VAL' THEN RETURN
    Y.BANDERA = 0
    IF Y.NUM.ANIOS = "" THEN
        Y.BANDERA = 1
        Y.NUM.ANIOS = 2
    END


    IF Y.NUM.ANIOS GE 2 THEN

        
        LocalRef<1,Y.POS.CALLE.ANT> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
        T.LOCREF<Y.POS.CALLE.ANT,7> = 'NOINPUT'

        LocalRef<1,Y.POS.DIR.NUM.EXT.ANT> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
        T.LOCREF<Y.POS.DIR.NUM.EXT.ANT,7> = 'NOINPUT'

        LocalRef<1,Y.POS.DIR.NUM.INT.ANT> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
        T.LOCREF<Y.POS.DIR.NUM.INT.ANT,7> = 'NOINPUT'

        LocalRef<1,Y.POS.DIR.COD.POS.ANT> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
        T.LOCREF<Y.POS.DIR.COD.POS.ANT,7> = 'NOINPUT'

        LocalRef<1,Y.POS.DIR.COLONIA.ANT> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
        T.LOCREF<Y.POS.DIR.COLONIA.ANT,7> = 'NOINPUT'

        LocalRef<1,Y.POS.DIR.DEL.MUN.ANT> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
        T.LOCREF<Y.POS.DIR.DEL.MUN.ANT,7> = 'NOINPUT'

        LocalRef<1,Y.POS.DIR.CD.EDO.ANT> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
        T.LOCREF<Y.POS.DIR.CD.EDO.ANT,7> = 'NOINPUT'

        LocalRef<1,Y.POS.DIR.PAIS.ANT> = ''
        EB.SystemTables.setRNew(ST.Customer.Customer.EbCusLocalRef, LocalRef)
        T.LOCREF<Y.POS.DIR.PAIS.ANT,7> = 'NOINPUT'

        
        EB.CUS.TOWN.COUNTRY = EB.SystemTables.getRNew(ST.Customer.Customer.EbCusTownCountry)<1,2>
        
        T(EB.CUS.TOWN.COUNTRY)<3> = 'NOINPUT'
    END ELSE
        T.LOCREF<Y.POS.CALLE.ANT,7>       = ''
        T.LOCREF<Y.POS.DIR.NUM.EXT.ANT,7> = ''
        T.LOCREF<Y.POS.DIR.NUM.INT.ANT,7> = ''
        T.LOCREF<Y.POS.DIR.COD.POS.ANT,7> = ''
        T.LOCREF<Y.POS.DIR.COLONIA.ANT,7> = ''
        T.LOCREF<Y.POS.DIR.DEL.MUN.ANT,7> = ''
        T.LOCREF<Y.POS.DIR.CD.EDO.ANT,7>  = ''
        T.LOCREF<Y.POS.DIR.PAIS.ANT,7>    = ''
    END

    IF Y.BANDERA = 1 THEN
        Y.NUM.ANIOS = ""
    END
    RETURN
END
