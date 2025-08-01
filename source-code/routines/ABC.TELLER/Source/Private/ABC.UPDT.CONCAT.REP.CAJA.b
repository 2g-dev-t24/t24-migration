*-----------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------
$PACKAGE AbcTeller
    SUBROUTINE ABC.UPDT.CONCAT.REP.CAJA
* ======================================================================
* Nombre de Programa : ABC.UPDT.CONCAT.REP.CAJA
* Parametros         :
* Objetivo           : Actualiza EB.LOOKUP con los IDs de los FTs ingresados para obtener los reportes de caja
* Requerimiento      : ABCCORE-2561 Reporte del operador de caja de sucursal
* Desarrollador      : CAST - FyG-Solutions
* Compania           : 
* Fecha Creacion     : 
* Modificaciones     :
* ======================================================================
* Modificado por :
* Fecha          :
* Descripcion    :
*
* ======================================================================



    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING EB.Template
    $USING EB.ErrorProcessing
    $USING EB.Updates



    GOSUB INICIA
    GOSUB ABRE.ARCHIVOS
    GOSUB PROCESO

    RETURN

*----------
INICIA:
*----------

    Y.ID.FT = EB.SystemTables.getIdNew()
    Y.TRANSACTION.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
    Y.DEBIT.CURRENCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCurrency)

    RETURN
*----------
*----------
ABRE.ARCHIVOS:
*----------
    FN.EB.LOOKUP = "F.EB.LOOKUP"
    F.EB.LOOKUP = ""
    EB.DataAccess.Opf(FN.EB.LOOKUP, F.EB.LOOKUP)

    RETURN
*----------
*----------
PROCESO:
*----------

    Y.INPUTTER = FIELD(EB.SystemTables.getRNew(FT.Contract.FundsTransfer.Inputter),'_',2)
    Y.ID.EB.LOOKUP = Y.INPUTTER:'*':Y.ID.FT
    R.EB.LOOKUP = ''
    R.EB.LOOKUP<EB.Template.Lookup.LuDescription>   = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TransactionType)
    R.EB.LOOKUP<EB.Template.Lookup.LuOtherInfo>     = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCurrency)
    R.EB.LOOKUP<EB.Template.Lookup.LuCurrNo>        = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CurrNo)
    R.EB.LOOKUP<EB.Template.Lookup.LuInputter>      = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.Inputter)
    R.EB.LOOKUP<EB.Template.Lookup.LuDateTime>      = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DateTime)
    R.EB.LOOKUP<EB.Template.Lookup.LuAuthoriser>    = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.Authoriser)
    R.EB.LOOKUP<EB.Template.Lookup.LuCoCode>        = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CoCode)
    R.EB.LOOKUP<EB.Template.Lookup.LuDeptCode>      = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DeptCode)
    R.EB.LOOKUP<EB.Template.Lookup.LuAuditorCode>   = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.AuditorCode)
    R.EB.LOOKUP<EB.Template.Lookup.LuAuditDateTime> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.AuditDateTime)
    EB.DataAccess.FWrite(FN.EB.LOOKUP, Y.ID.EB.LOOKUP, R.EB.LOOKUP)

    RETURN
*----------

END
