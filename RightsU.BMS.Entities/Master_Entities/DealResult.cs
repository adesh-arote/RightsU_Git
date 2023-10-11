using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public partial class DealResult
    {
        /// <summary>
        /// This is Deal Id ,Example:RUBMSD11
        /// </summary>
        [Required]
        public string DealId { get; set; }
        /// <summary>
        /// This is Deal AgreementNo ,Example:A-2022-00023
        /// </summary>
        [Required]
        public string AgreementNo { get; set; }
        /// <summary>
        /// This is Acquisition Date ,Example:01-Jun-2022
        /// </summary>
        [Required]
        public string AcquisitionDate { get; set; }
        /// <summary>
        /// This is Deal Description ,Example:Own/ Home Production
        /// </summary>
        [Required]
        public string Description { get; set; }
        /// <summary>
        /// This is Vendor Name ,Example:Manoranjan Electronics
        /// </summary>
        [Required]
        public string Licensor { get; set; }
        /// <summary>
        /// This is Currency Short Code ,Example:INR
        /// </summary>
        [Required]
        public string Currency { get; set; }
        /// <summary>
        /// This is Licensee Name ,Example:ABC Entertainment Limited
        /// </summary>
        [Required]
        public string Licensee { get; set; }
        /// <summary>
        /// This is Deal Category Name ,Example:Fixed Fee
        /// </summary>
        [Required]
        public string DealCategory { get; set; }
        /// <summary>
        /// This is Updated date and time UTC format ,Example:2023-07-16T19:20
        /// </summary>
        [Required]
        public DateTime LastUpdatedOn { get; set; }
        /// <summary>
        /// Status of Deal ,Example:true / false
        /// </summary>
        [Required]
        public string IsActive { get; set; }
    }
}
