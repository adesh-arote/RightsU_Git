
//namespace RightsU_Dapper.Entity
//{
//    using Dapper.SimpleSave;
//    using System;
//    using System.Collections.Generic;

//    [Table("Acq_Deal")]
//    public partial class Acq_Deal
//    {
//        public Acq_Deal()
//        {
//            //this.Acq_Deal_Ancillary = new HashSet<Acq_Deal_Ancillary>();
//            //this.Acq_Deal_Attachment = new HashSet<Acq_Deal_Attachment>();
//            //this.Acq_Deal_Licensor = new HashSet<Acq_Deal_Licensor>();
//            //this.Acq_Deal_Movie = new HashSet<Acq_Deal_Movie>();
//            //this.Acq_Deal_Rights = new HashSet<Acq_Deal_Rights>();
//            //this.Acq_Deal_Run = new HashSet<Acq_Deal_Run>();
//            //this.Material_Order_Details = new HashSet<Material_Order_Details>();
//            //this.Acq_Deal_Cost = new HashSet<Acq_Deal_Cost>();
//            //this.Acq_Deal_Payment_Terms = new HashSet<Acq_Deal_Payment_Terms>();
//            //this.Acq_Deal_Pushback = new HashSet<Acq_Deal_Pushback>();
//            //this.Acq_Deal_Material = new HashSet<Acq_Deal_Material>();
//            //this.Acq_Deal_Mass_Territory_Update = new HashSet<Acq_Deal_Mass_Territory_Update>();
//            //this.Acq_Deal_Sport = new HashSet<Acq_Deal_Sport>();
//            //this.Acq_Deal_Sport_Ancillary = new HashSet<Acq_Deal_Sport_Ancillary>();
//            //this.Acq_Deal_Sport_Monetisation_Ancillary = new HashSet<Acq_Deal_Sport_Monetisation_Ancillary>();
//            //this.Acq_Deal_Sport_Sales_Ancillary = new HashSet<Acq_Deal_Sport_Sales_Ancillary>();
//            //this.Acq_Deal_Budget = new HashSet<Acq_Deal_Budget>();
//            //this.Provisional_Deal = new HashSet<Provisional_Deal>();
//        }

//        //public State EntityState { get; set; }
//        [PrimaryKey]
//        public int? Acq_Deal_Code { get; set; }
//        public string Agreement_No { get; set; }
//        public string Version { get; set; }
//        public Nullable<System.DateTime> Agreement_Date { get; set; }
//        public string Deal_Desc { get; set; }
//        public Nullable<int> Deal_Type_Code { get; set; }
//        public string Year_Type { get; set; }
//        public Nullable<int> Entity_Code { get; set; }
//        public Nullable<int> Category_Code { get; set; }
//        public Nullable<int> Vendor_Code { get; set; }
//        public int Vendor_Contacts_Code { get; set; }
//        public Nullable<int> Currency_Code { get; set; }
//        public Nullable<decimal> Exchange_Rate { get; set; }
//        public string Ref_No { get; set; }
//        public string Attach_Workflow { get; set; }
//        public string Remarks { get; set; }
//        public string Deal_Workflow_Status { get; set; }
//        public Nullable<int> Parent_Deal_Code { get; set; }
//        public Nullable<int> Work_Flow_Code { get; set; }
//        public Nullable<System.DateTime> Amendment_Date { get; set; }
//        public string Is_Released { get; set; }
//        public Nullable<System.DateTime> Release_On { get; set; }
//        public Nullable<int> Release_By { get; set; }
//        public string Is_Completed { get; set; }
//        public string Is_Active { get; set; }
//        public string Content_Type { get; set; }
//        public string Payment_Terms_Conditions { get; set; }
//        public string Status { get; set; }
//        public string Is_Auto_Generated { get; set; }
//        public string Is_Migrated { get; set; }
//        public Nullable<int> Cost_Center_Id { get; set; }
//        public Nullable<int> Master_Deal_Movie_Code_ToLink { get; set; }
//        public string BudgetWise_Costing_Applicable { get; set; }
//        public string Validate_CostWith_Budget { get; set; }
//        public Nullable<int> Deal_Tag_Code { get; set; }
//        public Nullable<int> Business_Unit_Code { get; set; }
//        public string Ref_BMS_Code { get; set; }
//        public Nullable<int> Inserted_By { get; set; }
//        public Nullable<System.DateTime> Inserted_On { get; set; }
//        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
//        public Nullable<int> Last_Action_By { get; set; }
//        public Nullable<System.DateTime> Lock_Time { get; set; }
//        public string Is_Master_Deal { get; set; }
//        public string Rights_Remarks { get; set; }
//        public string Payment_Remarks { get; set; }
//        public string Deal_Complete_Flag { get; set; }
//        public string All_Channel { get; set; }
//        public Nullable<int> Role_Code { get; set; }
//        public Nullable<int> Channel_Cluster_Code { get; set; }
//        public string Is_Auto_Push { get; set; }
//        public Nullable<int> Deal_Segment_Code { get; set; }
//        public Nullable<int> Revenue_Vertical_Code { get; set; }
//        private bool _SaveGeneralOnly = true;
//        public bool SaveGeneralOnly
//        {
//            get { return _SaveGeneralOnly; }
//            set { _SaveGeneralOnly = value; }
//        }

