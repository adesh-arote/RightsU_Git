using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace RightsU.BMS.API
{
    public class GlobalParams
    {
        public LoginEntity objLoginEntity
        {
            get
            {
                if (System.Web.HttpContext.Current.Session["objLoginEntity"] == null)
                    System.Web.HttpContext.Current.Session["objLoginEntity"] = new LoginEntity();
                return (LoginEntity)System.Web.HttpContext.Current.Session["objLoginEntity"];
            }
            set { System.Web.HttpContext.Current.Session["objLoginEntity"] = value; }
        }
    }

    public class ReportSetting
    {
        public string GetReport(string ReportName)
        {
            string ReportFolder = "";
            string ReportPath = "";

            ReportFolder = ConfigurationManager.AppSettings["ReportingServerFolder"].ToUpper();
            //ReportFolder = ConfigurationManager.AppSettings["ReportingServerFolder"].ToUpper();
            //ReportFolder = "/RightsU_UAT";//Convert.ToString(new GlobalParams().objLoginEntity.ReportingServerFolder);
            if (ReportName == "DEAL_VERSION")
                ReportPath = ReportFolder + "/rptAcq_Deal_Version_History";
            else if (ReportName == "DEAL_VERSION_SYN")
                ReportPath = ReportFolder + "/rpt_Syn_Deal_Version_History";
            else if (ReportName == "CHANNEL_WISE_CONSUMPTION")
                ReportPath = ReportFolder + "/rptChannelWiseConsumption_Yearwise";
            else if (ReportName == "CHANNEL_WISE_CONSUMPTION_ENGLISH")
                ReportPath = ReportFolder + "/rptChannelWiseConsumption_Yearwise_English";
            else if (ReportName == "CHANNEL_WISE_CONSUMPTION_SHOW")
                ReportPath = ReportFolder + "/rpt_ChannelwiseConsumptionShows";
            else if (ReportName == "MIGRATE_COST")
                ReportPath = ReportFolder + "/MigrateCost";
            else if (ReportName == "MOVIE_STATUS_REPORT")
                ReportPath = ReportFolder + "/Movie_Status_Report";
            else if (ReportName == "REVENUE_ACCOUNTED_INFO")
                ReportPath = ReportFolder + "/RevenueAccountedInfo";
            else if (ReportName == "VMPL_ROYALTY")
                ReportPath = ReportFolder + "/repVMPLRoyalty";
            else if (ReportName == "CHANNEL_CONSUMP_SHOW")
                ReportPath = ReportFolder + "/Channelwise_Consumption_For_Shows";
            else if (ReportName == "ROYALTY_REPORT_DEAL_TITLE")
                ReportPath = ReportFolder + "/RoyaltyReportDealTitle";
            else if (ReportName == "AMORT_REPORT")
                ReportPath = ReportFolder + "/VMPL_AMORT_REPORT";
            else if (ReportName == "SALES_REPORT")
                ReportPath = ReportFolder + "/Sales_Report";
            else if (ReportName == "SYNDICATION_EXPIRY_REPORT")
                ReportPath = ReportFolder + "/Syndication_Expiry_Report";
            else if (ReportName == "TITLE_AVAILABILITY_REPORT")
                ReportPath = ReportFolder + "/rpt_Title_Availability_Report";
            else if (ReportName == "ACQUISITION_EXPIRY_REPORTS")
                ReportPath = ReportFolder + "/rptDealExpiry";
            else if (ReportName == "ACQUITION_DEAL_LIST_REPORT")
                ReportPath = ReportFolder + "/rptAcquisition_Deal_List";
            else if (ReportName == "AUDIT_TRAIL_LIST_REPORT")
                ReportPath = ReportFolder + "/rptAuditTrailAcqSyn";
            else if (ReportName == "SYNDICATION_DEAL_LIST_REPORT")
                ReportPath = ReportFolder + "/rptSyndication_Deal_List";
            else if (ReportName == "rpt_AncillaryRightsReport")
                ReportPath = ReportFolder + "/rptAncillary_Rights";
            else if (ReportName == "Title_Availability_Languagewise")
                ReportPath = ReportFolder + "/Title_Availability_Languagewise";
            else if (ReportName == "ACQ_TITLE_PLATFORM_REPORT")
                ReportPath = ReportFolder + "/rptPlatformwise_Acquisition";
            else if (ReportName == "Theatrical_Availability_Languagewise")
                ReportPath = ReportFolder + "/Theatrical_Availability_Languagewise";
            else if (ReportName == "Title_Availability_Languagewise_2")
                ReportPath = ReportFolder + "/Title_Availability_Languagewise_2";
            else if (ReportName == "Title_Availability_Languagewise_3")
                ReportPath = ReportFolder + "/rptMovie_Availability";
            else if (ReportName == "Title_Availability_Languagewise_V18")
                ReportPath = ReportFolder + "/rptMovie_Availability_V18";
            else if (ReportName == "Title_Availability_Languagewise_V18_Demo")
                ReportPath = ReportFolder + "/rptMovie_Availability_V18_Demo";
            else if (ReportName == "Acquisition_Expiry_Reports")
                ReportPath = ReportFolder + "/rptDealExpiry";
            else if (ReportName == "Syndication_Sales_Report")
                ReportPath = ReportFolder + "/rptSyndication_Sales";
            else if (ReportName == "Syn_Deal_Title_Platform_Report")
                ReportPath = ReportFolder + "/rptPlatformwise_Syndication";
            else if (ReportName == "Title_Availability_Show_3")
                ReportPath = ReportFolder + "/rptShow_Availability";
            else if (ReportName == "Title_Availability_Show_3_V18")
                ReportPath = ReportFolder + "/rptShow_Availability_V18";
            else if (ReportName == "Title_Availability_Show_3_V18_Demo")
                ReportPath = ReportFolder + "/rptShow_Availability_V18_Demo";
            else if (ReportName == "rptDealContent")
                ReportPath = ReportFolder + "/rptDealContent";
            else if (ReportName == "Title_Platform_Acq_New")
                ReportPath = ReportFolder + "/rptPlatformwise_Acquisition_Neo";
            else if (ReportName == "Title_Platform_Syn_New")
                ReportPath = ReportFolder + "/rptPlatformwise_Syndication_Neo";
            else if (ReportName == "rptMusicUsage")
                ReportPath = ReportFolder + "/rptMusicUsage";
            else if (ReportName == "MUSIC_LABEL_CONSUMPTION")
                ReportPath = ReportFolder + "/rptMusicLabelConsumption";
            else if (ReportName == "Content_Wise_Music_Wise")
                ReportPath = ReportFolder + "/rptContentWiseMusicUsage";
            else if (ReportName == "Channel_Wise_Music_Usage_Report")
                ReportPath = ReportFolder + "/rptChannelWiseMusicUsage";
            else if (ReportName == "Music_Exception_Handling_Report")
                ReportPath = ReportFolder + "/rptMusic_Exception_Handling";
            else if (ReportName == "Runs_Exception_Report")
                ReportPath = ReportFolder + "/rptAsRun_Sche_Exception";
            else if (ReportName == "Music_Assignment_Audit_Report")
                ReportPath = ReportFolder + "/rptMusic_Assignment_Audit";
            else if (ReportName == "Music_Airing_Report")
                ReportPath = ReportFolder + "/rptMusicAiring";
            else if (ReportName == "Music_Track_Audit_Report")
                ReportPath = ReportFolder + "/rptMusicTrackAudit";
            else if (ReportName == "Cost_Report")
                ReportPath = ReportFolder + "/rptCostReport";
            else if (ReportName == "Theatrical_Availability")
                ReportPath = ReportFolder + "/rptTheatrical_Availability";
            else if (ReportName == "rptTitleList")
                ReportPath = ReportFolder + "/rptTitleList";
            else if (ReportName == "rptListIPR")
                ReportPath = ReportFolder + "/rptListIPR";
            else if (ReportName == "rptListIPROpp")
                ReportPath = ReportFolder + "/rptListIPROpp";
            else if (ReportName == "rptListMusicTitle")
                ReportPath = ReportFolder + "/rptListMusicTitle";
            else if (ReportName == "rptListMasters")
                ReportPath = ReportFolder + "/rptListMasters";
            else if (ReportName == "TestReport")
                ReportPath = ReportFolder + "/UserData";
            else if (ReportName == "Attachment_Report")
                ReportPath = ReportFolder + "/rptAttachment";
            else if (ReportName == "Episodic_Cost_Report")
                ReportPath = ReportFolder + "/rpt_Episodic_Cost";
            else if (ReportName == "Music_Deal_List_Report")
                ReportPath = ReportFolder + "/rptMusicDealList";
            else if (ReportName == "Title_Amort_Report")
                ReportPath = ReportFolder + "/rptAmort_Month";
            else if (ReportName == "Movie_Availability_Indiacast")
                ReportPath = ReportFolder + "/rptMovie_Availability_V18_Indiacast";
            else if (ReportName == "Show_availability_Indiacast")
                ReportPath = ReportFolder + "/rptShow_Availability_Indiacast";
            else if (ReportName == "rpt_AdvAncillaryReport")
                ReportPath = ReportFolder + "/rptAdvAncillary";
            else if (ReportName == "Self_Utilization_Movie_Availability")
                ReportPath = ReportFolder + "/rpt_Self_Avail";
            else if (ReportName == "Self_Utilization_Show_Availability")
                ReportPath = ReportFolder + "/rpt_Self_Avail ";
            else if (ReportName == "rptMHRequisitionList")
                ReportPath = ReportFolder + "/rptMHRequisitionList";
            else if (ReportName == "TitleMilestone_Report")
                ReportPath = ReportFolder + "/rptTitleMilestoneList";
            else if (ReportName == "Title_Details_Report")
                ReportPath = ReportFolder + "/rptTitleDetailsReport";
            else if (ReportName == "ProjectMilestone_Report")
                ReportPath = ReportFolder + "/rptProjectMilestone";
            else if (ReportName == "rptExportToExcelBulkImport")
                ReportPath = ReportFolder + "/rptExportToExcelBulkImport";
            else if (ReportName == "rpt_Deal_WFStatus_Pending")
                ReportPath = ReportFolder + "/rpt_Deal_WFStatus_Pending";
            else if (ReportName == "rptDealStatusReport")
                ReportPath = ReportFolder + "/rptDealStatusReport";
            else if (ReportName == "rptIPR_IntDom_Report")
                ReportPath = ReportFolder + "/rptIPR_IntDom";
            else if (ReportName == "Title_Availability_Languagewise_L1")
                ReportPath = ReportFolder + "/rptMovie_Availability_L1";
            else if (ReportName == "Title_Availability_Show_3_V18_L1")
                ReportPath = ReportFolder + "/rptShow_Availability_V18_L1";

            return ReportPath;
        }

        
    }

    public class LoginEntity
    {
        public string ShortName { get; set; }
        public string FullName { get; set; }
        public string DatabaseName { get; set; }
        public string ConnectionStringName { get; set; }
        public string ReportingServerFolder { get; set; }
    }

}