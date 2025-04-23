*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE ABC.BP
    SUBROUTINE ABC.CUS.VALIDA.ORIG.REC(V.ORIGEN.RECURSOS)

    $USING EB.Reports
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Updates
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.Display
    $USING MXBASE.CustomerRegulatory


        IF V.ORIGEN.RECURSOS EQ 'Otro' THEN
           tmp=EB.SystemTables.getT(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.OtherSource)
           tmp<3>=""
           EB.SystemTables.setT(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.OtherSource, tmp)
        END ELSE
          tmp=EB.SystemTables.getT(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.OtherSource)
          tmp<3>="NOINPUT"
          EB.SystemTables.setT(MXBASE.CustomerRegulatory.MXBASEAddCustomerDetails.OtherSource, tmp)
        END

    RETURN
END
