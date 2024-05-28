using EntityFrameworkExtras.EF6;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UserDefinedSqlParameters;

namespace RightsU_InterimDb
{
    [StoredProcedure("USP_SaveAcqDeal")]
    public class USP_SaveAcqDeal
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "ds_Acq_Deal")]
        public List<UserDefinedTable> Acq_Deal_Code_Rights_Title_UDT { get; set; }

        public int Title_Code { get; set; }
        public string Title_Name { get; set; }
    }
}
