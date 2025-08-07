* @ValidationCode : MjotMjA2OTIwNzg2OkNwMTI1MjoxNzU0NTM0OTc3NjI0Okx1aXMgQ2FwcmE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Aug 2025 23:49:37
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

RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
    Y.ID = EB.SystemTables.getIdNew()
*Si envia el numero de cuenta se busca el id de AA.
    
    IF (Y.ID NE '') THEN
        
        EB.DataAccess.FRead(FN.ACCOUNT, Y.ID, R.ACCOUNT, F.ACCOUNT, Y.ERR.ACCOUNT)
        
        IF (R.ACCOUNT EQ '') THEN
            
            Y.ID.AA = R.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
            
            EB.DataAccess.FRead(FN.AA.ARRANGEMENT, Y.ID.AA, R.AA.ARRANGEMENT,F.AA.ARRANGEMENT, Y.ERR.AA.ARRANGEMENT)
            
            IF (R.AA.ARRANGEMENT) THEN
                
                EB.SystemTables.setComi(Y.ID.AA)
                
            END ELSE
            
                ETEXT = 'Numero de cuenta o Arrangement id no existe'
                EB.SystemTables.setE(ETEXT)
                RETURN
                
            END
        END
        
    END ELSE
    
        GOSUB OBTENER.ID.AA
   
    END

RETURN


*-----------------------------------------------------------------------------
OBTENER.ID.AA:
*** <desc>Genera un nuevo id de customer para poder  guardarlo en la tabla como resultado </desc>
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
