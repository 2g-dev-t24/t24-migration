*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AbcSpei
    SUBROUTINE ABC.OBTEN.GRUPO
*===============================================================================
* Desarrollador: 
* Compania:  ABC Capital
* Fecha:   
* Descripción:  Rutina que obtiene el grupo de la tabla ACCT.GEN.CONDITION
*Parámetros:  Entrada:
*                      O.DATA - Contiene el id de ACCT.GEN.CONDITION
*
*                       Salida:
*                       O.DATA - Contiene el valor de grupo
*===============================================================================

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING EB.Updates
    $USING EB.Display
    $USING EB.Reports
    $USING AC.Config

    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO

    RETURN

***********
INICIA:
***********

    Y.ACCT.GEN.CONDITION.ID = EB.Reports.getOData()

    EB.Reports.setOData("")

    Y.GRUPO.ESTANDAR = "4"
    Y.GRUPO.PLUS = "8"
    RETURN


***********
ABRE.ARCHIVOS:
***********

    FN.ACCT.GEN.CONDITION  = 'FBNK.ACCT.GEN.CONDITION'
    F.ACCT.GEN.CONDITION   = ''
    EB.DataAccess.Opf(FN.ACCT.GEN.CONDITION,F.ACCT.GEN.CONDITION)



    RETURN

*****************
PROCESO:
*****************

    Y.SEL.CMD = 'SELECT ':FN.ACCT.GEN.CONDITION:' WITH @ID EQ ':Y.ACCT.GEN.CONDITION.ID:' BY-DSND @ID'

    Y.LIST=''
    Y.NO.REG=''
    Y.SEL.ERR=''
    EB.DataAccess.Readlist(Y.SEL.CMD,Y.LIST,'',Y.NO.REG,Y.SEL.ERR)
    Y.ID.ACCT.GEN.CONDITION = Y.LIST<1>

    EB.DataAccess.FRead(FN.ACCT.GEN.CONDITION,Y.ID.ACCT.GEN.CONDITION,R.ACCT.GEN.CONDITION,F.ACCT.GEN.CONDITION,Y.ACCT.ERR)
    IF R.ACCT.GEN.CONDITION THEN

        Y.DESCRIPTION=R.ACCT.GEN.CONDITION<AC.Config.AcctGenCondition.EbAgcDescription>
        CHANGE '|' TO @FM IN Y.DESCRIPTION
        Y.GRUPO = Y.DESCRIPTION<2>
        IF Y.GRUPO EQ Y.GRUPO.PLUS THEN
            EB.Reports.setOData(Y.GRUPO.PLUS)

        END ELSE
            EB.Reports.setOData(Y.GRUPO.ESTANDAR)
        END
    END ELSE
        EB.Reports.setEnqError("Sin grupo")
    END


    RETURN


END
