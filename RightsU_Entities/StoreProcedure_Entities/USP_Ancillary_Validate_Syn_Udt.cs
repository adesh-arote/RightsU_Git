using EntityFrameworkExtras.EF6;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    [StoredProcedure("USP_Ancillary_Validate_Syn_Udt")]
    public class USP_Ancillary_Validate_Syn_Udt
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Ancillary_Title")]
        public List<Deal_Ancillary_Title_UDT> Ancillary_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Ancillary_Platform")]
        public List<Deal_Ancillary_Platform_UDT> Ancillary_Platform { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Ancillary_Platform_Medium")]
        public List<Deal_Ancillary_Platform_Medium_UDT> Ancillary_Platform_Medium { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Ancillary_Type_code")]
        public int Ancillary_Type_code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Syn_Deal_Ancillary_Code")]
        public int Syn_Deal_Ancillary_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Syn_Deal_Code")]
        public int Syn_Deal_Code { get; set; }
        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Catch_Up_From")]
        public string Catch_Up_From { get; set; }

        public int dup_Count { get; set; }
    }

}
