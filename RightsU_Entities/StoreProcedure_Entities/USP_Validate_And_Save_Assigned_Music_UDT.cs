using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EntityFrameworkExtras.EF6;

namespace RightsU_Entities
{
    [UserDefinedTableType("Assign_Music")]
    public class Assign_Music_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Movie_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Music_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Episode_No { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> No_Of_Play { get; set; }
    }

    [StoredProcedure("USP_Validate_And_Save_Assigned_Music_UDT")]
    public class USP_Validate_And_Save_Assigned_Music_UDT
    {
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Deal_Type_Code")]
        public int Deal_Type_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Login_User_Code")]
        public int Login_User_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Link_Show")]
        public string Link_Show { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Action")]
        public string Action { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "AssignMusic")]
        public List<Assign_Music_UDT> AssignMusic { get; set; }

        public string Agreement_No { get; set; }
        public string Music_Library { get; set; }
        public string Music_Title { get; set; }
        public string Movie_Album { get; set; }
        public string Title_Name { get; set; }
        public string Deal_Type { get; set; }
        public string Episodes { get; set; }
        public string Is_Warning { get; set; }
        public string Err_Message { get; set; }
    }
}
