using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using EntityFrameworkExtras.EF6;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections;
using RightsU_InterimDb;
using RightsU_InterimDb.Models;
using System.Data.Entity;

namespace UserDefinedSqlParameters
{
    [TestClass]
    public class DataTests
    {
        private string _conn = ConfigurationManager.ConnectionStrings["Ado"].ConnectionString;
        private string _efConn = ConfigurationManager.ConnectionStrings["RightsU_NeoEntities"].ConnectionString;
        

        //[TestMethod]
        //public void TestEfUdt()
        //{
        //    var db = new Entities(_efConn);
        //    var sproc = new MyUdtSproc();
        //    sproc.UserDefined = new List<UserDefinedTable>()
        //                        {
        //                            new UserDefinedTable(){Guid = Guid.NewGuid()},
        //                            new UserDefinedTable(){Guid = Guid.NewGuid()},
        //                            new UserDefinedTable(){Guid = Guid.NewGuid()},
        //                            new UserDefinedTable(){Guid = Guid.NewGuid()}
        //                        };

        //    var result = db.Database.ExecuteStoredProcedure<Guid>(sproc);
        //}

        public SqlParameter SqlParameter(string ParameterName, object Value, SqlDbType sqlDbType)
        {
            SqlParameter objSqlParameter = new SqlParameter();
            objSqlParameter.ParameterName = ParameterName;
            objSqlParameter.Value = Value;
            objSqlParameter.SqlDbType = sqlDbType;
            return objSqlParameter;
        }
         private void AttachParameters(SqlCommand command, SqlParameter[] commandParameters)
        {
            command.Parameters.Clear();

            if (command == null) throw new ArgumentNullException("command");
            if (commandParameters != null)
            {
                for (int i = 0; i < commandParameters.Length; i++)
                {


                    SqlParameter sp = new SqlParameter();
                    sp = (SqlParameter)commandParameters.GetValue(i);
                    //SqlParameter Obj = new SqlParameter(sp.ParameterName, sp.Value);
                    SqlParameter Obj = new SqlParameter(sp.ParameterName, sp.Value);
                    Obj.Direction = sp.Direction;

                    if (Obj != null)
                    {
                        //Check for derived output value with no value assigned
                        if ((Obj.Direction == ParameterDirection.InputOutput ||
                            Obj.Direction == ParameterDirection.Input) &&
                            (Obj.Value == null || Obj.Value.ToString() == ""))
                        {
                            Obj.Value = DBNull.Value;
                        }
                        command.Parameters.Add(Obj);
                    }
                }
            }
        }

 //        public static DataTable CopyToDataTable<T>(
 //    this IEnumerable<T> source
 //)
 //where T : DataRow { }
        //[TestMethod]
        //public void TestAdo()
        //{
        //    var proc = new USP_SaveAcqDeal();
        //    DataTable dt = new DataTable();
        //    dt.Columns.Add("Title_Code");
        //    List<UserDefinedTable> lstobj = new List<UserDefinedTable>();
        //    for (int i = 0; i < 4; i++)
        //    {
        //        var row = dt.NewRow();
        //        row["Title_Code"] = i;
        //        dt.Rows.Add(row);
        //        lstobj.Add(new UserDefinedTable{Title_Code=i });
        //    }

        //    proc.Acq_Deal_Code_Rights_Title_UDT = lstobj;
        //    var context = new DbContext(_conn);
        //    IEnumerable<USP_SaveAcqDeal> obj = context.Database.ExecuteStoredProcedure<USP_SaveAcqDeal>(proc);
        //    #region deadcode
        //    //
        //    //dt.co
        //    //var result = ExecuteStoredProcedureSingle<USP_SaveAcqDeal>(proc);

        //    //Assert.AreEqual("England", result.);

        //    //using (var conn = new SqlConnection(_conn))
        //    //{
        //    //    using (var sproc = new SqlCommand("[dbo].[USP_SaveAcqDeal]", conn))
        //    //    {
        //    //        //var param = new SqlParameter("@ds_Acq_Deal", SqlDbType.Structured);
        //    //        //param.TypeName = "[dbo].[Acq_Deal_Code_Rights_Title_UDT]";
        //    //        //param.SqlValue = dt;
        //    //        //sproc.Parameters.Add(param);
        //    //        SqlParameter[] sqlParam = new SqlParameter[1];
        //    //        sqlParam[0] = SqlParameter("@ds_Acq_Deal", dt, SqlDbType.Structured);
        //    //        //sproc.Parameters.att(sqlParam);
        //    //        AttachParameters(sproc, sqlParam);

        //    //        SqlDataAdapter sda = new SqlDataAdapter(sproc);
        //    //        DataSet ds = new DataSet();
        //    //        sda.Fill(ds);

        //    //        //if (conn.State != ConnectionState.Open) conn.Open();
        //    //        //var reader = sproc.ExecuteReader();

        //    //        //int numOfFlds = reader.VisibleFieldCount;

        //    //        //ArrayList arrTbl = new ArrayList();
        //    //        //ArrayList arrRow = null;
        //    //        //while (reader.Read())
        //    //        //{
        //    //        //    arrRow = new ArrayList();
        //    //        //    for (int i = 0; i < numOfFlds; i++)
        //    //        //    {
        //    //        //        arrRow.Add(reader.GetValue(i));
        //    //        //    }
        //    //        //    arrTbl.Add(arrRow);
        //    //        //}
        //    //        //reader.Close();

        //    //        //SqlDataAdapter sda = new SqlDataAdapter(query, con);
        //    //        //count = sda.Fill(ds);

        //    //    }
        //    //}
        //    #endregion
        //}

        //[TestMethod]
        //public void TestAncillaryValidation() 
        //{
        //    var proc = new USP_Ancillary_Validate_Udt();

            
        //    List<Acq_Ancillary_Validate_Udt> lstobj = new List<Acq_Ancillary_Validate_Udt>();

        //    lstobj.Add(
        //        new Acq_Ancillary_Validate_Udt 
        //    { Acq_Deal_Ancillary_Code = 157,Title_Code=906,Ancillary_Platform_Code=28,Ancillary_Platform_Medium_Code=17 });

        //    lstobj.Add(
        //        new Acq_Ancillary_Validate_Udt 
        //    { Acq_Deal_Ancillary_Code = 157, Title_Code = 906, Ancillary_Platform_Code = 28, Ancillary_Platform_Medium_Code = 16 });

        //    proc.Acq_Deal_Code_Rights_Title_UDT = lstobj;
        //    proc.Ancillary_Type_code = 3;
        //    proc.Acq_Deal_Ancillary_Code = 157;
        //    using (var context = new DbContext(_conn))
        //    {
        //        IEnumerable<USP_Ancillary_Validate_Udt> obj = context.Database.ExecuteStoredProcedure<USP_Ancillary_Validate_Udt>(proc);
        //    }
        //}

        [TestMethod]
        public void TestACQTErr() {

            //var proc = new USP_Select_Acq_Deal_Rights_Territory();

            //proc.

            using (RightsU_NeoEntities context = new RightsU_NeoEntities())
            { 
                //context.us
                //context.USP_Select_Acq_Deal_Rights_Territory(
                var rightsTerr = context.Acq_Deal_Rights.Find(1132);
                //DbSet<Acq_Deal_Rights_Territory> objDb = context.Set<Acq_Deal_Rights_Territory>();
                //objDb.where
                //context.USP_Select_Acq_Deal_Rights_Territory(1132, System.Data.Entity.Core.Objects.MergeOption.NoTracking);
                        
            }
        }
    }
}
