using EntityFrameworkExtras.EF6;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    [StoredProcedure("USP_Validate_Rights_Duplication_UDT")]
    public class USP_Validate_Rights_Duplication_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights")]
        public List<Deal_Rights_UDT> Deal_Rights { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
        public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Platform")]
        public List<Deal_Rights_Platform_UDT> Deal_Rights_Platform { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Territory")]
        public List<Deal_Rights_Territory_UDT> Deal_Rights_Territory { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Subtitling")]
        public List<Deal_Rights_Subtitling_UDT> Deal_Rights_Subtitling { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Dubbing")]
        public List<Deal_Rights_Dubbing_UDT> Deal_Rights_Dubbing { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "CallFrom")]
        public string CallFrom { get; set; }

        public string Platform_Name { get; set; }
        public int Platform_Code { get; set; }
        public string Territory_Name { get; set; }
        public string Country_Name { get; set; }
        public string Territory_Type { get; set; }
        public string Title_Name { get; set; }
        public Nullable<DateTime> Right_Start_Date { get; set; }
        public Nullable<DateTime> Right_End_Date { get; set; }
        public string Right_Type { get; set; }
        public string Is_Sub_License { get; set; }
        public string Subtitling_Language { get; set; }
        public string Dubbing_Language { get; set; }
        public string ErrorMSG { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public string Agreement_No { get; set; }
    }
    [StoredProcedure("USP_Validate_Rev_HB_Duplication_UDT_Acq")]
    public class USP_Validate_Rev_HB_Duplication_UDT_Acq
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights")]
        public List<Deal_Rights_UDT> Deal_Rights { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
        public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Platform")]
        public List<Deal_Rights_Platform_UDT> Deal_Rights_Platform { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Territory")]
        public List<Deal_Rights_Territory_UDT> Deal_Rights_Territory { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Subtitling")]
        public List<Deal_Rights_Subtitling_UDT> Deal_Rights_Subtitling { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Dubbing")]
        public List<Deal_Rights_Dubbing_UDT> Deal_Rights_Dubbing { get; set; }

        //[StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "CallFrom")]
        //public string CallFrom { get; set; }

        public string Platform_Name { get; set; }
        public int Platform_Code { get; set; }
        public string Territory_Name { get; set; }
        public string Country_Name { get; set; }
        public string Territory_Type { get; set; }
        public string Title_Name { get; set; }
        public Nullable<DateTime> Right_Start_Date { get; set; }
        public Nullable<DateTime> Right_End_Date { get; set; }
        public string Right_Type { get; set; }
        public string Is_Sub_License { get; set; }
        public string Subtitling_Language { get; set; }
        public string Dubbing_Language { get; set; }
        public string ErrorMSG { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public string Agreement_No { get; set; }
    }

    [StoredProcedure("USP_Validate_Show_Episode_UDT")]
    public class USP_Validate_Show_Episode_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
        public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

        public string Title_Name { get; set; }
        public int Title_Code { get; set; }
        public string Episode_No { get; set; }
    }

    [StoredProcedure("USP_Get_Data_Restriction_Remark_UDT")]
    public class USP_Get_Data_Restriction_Remark_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights")]
        public List<Deal_Rights_UDT> Deal_Rights { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
        public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Platform")]
        public List<Deal_Rights_Platform_UDT> Deal_Rights_Platform { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Territory")]
        public List<Deal_Rights_Territory_UDT> Deal_Rights_Territory { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Subtitling")]
        public List<Deal_Rights_Subtitling_UDT> Deal_Rights_Subtitling { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Dubbing")]
        public List<Deal_Rights_Dubbing_UDT> Deal_Rights_Dubbing { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Debug")]
        public string Debug { get; set; }

        public string Title_Name { get; set; }
        public string Platform_Name { get; set; }
        public string Country_Name { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public string SubTitle_Lang_Name { get; set; }
        public string Dubb_Lang_Name { get; set; }
        public string Restriction_Remarks { get; set; }
        public string SubLicensing { get; set; }
    }
    [StoredProcedure("USP_CheckHoldbackForSyn_UDT")]
    public class USP_CheckHoldbackForSyn_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights")]
        public List<Deal_Rights_UDT> Deal_Rights { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
        public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Platform")]
        public List<Deal_Rights_Platform_UDT> Deal_Rights_Platform { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Territory")]
        public List<Deal_Rights_Territory_UDT> Deal_Rights_Territory { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Subtitling")]
        public List<Deal_Rights_Subtitling_UDT> Deal_Rights_Subtitling { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Dubbing")]
        public List<Deal_Rights_Dubbing_UDT> Deal_Rights_Dubbing { get; set; }

        public int Acq_Deal_Rights_Code { get; set; }
        public int Platform_Code { get; set; }
        public int Region_Code { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public int Dubbing_Lang_Code { get; set; }
        public int Sub_Lan_Code { get; set; }
        public string Holdback_Type { get; set; }
        public string Holdback_Comment { get; set; }
        public DateTime Holdback_Release_Date { get; set; }
        public int HB_Run_After_Release_No { get; set; }
        public int HB_Run_After_Release_Units { get; set; }
        public int Holdback_On_Platform_Code { get; set; }

    }


    [StoredProcedure("USP_Validate_Platform_Run_UDT")]
    public class USP_Validate_Platform_Run_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
        public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Platform")]
        public List<Deal_Rights_Platform_UDT> Deal_Rights_Platform { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Deal_Rights_Code")]
        public int Deal_Rights_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Deal_Code")]
        public int Deal_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "CallFrom")]
        public string CallFrom { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Debug")]
        public string Debug { get; set; }

        public string Title_Names { get; set; }
    }
    [StoredProcedure("USP_Validate_Title_Talent_UDT")]
    public class USP_Validate_Title_Talent_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Title_Talent_Role")]
        public List<Title_Talent_Role_UDT> Title_Talent_Role { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "CallFrom")]
        public string CallFrom { get; set; }

        public int Talent_Code { get; set; }
        public int Role_Code { get; set; }

    }
    [StoredProcedure("USP_INSERT_SAP_WBS_UDT")]
    public class USP_INSERT_SAP_WBS_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "SAP_WBS_DATA")]
        public List<SAP_WBS_DATA_UDT> SAP_WBS_DATA_UDT { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Upload_File_Data")]
        public List<Upload_File_Data_UDT> Upload_File_Data_UDT { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Is_ERROR")]
        public string Is_ERROR { get; set; }
    }
    //[StoredProcedure("USP_Syn_Acq_Mapping_UDT")]
    //public class USP_Syn_Acq_Mapping_UDT
    //{
    //    [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights")]
    //    public List<Deal_Rights_UDT> Deal_Rights { get; set; }

    //    [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
    //    public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

    //    [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Platform")]
    //    public List<Deal_Rights_Platform_UDT> Deal_Rights_Platform { get; set; }

    //    [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Territory")]
    //    public List<Deal_Rights_Territory_UDT> Deal_Rights_Territory { get; set; }

    //    [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Subtitling")]
    //    public List<Deal_Rights_Subtitling_UDT> Deal_Rights_Subtitling { get; set; }

    //    [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Dubbing")]
    //    public List<Deal_Rights_Dubbing_UDT> Deal_Rights_Dubbing { get; set; }

    //    [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Debug")]
    //    public string Debug { get; set; }

    //    public string Result { get; set; }
    //}
    [StoredProcedure("USP_Acq_Deal_Clone_UDT")]
    public class USP_Acq_Deal_Clone_UDT
    {
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "New_Acq_Deal_Code")]
        public int New_Acq_Deal_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Previous_Acq_Deal_Code")]
        public int Previous_Acq_Deal_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
        public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }
        public string Result { get; set; }
    }

    [StoredProcedure("USP_Syn_Deal_Clone_UDT")]
    public class USP_Syn_Deal_Clone_UDT
    {
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "New_Syn_Deal_Code")]
        public int New_Syn_Deal_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Previous_Syn_Deal_Code")]
        public int Previous_Syn_Deal_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Rights_Title")]
        public List<Deal_Rights_Title_UDT> Deal_Rights_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }
        public string Result { get; set; }
    }

    [UserDefinedTableType("Deal_Rights")]
    public class Deal_Rights_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Rights_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Deal_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string Is_Exclusive { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public string Is_Title_Language_Right { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public string Is_Sub_License { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public Nullable<int> Sub_License_Code { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public string Is_Theatrical_Right { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public string Right_Type { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public string Is_Tentative { get; set; }

        [UserDefinedTableTypeColumn(10)]
        public string Term { get; set; }

        [UserDefinedTableTypeColumn(11)]
        public Nullable<int> Milestone_Type_Code { get; set; }

        [UserDefinedTableTypeColumn(12)]
        public Nullable<int> Milestone_No_Of_Unit { get; set; }

        [UserDefinedTableTypeColumn(13)]
        public Nullable<int> Milestone_Unit_Type { get; set; }

        [UserDefinedTableTypeColumn(14)]
        public string Is_ROFR { get; set; }

        [UserDefinedTableTypeColumn(15)]
        public Nullable<DateTime> ROFR_Date { get; set; }

        [UserDefinedTableTypeColumn(16)]
        public string Restriction_Remarks { get; set; }

        [UserDefinedTableTypeColumn(17)]
        public Nullable<DateTime> Right_Start_Date { get; set; }

        [UserDefinedTableTypeColumn(18)]
        public Nullable<DateTime> Right_End_Date { get; set; }

        [UserDefinedTableTypeColumn(19)]
        public Nullable<int> Title_Code { get; set; }

        [UserDefinedTableTypeColumn(20)]
        public Nullable<int> Platform_Code { get; set; }

        [UserDefinedTableTypeColumn(21)]
        public string Check_For { get; set; }

        [UserDefinedTableTypeColumn(22)]
        public string Buyback_Syn_Rights_Code { get; set; }

        //[UserDefinedTableTypeColumn(22)]
        //public string Original_Right_Type { get; set; }
    }

    [UserDefinedTableType("Deal_Rights_Title")]
    public class Deal_Rights_Title_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Rights_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Title_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Episode_From { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> Episode_To { get; set; }
    }

    [UserDefinedTableType("Deal_Rights_Platform")]
    public class Deal_Rights_Platform_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Rights_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Platform_Code { get; set; }
    }

    [UserDefinedTableType("Deal_Rights_Territory")]
    public class Deal_Rights_Territory_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Rights_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Territory_Type { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Territory_Code { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> Country_Code { get; set; }
    }

    [UserDefinedTableType("Deal_Rights_Dubbing")]
    public class Deal_Rights_Dubbing_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Rights_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Language_Type { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Language_Group_Code { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> Dubbing_Code { get; set; }
    }

    [UserDefinedTableType("Deal_Rights_Subtitling")]
    public class Deal_Rights_Subtitling_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Rights_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Language_Type { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Language_Group_Code { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> Subtitling_Code { get; set; }
    }
    [UserDefinedTableType("Title_Talent_Role")]
    public class Title_Talent_Role_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Title_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public int Talent_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Role_Code { get; set; }
    }
    [StoredProcedure("USP_Validate_Run_UDT")]
    public class USP_Validate_Run_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Run_Title")]
        public List<Deal_Run_Title_UDT> Deal_Run_Title { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Run_Yearwise_Run")]
        public List<Deal_Run_Yearwise_Run_UDT> Deal_Run_Yearwise_Run { get; set; }

        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Deal_Run_Channel")]
        public List<Deal_Run_Channel_UDT> Deal_Run_Channel { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Acq_Deal_Code")]
        public int Acq_Deal_Code { get; set; }
        public string Title_Name { get; set; }
        public int Episode_No { get; set; }
        public string EndDate { get; set; }
        public string StartDate { get; set; }
        public string Channel_Name { get; set; }
        public int No_Of_Schd_Run { get; set; }
        public int No_Of_Runs { get; set; }
    }

    [UserDefinedTableType("Deal_Run_Yearwise_Run")]
    public class Deal_Run_Yearwise_Run_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Run_Yearwise_Run_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Deal_Run_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<DateTime> Start_Date { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<DateTime> End_Date { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public Nullable<int> No_Of_Runs { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public Nullable<int> No_Of_Runs_Sched { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public Nullable<int> No_Of_AsRuns { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public Nullable<int> Inserted_By { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public Nullable<DateTime> Inserted_On { get; set; }

        [UserDefinedTableTypeColumn(10)]
        public Nullable<int> Last_action_By { get; set; }

        [UserDefinedTableTypeColumn(11)]
        public Nullable<DateTime> Last_updated_Time { get; set; }
    }

    [UserDefinedTableType("Deal_Run_Channel")]
    public class Deal_Run_Channel_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Run_Channel_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Deal_Run_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Channel_Code { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> Min_Runs { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public Nullable<int> Max_Runs { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public Nullable<int> No_Of_Runs_Sched { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public Nullable<int> No_Of_AsRuns { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public string Do_Not_Consume_Rights { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public string Is_Primary { get; set; }

        [UserDefinedTableTypeColumn(10)]
        public Nullable<int> Inserted_By { get; set; }

        [UserDefinedTableTypeColumn(11)]
        public Nullable<DateTime> Inserted_On { get; set; }

        [UserDefinedTableTypeColumn(12)]
        public Nullable<int> Last_action_By { get; set; }

        [UserDefinedTableTypeColumn(13)]
        public Nullable<DateTime> Last_updated_Time { get; set; }
    }

    [UserDefinedTableType("Deal_Run_Title")]
    public class Deal_Run_Title_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Run_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Title_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Episode_From { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> Episode_To { get; set; }
    }

    [StoredProcedure("USP_Insert_Title_Import_UDT")]
    public class USP_Insert_Title_Import_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Title_Import")]
        public List<Title_Import_UDT> Title_Import { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }

        public string Title_Name { get; set; }
        public string Title_Type { get; set; }
        public string Title_Language { get; set; }
        public string Year_of_Release { get; set; }
        public string Duration { get; set; }
        public string Director { get; set; }
        public string Key_Star_Cast { get; set; }
        public string Synopsis { get; set; }
        public string Music_Label { get; set; }
        public string Error_Messages { get; set; }
    }
    [StoredProcedure("USP_DM_Title_PI")]
    public class USP_DM_Title_PI
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Title_Import")]
        public List<Title_Import_UDT> Title_Import { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }

        public string Title_Name { get; set; }
        public string Title_Type { get; set; }
        public string Title_Language { get; set; }
        public string Year_of_Release { get; set; }
        public string Duration { get; set; }
        public string Director { get; set; }
        public string Key_Star_Cast { get; set; }
        public string Synopsis { get; set; }
        public string Music_Label { get; set; }
        public string Error_Messages { get; set; }
        public string Original_Title { get; set; }
        public string Original_Language { get; set; }
    }

    [UserDefinedTableType("Title_Import")]
    public class Title_Import_UDT
    {

        [UserDefinedTableTypeColumn(1)]
        public string Title_Name { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Original_Title { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string Title_Type { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public string Title_Language { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public string Original_Language { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public string Year_of_Release { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public string Duration { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public string Key_Star_Cast { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public string Director { get; set; }

        [UserDefinedTableTypeColumn(10)]
        public string Synopsis { get; set; }

        [UserDefinedTableTypeColumn(11)]
        public string Music_Label { get; set; }
        [UserDefinedTableTypeColumn(12)]
        public string DM_Master_Import_Code { get; set; }
        [UserDefinedTableTypeColumn(13)]
        public string Excel_Line_No { get; set; }
        [UserDefinedTableTypeColumn(14)]
        public string Program_Category { get; set; }

    }
    [UserDefinedTableType("Music_Title_Import")]
    public class Music_Title_Import_UDT
    {

        [UserDefinedTableTypeColumn(1)]
        public string Music_Title_Name { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Duration { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string Movie_Album { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public string Singers { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public string Lyricist { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public string Music_Director { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public string Title_Language { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public string Music_Label { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public string Year_of_Release { get; set; }

        [UserDefinedTableTypeColumn(10)]
        public string Title_Type { get; set; }

        [UserDefinedTableTypeColumn(11)]
        public string Genres { get; set; }

        [UserDefinedTableTypeColumn(12)]
        public string Star_Cast { get; set; }

        [UserDefinedTableTypeColumn(13)]
        public string Music_Version { get; set; }

        [UserDefinedTableTypeColumn(14)]
        public string Effective_Start_Date { get; set; }

        [UserDefinedTableTypeColumn(15)]
        public string Theme { get; set; }

        [UserDefinedTableTypeColumn(16)]
        public string Music_Tag { get; set; }
        [UserDefinedTableTypeColumn(17)]
        public string Movie_Star_Cast { get; set; }

        [UserDefinedTableTypeColumn(18)]
        public string Music_Album_Type { get; set; }
        [UserDefinedTableTypeColumn(19)]
        public string DM_Master_Import_Code { get; set; }
        [UserDefinedTableTypeColumn(20)]
        public string Excel_Line_No { get; set; }
        [UserDefinedTableTypeColumn(21)]
        public string Public_Domain { get; set; }
    }
    [UserDefinedTableType("DM_Import_UDT")]
    public class DM_Import_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public string Key { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string value { get; set; }
        [UserDefinedTableTypeColumn(3)]
        public string DM_Master_Type { get; set; }
    }
    [UserDefinedTableType("Rights_Bulk_Update_UDT")]
    public class Rights_Bulk_Update_UDT
    {

        [UserDefinedTableTypeColumn(1)]
        public string Right_Codes { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Change_For { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string Action_For { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<DateTime> Start_Date { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public Nullable<DateTime> End_Date { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public string Term { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public string Milestone_Type_Code { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public string Milestone_No_Of_Unit { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public string Milestone_Unit_Type { get; set; }

        [UserDefinedTableTypeColumn(10)]
        public string Rights_Type { get; set; }

        [UserDefinedTableTypeColumn(11)]
        public string Codes { get; set; }

        [UserDefinedTableTypeColumn(12)]
        public string Is_Exclusive { get; set; }

        [UserDefinedTableTypeColumn(13)]
        public string Is_Title_Language { get; set; }

        [UserDefinedTableTypeColumn(14)]
        public string Is_Tentative { get; set; }
    }

    [UserDefinedTableType("Termination_Deals")]
    public class Termination_Deals_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Deal_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Title_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<int> Termination_Episode_No { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<DateTime> Termination_Date { get; set; }
    }

    [StoredProcedure("USP_Acq_Termination_UDT")]
    public class USP_Acq_Termination_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Termination_Deals")]
        public List<Termination_Deals_UDT> Termination_Deals { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Login_User_Code")]
        public int Login_User_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Syn_Error_Body")]
        public string Syn_Error_Body { get; set; }

        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "Is_Validate_Error")]
        public string Is_Validate_Error { get; set; }

        public int Deal_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Episode_No { get; set; }
        public Nullable<DateTime> Termination_Date { get; set; }
        public string Is_Error { get; set; }
        public string Error_Details { get; set; }
        public string Title_Name { get; set; }
        public string Agreement_No { get; set; }
        public string Vendor_Name { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }
        public Nullable<DateTime> Right_Start_Date { get; set; }
        public Nullable<DateTime> Right_End_Date { get; set; }

    }

    [StoredProcedure("USP_Syn_Termination_UDT")]
    public class USP_Syn_Termination_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Termination_Deals")]
        public List<Termination_Deals_UDT> Termination_Deals { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Login_User_Code")]
        public int Login_User_Code { get; set; }

        public int Deal_Code { get; set; }
        public int Title_Code { get; set; }
        public int Episode_No { get; set; }
        public Nullable<DateTime> Termination_Date { get; set; }
        public string Is_Error { get; set; }
        public string Error_Details { get; set; }
    }

    [StoredProcedure("USP_DM_Music_Title_PI")]
    public class USP_DM_Music_Title_PI
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Music_Title_Import")]
        public List<Music_Title_Import_UDT> Music_Title_Import { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }
        public int Line_Number { get; set; }
        public string Music_Title_Name { get; set; }
        public string Movie_Album { get; set; }
        //public string Title_Type { get; set; }
        public string Title_Language { get; set; }
        public string Year_of_Release { get; set; }
        //public string Duration { get; set; }
        //public string Singers { get; set; }
        //public string Lyricist { get; set; }
        //public string Music_Director { get; set; }
        public string Music_Label { get; set; }
        public string Movie_Star_Cast { get; set; }

        public string Music_Album_Type { get; set; }
        public string Error_Messages { get; set; }
        //public string Genres { get; set; }
        //public string Star_Cast { get; set; }
        //public string Music_Version { get; set; }
    }
    [StoredProcedure("USP_Insert_Music_Title_Import_UDT")]
    public class USP_Insert_Music_Title_Import_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Music_Title_Import")]
        public List<Music_Title_Import_UDT> Music_Title_Import { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }
        public int Line_Number { get; set; }
        public string Music_Title_Name { get; set; }
        public string Movie_Album { get; set; }
        //public string Title_Type { get; set; }
        public string Title_Language { get; set; }
        public string Year_of_Release { get; set; }
        //public string Duration { get; set; }
        //public string Singers { get; set; }
        //public string Lyricist { get; set; }
        //public string Music_Director { get; set; }
        public string Music_Label { get; set; }
        public string Movie_Star_Cast { get; set; }

        public string Music_Album_Type { get; set; }
        public string Error_Messages { get; set; }
        //public string Genres { get; set; }
        //public string Star_Cast { get; set; }
        //public string Music_Version { get; set; }
    }
    [UserDefinedTableType("Title_Content_UDT")]
    public class Title_Content_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Title_Content_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Episode_Title { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public Nullable<decimal> Duration { get; set; }
    }

    [StoredProcedure("USP_Import_Title_Content_UDT")]
    public class USP_Import_Title_Content_UDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Title_Content_UDT")]
        public List<Title_Content_UDT> Title_Content_UDT { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Deal_Code")]
        public int Deal_Code { get; set; }

        public string Err_Message { get; set; }
    }

    [StoredProcedure("USP_Bulk_Update")]
    public class USP_Bulk_Update
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Rights_Bulk_Update")]
        public List<Rights_Bulk_Update_UDT> Rights_Bulk_Update_UDT { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Login_User_Code")]
        public int Login_User_Code { get; set; }

        //public string RightsCodes { get; set; }
        //public string ErrorType { get; set; }
        public int Rights_Code { get; set; }
        public string Title_Name { get; set; }
        public string Platform_Name { get; set; }
        public Nullable<DateTime> Right_Start_Date { get; set; }
        public Nullable<DateTime> Right_End_Date { get; set; }
        public string Right_Type { get; set; }
        public string Is_Sub_License { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public string Country_Name { get; set; }
        public string Subtitling_Language { get; set; }
        public string Dubbing_Language { get; set; }
        public string Agreement_No { get; set; }
        public string ErrorMSG { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }
        public string Is_Updated { get; set; }
    }

    [StoredProcedure("USP_Acq_Bulk_Update")]
    public class USP_Acq_Bulk_Update
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Rights_Bulk_Update")]
        public List<Rights_Bulk_Update_UDT> Rights_Bulk_Update_UDT { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Login_User_Code")]
        public int Login_User_Code { get; set; }

        public int Rights_Code { get; set; }
        public string Title_Name { get; set; }
        public string Platform_Name { get; set; }
        public Nullable<DateTime> Right_Start_Date { get; set; }
        public Nullable<DateTime> Right_End_Date { get; set; }
        public string Right_Type { get; set; }
        public string Is_Sub_License { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public string Country_Name { get; set; }
        public string Subtitling_Language { get; set; }
        public string Dubbing_Language { get; set; }
        public string Agreement_No { get; set; }
        public string ErrorMSG { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }
        public string Is_Updated { get; set; }
    }

    [StoredProcedure("USP_Acq_Bulk_Update_Validation")]
    public class USP_Acq_Bulk_Update_Validation
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Rights_Bulk_Update")]
        public List<Rights_Bulk_Update_UDT> Rights_Bulk_Update_UDT { get; set; }

        public int Rights_Code { get; set; }
        public string Title_Name { get; set; }
        public string Platform_Name { get; set; }
        public Nullable<DateTime> Right_Start_Date { get; set; }
        public Nullable<DateTime> Right_End_Date { get; set; }
        public string Right_Type { get; set; }
        public string Is_Sub_License { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public string Country_Name { get; set; }
        public string Subtitling_Language { get; set; }
        public string Dubbing_Language { get; set; }
        public string Agreement_No { get; set; }
        public string ErrorMSG { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }
        public string Is_Updated { get; set; }
    }

    [UserDefinedTableType("Content_Music_Link_UDT")]
    public class Content_Music_Link_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public string Title_Content_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string From { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string From_Frame { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public string To { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public string To_Frame { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public string Music_Track { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public string Duration { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public string Duration_Frame { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public string Version_Name { get; set; }
        [UserDefinedTableTypeColumn(10)]
        public string DM_Master_Import_Code { get; set; }
        [UserDefinedTableTypeColumn(11)]
        public string Excel_Line_No { get; set; }
    }
    [UserDefinedTableType("Title_Content_Version_UDT")]
    public class Title_Content_Version_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public string Title_Content_Version_Details_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Title_Content_Version_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string House_Id { get; set; }
    }
    [StoredProcedure("USP_Content_Music_Link_Bulk_Insert_UDT")]
    public class USP_Content_Music_Link_Bulk_Insert_UDT
    {
        #region --- Input Parameters ---
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Content_Music_Link_UDT")]
        public List<Content_Music_Link_UDT> Content_Music_Link_UDT { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "UserCode")]
        public int User_Code { get; set; }
        #endregion

        #region --- Output Columns ---
        public int Row_No { get; set; }
        public string Content_Name { get; set; }
        public Nullable<int> Episode_No { get; set; }
        public string Music_Track { get; set; }
        public string TC_IN { get; set; }
        public string TC_OUT { get; set; }
        public string From_Frame { get; set; }
        public string To_Frame { get; set; }
        public string Duration { get; set; }
        public string Duration_Frame { get; set; }
        public string Version_Name { get; set; }
        public string Error_Message { get; set; }
        #endregion
    }

    [StoredProcedure("USP_DM_Music_Title_PII")]
    public class USP_DM_Music_Title_PII
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "DM_Import_UDT")]
        public List<DM_Import_UDT> DM_Import_UDT { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "DM_Master_Import_Code")]
        public Nullable<int> DM_Master_Import_Code { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Users_Code")]
        public Nullable<int> Users_Code { get; set; }
    }
    [StoredProcedure("USP_DM_Music_Title_PIII")]
    public class USP_DM_Music_Title_PIII
    {
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "DM_Master_Import_Code")]
        public Nullable<int> DM_Master_Import_Code { get; set; }
    }

    [StoredProcedure("USP_DM_Title_PII")]
    public class USP_DM_Title_PII
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "DM_Import_UDT")]
        public List<DM_Import_UDT> DM_Import_UDT { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "DM_Master_Import_Code")]
        public Nullable<int> DM_Master_Import_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Users_Code")]
        public Nullable<int> Users_Code { get; set; }
    }

    [StoredProcedure("USP_Title_Import_Utility_PII")]
    public class USP_Title_Import_Utility_PII
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "DM_Import_UDT")]
        public List<DM_Import_UDT> DM_Import_UDT { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "DM_Master_Import_Code")]
        public Nullable<int> DM_Master_Import_Code { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Users_Code")]
        public Nullable<int> Users_Code { get; set; }
    }

    [StoredProcedure("USP_DM_Title_PIII")]
    public class USP_DM_Title_PIII
    {
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "DM_Master_Import_Code")]
        public Nullable<int> DM_Master_Import_Code { get; set; }
    }

    [UserDefinedTableType("Music_Content_Assignment_UDT")]
    public class Music_Content_Assignment_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public Nullable<int> Music_Title_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public Nullable<int> Title_Content_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string From { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public Nullable<int> From_Frame { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public Nullable<int> To_Frame { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public string To { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public string Duration { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public Nullable<int> Duration_Frame { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public Nullable<int> Content_Music_Link_Code { get; set; }
    }
    [UserDefinedTableType("SAP_WBS_DATA")]
    public class SAP_WBS_DATA_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public string WBS_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string WBS_Description { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string Studio_Vendor { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public string Original_Dubbed { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public string Status { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public string Short_ID { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public string Sport_Type { get; set; }

    }
    [UserDefinedTableType("Upload_File_Data")]
    public class Upload_File_Data_UDT
    {

        [UserDefinedTableTypeColumn(1)]
        public int Row_Num { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Row_Delimed { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string Err_Cols { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public string Upload_Type { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public string Upload_Title_Type { get; set; }
    }
    [StoredProcedure("USP_Multi_Music_Schedule_Process")]
    public class USP_Multi_Music_Schedule_Process
    {
        #region --- Input Parameters ---
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Music_Content_Assignment_UDT")]
        public List<Music_Content_Assignment_UDT> Music_Content_Assignment_UDT { get; set; }
        #endregion
        #region --- Output Columns ---

        public string Status { get; set; }

        #endregion
    }
    [StoredProcedure("USP_Content_Music_PI")]
    public class USP_Content_Music_PI
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Content_Music_Link_UDT")]
        public List<Content_Music_Link_UDT> Content_Music_Link_UDT { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "UserCode")]
        public int UserCode { get; set; }
        public int Excel_Line_No { get; set; }
        public string Content_Name { get; set; }
        public int Episode_No { get; set; }
        public string Music_Track { get; set; }
        public string From { get; set; }
        public string To { get; set; }
        public string From_Frame { get; set; }
        public string To_Frame { get; set; }
        public string Duration { get; set; }
        public string Duration_Frame { get; set; }
        public string Version_Name { get; set; }
        public string Error_Message { get; set; }
    }
    [StoredProcedure("USP_Content_Music_PII")]
    public class USP_Content_Music_PII
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "DM_Import_UDT")]
        public List<DM_Import_UDT> DM_Import_UDT { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "DM_Master_Import_Code")]
        public Nullable<int> DM_Master_Import_Code { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "Users_Code")]
        public Nullable<int> Users_Code { get; set; }
    }
    [StoredProcedure("USP_Content_Music_PIII")]
    public class USP_Content_Music_PIII
    {
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "DM_Master_Import_Code")]
        public Nullable<int> DM_Master_Import_Code { get; set; }
    }
    [StoredProcedure("USP_Title_Content_Version_PI")]
    public class USP_Title_Content_Version_PI
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Title_Content_Version_UDT")]
        public List<Title_Content_Version_UDT> Title_Content_Version_UDT { get; set; }
        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "UserCode")]
        public string UserCode { get; set; }
    }
    [UserDefinedTableType("Avail_Report_Schedule_Data")]
    public class Avail_Report_Schedule_UDT
    {

        [UserDefinedTableTypeColumn(1)]
        public string Title_Code { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public string Platform_Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public string Country_Code { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public string Is_Original_Language { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public string Dubbing_Subtitling { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public string Language_Code { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public string Date_Type { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public string StartDate { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public string EndDate { get; set; }
        [UserDefinedTableTypeColumn(10)]
        public int UserCode { get; set; }
        [UserDefinedTableTypeColumn(11)]
        public Nullable<DateTime> Inserted_On { get; set; }
        [UserDefinedTableTypeColumn(12)]
        public string Report_Status { get; set; }
        [UserDefinedTableTypeColumn(13)]
        public string Visibility { get; set; }
        [UserDefinedTableTypeColumn(14)]
        public string ReportName { get; set; }
        [UserDefinedTableTypeColumn(15)]
        public string RestrictionRemark { get; set; }
        [UserDefinedTableTypeColumn(16)]
        public string OtherRemark { get; set; }
        [UserDefinedTableTypeColumn(17)]
        public string Platform_ExactMatch { get; set; }
        [UserDefinedTableTypeColumn(18)]
        public string MustHave_Platform { get; set; }
        [UserDefinedTableTypeColumn(19)]
        public string Exclusivity { get; set; }
        [UserDefinedTableTypeColumn(20)]
        public string SubLicenseCode { get; set; }
        [UserDefinedTableTypeColumn(21)]
        public string Region_ExactMatch { get; set; }
        [UserDefinedTableTypeColumn(22)]
        public string Region_MustHave { get; set; }
        [UserDefinedTableTypeColumn(23)]
        public string Region_Exclusion { get; set; }
        [UserDefinedTableTypeColumn(24)]
        public string Subtit_Language_Code { get; set; }
        [UserDefinedTableTypeColumn(25)]
        public string Dubbing_Language_Code { get; set; }
        [UserDefinedTableTypeColumn(26)]
        public int BU_Code { get; set; }
        [UserDefinedTableTypeColumn(27)]
        public string Report_Type { get; set; }
        [UserDefinedTableTypeColumn(28)]
        public bool Digital { get; set; }
        [UserDefinedTableTypeColumn(28)]
        public string IncludeMetadata { get; set; }
        [UserDefinedTableTypeColumn(29)]
        public string Is_IFTA_Cluster { get; set; }
        [UserDefinedTableTypeColumn(30)]
        public string Platform_Group_Code { get; set; }
        [UserDefinedTableTypeColumn(31)]
        public string Subtitling_Group_Code { get; set; }
        [UserDefinedTableTypeColumn(32)]
        public string Subtitling_ExactMatch { get; set; }
        [UserDefinedTableTypeColumn(33)]
        public string Subtitling_MustHave { get; set; }
        [UserDefinedTableTypeColumn(34)]
        public string Subtitling_Exclusion { get; set; }
        [UserDefinedTableTypeColumn(35)]
        public string Dubbing_Group_Code { get; set; }
        [UserDefinedTableTypeColumn(36)]
        public string Dubbing_ExactMatch { get; set; }
        [UserDefinedTableTypeColumn(37)]
        public string Dubbing_MustHave { get; set; }
        [UserDefinedTableTypeColumn(38)]
        public string Dubbing_Exclusion { get; set; }
        [UserDefinedTableTypeColumn(39)]
        public string Territory_Code { get; set; }
        [UserDefinedTableTypeColumn(40)]
        public string IndiaCast { get; set; }
        [UserDefinedTableTypeColumn(41)]
        public string Region_On { get; set; }
        [UserDefinedTableTypeColumn(42)]
        public string Include_Ancillary { get; set; }
        [UserDefinedTableTypeColumn(43)]
        public string Promoter_Code { get; set; }
        [UserDefinedTableTypeColumn(44)]
        public string MustHave_Promoter { get; set; }
        [UserDefinedTableTypeColumn(45)]
        public string Promoter_ExactMatch { get; set; }
        [UserDefinedTableTypeColumn(46)]
        public int Module_Code { get; set; }

        [UserDefinedTableTypeColumn(47)]
        public int Episode_From { get; set; }
        [UserDefinedTableTypeColumn(48)]
        public int Episode_To { get; set; }

    }
    [StoredProcedure("USP_Get_Title_Avail_Language_Data")]
    public class USP_Get_Title_Avail_Language_Data
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Avail_Report_Schedule_Data")]
        public List<Avail_Report_Schedule_UDT> Avail_Report_Schedule_Data { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "UserCode")]
        public int UserCode { get; set; }
        [StoredProcedureParameter(SqlDbType.Char, ParameterName = "Mode")]
        public string Mode { get; set; }
        [StoredProcedureParameter(SqlDbType.NVarChar, ParameterName = "StrCriteria")]
        public string StrCriteria { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "PageNo")]
        public int PageNo { get; set; }
        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "OrderByCndition")]
        public string OrderByCndition { get; set; }
        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "IsPaging")]
        public string IsPaging { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "PageSize")]
        public int PageSize { get; set; }
        public int RowNum { get; set; }
        public int Avail_Report_Schedule_Code { get; set; }
        public string Title_Code { get; set; }
        public string Platform_Code { get; set; }
        public string Country_Code { get; set; }
        public string Is_Original_Language { get; set; }
        public string Dubbing_Subtitling { get; set; }
        public string GroupBy { get; set; }
        public string Node { get; set; }
        public string Language_Code { get; set; }
        public string Date_Type { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int User_Code { get; set; }
        public DateTime Inserted_On { get; set; }
        public string Report_Status { get; set; }
        public string Report_File_Name { get; set; }
        public string ShowRemark { get; set; }
        public string Title_Names { get; set; }
        public string Platform_Names { get; set; }
        public string Country_Names { get; set; }
        public string Language_Names { get; set; }
        public string Is_Dubbing { get; set; }
        public string Is_Subtitling { get; set; }
        public string Email_Status { get; set; }
        public string Visibility { get; set; }
        public string ReportName { get; set; }
        public string RestrictionRemarks { get; set; }
        public string OthersRemark { get; set; }
        public string Platform_ExactMatch { get; set; }
        public string MustHave_Platform { get; set; }
        public string Exclusivity { get; set; }
        public string SubLicense_Code { get; set; }
        public string Region_ExactMatch { get; set; }
        public string Region_MustHave { get; set; }
        public string Region_Exclusion { get; set; }
        public string Subtit_Language_Code { get; set; }
        public string Dubbing_Language_Code { get; set; }
        public int BU_Code { get; set; }
        public string Report_Type { get; set; }
        public string UserName { get; set; }
        public string Digital { get; set; }
        public string IncludeMetadata { get; set; }
        public string Is_IFTA_Cluster { get; set; }
        public string Subtitling_Group_Code { get; set; }
        public string Platform_Group_Code { get; set; }
        public string Subtitling_ExactMatch { get; set; }
        public string Subtitling_MustHave { get; set; }
        public string Subtitling_Exclusion { get; set; }
        public string Dubbing_Group_Code { get; set; }
        public string Dubbing_ExactMatch { get; set; }
        public string Dubbing_MustHave { get; set; }
        public string Dubbing_Exclusion { get; set; }
        public string Territory_Code { get; set; }
        public string Include_Ancillary { get; set; }
        public string Promoter_Code { get; set; }
        public string Promoter_ExactMatch { get; set; }
        public string MustHave_Promoter { get; set; }
        public string Indiacast { get; set; }
        public string Region_On { get; set; }

        public int Module_Code { get; set; }
        public int Recordcount { get; set; }
    }
    [StoredProcedure("USP_Get_Title_Avail_Language_Data_Show")]
    public class USP_Get_Title_Avail_Language_Data_Show
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Avail_Report_Schedule_Data")]
        public List<Avail_Report_Schedule_UDT> Avail_Report_Schedule_Data { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "UserCode")]
        public int UserCode { get; set; }
        [StoredProcedureParameter(SqlDbType.Char, ParameterName = "Mode")]
        public string Mode { get; set; }
        [StoredProcedureParameter(SqlDbType.NVarChar, ParameterName = "StrCriteria")]
        public string StrCriteria { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "PageNo")]
        public int PageNo { get; set; }
        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "OrderByCndition")]
        public string OrderByCndition { get; set; }
        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "IsPaging")]
        public string IsPaging { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "PageSize")]
        public int PageSize { get; set; }

        public int RowNum { get; set; }
        public int Avail_Report_Schedule_Code { get; set; }
        public string Title_Code { get; set; }
        public string Platform_Code { get; set; }
        public string Country_Code { get; set; }
        public string Is_Original_Language { get; set; }
        public string Dubbing_Subtitling { get; set; }
        public string GroupBy { get; set; }
        public string Node { get; set; }
        public string Language_Code { get; set; }
        public string Date_Type { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int User_Code { get; set; }
        public DateTime Inserted_On { get; set; }
        public string Report_Status { get; set; }
        public string Report_File_Name { get; set; }
        public string ShowRemark { get; set; }
        public string Title_Names { get; set; }
        public string Platform_Names { get; set; }
        public string Country_Names { get; set; }
        public string Language_Names { get; set; }
        public string Is_Dubbing { get; set; }
        public string Is_Subtitling { get; set; }
        public string Email_Status { get; set; }
        public string Visibility { get; set; }
        public string ReportName { get; set; }
        public string RestrictionRemarks { get; set; }
        public string OthersRemark { get; set; }
        public string Platform_ExactMatch { get; set; }
        public string MustHave_Platform { get; set; }
        public string Exclusivity { get; set; }
        public string SubLicense_Code { get; set; }
        public string Region_ExactMatch { get; set; }
        public string Region_MustHave { get; set; }
        public string Region_Exclusion { get; set; }
        public string Subtit_Language_Code { get; set; }
        public string Dubbing_Language_Code { get; set; }
        public string BU_Code { get; set; }
        public string Report_Type { get; set; }
        public string UserName { get; set; }
        public string Digital { get; set; }
        public string IncludeMetadata { get; set; }
        public string Is_IFTA_Cluster { get; set; }
        public string Subtitling_Group_Code { get; set; }
        public string Platform_Group_Code { get; set; }
        public string Subtitling_ExactMatch { get; set; }
        public string Subtitling_MustHave { get; set; }
        public string Subtitling_Exclusion { get; set; }
        public string Dubbing_Group_Code { get; set; }
        public string Dubbing_ExactMatch { get; set; }
        public string Dubbing_MustHave { get; set; }
        public string Dubbing_Exclusion { get; set; }
        public string Territory_Code { get; set; }
        public string Include_Ancillary { get; set; }
        public string Promoter_Code { get; set; }
        public string Promoter_ExactMatch { get; set; }
        public string MustHave_Promoter { get; set; }
        public string Indiacast { get; set; }
        public string Region_On { get; set; }
        public int Module_Code { get; set; }
        public int Recordcount { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }

    }
    [UserDefinedTableType("TATSLAUDT")]
    public class TATSLAUDT
    {
        [UserDefinedTableTypeColumn(1)]
        public int TATSLACode { get; set; }

        [UserDefinedTableTypeColumn(2)]
        public int TATSLAMatrix1Code { get; set; }

        [UserDefinedTableTypeColumn(3)]
        public int TATSLAMatrix2Code { get; set; }

        [UserDefinedTableTypeColumn(4)]
        public int TATSLAMatrix3Code { get; set; }

        [UserDefinedTableTypeColumn(5)]
        public int WorkflowStatus { get; set; }

        [UserDefinedTableTypeColumn(6)]
        public int SLA1FromDays { get; set; }

        [UserDefinedTableTypeColumn(7)]
        public int SLA1ToDays { get; set; }

        [UserDefinedTableTypeColumn(8)]
        public string SLA1Users { get; set; }

        [UserDefinedTableTypeColumn(9)]
        public int SLA2FromDays { get; set; }

        [UserDefinedTableTypeColumn(10)]
        public int SLA2ToDays { get; set; }

        [UserDefinedTableTypeColumn(11)]
        public string SLA2Users { get; set; }

        [UserDefinedTableTypeColumn(12)]
        public int SLA3FromDays { get; set; }

        [UserDefinedTableTypeColumn(13)]
        public int SLA3ToDays { get; set; }

        [UserDefinedTableTypeColumn(14)]
        public string SLA3Users { get; set; }

        [UserDefinedTableTypeColumn(15)]
        public string Action { get; set; }
    }

    [StoredProcedure("USPSaveSLAMatrixUDT")]
    public class USPSaveSLAMatrixUDT
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "TATSLAUDT")]
        public List<TATSLAUDT> TATSLAUDT { get; set; }

        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "UserCode")]
        public int UserCode { get; set; }
    }

    [UserDefinedTableType("Title_Import_Utility")]
    public class Title_Import_Utility_UDT
    {
        [UserDefinedTableTypeColumn(1)] public string Col1 { get; set; }
        [UserDefinedTableTypeColumn(2)] public string Col2 { get; set; }
        [UserDefinedTableTypeColumn(3)] public string Col3 { get; set; }
        [UserDefinedTableTypeColumn(4)] public string Col4 { get; set; }
        [UserDefinedTableTypeColumn(5)] public string Col5 { get; set; }
        [UserDefinedTableTypeColumn(6)] public string Col6 { get; set; }
        [UserDefinedTableTypeColumn(7)] public string Col7 { get; set; }
        [UserDefinedTableTypeColumn(8)] public string Col8 { get; set; }
        [UserDefinedTableTypeColumn(9)] public string Col9 { get; set; }
        [UserDefinedTableTypeColumn(10)] public string Col10 { get; set; }
        [UserDefinedTableTypeColumn(11)] public string Col11 { get; set; }
        [UserDefinedTableTypeColumn(12)] public string Col12 { get; set; }
        [UserDefinedTableTypeColumn(13)] public string Col13 { get; set; }
        [UserDefinedTableTypeColumn(14)] public string Col14 { get; set; }
        [UserDefinedTableTypeColumn(15)] public string Col15 { get; set; }
        [UserDefinedTableTypeColumn(16)] public string Col16 { get; set; }
        [UserDefinedTableTypeColumn(17)] public string Col17 { get; set; }
        [UserDefinedTableTypeColumn(18)] public string Col18 { get; set; }
        [UserDefinedTableTypeColumn(19)] public string Col19 { get; set; }
        [UserDefinedTableTypeColumn(20)] public string Col20 { get; set; }
        [UserDefinedTableTypeColumn(21)] public string Col21 { get; set; }
        [UserDefinedTableTypeColumn(22)] public string Col22 { get; set; }
        [UserDefinedTableTypeColumn(23)] public string Col23 { get; set; }
        [UserDefinedTableTypeColumn(24)] public string Col24 { get; set; }
        [UserDefinedTableTypeColumn(25)] public string Col25 { get; set; }
        [UserDefinedTableTypeColumn(26)] public string Col26 { get; set; }
        [UserDefinedTableTypeColumn(27)] public string Col27 { get; set; }
        [UserDefinedTableTypeColumn(28)] public string Col28 { get; set; }
        [UserDefinedTableTypeColumn(29)] public string Col29 { get; set; }
        [UserDefinedTableTypeColumn(30)] public string Col30 { get; set; }
        [UserDefinedTableTypeColumn(31)] public string Col31 { get; set; }
        [UserDefinedTableTypeColumn(32)] public string Col32 { get; set; }
        [UserDefinedTableTypeColumn(33)] public string Col33 { get; set; }
        [UserDefinedTableTypeColumn(34)] public string Col34 { get; set; }
        [UserDefinedTableTypeColumn(35)] public string Col35 { get; set; }
        [UserDefinedTableTypeColumn(36)] public string Col36 { get; set; }
        [UserDefinedTableTypeColumn(37)] public string Col37 { get; set; }
        [UserDefinedTableTypeColumn(38)] public string Col38 { get; set; }
        [UserDefinedTableTypeColumn(39)] public string Col39 { get; set; }
        [UserDefinedTableTypeColumn(40)] public string Col40 { get; set; }
        [UserDefinedTableTypeColumn(41)] public string Col41 { get; set; }
        [UserDefinedTableTypeColumn(42)] public string Col42 { get; set; }
        [UserDefinedTableTypeColumn(43)] public string Col43 { get; set; }
        [UserDefinedTableTypeColumn(44)] public string Col44 { get; set; }
        [UserDefinedTableTypeColumn(45)] public string Col45 { get; set; }
        [UserDefinedTableTypeColumn(46)] public string Col46 { get; set; }
        [UserDefinedTableTypeColumn(47)] public string Col47 { get; set; }
        [UserDefinedTableTypeColumn(48)] public string Col48 { get; set; }
        [UserDefinedTableTypeColumn(49)] public string Col49 { get; set; }
        [UserDefinedTableTypeColumn(50)] public string Col50 { get; set; }
        [UserDefinedTableTypeColumn(51)] public string Col51 { get; set; }
        [UserDefinedTableTypeColumn(52)] public string Col52 { get; set; }
        [UserDefinedTableTypeColumn(53)] public string Col53 { get; set; }
        [UserDefinedTableTypeColumn(54)] public string Col54 { get; set; }
        [UserDefinedTableTypeColumn(55)] public string Col55 { get; set; }
        [UserDefinedTableTypeColumn(56)] public string Col56 { get; set; }
        [UserDefinedTableTypeColumn(57)] public string Col57 { get; set; }
        [UserDefinedTableTypeColumn(58)] public string Col58 { get; set; }
        [UserDefinedTableTypeColumn(59)] public string Col59 { get; set; }
        [UserDefinedTableTypeColumn(60)] public string Col60 { get; set; }
        [UserDefinedTableTypeColumn(61)] public string Col61 { get; set; }
        [UserDefinedTableTypeColumn(62)] public string Col62 { get; set; }
        [UserDefinedTableTypeColumn(63)] public string Col63 { get; set; }
        [UserDefinedTableTypeColumn(64)] public string Col64 { get; set; }
        [UserDefinedTableTypeColumn(65)] public string Col65 { get; set; }
        [UserDefinedTableTypeColumn(66)] public string Col66 { get; set; }
        [UserDefinedTableTypeColumn(67)] public string Col67 { get; set; }
        [UserDefinedTableTypeColumn(68)] public string Col68 { get; set; }
        [UserDefinedTableTypeColumn(69)] public string Col69 { get; set; }
        [UserDefinedTableTypeColumn(70)] public string Col70 { get; set; }
        [UserDefinedTableTypeColumn(71)] public string Col71 { get; set; }
        [UserDefinedTableTypeColumn(72)] public string Col72 { get; set; }
        [UserDefinedTableTypeColumn(73)] public string Col73 { get; set; }
        [UserDefinedTableTypeColumn(74)] public string Col74 { get; set; }
        [UserDefinedTableTypeColumn(75)] public string Col75 { get; set; }
        [UserDefinedTableTypeColumn(76)] public string Col76 { get; set; }
        [UserDefinedTableTypeColumn(77)] public string Col77 { get; set; }
        [UserDefinedTableTypeColumn(78)] public string Col78 { get; set; }
        [UserDefinedTableTypeColumn(79)] public string Col79 { get; set; }
        [UserDefinedTableTypeColumn(80)] public string Col80 { get; set; }
        [UserDefinedTableTypeColumn(81)] public string Col81 { get; set; }
        [UserDefinedTableTypeColumn(82)] public string Col82 { get; set; }
        [UserDefinedTableTypeColumn(83)] public string Col83 { get; set; }
        [UserDefinedTableTypeColumn(84)] public string Col84 { get; set; }
        [UserDefinedTableTypeColumn(85)] public string Col85 { get; set; }
        [UserDefinedTableTypeColumn(86)] public string Col86 { get; set; }
        [UserDefinedTableTypeColumn(87)] public string Col87 { get; set; }
        [UserDefinedTableTypeColumn(88)] public string Col88 { get; set; }
        [UserDefinedTableTypeColumn(89)] public string Col89 { get; set; }
        [UserDefinedTableTypeColumn(90)] public string Col90 { get; set; }
        [UserDefinedTableTypeColumn(91)] public string Col91 { get; set; }
        [UserDefinedTableTypeColumn(92)] public string Col92 { get; set; }
        [UserDefinedTableTypeColumn(93)] public string Col93 { get; set; }
        [UserDefinedTableTypeColumn(94)] public string Col94 { get; set; }
        [UserDefinedTableTypeColumn(95)] public string Col95 { get; set; }
        [UserDefinedTableTypeColumn(96)] public string Col96 { get; set; }
        [UserDefinedTableTypeColumn(97)] public string Col97 { get; set; }
        [UserDefinedTableTypeColumn(98)] public string Col98 { get; set; }
        [UserDefinedTableTypeColumn(99)] public string Col99 { get; set; }
        [UserDefinedTableTypeColumn(100)] public string Col100 { get; set; }
    }

    [StoredProcedure("USP_Title_Import_Utility_PI")]
    public class USP_Title_Import_Utility_PI
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Title_Import_Utility")]
        public List<Title_Import_Utility_UDT> Title_Import_Utility { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }
        [StoredProcedureParameter(SqlDbType.NVarChar, ParameterName = "CallFor")]
        public string callFor { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "DM_Master_Import_Code")]
        public int DM_Master_Import_Code { get; set; }
        [StoredProcedureParameter(SqlDbType.VarChar, ParameterName = "TitleType")]
        public string TitleType { get; set; }
        public string Result { get; set; }
    }

    [UserDefinedTableType("Title_Objection_UDT")]
    public class Title_Objection_UDT
    {
        [UserDefinedTableTypeColumn(1)]
        public int Title_Objection_Code { get; set; }
        [UserDefinedTableTypeColumn(2)]
        public string PlatformCodes { get; set; }
        [UserDefinedTableTypeColumn(3)]
        public string CTCodes { get; set; }
        [UserDefinedTableTypeColumn(4)]
        public string LPCodes { get; set; }
        [UserDefinedTableTypeColumn(5)]
        public string SD { get; set; }
        [UserDefinedTableTypeColumn(6)]
        public string ED { get; set; }
        [UserDefinedTableTypeColumn(7)]
        public string ObjRemarks { get; set; }
        [UserDefinedTableTypeColumn(8)]
        public string ResRemarks { get; set; }
        [UserDefinedTableTypeColumn(9)]
        public int Objection_Type_Code { get; set; }
        [UserDefinedTableTypeColumn(10)]
        public int Title_Status_Code { get; set; }
        [UserDefinedTableTypeColumn(11)]
        public char CntTerr { get; set; }
        [UserDefinedTableTypeColumn(12)]
        public int TitleCode { get; set; }
        [UserDefinedTableTypeColumn(13)]
        public char RecordType { get; set; }
        [UserDefinedTableTypeColumn(14)]
        public int RecordCode { get; set; }
    }

    [StoredProcedure("USP_Validate_Title_Objection_Dup")]
    public class USP_Validate_Title_Objection_Dup
    {
        [StoredProcedureParameter(SqlDbType.Udt, ParameterName = "Title_Objection_UDT")]
        public List<Title_Objection_UDT> Title_Objection_UDT { get; set; }
        [StoredProcedureParameter(SqlDbType.Int, ParameterName = "User_Code")]
        public int User_Code { get; set; }
        public string Result { get; set; }
    }
}

