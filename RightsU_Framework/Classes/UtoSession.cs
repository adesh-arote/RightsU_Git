using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Web.SessionState;


namespace UTOFrameWork.FrameworkClasses {
    public class UtoSession {
        public UtoSession()
        {
        }
        public const string SESS_KEY = "UTO_SESS";
		public const string SESS_DEAL= "DEAL";
        public const string ACQ_DEAL_SCHEMA = "ACQ_DEAL_SCHEMA";
        public const string Syn_DEAL_SCHEMA = "Syn_DEAL_SCHEMA";
        public const string SESS_SYNDEAL = "SYNDEAL";
		public const string SESS_OLDSYNDEAL = "OLDSYNDEAL";
        public const string SESS_OLDDEAL = "OLDDEAL";
        private ArrayList _arrInventory;
        public ArrayList arrInventory
        {
            get
            {
                if (_arrInventory == null)
                    _arrInventory = new ArrayList();
                return _arrInventory;

            }
            set
            {
                _arrInventory = value;
            }
        }
        //public User 
        public string ChannelName;

        private Users _Objuser;
        public Users Objuser
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
