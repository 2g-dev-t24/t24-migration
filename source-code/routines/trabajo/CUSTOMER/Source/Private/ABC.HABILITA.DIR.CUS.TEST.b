* @ValidationCode : MjotMTIxNTUwOTY0NjpDcDEyNTI6MTc0MjQ5MjQ3MjM4OTpMdWlzIENhcHJhOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjI0X1NQMS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Mar 2025 14:41:12
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
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
*   Fecha: Mayo 2015
*   Autor: Omar Basabe.
*
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
SUBROUTINE ABC.HABILITA.DIR.CUS.TEST

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

    V.APP      = 'CUSTOMER'
    V.FLD.NAME = 'ABC.DIR.CALLE.A':@VM:'ABC.NUM.EXT.ANT':@VM:'ABC.COD.POS.ANT':@VM:'ABC.COLONIA.ANT':@VM:'ABC.DEL.MUN.ANT':@VM:'ABC.CD.EDO.ANT':@VM:'ABC.PAIS.ANT'
    V.FLD.POS  = ''

    EB.LocalReferences.GetLocRef(V.APP,V.FLD.NAME,V.FLD.POS)

    Y.POS.CALLE.ANT       = V.FLD.POS<1,1>
    Y.POS.DIR.NUM.EXT.ANT = V.FLD.POS<1,2>
    Y.POS.DIR.COD.POS.ANT = V.FLD.POS<1,3>
    Y.POS.DIR.COLONIA.ANT = V.FLD.POS<1,4>
    Y.POS.DIR.DEL.MUN.ANT = V.FLD.POS<1,5>
    Y.POS.DIR.CD.EDO.ANT  = V.FLD.POS<1,6>
    Y.POS.DIR.PAIS.ANT    = V.FLD.POS<1,7>
    

RETURN

*************
PROCESO:
**********************


    
    tmp=EB.SystemTables.getTLocref()
    tmp<Y.POS.CALLE.ANT,7>=''
    tmp<Y.POS.DIR.NUM.EXT.ANT,7>='INPUT'
    tmp<Y.POS.DIR.COD.POS.ANT,7>='INPUT'
    tmp<Y.POS.DIR.COLONIA.ANT,7>='INPUT'
    tmp<Y.POS.DIR.DEL.MUN.ANT,7>='INPUT'
    tmp<Y.POS.DIR.CD.EDO.ANT,7> ='INPUT'
    tmp<Y.POS.DIR.PAIS.ANT,7>   ='INPUT'
    EB.SystemTables.setTLocref(tmp)
        
RETURN
END
