using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.Audit.Entities.InputEntities
{
    public class MasterAuditLogInput
    {
        /// <summary>
        /// System Module code of a master
        /// </summary>
        public int moduleCode { get; set; }
        /// <summary>
        /// Primary Key of a respective master record
        /// </summary>
        public int intCode { get; set; }
        /// <summary>
        /// JSON object of a respective master record
        /// </summary>
        public string logData { get; set; }
        /// <summary>
        /// Login User Id of the user
        /// </summary>
        public string actionBy { get; set; }
        /// <summary>
        /// Linux Date & Time format
        /// </summary>
        public int actionOn { get; set; }
        /// <summary>
        /// Only below keywards are allowed , "C" - for new instance of a record,"X" - for Delete,"U" - for Update,"A" - for Active,"D" - for De-Active
        /// </summary>
        public string actionType { get; set; }
        [JsonIgnore]
        public string requestId { get; set; }


        //[JsonIgnore]
        public bool isExternal { get; set; }
    }
}
