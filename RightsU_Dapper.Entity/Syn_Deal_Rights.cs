
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Rights")]
    public partial class Syn_Deal_Rights
    {
        //        public Syn_Deal_Rights()
        //        {
        //            //this.Syn_Deal_Rights_Blackout = new HashSet<Syn_Deal_Rights_Blackout>();
        //            this.Syn_Deal_Rights_Dubbing = new HashSet<Syn_Deal_Rights_Dubbing>();
        //            //this.Syn_Deal_Rights_Holdback = new HashSet<Syn_Deal_Rights_Holdback>();
        //            //this.Syn_Deal_Rights_Platform = new HashSet<Syn_Deal_Rights_Platform>();
        //            this.Syn_Deal_Rights_Subtitling = new HashSet<Syn_Deal_Rights_Subtitling>();
        //            //this.Syn_Deal_Rights_Territory = new HashSet<Syn_Deal_Rights_Territory>();
        //            //this.Syn_Deal_Rights_Title = new HashSet<Syn_Deal_Rights_Title>();
        //            this.Syn_Deal_Rights_Promoter = new HashSet<Syn_Deal_Rights_Promoter>();

        //            //this.LstDeal_Rights_UDT = new List<Deal_Rights_UDT>();
        //            //this.LstDeal_Rights_Title_UDT = new List<Deal_Rights_Title_UDT>();
        //            //this.LstDeal_Rights_Platform_UDT = new List<Deal_Rights_Platform_UDT>();
        //            //this.LstDeal_Rights_Territory_UDT = new List<Deal_Rights_Territory_UDT>();
        //            //this.LstDeal_Rights_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>();
        //            //this.LstDeal_Rights_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>();
        //        }
        //        [PrimaryKey]
        //        public int? Syn_Deal_Rights_Code { get; set; }
        //        public int Syn_Deal_Code { get; set; }
        //        public string Is_Exclusive { get; set; }
        //        public string Is_Title_Language_Right { get; set; }
        //        public string Is_Sub_License { get; set; }
        //        public Nullable<int> Sub_License_Code { get; set; }
        //        public string Is_Theatrical_Right { get; set; }
        //        public string Right_Type { get; set; }
        //        public string Is_Tentative { get; set; }
        //        public string Term { get; set; }
        //        public Nullable<System.DateTime> Right_Start_Date { get; set; }
        //        public Nullable<System.DateTime> Right_End_Date { get; set; }
        //        public Nullable<int> Milestone_Type_Code { get; set; }
        //        public Nullable<int> Milestone_No_Of_Unit { get; set; }
        //        public Nullable<int> Milestone_Unit_Type { get; set; }
        //        public string Is_ROFR { get; set; }
        //        public Nullable<System.DateTime> ROFR_Date { get; set; }
        //        public string Restriction_Remarks { get; set; }
        //        public Nullable<System.DateTime> Effective_Start_Date { get; set; }
        //        public Nullable<System.DateTime> Actual_Right_Start_Date { get; set; }
        //        public Nullable<System.DateTime> Actual_Right_End_Date { get; set; }
        //        public string Is_Pushback { get; set; }
        //        public Nullable<int> Inserted_By { get; set; }
        //        public Nullable<System.DateTime> Inserted_On { get; set; }
        //        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        //        public Nullable<int> Last_Action_By { get; set; }
        //        public string Right_Status { get; set; }
        //        public Nullable<int> ROFR_Code { get; set; }
        //        public string Is_Verified { get; set; }
        //        public string Original_Right_Type { get; set; }
        //        public string Promoter_Flag { get; set; }

        //        //public virtual Milestone_Type Milestone_Type { get; set; }
        //        //public virtual Sub_License Sub_License { get; set; }
        //        //public virtual Syn_Deal Syn_Deal { get; set; }
        //        //public virtual ICollection<Syn_Deal_Rights_Blackout> Syn_Deal_Rights_Blackout { get; set; }
        //        public virtual ICollection<Syn_Deal_Rights_Dubbing> Syn_Deal_Rights_Dubbing { get; set; }
        //        //public virtual ICollection<Syn_Deal_Rights_Holdback> Syn_Deal_Rights_Holdback { get; set; }
        //        //public virtual ICollection<Syn_Deal_Rights_Platform> Syn_Deal_Rights_Platform { get; set; }
        //        public virtual ICollection<Syn_Deal_Rights_Subtitling> Syn_Deal_Rights_Subtitling { get; set; }
        //        //public virtual ICollection<Syn_Deal_Rights_Territory> Syn_Deal_Rights_Territory { get; set; }
        //        //public virtual ICollection<Syn_Deal_Rights_Title> Syn_Deal_Rights_Title { get; set; }

        //        //public List<Deal_Rights_UDT> LstDeal_Rights_UDT { get; set; }
        //        //public List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT { get; set; }
        //        //public List<Deal_Rights_Platform_UDT> LstDeal_Rights_Platform_UDT { get; set; }
        //        //public List<Deal_Rights_Territory_UDT> LstDeal_Rights_Territory_UDT { get; set; }
        //        //public List<Deal_Rights_Subtitling_UDT> LstDeal_Rights_Subtitling_UDT { get; set; }
        //        //public List<Deal_Rights_Dubbing_UDT> LstDeal_Rights_Dubbing_UDT { get; set; }
        //        public virtual ICollection<Syn_Deal_Rights_Promoter> Syn_Deal_Rights_Promoter { get; set; }
        //        //public virtual ROFR ROFR { get; set; }

        //        #region ========== DUMMY PROPERTIES ==========

        //        public string Region_Type { get; set; }
        //        public string Sub_Type { get; set; }
        //        public string Dub_Type { get; set; }

        //        public string Title_Codes { get; set; }
        //        public string Platform_Codes { get; set; }
        //        public string Region_Codes { get; set; }
        //        public string Sub_Codes { get; set; }
        //        public string Dub_Codes { get; set; }

        //        public string Term_YY { get; set; }
        //        public string Term_MM { get; set; }
        //        public string Term_DD { get; set; }
        //        public string Start_Date { get; set; }
        //        public string End_Date { get; set; }
        //        public string Milestone_Start_Date { get; set; }
        //        public string Milestone_End_Date { get; set; }
        //        public string Perpetuity_Date { get; set; }
        //        public string ROFR_DT { get; set; }
        //        public string ROFR_Days { get; set; }

        //        public string Theatrical_Platform_Code { get; set; }

        //        //======== DISABLED PROP

        //        public string Disable_SubLicensing { get; set; }
        //        public string Disable_IsExclusive { get; set; }
        //        public string Disable_TitleRights { get; set; }
        //        public string Disable_Tentative { get; set; }
        //        public string Disable_Thetrical { get; set; }
        //        public string Disable_RightType { get; set; }
        //        public string Existing_RightType { get; set; }

        //        //======== DISABLED END

        //        #endregion

        //        //public void Fill_All_UDT(int Title_Code = 0, int Episode_From = 1, int Episode_To = 1, int Platform_Code = 0)
        //        //{
        //        //    #region --- Clear All UDT Lists ---
        //        //    LstDeal_Rights_UDT.Clear();
        //        //    LstDeal_Rights_Title_UDT.Clear();
        //        //    LstDeal_Rights_Platform_UDT.Clear();
        //        //    LstDeal_Rights_Territory_UDT.Clear();
        //        //    LstDeal_Rights_Subtitling_UDT.Clear();
        //        //    LstDeal_Rights_Dubbing_UDT.Clear();
        //        //    #endregion

        //        //    #region --- Fill LstDeal_Rights_UDT ---
        //        //    Deal_Rights_UDT objDeal_Rights_UDT = new Deal_Rights_UDT();
        //        //    objDeal_Rights_UDT.Check_For = "";
        //        //    objDeal_Rights_UDT.Deal_Code = this.Syn_Deal_Code;
        //        //    objDeal_Rights_UDT.Deal_Rights_Code = this.Syn_Deal_Rights_Code;
        //        //    objDeal_Rights_UDT.Is_Exclusive = this.Is_Exclusive;
        //        //    objDeal_Rights_UDT.Is_ROFR = this.Is_ROFR;
        //        //    objDeal_Rights_UDT.Is_Sub_License = this.Is_Sub_License;
        //        //    objDeal_Rights_UDT.Is_Tentative = this.Is_Tentative;
        //        //    objDeal_Rights_UDT.Is_Theatrical_Right = this.Is_Theatrical_Right;
        //        //    objDeal_Rights_UDT.Is_Title_Language_Right = this.Is_Title_Language_Right;
        //        //    objDeal_Rights_UDT.Milestone_No_Of_Unit = this.Milestone_No_Of_Unit;
        //        //    objDeal_Rights_UDT.Milestone_Type_Code = this.Milestone_Type_Code;
        //        //    objDeal_Rights_UDT.Milestone_Unit_Type = this.Milestone_Unit_Type;
        //        //    objDeal_Rights_UDT.Restriction_Remarks = this.Restriction_Remarks;
        //        //    objDeal_Rights_UDT.Right_End_Date = this.Right_End_Date;
        //        //    objDeal_Rights_UDT.Right_Start_Date = this.Right_Start_Date;
        //        //    objDeal_Rights_UDT.Right_Type = this.Right_Type;
        //        //    objDeal_Rights_UDT.ROFR_Date = this.ROFR_Date;
        //        //    objDeal_Rights_UDT.Sub_License_Code = this.Sub_License_Code;
        //        //    objDeal_Rights_UDT.Term = this.Term;
        //        //    LstDeal_Rights_UDT.Add(objDeal_Rights_UDT);
        //        //    #endregion

        //        //    #region --- Fill LstDeal_Rights_Title_UDT ---
        //        //    if (Title_Code > 0)
        //        //    {
        //        //        Deal_Rights_Title_UDT objDeal_Rights_Title_UDT = new Deal_Rights_Title_UDT();
        //        //        objDeal_Rights_Title_UDT.Title_Code = Title_Code;
        //        //        objDeal_Rights_Title_UDT.Episode_From = Episode_From;
        //        //        objDeal_Rights_Title_UDT.Episode_To = Episode_To;
        //        //        this.LstDeal_Rights_Title_UDT.Add(objDeal_Rights_Title_UDT);
        //        //    }
        //        //    else
        //        //    {
        //        //        foreach (Syn_Deal_Rights_Title obj in this.Syn_Deal_Rights_Title)
        //        //        {
        //        //            Deal_Rights_Title_UDT objDeal_Rights_Title_UDT = new Deal_Rights_Title_UDT();
        //        //            objDeal_Rights_Title_UDT.Title_Code = obj.Title_Code;
        //        //            objDeal_Rights_Title_UDT.Episode_From = obj.Episode_From;
        //        //            objDeal_Rights_Title_UDT.Episode_To = obj.Episode_To;
        //        //            this.LstDeal_Rights_Title_UDT.Add(objDeal_Rights_Title_UDT);
        //        //        }
        //        //    }
        //        //    #endregion

        //        //    #region --- Fill LstDeal_Rights_Platform_UDT ---
        //        //    if (Platform_Code > 0)
        //        //    {
        //        //        Deal_Rights_Platform_UDT objDeal_Rights_Platform_UDT = new Deal_Rights_Platform_UDT();
        //        //        objDeal_Rights_Platform_UDT.Platform_Code = Platform_Code;
        //        //        this.LstDeal_Rights_Platform_UDT.Add(objDeal_Rights_Platform_UDT);
        //        //    }
        //        //    else
        //        //    {
        //        //        foreach (Syn_Deal_Rights_Platform obj in this.Syn_Deal_Rights_Platform)
        //        //        {
        //        //            Deal_Rights_Platform_UDT objDeal_Rights_Platform_UDT = new Deal_Rights_Platform_UDT();
        //        //            objDeal_Rights_Platform_UDT.Platform_Code = obj.Platform_Code;
        //        //            this.LstDeal_Rights_Platform_UDT.Add(objDeal_Rights_Platform_UDT);
        //        //        }
        //        //    }
        //        //    #endregion

        //        //    #region --- Fill LstDeal_Rights_Territory_UDT ---
        //        //    foreach (Syn_Deal_Rights_Territory obj in this.Syn_Deal_Rights_Territory)
        //        //    {
        //        //        Deal_Rights_Territory_UDT objDeal_Rights_Territory_UDT = new Deal_Rights_Territory_UDT();
        //        //        objDeal_Rights_Territory_UDT.Country_Code = obj.Country_Code;
        //        //        objDeal_Rights_Territory_UDT.Deal_Rights_Code = obj.Syn_Deal_Rights_Code;
        //        //        objDeal_Rights_Territory_UDT.Territory_Code = obj.Territory_Code;
        //        //        objDeal_Rights_Territory_UDT.Territory_Type = obj.Territory_Type;
        //        //        this.LstDeal_Rights_Territory_UDT.Add(objDeal_Rights_Territory_UDT);
        //        //    }
        //        //    #endregion

        //        //    #region --- Fill LstDeal_Rights_Subtitling_UDT ---
        //        //    //foreach (Syn_Deal_Rights_Subtitling obj in this.Syn_Deal_Rights_Subtitling)
        //        //    //{
        //        //    //    Deal_Rights_Subtitling_UDT objDeal_Rights_Subtitling_UDT = new Deal_Rights_Subtitling_UDT();
        //        //    //    objDeal_Rights_Subtitling_UDT.Subtitling_Code = obj.Language_Code;
        //        //    //    objDeal_Rights_Subtitling_UDT.Deal_Rights_Code = obj.Syn_Deal_Rights_Code;
        //        //    //    objDeal_Rights_Subtitling_UDT.Language_Type = obj.Language_Type;
        //        //    //    objDeal_Rights_Subtitling_UDT.Language_Group_Code = obj.Language_Group_Code;
        //        //    //    this.LstDeal_Rights_Subtitling_UDT.Add(objDeal_Rights_Subtitling_UDT);
        //        //    //}
        //        //    #endregion

        //        //    #region --- Fill LstDeal_Rights_Dubbing_UDT ---
        //        //    //foreach (Syn_Deal_Rights_Dubbing obj in this.Syn_Deal_Rights_Dubbing)
        //        //    //{
        //        //    //    Deal_Rights_Dubbing_UDT objDeal_Rights_Dubbing_UDT = new Deal_Rights_Dubbing_UDT();
        //        //    //    objDeal_Rights_Dubbing_UDT.Dubbing_Code = obj.Language_Code;
        //        //    //    objDeal_Rights_Dubbing_UDT.Deal_Rights_Code = obj.Syn_Deal_Rights_Code;
        //        //    //    objDeal_Rights_Dubbing_UDT.Language_Type = obj.Language_Type;
        //        //    //    objDeal_Rights_Dubbing_UDT.Language_Group_Code = obj.Language_Group_Code;
        //        //    //    this.LstDeal_Rights_Dubbing_UDT.Add(objDeal_Rights_Dubbing_UDT);
        //        //    //}
        //        //    #endregion

        //        //}
        //    }
    }
}

