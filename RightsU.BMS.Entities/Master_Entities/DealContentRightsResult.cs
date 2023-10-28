using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public partial class DealContentRightsResult
    {
        /// <summary>
        /// This is Deal Content Rights Id ,Example:RUBMSR13
        /// </summary>
        [Required]
        public string DealContentRightsId { get; set; }
        /// <summary>
        /// This is Deal Id ,Example:RUBMSD11
        /// </summary>
        [Required]
        public string DealId { get; set; }
        /// <summary>
        /// This is Deal Content Id ,Example:RUBMSC23
        /// </summary>
        [Required]
        public string DealContentId { get; set; }
        /// <summary>
        /// This is Deal Channel Mapping Id ,Example:RUBMSS16
        /// </summary>
        [Required]
        public string ChannelId { get; set; }
        /// <summary>
        /// This is Right Rule ,Example:1Org6Rep
        /// </summary>
        public string RightRule { get; set; }
        /// <summary>
        /// This is Original Airing Play per day ,Example:2
        /// </summary>
        public Int32 RRPlayPerDay { get; set; }
        /// <summary>
        /// This is Natural Repeat Airing ,Example:6
        /// </summary>
        public Int32 RRNoOfRepeats { get; set; }
        /// <summary>
        /// This is Duration of Day (in Hrs) ,Example:168
        /// </summary>
        public Int32 RRDuration { get; set; }
        /// <summary>
        /// This is Asset Id ,Example:RUBMSA11
        /// </summary>
        [Required]
        public string AssetId { get; set; }
        /// <summary>
        /// This is Total No Of Runs Limited/ Unlimited ,Example:50 / -1
        /// </summary>
        [Required]
        public string DaysAvailable { get; set; }
        /// <summary>
        /// This is License StartDate Format: “YYYY-MM-DD” ,Example:2023-06-23
        /// </summary>
        [Required]
        public string LicenseStartDate { get; set; }
        /// <summary>
        /// This is License EndDate Format: “YYYY-MM-DD” ,Example:2025-06-22
        /// </summary>
        [Required]
        public string LicenseEndDate { get; set; }
        /// <summary>
        /// This is Updated date and time UTC format ,Example:2023-07-16T19:20
        /// </summary>
        [Required]
        public DateTime LastUpdatedOn { get; set; }
        /// <summary>
        /// Status of Assets ,Example:true / false
        /// </summary>
        [Required]
        public string IsActive { get; set; }
    }
}
