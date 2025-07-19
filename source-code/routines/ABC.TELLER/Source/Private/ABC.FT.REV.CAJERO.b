*-----------------------------------------------------------------------------
* <Rating>199</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.FT.REV.CAJERO

*===============================================================================
* Rutina:    ABC.FT.REV.CAJERO
* Desarrollador:        
* Compania:             ABC Capital
* Fecha:                
* Descripci�n:          ID.ROUTINE que valida que la persona que quiere reversar
*                       un traspaso entre cuentas pertenece a la misma caja
*                       que el usuario que dio de alta la operaci�n.
*===============================================================================
    $USING EB.SystemTables
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.Security
    $USING FT.Contract
    $USING EB.Security

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER$NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER$NAU = ''
    EB.DataAccess.Opf(FN.FUNDS.TRANSFER$NAU, F.FUNDS.TRANSFER$NAU)

    FN.USER = 'F.USER'
    F.USER = ''
    EB.DataAccess.Opf(FN.USER,F.USER)


    ID.TRANSACCION = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.FUNDS.TRANSFER,ID.TRANSACCION,REC.FT,F.FUNDS.TRANSFER,ERR.FUNDS.TRANSFER)
    FT.ESTATUS = REC.FT<FT.RECORD.STATUS>

    EB.DataAccess.FRead(FN.FUNDS.TRANSFER$NAU,ID.TRANSACCION,REC.FTH,F.FUNDS.TRANSFER$NAU,ERR.FUNDS.TRANSFER$NAU)
    FT.ESTATUSH = REC.FTH<FT.RECORD.STATUS>

*... unicamente podra reversar sus movimientos usuarios de la misma caja

    Y.OPERADOR = EB.SystemTables.getRUser()  
    EB.DataAccess.FRead(FN.USER, Y.OPERADOR, R.USER, F.USER, ERR.USER)
    Y.USER.CAJERO = R.USER<EB.Security.User.UseDepartmentCode>
    IF REC.FT NE '' THEN
        Y.TRANS.CAJERO = REC.FT<FT.DEPT.CODE>[1,5]

        IF NOT(Y.USER.CAJERO EQ Y.TRANS.CAJERO) THEN
            ETEXT = "TRANSACCION NO CORRESPONDE A CAJERO/SUCURSAL"
            EB.SystemTables.setEtext(ETEXT)
            B.ErrorProcessing.StoreEndError()
            RETURN
        END
    END

END
