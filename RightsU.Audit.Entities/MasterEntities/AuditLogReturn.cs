﻿using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.Audit.Entities.MasterEntities
{
    public class AuditLogReturn
    {
        public AuditLogReturn()
        {
            paging = new paging();
            auditData = new List<string>();
        }

        /// <summary>
        /// Paging Details
        /// </summary>
        [Required]
        public paging paging { get; set; }
        /// <summary>
        /// Audit Data
        /// </summary>
        public List<string> auditData { get; set; }
    }

    public class AuditLog
    {
        [JsonIgnore]
        public Int32 AuditLogCode { get; set; }
        [JsonIgnore]
        public Int32 ModuleCode { get; set; }
        [JsonIgnore]
        public Int32 IntCode { get; set; }
        public string LogData { get; set; }
        [JsonIgnore]
        public Int32 Version { get; set; }
        [JsonIgnore]
        public string ActionBy { get; set; }
        [JsonIgnore]
        public string ActionOn { get; set; }
        [JsonIgnore]
        public string ActionType { get; set; }
    }

    public class paging
    {
        /// <summary>
        /// The page number
        /// </summary>
        public int page { get; set; }
        /// <summary>
        /// The number of records per page
        /// </summary>
        public int size { get; set; }
        /// <summary>
        /// The overall number of records, only accurate up to 10,000
        /// </summary>
        public Int64 total { get; set; }
    }

}