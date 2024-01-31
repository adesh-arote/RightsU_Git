using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Currency_Exchange_Rate")]
    public partial class CurrencyExchangeRate
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "currency_exchange_rate_code")]
        public int ? Currency_Exchange_Rate_Code { get; set; }

        [ForeignKeyReference(typeof(Currency))]
        [JsonProperty(PropertyName = "currency_code")]
        public Nullable<int> Currency_Code { get; set; }

      
        [JsonIgnore]
        public System.DateTime Effective_Start_Date { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "effective_start_date")]
        public string effective_start_date { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> System_End_Date { get; set; }

        [JsonProperty(PropertyName = "exchange_rate")]
        public Nullable<decimal> Exchange_Rate { get; set; }
    }
}
