* @ValidationCode : MjotMTM3MzYyOTgyNjpDcDEyNTI6MTc1MjcxNTgwMzAyNDpMdWNhc0ZlcnJhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjRfU1AxLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Jul 2025 22:30:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : LucasFerrari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R24_SP1.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2025. All rights reserved.

$PACKAGE AbcTeller

SUBROUTINE ABC.BR2.TELDENOM.TOT.CAMBIO
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates

    $USING TT.Contract
    $USING TT.Stock
    $USING TT.Config
    $USING EB.Display
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO
    
RETURN
*-----------------------------------------------------------------------------
INICIA:
*-----------------------------------------------------------------------------
    Y.MONTO.TXN = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
    Y.MONEDA = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyOne)
    Y.TTID.1 = EB.SystemTables.getRNew(TT.Contract.Teller.TeTellerIdOne)
    Y.CUENTA = Y.MONEDA:'10000':Y.TTID.1
    Y.CR.AMOUNT = 0
    Y.DR.AMOUNT = 0
    
RETURN
*-----------------------------------------------------------------------------
ABRE.ARCHIVOS:
*-----------------------------------------------------------------------------
    APP.NAME<1>     = "TELLER"
    FIELD.NAME<1>   = "GRAN.TOTAL"
    
    FIELD.POS = ""
    EB.Updates.MultiGetLocRef(APP.NAME,FIELD.NAME,FIELD.POS)
    Y.POS.GRAN.TOTAL     = FIELD.POS<1,1>

    FN.TELLER.DENOMINATION = "F.TELLER.DENOMINATION"
    F.TELLER.DENOMINATION = ""
    EB.DataAccess.Opf(FN.TELLER.DENOMINATION, F.TELLER.DENOMINATION)
    
RETURN
*-----------------------------------------------------------------------------
PROCESO:
*-----------------------------------------------------------------------------
    VPM.UNIT.VAL = EB.SystemTables.getComi()
    Y.AV = EB.SystemTables.getAv()
    POSN = Y.AV
    Y.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)
    Y.DENOM = Y.DENOM<1,POSN>
    
    TT.LOCAL.REF = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    
    GOSUB OBTEN.VALOR.DENOM
    
    DENOM.VAL = Y.VALOR

    IF POSN = 1 THEN
        TOTALVAL = VPM.UNIT.VAL * DENOM.VAL
        TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL> = TOTALVAL
        
        IF VPM.UNIT.VAL GT 0 THEN
            Y.CR.AMOUNT = Y.CR.AMOUNT + TOTALVAL
        END ELSE
            Y.DR.AMOUNT = Y.DR.AMOUNT + TOTALVAL
        END
    
        IF TOTALVAL GT Y.MONTO.TXN THEN
            GOSUB CALCULA.CAMBIO
        END
    
    END ELSE
        CURR.VAL = VPM.UNIT.VAL * DENOM.VAL
        
        IF VPM.UNIT.VAL GT 0 THEN
            Y.CR.AMOUNT = Y.CR.AMOUNT + CURR.VAL
        END ELSE
            Y.DR.AMOUNT = Y.DR.AMOUNT + CURR.VAL
        END
    
        POSN = POSN - 1
        SUM.DR = 0
        DENOM.VAL = ''
        VPM.UNIT.VAL = 0
        PREV.VAL = 0

        FOR NO.OF.DENOM = 1 TO POSN
            Y.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)
            Y.DENOM = Y.DENOM<1,NO.OF.DENOM>
            
            GOSUB OBTEN.VALOR.DENOM
            
            DENOM.VAL = Y.VALOR
            VPM.UNIT.VAL = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
            VPM.UNIT.VAL = VPM.UNIT.VAL<1,NO.OF.DENOM>
            
            PREV.VAL = VPM.UNIT.VAL * DENOM.VAL
            SUM.DR = SUM.DR + PREV.VAL
            
            IF VPM.UNIT.VAL GT 0 THEN
                Y.CR.AMOUNT = Y.CR.AMOUNT + PREV.VAL
            END ELSE
                Y.DR.AMOUNT = Y.DR.AMOUNT + PREV.VAL
            END
        
        NEXT NO.OF.DENOM
    
        TOTALVAL = CURR.VAL + SUM.DR
        
        IF TOTALVAL GT Y.MONTO.TXN THEN
            GOSUB CALCULA.CAMBIO
        END
    
        TT.LOCAL.REF<1,Y.POS.GRAN.TOTAL> = TOTALVAL
    END
    
    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef, TT.LOCAL.REF)

    EB.Display.RebuildScreen()
    
