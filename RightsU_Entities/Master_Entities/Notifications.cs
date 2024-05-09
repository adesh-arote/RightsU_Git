﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class Notifications
    {
        public State EntityState { get; set; }
        public long NotificationsCode { get; set; }
        public string NotificationType { get; set; }
        public string EventCategory { get; set; }
        public long UserCode { get; set; }
        public Nullable<long> TransType { get; set; }
        public Nullable<long> TransCode { get; set; }
        public string Email { get; set; }
        public string Mobile { get; set; }
        public bool IsSend { get; set; }
        public bool IsRead { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public string Subject { get; set; }
        public string HtmlBody { get; set; }
        public string TextBody { get; set; }
        public Nullable<System.DateTime> ScheduleDateTime { get; set; }
        public Nullable<int> NoOfRetry { get; set; }
        public Nullable<int> MsgStatusCode { get; set; }
        public Nullable<System.DateTime> SentOrReadDateTime { get; set; }
        public string API_Status { get; set; }
        public string ErrorDetails { get; set; }
        public Nullable<System.DateTime> CreatedOn { get; set; }
        public Nullable<long> CreatedBy { get; set; }
        public Nullable<System.DateTime> ModifiedOn { get; set; }
        public Nullable<long> ModifiedBy { get; set; }
        public bool IsAutoEscalated { get; set; }
        public bool IsReminderMail { get; set; }
        public string Service_Response { get; set; }
        public Nullable<int> Email_Config_Code { get; set; }
        public Nullable<int> Event_Platform_Code { get; set; }
        public string Event_Template_Type { get; set; }

        public virtual Email_Config Email_Config { get; set; }
        public virtual Event_Platform Event_Platform { get; set; }
    }
}
