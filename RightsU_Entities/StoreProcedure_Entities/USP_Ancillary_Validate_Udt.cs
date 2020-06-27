using EntityFrameworkExtras.EF6;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    [StoredProcedure("USP_Ancillary_Validate_Udt")]
    public class USP_Ancillary_Validate_Udt
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Ancillary_Title")]
        public List<Deal_Ancillary_Title_UDT> Ancillary_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Ancillary_Platform")]
        public List<Deal_Ancillary_Platform_UDT> Ancillary_Platform { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Ancillary_Platform_Medium")]
        public List<Deal_Ancillary_Platform_Medium_UDT> Ancillary_Platform_Medium { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Ancillary_Type_code")]
        public int Ancillary_Type_code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Acq_Deal_Ancillary_Code")]
        public int Acq_Deal_Ancillary_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Acq_Deal_Code")]
        public int Acq_Deal_Code { get; set; }
        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Catch_Up_From")]
        public string Catch_Up_From { get; set; }

        public int dup_Count { get; set; }        
    }

    [UserDefinedTableType("Ancillary_Title")]
    public class Deal_Ancillary_Title_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Ancillary_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Title_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Episode_From { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> Episode_To { get; set; }
    }

    [UserDefinedTableType("Ancillary_Platform")]
    public class Deal_Ancillary_Platform_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Ancillary_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Ancillary_Platform_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Platform_Code { get; set; }
    }

    [UserDefinedTableType("Ancillary_Platform_Medium")]
    public class Deal_Ancillary_Platform_Medium_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Ancillary_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Ancillary_Platform_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Ancillary_Platform_Medium_Code { get; set; }
    }


}
