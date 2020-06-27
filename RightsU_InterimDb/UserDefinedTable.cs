using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntityFrameworkExtras.EF6;

namespace UserDefinedSqlParameters
{
    [UserDefinedTableType("Acq_Deal_Code_Rights_Title_UDT")]
    public class UserDefinedTable
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Title_Code { get; set; }
    }
}
