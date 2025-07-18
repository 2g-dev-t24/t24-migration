$PACKAGE ABC.BP
SUBROUTINE ABC.NOFILE.ACT.CUS.AUTH.PF(R.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.Security
    $USING EB.Reports
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Template
    $USING ST.Customer
	$USING ST.Config
    
    GOSUB INICIALIZA
    GOSUB PROCESA
    GOSUB FINAL
    
RETURN

*---------------------------------------------------------------
INICIALIZA:
*---------------------------------------------------------------

   FN.CUSTOMER = "F.CUSTOMER"
   F.CUSTOMER = ""
   EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
   

   F.CUST$NAU  = ""
   FN.CUST$NAU = "F.CUSTOMER$NAU"
   EB.DataAccess.Opf(FN.CUST$NAU,F.CUST$NAU)
   
    FN.CUSTOMER.HIS         = 'F.CUSTOMER$HIS'
    F.CUSTOMER.HIS          = ''
    
    EB.DataAccess.Opf(FN.CUSTOMER.HIS, F.CUSTOMER.HIS)

   FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER"
   F.DEPT.ACCT.OFFICER = ""
   EB.DataAccess.Opf(FN.DEPT.ACCT.OFFICER, F.DEPT.ACCT.OFFICER)

*    ID.IUB.CUS = '' ; IUB.POS = ''
*    LOCATE "IUB" IN SEL.FIELDS SETTING IUB.POS THEN
*        ID.IUB.CUS = SEL.VALUES<IUB.POS>
*    END

    R.DATA = ''
    Y.SEP = '|'


RETURN

*---------------------------------------------------------------
PROCESA:
*---------------------------------------------------------------

    Y.SEL.CMD = "SELECT " : FN.CUSTOMER : " WITH SECTOR EQ 1001 AND CUSTOMER.TYPE EQ PROSPECT"
    Y.REG.LIST = '' ; Y.NO.REG = ''
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
    GOSUB IMPRIME.TODO
    Y.SEL.CMD = "SELECT " : FN.CUST$NAU : " WITH SECTOR EQ 1001 AND CUSTOMER.TYPE EQ PROSPECT"
    Y.REG.LIST = '' ; Y.NO.REG = ''
    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
    GOSUB IMPRIME.TODO
*    Y.SEL.CMD = "SELECT " : FN.CUSTOMER.HIS : " WITH SECTOR EQ 1001 AND CUSTOMER.TYPE EQ PROSPECT"
*    Y.REG.LIST = '' ; Y.NO.REG = ''
*    EB.DataAccess.Readlist(Y.SEL.CMD, Y.REG.LIST, '', Y.NO.REG, Y.ERROR)
*    GOSUB IMPRIME.TODO

RETURN
*---------------------------------------------------------------
IMPRIME.TODO:
*---------------------------------------------------------------
*    Y.NO.REG = Y.NO.REG1:@FM:Y.NO.REG2:@FM:Y.NO.REG3
*    Y.REG.LIST= Y.REG.LIST1:@FM:Y.REG.LIST2:@FM:Y.REG.LIST3
    Y.I = 1
    LOOP
    WHILE Y.I LE Y.NO.REG
        Y.REG.ACT = Y.REG.LIST<Y.I>
        EB.DataAccess.FRead(FN.CUSTOMER, Y.REG.ACT, R.CUSTOMER, F.CUSTOMER, CUST.ERR)
        IF NOT(R.CUSTOMER) THEN
           EB.DataAccess.FRead(FN.CUST$NAU, Y.REG.ACT, R.CUSTOMER, F.CUST$NAU, CUST.ERR)
        END
        IF NOT(R.CUSTOMER) THEN
           EB.DataAccess.FRead(FN.CUSTOMER.HIS, Y.REG.ACT, R.CUSTOMER, F.CUSTOMER.HIS, CUST.ERR)
        END
        
        IF NOT(R.CUSTOMER) THEN
           RETURN
        END
        Y.ID.OFFICER = R.CUSTOMER<ST.Customer.Customer.EbCusAccountOfficer>

        EB.DataAccess.FRead(FN.DEPT.ACCT.OFFICER, Y.ID.OFFICER, R.DAO, F.DEPT.ACCT.OFFICER, Y.ERR.DAO)


        Y.SHORT.NAME = R.CUSTOMER<ST.Customer.Customer.EbCusShortName>
        Y.NAME.ONE = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
        Y.NAME.TWO = R.CUSTOMER<ST.Customer.Customer.EbCusNameTwo>
        Y.SECTOR = R.CUSTOMER<ST.Customer.Customer.EbCusSector>
        Y.DAO.NAME = R.DAO<ST.Config.DeptAcctOfficer.EbDaoName>
        Y.INPUTTER = R.CUSTOMER<ST.Customer.Customer.EbCusInputter>
        Y.COMPANY = R.CUSTOMER<ST.Customer.Customer.EbCusCompanyBook>
        R.DATA<-1> = Y.REG.ACT:Y.SEP:Y.SHORT.NAME:Y.SEP:Y.NAME.ONE:Y.SEP:Y.NAME.TWO:Y.SEP:Y.SECTOR:Y.SEP:'1001':Y.SEP:Y.ID.OFFICER:Y.SEP:Y.DAO.NAME:Y.SEP:'Por Activar':Y.SEP:Y.INPUTTER:Y.SEP:Y.COMPANY

*        R.DATA<-1> = 1:Y.SEP:2:Y.SEP:3:Y.SEP:4:Y.SEP:5:Y.SEP:6:Y.SEP:7:Y.SEP:8:Y.SEP:9:Y.SEP:10:Y.SEP:11:Y.SEP:12:Y.SEP:13
        Y.I++
    REPEAT

RETURN

*---------------------------------------------------------------
FINAL:
*---------------------------------------------------------------

END



