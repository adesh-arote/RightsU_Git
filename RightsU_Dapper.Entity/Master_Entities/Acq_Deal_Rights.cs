namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Acq_Deal_Rights")]
    public partial class Acq_Deal_Rights
    {
        public Acq_Deal_Rights()
        {
            //this.Acq_Deal_Rights_Blackout = new HashSet<Acq_Deal_Rights_Blackout>();
            this.Acq_Deal_Rights_Dubbing = new HashSet<Acq_Deal_Rights_Dubbing>();
            //this.Acq_Deal_Rights_Holdback = new HashSet<Acq_Deal_Rights_Holdback>();
            //this.Acq_Deal_Rights_Platform = new HashSet<Acq_Deal_Rights_Platform>();
            this.Acq_Deal_Rights_Subtitling = new HashSet<Acq_Deal_Rights_Subtitling>();
            //this.Acq_Deal_Rights_Territory = new HashSet<Acq_Deal_Rights_Territory>();
            //this.Acq_Deal_Rights_Title = new HashSet<Acq_Deal_Rights_Title>();
            //this.Acq_Deal_Rights_Promoter = new HashSet<Acq_Deal_Rights_Promoter>();

            //this.LstDeal_Rights_UDT = new List<Deal_Rights_UDT>();
            //this.LstDeal_Rights_Title_UDT = new List<Deal_Rights_Title_UDT>();
            //this.LstDeal_Rights_Platform_UDT = new List<Deal_Rights_Platform_UDT>();
            //this.LstDeal_Rights_Territory_UDT = new List<Deal_Rights_Territory_UDT>();
            //this.LstDeal_Rights_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>();
            //this.LstDeal_Rights_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>();

        }
        [PrimaryKey]
        public int? Acq_Deal_Rights_Code { get; set; }
        [ForeignKeyReference(typeof(Acq_Deal))]
        public int Acq_Deal_Code { get; set; }
        public string Is_Exclusive { get; set; }
        public string Is_Title_Language_Right { get; set; }
        public string Is_Sub_License { get; set; }
        public Nullable<int> Sub_License_Code { get; set; }
        public string Is_Theatrical_Right { get; set; }
        public string Right_Type { get; set; }
        public string Is_Tentative { get; set; }
        public string Term { get; set; }
        public Nullable<System.DateTime> Right_Start_Date { get; set; }
        public Nullable<System.DateTime> Right_End_Date { get; set; }
        public Nullable<int> Milestone_Type_Code { get; set; }
        public Nullable<int> Milestone_No_Of_Unit { get; set; }
        public Nullable<int> Milestone_Unit_Type { get; set; }
        public string Is_ROFR { get; set; }
        public Nullable<System.DateTime> ROFR_Date { get; set; }
        public string Restriction_Remarks { get; set; }
        public Nullable<System.DateTime> Effective_Start_Date { get; set; }
        public Nullable<System.DateTime> Actual_Right_Start_Date { get; set; }
        public Nullable<System.DateTime> Actual_Right_End_Date { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Right_Status { get; set; }
        public string Is_Verified { get; set; }
        public Nullable<int> ROFR_Code { get; set; }
        public string Original_Right_Type { get; set; }
        public string Promoter_Flag { get; set; }

        public virtual Acq_Deal Acq_Deal { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Blackout> Acq_Deal_Rights_Blackout { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Dubbing> Acq_Deal_Rights_Dubbing { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Holdback> Acq_Deal_Rights_Holdback { get; set; }
        //public virtual Milestone_Type Milestone_Type { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Platform> Acq_Deal_Rights_Platform { get; set; }
        //public virtual Sub_License Sub_License { get; set; }
        public virtual ICollection<Acq_Deal_Rights_Subtitling> Acq_Deal_Rights_Subtitling { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Territory> Acq_Deal_Rights_Territory { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Title> Acq_Deal_Rights_Title { get; set; }
        //public virtual ICollection<Acq_Deal_Rights_Promoter> Acq_Deal_Rights_Promoter { get; set; }

        //public List<Deal_Rights_UDT> LstDeal_Rights_UDT { get; set; }
        //public List<Deal_Rights_Title_UDT> LstDeal_Rights_Title_UDT { get; set; }
        //public List<Deal_Rights_Platform_UDT> LstDeal_Rights_Platform_UDT { get; set; }
        //public List<Deal_Rights_Territory_UDT> LstDeal_Rights_Territory_UDT { get; set; }
        //public List<Deal_Rights_Subtitling_UDT> LstDeal_Rights_Subtitling_UDT { get; set; }
        //public List<Deal_Rights_Dubbing_UDT> LstDeal_Rights_Dubbing_UDT { get; set; }
        //public virtual ROFR ROFR { get; set; }

        #region ========== DUMMY PROPERTIES ==========

        public string Region_Type { get; set; }
        public string Sub_Type { get; set; }
        public string Dub_Type { get; set; }

        public string Title_Codes { get; set; }
        public string Platform_Codes { get; set; }
        public string Region_Codes { get; set; }
        public string Sub_Codes { get; set; }
        public string Dub_Codes { get; set; }

        public string Term_YY { get; set; }
        public string Term_MM { get; set; }
        public string Term_DD { get; set; }
        public string Start_Date { get; set; }
        public string End_Date { get; set; }
        public string Milestone_Start_Date { get; set; }
        public string Milestone_End_Date { get; set; }
        public string Perpetuity_Date { get; set; }
        public string ROFR_DT { get; set; }
        public string ROFR_Days { get; set; }

        public string Theatrical_Platform_Code { get; set; }

        //======== DISABLED PROP

        public string Disable_SubLicensing { get; set; }
        public string Disable_IsExclusive { get; set; }
        public string Disable_TitleRights { get; set; }
        public string Disable_Tentative { get; set; }
        public string Disable_Thetrical { get; set; }
        public string Disable_RightType { get; set; }
        public string Existing_RightType { get; set; }

        //======== DISABLED END

        #endregion

    }
}
