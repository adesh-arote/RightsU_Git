using EntityFrameworkExtras.EF6;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_InterimDb
{
    [StoredProcedure("USP_Ancillary_Validate_Udt")]
    public class USP_Ancillary_Validate_Udt
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Ancillary_TPPM")]
        public List<Acq_Ancillary_Validate_Udt> Acq_Deal_Code_Rights_Title_UDT { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Ancillary_Type_code")]
        public int Ancillary_Type_code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Acq_Deal_Ancillary_Code")]
        public int Acq_Deal_Ancillary_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Catch_Up_From")]
        public int Catch_Up_From { get; set; }

        public int dup_Count { get; set; }        
    }

    [UserDefinedTableType("Acq_Ancillary_Validate_Udt")]
    public class Acq_Ancillary_Validate_Udt
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Acq_Deal_Ancillary_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Title_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Ancillary_Platform_Code { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> Ancillary_Platform_Medium_Code { get; set; }
    }
}
