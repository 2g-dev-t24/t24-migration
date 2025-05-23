$PACKAGE AbcTable
SUBROUTINE BA.EMPLEADOS.NOMINA.FIELDS
*-----------------------------------------------------------------------------
    $USING EB.Template
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    EB.Template.TableDefineid("@ID", EB.Template.T24String)
    EB.SystemTables.setIdF('@ID')
    EB.SystemTables.setIdN('6.6')
    EB.SystemTables.setIdT('A')
*-----------------------------------------------------------------------------

    EB.Template.TableAddfielddefinition('PRI.NOMBRE' ,'20', 'A', '')
    EB.Template.TableAddfielddefinition('SPEI.MONTO.MAX' ,'20', 'A', '')
    EB.Template.TableAddfielddefinition('TXN.TIPO.ENV' ,'4', 'A', '')
    EB.Template.TableAddfielddefinition('TXN.TIPO.MEN' ,'4', 'A', '')
    EB.Template.TableAddfielddefinition('TXN.TIPO.REC' ,'4', 'A', '')
    EB.Template.TableAddfielddefinition('TXN.TIPO.DEV' ,'4', 'A', '')
    EB.Template.TableAddfielddefinition('SPEI.DEVOL.REC' ,'60', 'A', '')
    EB.Template.TableAddfielddefinition('SPEI.ORD.REC' ,'60', 'A', '')
    EB.Template.TableAddfielddefinition('SPEI.ORD.REC.DEVOL' ,'60', 'A', '')
    EB.Template.TableAddfielddefinition('SPEI.CTA.MENORES' ,'11', 'A', '')
    EB.Template.TableAddfielddefinition('SPEI.CTA.BANXICO' ,'11', 'A', '')
    EB.Template.TableAddfielddefinition('OFS.SOURCE' ,'20', 'A', '')
    EB.Template.FieldSetcheckfile("OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:"A.")
    EB.Template.TableAddfielddefinition('OFS.FX.VERSION' ,'39', 'A', '')
    EB.Template.FieldSetcheckfile("VERSION":FM:EB.VER.DESCRIPTION:FM:"A.")
    EB.Template.TableAddfielddefinition('DISP.PATH' ,'60', 'A', '')
    EB.Template.TableAddfielddefinition('DISP.ERR.PATH' ,'60', 'A', '')
    EB.Template.TableAddfielddefinition('DISP.AMT' ,'20', 'AMT', '')
    EB.Template.TableAddfielddefinition('NUM.DIAS.DISP' ,'2', 'AMT', '')
    EB.Template.TableAddfielddefinition('OFS.SOURCE.DISP' ,'20', 'A', '')
    EB.Template.FieldSetcheckfile("OFS.SOURCE":FM:OFS.SRC.DESCRIPTION:FM:"A.")
    EB.Template.TableAddfielddefinition('OFS.DISP.VERSION' ,'39', 'A', '')
    EB.Template.FieldSetcheckfile("VERSION":FM:EB.VER.DESCRIPTION:FM:"A.")
    EB.Template.TableAddfielddefinition('OFS.DISP.INT.VER' ,'39', 'A', '')
    EB.Template.FieldSetcheckfile("VERSION":FM:EB.VER.DESCRIPTION:FM:"A.")
    EB.Template.TableAddfielddefinition('DISP.INT.TXN' ,'4', 'A', '')
    EB.Template.FieldSetcheckfile("FT.TXN.TYPE.CONDITION":FM:FT6.SHORT.DESCR:FM:"A.")
    EB.Template.TableAddfielddefinition('TIPO.TERC.TERC' ,'1', 'A', '')
    EB.Template.TableAddfielddefinition('TIPO.BCO.TERCERO' ,'1', 'A', '')
    EB.Template.TableAddfielddefinition('COMM.FT.MASIV' ,'11', 'A', '')
    EB.Template.FieldSetcheckfile("FT.COMMISSION.TYPE":FM:FT4.DESCRIPTION:FM:'A.')
    EB.Template.TableAddfielddefinition('DAYS.TO.HIS' ,'3', 'A', '')
    EB.Template.TableAddfielddefinition('DAYS.TO.DEL' ,'3', 'A', '')
    EB.Template.TableAddreservedfield("RESERVED.3")
    EB.Template.TableAddreservedfield("RESERVED.2")
    EB.Template.TableAddreservedfield("RESERVED.1")



    EB.Template.TableAddlocalreferencefield('')
    EB.Template.TableAddoverridefield()
    EB.Template.TableSetauditposition()
*-----------------------------------------------------------------------------

END
