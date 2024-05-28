using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace RightsUMusic.Entity
{
    [Table("MHCueSheet")]
    public partial class MHCueSheet
    {
        public MHCueSheet()
        {
            this.MHCueSheetSong = new HashSet<MHCueSheetSong>();

        }
        [PrimaryKey]
        public int? MHCueSheetCode                                 { get; set; }
        public string RequestID                                    { get; set; }
        public string FileName                                     { get; set; }
        public string UploadStatus                                 { get; set; }
        public int VendorCode                                      { get; set; }
        public int TotalRecords                                    { get; set; }
        public int ErrorRecords                                    { get; set; }
        public int CreatedBy                                       { get; set; }
        public Nullable<System.DateTime> CreatedOn                 { get; set; }
        public int ApprovedBy                                      { get; set; }
        public Nullable<System.DateTime> ApprovedOn                { get; set; }
        public string SpecialInstruction                           { get; set; }
        public int SubmitBy                                        { get; set; }
        public Nullable<System.DateTime> SubmitOn                  { get; set; }
        //[ForeignKeyReference(typeof(MHRequest))]
        //public long? MHRequestCode                                 { get; set; }
        [OneToMany]
        public virtual ICollection<MHCueSheetSong> MHCueSheetSong  { get; set; }
    }
}