RETURN
*-----------------------------------------------------------------------------
CALCULA.CAMBIO:
*-----------------------------------------------------------------------------
    Y.CAMBIO = Y.CR.AMOUNT - Y.MONTO.TXN
    R.TT.STOCK.CONTROL = TT.Stock.StockControl.Read(Y.CUENTA, ERR.PARAM)
    
    IF R.TT.STOCK.CONTROL EQ "" THEN
        ETEXT="EB-CASHLESS.TELLER"
        EB.SystemTables.setEtext(ETEXT)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
    Y.DENOM.EN.CAJA = R.TT.STOCK.CONTROL<TT.Stock.StockControl.ScDenomination>
    Y.CANT.DENOM.EN.CAJA = R.TT.STOCK.CONTROL<TT.Stock.StockControl.ScQuantity>
    Y.TOTAL.CAMBIO = 0
    Y.NO.DENOMINACIONES = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)
    Y.NO.DENOMINACIONES = DCOUNT(Y.NO.DENOMINACIONES,@VM)
    
    FOR Y.AA=1 TO Y.NO.DENOMINACIONES
        Y.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)
        Y.DENOM = Y.DENOM<1,Y.AA>
        FIND Y.DENOM IN Y.DENOM.EN.CAJA SETTING Y.FM.TT.SC, Y.VM.TT.SC THEN
            Y.CANT.DENOM.EN.CAJA =  R.TT.STOCK.CONTROL<TT.Stock.StockControl.ScQuantity,Y.VM.TT.SC>
            
            GOSUB OBTEN.VALOR.DENOM
            
            IF Y.VALOR LE Y.CAMBIO THEN
                Y.UNIT.CMB = INT(Y.CAMBIO / Y.VALOR)
                
                Y.TT.DR.DENOM = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrDenom)
                FIND Y.DENOM IN Y.TT.DR.DENOM SETTING Y.TT.FM, Y.TT.VM THEN
                    IF Y.UNIT.CMB LE Y.CANT.DENOM.EN.CAJA THEN
                        IF Y.AA NE Y.AV THEN
                            TT.TE.DR.UNIT = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
                            TT.TE.DR.UNIT<1,Y.TT.VM> = Y.UNIT.CMB * (-1)
                            EB.SystemTables.setRNew(TT.Contract.Teller.TeDrUnit, TT.TE.DR.UNIT)
                        END
                    END ELSE
                        IF Y.AA NE Y.AV THEN
                            TT.TE.DR.UNIT = EB.SystemTables.getRNew(TT.Contract.Teller.TeDrUnit)
                            TT.TE.DR.UNIT<1,Y.TT.VM> = Y.CANT.DENOM.EN.CAJA * (-1)
                            EB.SystemTables.setRNew(TT.Contract.Teller.TeDrUnit, TT.TE.DR.UNIT)
                            Y.UNIT.CMB = Y.CANT.DENOM.EN.CAJA
                        END
                    END
                    Y.UNIT.X.VALOR = Y.UNIT.CMB * Y.VALOR
                    Y.TOTAL.CAMBIO = Y.TOTAL.CAMBIO + Y.UNIT.X.VALOR
                    Y.CAMBIO = Y.CAMBIO - Y.UNIT.X.VALOR
                    IF Y.CAMBIO = 0 THEN
                        BREAK
                    END
                END
            END
        END
    NEXT Y.AA

RETURN
*-----------------------------------------------------------------------------
OBTEN.VALOR.DENOM:
*-----------------------------------------------------------------------------
    R.TELLER.DENOMINATION=""
    EB.DataAccess.FRead(FN.TELLER.DENOMINATION,Y.DENOM,R.TELLER.DENOMINATION,F.TELLER.DENOMINATION,ERR.TELLER.DENOMINATION)
    
    IF R.TELLER.DENOMINATION THEN
        Y.VALOR = R.TELLER.DENOMINATION<TT.Config.TellerDenomination.DenValue>
    END

RETURN

*-----------------------------------------------------------------------------
END