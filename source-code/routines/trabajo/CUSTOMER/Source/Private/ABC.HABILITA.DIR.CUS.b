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
    $USING EB.Display
    GOSUB POS.LOCALES
    GOSUB PROCESO
    EB.Display.RebuildScreen()
    RETURN

*************
POS.LOCALES:
**********************

     NOM.CAMPOS     = 'ABC.DIR.CALLE.A':@VM:'ABC.NUM.EXT.ANT':@VM:'ABC.COD.POS.ANT':@VM:'ABC.COLONIA.ANT':@VM:'ABC.DEL.MUN.ANT':@VM:'ABC.CD.EDO.ANT':@VM:'ABC.PAIS.ANT':@VM:'ABC.NUM.INT.ANT'
    POS.CAMP.LOCAL = ""


    EB.Updates.MultiGetLocRef("CUSTOMER",NOM.CAMPOS,POS.CAMP.LOCAL)


    Y.POS.CALLE.ANT       = POS.CAMP.LOCAL<1,1> 
    Y.POS.DIR.NUM.EXT.ANT = POS.CAMP.LOCAL<1,2> 
    Y.POS.DIR.COD.POS.ANT = POS.CAMP.LOCAL<1,3> 
    Y.POS.DIR.COLONIA.ANT = POS.CAMP.LOCAL<1,4> 
    Y.POS.DIR.DEL.MUN.ANT = POS.CAMP.LOCAL<1,5> 
    Y.POS.DIR.CD.EDO.ANT  = POS.CAMP.LOCAL<1,6> 
    Y.POS.DIR.PAIS.ANT    = POS.CAMP.LOCAL<1,7> 
    Y.POS.ABC.NUM.INT.ANT = POS.CAMP.LOCAL<1,8>
    RETURN

*************
PROCESO:
**********************

    Y.BANDERA = 0
    IF Y.NUM.ANIOS = "" THEN
        Y.BANDERA = 1
        Y.NUM.ANIOS = 2
    END


    IF Y.NUM.ANIOS GE 2 THEN

        
        tmp=EB.SystemTables.getTLocref()
        tmp<Y.POS.CALLE.ANT,7>="NOINPUT"
        tmp<Y.POS.DIR.NUM.EXT.ANT,7>="NOINPUT"
        tmp<Y.POS.DIR.COD.POS.ANT,7>="NOINPUT"
        tmp<Y.POS.DIR.COLONIA.ANT,7>="NOINPUT"
        tmp<Y.POS.DIR.DEL.MUN.ANT,7>="NOINPUT"
        tmp<Y.POS.DIR.CD.EDO.ANT,7>="NOINPUT"
        tmp<Y.POS.DIR.PAIS.ANT,7>="NOINPUT"
        tmp<Y.POS.ABC.NUM.INT.ANT,7>="NOINPUT"
        EB.SystemTables.setTLocref(tmp)
        
        tmp=EB.SystemTables.getT(ST.Customer.Customer.EbCusTownCountry)<1,2>
        tmp<3>="NOINPUT"
        EB.SystemTables.setT(ST.Customer.Customer.EbCusTownCountry, tmp)

    END ELSE
        tmp=EB.SystemTables.getTLocref()
        tmp<Y.POS.CALLE.ANT,7>="INPUT"   
        tmp<Y.POS.DIR.NUM.EXT.ANT,7>="INPUT"         
        tmp<Y.POS.DIR.COD.POS.ANT,7>="INPUT"     
        tmp<Y.POS.DIR.COLONIA.ANT,7>="INPUT"    
        tmp<Y.POS.DIR.DEL.MUN.ANT,7>="INPUT"    
        tmp<Y.POS.DIR.CD.EDO.ANT,7>="INPUT"       
        tmp<Y.POS.DIR.PAIS.ANT,7>="INPUT"
        tmp<Y.POS.ABC.NUM.INT.ANT,7>="INPUT"

    END

    IF Y.BANDERA = 1 THEN
        Y.NUM.ANIOS = ""
    END
    RETURN
END