//        //public virtual Deal_Tag Deal_Tag { get; set; }
//        //public virtual Deal_Type Deal_Type1 { get; set; }
//        //public virtual ICollection<Acq_Deal_Ancillary> Acq_Deal_Ancillary { get; set; }
//        //public virtual ICollection<Acq_Deal_Attachment> Acq_Deal_Attachment { get; set; }
//        //public virtual Business_Unit Business_Unit { get; set; }
//        //public virtual Category Category { get; set; }
//        //public virtual Cost_Center Cost_Center { get; set; }
//        //public virtual Currency Currency { get; set; }
//        //public virtual Entity Entity { get; set; }
//        //public virtual ICollection<Acq_Deal_Licensor> Acq_Deal_Licensor { get; set; }
//        //public virtual ICollection<Acq_Deal_Movie> Acq_Deal_Movie { get; set; }
//        //public virtual ICollection<Acq_Deal_Rights> Acq_Deal_Rights { get; set; }
//        //public virtual ICollection<Acq_Deal_Run> Acq_Deal_Run { get; set; }
//        //public virtual Vendor Vendor { get; set; }
//        //public virtual Vendor_Contacts Vendor_Contacts { get; set; }
//        //public virtual Workflow Workflow { get; set; }
//        //public virtual ICollection<Material_Order_Details> Material_Order_Details { get; set; }
//        //public virtual ICollection<Acq_Deal_Cost> Acq_Deal_Cost { get; set; }
//        //public virtual ICollection<Acq_Deal_Payment_Terms> Acq_Deal_Payment_Terms { get; set; }
//        //public virtual ICollection<Acq_Deal_Pushback> Acq_Deal_Pushback { get; set; }
//        //public virtual ICollection<Acq_Deal_Material> Acq_Deal_Material { get; set; }
//        //public virtual ICollection<Acq_Deal_Mass_Territory_Update> Acq_Deal_Mass_Territory_Update { get; set; }
//        //public virtual ICollection<Acq_Deal_Sport> Acq_Deal_Sport { get; set; }
//        //public virtual ICollection<Acq_Deal_Sport_Ancillary> Acq_Deal_Sport_Ancillary { get; set; }
//        //public virtual ICollection<Acq_Deal_Sport_Monetisation_Ancillary> Acq_Deal_Sport_Monetisation_Ancillary { get; set; }
//        //public virtual ICollection<Acq_Deal_Sport_Sales_Ancillary> Acq_Deal_Sport_Sales_Ancillary { get; set; }
//        //public virtual Role Role { get; set; }
//        //public virtual ICollection<Acq_Deal_Budget> Acq_Deal_Budget { get; set; }
//        //public virtual Channel_Cluster Channel_Cluster { get; set; }
//        //public virtual ICollection<Provisional_Deal> Provisional_Deal { get; set; }
//        //public virtual Deal_Segment Deal_Segment { get; set; }
//        //public virtual Revenue_Vertical Revenue_Vertical { get; set; }
//    }
//}


