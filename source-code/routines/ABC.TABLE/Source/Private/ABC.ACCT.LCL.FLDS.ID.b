* @ValidationCode : MjotMjE4ODg1NTg6Q3AxMjUyOjE3NTQ1ODc3MDY1MTc6bWF1cmljaW8ubG9wZXo6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Aug 2025 14:28:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : mauricio.lopez
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.
$PACKAGE AbcTable


SUBROUTINE ABC.ACCT.LCL.FLDS.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.ErrorProcessing
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AbcTable
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING EB.TransactionControl
*-----------------------------------------------------------------------------

    GOSUB INITIALIZE
    GOSUB PROCESS

 
   
RETURN
*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------
    
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
    
    Y.ERR.ACCOUNT = ''

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
    Y.ID = EB.SystemTables.getComi()
*Si envia el numero de cuenta se busca el id de AA.
    
    IF (Y.ID NE '') THEN
        
        EB.DataAccess.FRead(FN.ACCOUNT, Y.ID, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
        
        IF NOT(Y.ERR.ACCOUNT) THEN
            
            Y.ID.AA = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
            
            EB.DataAccess.FRead(FN.AA.ARRANGEMENT, Y.ID.AA, R.AA.ARRANGEMENT,F.AA.ARRANGEMENT, Y.ERR.AA.ARRANGEMENT)
            
            IF (R.AA.ARRANGEMENT) THEN   
                EB.SystemTables.setIdNew(Y.ID.AA)               
            END ELSE
                ETEXT = 'Numero de cuenta o Arrangement id no existe'
                EB.SystemTables.setE(ETEXT)
            END
        END ELSE
            ETEXT = 'Numero de cuenta o Arrangement id no existe'
            EB.SystemTables.setE(ETEXT)
        END
    END ELSE
        GOSUB OBTENER.ID.AA
    END

RETURN


*-----------------------------------------------------------------------------
OBTENER.ID.AA:
*** <desc>Genera un nuevo id de AA.ARRANGEMENT para poder  guardarlo en la tabla como resultado </desc>
*-----------------------------------------------------------------------------


    Y.FULL.NAME     = EB.SystemTables.getFullFname()
    Y.V.FUNCTION    = EB.SystemTables.getVFunction()
    Y.PGM           = EB.SystemTables.getPgmType()
    Y.ID.CONCATFILE = EB.SystemTables.getIdConcatfile()
    Y.SAVE.COMI     = EB.SystemTables.getComi()
    Y.APPLICATION   = EB.SystemTables.getApplication()
    
    EB.SystemTables.setFullFname('FBNK.AA.ARRANGEMENT')
    EB.SystemTables.setVFunction('I')
    EB.SystemTables.setPgmType('.IDA')
    EB.SystemTables.setIdConcatfile('')
    EB.SystemTables.setComi('')
    EB.SystemTables.setApplication('AA.ARRANGEMENT')
    
    EB.TransactionControl.GetNextId('','F')

    Y.ID.AA        = EB.SystemTables.getComi()
    EB.SystemTables.setFullFname(Y.FULL.NAME)
    EB.SystemTables.setVFunction(Y.V.FUNCTION)
    EB.SystemTables.setPgmType(Y.PGM)
    EB.SystemTables.setIdConcatfile(Y.ID.CONCATFILE)
    EB.SystemTables.setComi(Y.SAVE.COMI)
    EB.SystemTables.setApplication(Y.APPLICATION)

RETURN

END
