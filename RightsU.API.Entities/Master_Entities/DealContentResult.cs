using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    public partial class DealContentResult
    {
        /// <summary>
        /// This is Deal Content Id ,Example:RUBMSC23
        /// </summary>
        [Required]
        public string DealContentId { get; set; }
        /// <summary>
        /// This is Deal Id ,Example:RUBMSD11
        /// </summary>
        [Required]
        public string DealId { get; set; }
        /// <summary>
        /// This is Asset Id ,Example:RUBMSA11
        /// </summary>
        [Required]
        public string AssetId { get; set; }
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
