﻿using Newtonsoft.Json;
using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class TitleReturn : ListReturn
    {
        public TitleReturn()
        {
            assets = new List<title>();
            paging = new paging();
        }

        /// <summary>
        /// Title Details
        /// </summary>
        public override object assets { get; set; }
    }

    public class title_List
    {
        public title_List()
        {
            //StarCast = new List<string>();
        }
        /// <summary>
        /// This is Title Code ,Example:RUBMSA11
        /// </summary>
        public int id { get; set; }
        public string Name { get; set; }
        public string Language { get; set; }
        public string OriginalName { get; set; }
        public string OriginalLanguage { get; set; }
        public string ProductionYear { get; set; }
        public decimal DurationInMin { get; set; }
        public string Program { get; set; }
        [JsonIgnore]
        public string Country1 { get; set; }
        public List<string> Country
        {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(Country1))
                {
                    foreach (var item in Country1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
        [JsonIgnore]
        public string StarCast1 { get; set; }
        public List<string> StarCast {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(StarCast1))
                {
                    foreach (var item in StarCast1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
        [JsonIgnore]
        public string Producer1 { get; set; }
        public List<string> Producer
        {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(Producer1))
                {
                    foreach (var item in Producer1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
        [JsonIgnore]
        public string Director1 { get; set; }
        public List<string> Director
        {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(Director1))
                {
                    foreach (var item in Director1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
        [JsonIgnore]
        public Int32 Deal_Type_Code { get; set; }
        public string AssetType { get; set; }
        public string Synopsis { get; set; }
        [JsonIgnore]
        public string Genre1 { get; set; }
        public List<string> Genre
        {
            get
            {
                List<string> lst = new List<string>();
                if (!string.IsNullOrEmpty(Genre1))
                {
                    foreach (var item in Genre1.Split(','))
                    {
                        lst.Add(item.Trim());
                    }
                }
                return lst;
            }
        }
    }

    public class title
    {
        public title()
        {
            MetaData = new Dictionary<string, Dictionary<string, string>>();
        }
        /// <summary>
        /// This is Title Code ,Example:RUBMSA11
        /// </summary>
        public int id { get; set; }
        public string Name { get; set; }
        public string Language { get; set; }
        public string OriginalName { get; set; }
        public string OriginalLanguage { get; set; }
        public string ProductionYear { get; set; }
        public decimal DurationInMin { get; set; }
        public string Program { get; set; }
        public string Country { get; set; }
        public string StarCast { get; set; }
        public string Producer { get; set; }
        public string Director { get; set; }
        [JsonIgnore]
        public Int32 Deal_Type_Code { get; set; }
        public string AssetType { get; set; }
        public string Synopsis { get; set; }
        public string Genre { get; set; }

        public Dictionary<string, Dictionary<string, string>> MetaData { get; set; }
    }
}
