using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UTOFrameWork.FrameworkClasses;


    public class CostTypeMapping : Persistent
    {


        public CostTypeMapping()
        {
            tableName = "Paf_Cost_Type_Mapping";
            pkColName = "paf_ctm_code";
            OrderByColumnName = "paf_ctm_code";
            OrderByCondition = "ASC";
        }

        #region ---------------Attributes And Prperties---------------



        private string _PafCostType;
        public string PafCostType
        {
            get { return this._PafCostType; }
            set { this._PafCostType = value; }
        }

        private int _AMSCostTypeCode;
        public int AMSCostTypeCode
        {
            get { return this._AMSCostTypeCode; }
            set { this._AMSCostTypeCode = value; }
        }


        private string _AMSCostTypeName;
        public string AMSCostTypeName
        {
            get { return this._AMSCostTypeName; }
            set { this._AMSCostTypeName = value; }
        }


        private string _IsAnyReference;
        public string IsAnyReference
        {
            get { return this._IsAnyReference; }
            set { this._IsAnyReference = value; }
        }

        private char _IsMapped;
        public char IsMapped
        {
            get { return this._IsMapped; }
            set { this._IsMapped = value; }
        }

        #endregion


        public override DatabaseBroker GetBroker()
        {
            return new CostTypeMappingBroker();
        }

        public override void UnloadObjects()
        {
            throw new NotImplementedException();
        }
    }

