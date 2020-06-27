﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Plus.MSM_SAP_WS {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="urn:sap-com:document:sap:soap:functions:mc-style", ConfigurationName="MSM_SAP_WS.ZPS_WEB_SERV_WBS_DATES")]
    public interface ZPS_WEB_SERV_WBS_DATES {
        
        [System.ServiceModel.OperationContractAttribute(Action="urn:sap-com:document:sap:soap:functions:mc-style:ZPS_WEB_SERV_WBS_DATES:ZpsWbsDat" +
            "esForWebServRequest", ReplyAction="urn:sap-com:document:sap:soap:functions:mc-style:ZPS_WEB_SERV_WBS_DATES:ZpsWbsDat" +
            "esForWebServResponse")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServResponse ZpsWbsDatesForWebServ(RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServRequest request);
        
        // CODEGEN: Generating message contract since the operation has multiple return values.
        [System.ServiceModel.OperationContractAttribute(Action="urn:sap-com:document:sap:soap:functions:mc-style:ZPS_WEB_SERV_WBS_DATES:ZpsWbsDat" +
            "esForWebServRequest", ReplyAction="urn:sap-com:document:sap:soap:functions:mc-style:ZPS_WEB_SERV_WBS_DATES:ZpsWbsDat" +
            "esForWebServResponse")]
        System.Threading.Tasks.Task<RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServResponse> ZpsWbsDatesForWebServAsync(RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServRequest request);
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.2046.0")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="urn:sap-com:document:sap:soap:functions:mc-style")]
    public partial class ZpsWebWbsDates : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string posidField;
        
        private string begdaField;
        
        private string enddaField;
        
        private string zstatusLdField;
        
        private string zerrorField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string Posid {
            get {
                return this.posidField;
            }
            set {
                this.posidField = value;
                this.RaisePropertyChanged("Posid");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public string Begda {
            get {
                return this.begdaField;
            }
            set {
                this.begdaField = value;
                this.RaisePropertyChanged("Begda");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=2)]
        public string Endda {
            get {
                return this.enddaField;
            }
            set {
                this.enddaField = value;
                this.RaisePropertyChanged("Endda");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=3)]
        public string ZstatusLd {
            get {
                return this.zstatusLdField;
            }
            set {
                this.zstatusLdField = value;
                this.RaisePropertyChanged("ZstatusLd");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=4)]
        public string Zerror {
            get {
                return this.zerrorField;
            }
            set {
                this.zerrorField = value;
                this.RaisePropertyChanged("Zerror");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.MessageContractAttribute(WrapperName="ZpsWbsDatesForWebServ", WrapperNamespace="urn:sap-com:document:sap:soap:functions:mc-style", IsWrapped=true)]
    public partial class ZpsWbsDatesForWebServRequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="", Order=0)]
        [System.Xml.Serialization.XmlArrayAttribute()]
        [System.Xml.Serialization.XmlArrayItemAttribute("item", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, IsNullable=false)]
        public RightsU_Plus.MSM_SAP_WS.ZpsWebWbsDates[] LtWbsDates;
        
        public ZpsWbsDatesForWebServRequest() {
        }
        
        public ZpsWbsDatesForWebServRequest(RightsU_Plus.MSM_SAP_WS.ZpsWebWbsDates[] LtWbsDates) {
            this.LtWbsDates = LtWbsDates;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.MessageContractAttribute(WrapperName="ZpsWbsDatesForWebServResponse", WrapperNamespace="urn:sap-com:document:sap:soap:functions:mc-style", IsWrapped=true)]
    public partial class ZpsWbsDatesForWebServResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="", Order=0)]
        [System.Xml.Serialization.XmlArrayAttribute()]
        [System.Xml.Serialization.XmlArrayItemAttribute("item", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, IsNullable=false)]
        public RightsU_Plus.MSM_SAP_WS.ZpsWebWbsDates[] LtWbsDates;
        
        public ZpsWbsDatesForWebServResponse() {
        }
        
        public ZpsWbsDatesForWebServResponse(RightsU_Plus.MSM_SAP_WS.ZpsWebWbsDates[] LtWbsDates) {
            this.LtWbsDates = LtWbsDates;
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface ZPS_WEB_SERV_WBS_DATESChannel : RightsU_Plus.MSM_SAP_WS.ZPS_WEB_SERV_WBS_DATES, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class ZPS_WEB_SERV_WBS_DATESClient : System.ServiceModel.ClientBase<RightsU_Plus.MSM_SAP_WS.ZPS_WEB_SERV_WBS_DATES>, RightsU_Plus.MSM_SAP_WS.ZPS_WEB_SERV_WBS_DATES {
        
        public ZPS_WEB_SERV_WBS_DATESClient() {
        }
        
        public ZPS_WEB_SERV_WBS_DATESClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public ZPS_WEB_SERV_WBS_DATESClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public ZPS_WEB_SERV_WBS_DATESClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public ZPS_WEB_SERV_WBS_DATESClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServResponse RightsU_Plus.MSM_SAP_WS.ZPS_WEB_SERV_WBS_DATES.ZpsWbsDatesForWebServ(RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServRequest request) {
            return base.Channel.ZpsWbsDatesForWebServ(request);
        }
        
        public void ZpsWbsDatesForWebServ(ref RightsU_Plus.MSM_SAP_WS.ZpsWebWbsDates[] LtWbsDates) {
            RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServRequest inValue = new RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServRequest();
            inValue.LtWbsDates = LtWbsDates;
            RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServResponse retVal = ((RightsU_Plus.MSM_SAP_WS.ZPS_WEB_SERV_WBS_DATES)(this)).ZpsWbsDatesForWebServ(inValue);
            LtWbsDates = retVal.LtWbsDates;
        }
        
        public System.Threading.Tasks.Task<RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServResponse> ZpsWbsDatesForWebServAsync(RightsU_Plus.MSM_SAP_WS.ZpsWbsDatesForWebServRequest request) {
            return base.Channel.ZpsWbsDatesForWebServAsync(request);
        }
    }
}
