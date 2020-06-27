using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public class Link_Show_Episode_Play
    {
        public Link_Show_Episode_Play()
        {
            this.lstEpisode_Play = new List<Episode_Play>();
        }
        public int Deal_Movie_Code { get; set; }
        public int Music_Code { get; set; }
        public string IsSelected { get; set; }
        public List<Episode_Play> lstEpisode_Play { get; set; }
    }

    public class Episode_Play
    {
        public string Episode_Numbers { get; set; }
        public string Episode_Numbers_Display { get; set; }
        public int No_Of_Play { get; set; }

        private string _Dummy_Guid { get; set; }
        public string Dummy_Guid
        {
            get
            {
                if (string.IsNullOrEmpty(_Dummy_Guid))
                    _Dummy_Guid = GetDummy_Guid();
                return _Dummy_Guid;
            }
        }

        private string GetDummy_Guid()
        {
            return Guid.NewGuid().ToString();
        }
    }
}
