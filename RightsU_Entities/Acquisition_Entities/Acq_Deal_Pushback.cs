//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class Acq_Deal_Pushback
    {
        public Acq_Deal_Pushback()
        {
            this.Acq_Deal_Pushback_Dubbing = new HashSet<Acq_Deal_Pushback_Dubbing>();
            this.Acq_Deal_Pushback_Platform = new HashSet<Acq_Deal_Pushback_Platform>();
            this.Acq_Deal_Pushback_Subtitling = new HashSet<Acq_Deal_Pushback_Subtitling>();
            this.Acq_Deal_Pushback_Territory = new HashSet<Acq_Deal_Pushback_Territory>();
            this.Acq_Deal_Pushback_Title = new HashSet<Acq_Deal_Pushback_Title>();

            this.LstDeal_Pushback_UDT = new List<Deal_Rights_UDT>();
            this.LstDeal_Pushback_Title_UDT = new List<Deal_Rights_Title_UDT>();
            this.LstDeal_Pushback_Platform_UDT = new List<Deal_Rights_Platform_UDT>();
            this.LstDeal_Pushback_Territory_UDT = new List<Deal_Rights_Territory_UDT>();
            this.LstDeal_Pushback_Subtitling_UDT = new List<Deal_Rights_Subtitling_UDT>();
            this.LstDeal_Pushback_Dubbing_UDT = new List<Deal_Rights_Dubbing_UDT>();
        }

        public State EntityState { get; set; }
        public int Acq_Deal_Pushback_Code { get; set; }
        public Nullable<int> Acq_Deal_Code { get; set; }
        public string Term { get; set; }
        [Display(Name = "Right_Start_Date")]
        [DataType(DataType.Date), DisplayFormat(DataFormatString = "{0:DD/MM/YYYY}", ApplyFormatInEditMode = true)]
        public Nullable<System.DateTime> Right_Start_Date { get; set; }
        [Display(Name = "Right_End_Date")]
        [DataType(DataType.Date), DisplayFormat(DataFormatString = "{0:DD/MM/YYYY}", ApplyFormatInEditMode = true)]
        public Nullable<System.DateTime> Right_End_Date { get; set; }
        public Nullable<int> Milestone_Type_Code { get; set; }
        public Nullable<int> Milestone_No_Of_Unit { get; set; }
        public Nullable<int> Milestone_Unit_Type { get; set; }
        public string Remarks { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Right_Type { get; set; }
        public string Is_Tentative { get; set; }
        public string Is_Title_Language_Right { get; set; }

        public virtual Acq_Deal Acq_Deal { get; set; }
        public virtual ICollection<Acq_Deal_Pushback_Dubbing> Acq_Deal_Pushback_Dubbing { get; set; }
        public virtual Milestone_Type Milestone_Type { get; set; }
        public virtual ICollection<Acq_Deal_Pushback_Platform> Acq_Deal_Pushback_Platform { get; set; }
        public virtual ICollection<Acq_Deal_Pushback_Subtitling> Acq_Deal_Pushback_Subtitling { get; set; }
        public virtual ICollection<Acq_Deal_Pushback_Territory> Acq_Deal_Pushback_Territory { get; set; }
        public virtual ICollection<Acq_Deal_Pushback_Title> Acq_Deal_Pushback_Title { get; set; }

        public List<Deal_Rights_UDT> LstDeal_Pushback_UDT { get; set; }
        public List<Deal_Rights_Title_UDT> LstDeal_Pushback_Title_UDT { get; set; }
        public List<Deal_Rights_Platform_UDT> LstDeal_Pushback_Platform_UDT { get; set; }
        public List<Deal_Rights_Territory_UDT> LstDeal_Pushback_Territory_UDT { get; set; }
        public List<Deal_Rights_Subtitling_UDT> LstDeal_Pushback_Subtitling_UDT { get; set; }
        public List<Deal_Rights_Dubbing_UDT> LstDeal_Pushback_Dubbing_UDT { get; set; }
        public string str_Right_Start_Date { get; set; }
        public string str_Right_End_Date { get; set; }
        public string Perpetuity_Date { get; set; }
    }
}
