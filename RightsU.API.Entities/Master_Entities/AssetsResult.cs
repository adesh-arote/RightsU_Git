using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    public class AssetsResult
    {
        /// <summary>
        /// This is Asset Id ,Example:RUBMSA11
        /// </summary>        
        [Required]        
        public string AssetId { get; set; }
        /// <summary>
        /// This is Title ,Example:KBC S12
        /// </summary>        
        [Required]        
        public string Title { get; set; }
        /// <summary>
        /// Title + Episode for Show and for Movie = NULL ,Example:KBC s12 ep12
        /// </summary>        
        [Required]
        public string EpisodeTitle { get; set; }
        /// <summary>
        /// Episode number ,Example:12
        /// </summary>
        [Required]
        public Int32 EpisodeNumber { get; set; }
        /// <summary>
        /// Program Category ,Example:Movie / program
        /// </summary>
        [Required]
        public string Category { get; set; }
        /// <summary>
        /// Language of the Asset ,Example:Hindi
        /// </summary>
        [Required]
        public string Language { get; set; }
        /// <summary>
        /// Duration (min) ,Example:149
        /// </summary>
        [Required]
        public string Duration { get; set; }
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
