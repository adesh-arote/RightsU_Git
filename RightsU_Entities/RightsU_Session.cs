using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace RightsU_Entities
{
    public class RightsU_Session {
        public RightsU_Session()
        {
        }
        public const string SESS_KEY = "UTO_SESS";
		public const string SESS_DEAL= "DEAL";
        public const string ACQ_DEAL_SCHEMA = "ACQ_DEAL_SCHEMA";
        public const string Syn_DEAL_SCHEMA = "Syn_DEAL_SCHEMA";
        public const string MUSIC_DEAL_SCHEMA = "MUSIC_DEAL_SCHEMA";
        public const string SESS_MUSIC_DEAL = "SESS_MUSIC_DEAL";
        public const string SESS_SYNDEAL = "SYNDEAL";
		public const string SESS_OLDSYNDEAL = "OLDSYNDEAL";
        public const string SESS_OLDDEAL = "OLDDEAL";
        public const string CurrentLoginEntity = "CURRENT_LOGIN_ENTITY";
        public const string PRO_DEAL_SCHEMA = "PRO_DEAL_SCHEMA";
        //private ArrayList _arrInventory;
        //public ArrayList arrInventory
        //{
        //    get
        //    {
        //        if (_arrInventory == null)
        //            _arrInventory = new ArrayList();
        //        return _arrInventory;

        //    }
        //    set
        //    {
        //        _arrInventory = value;
        //    }
        //}
        //public User 
        public string ChannelName;

        private User _Objuser;
        public User Objuser
        {
            get
            {
                return _Objuser;
            }
            set
            {

                _Objuser = value;
            }
        }
		


        public string Office_Name;
        public string Region_code;
        public string User_Name;

    }
}
