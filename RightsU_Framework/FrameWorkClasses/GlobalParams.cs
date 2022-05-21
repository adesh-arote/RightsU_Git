using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using AjaxControlToolkit;
using System.Collections;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Reflection;

namespace UTOFrameWork.FrameworkClasses
{
    public class GlobalParams
    {
        #region ----- Attribites for Main Menu ---
        public const string ChannelWiseAmort = "C";
        public const string EpisodWiseAmort = "E";
        #endregion

        public const int WEEK_START_DAY = 2; //1-Sunday,2-Monday ....
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
        //Yogesh Added-------------------------------------

        //When Rule type is premium, nos field of Amort Rule  is const 
        // It is hardcoded and same used for calculation
        public const int nosValInRuleTypePremium = 1;
        public const int Year = 2;
        public const string orFlagInPremium = "F";

        //Dada Changed-------------------------------------  
        #region----------Define Module Codes-----------
        public const int ModuleCodeForMasters = 1;
        public const int ModuleCodeForUsers = 3;
        public const int ModuleCodeForSecurityGr = 4;
        public const int ModuleCodeForCurrency = 5;
        public const int ModuleCodeForInternationalTerritory = 6;
        public const int ModuleCodeForCountry = 6;
        public const int ModuleCodeForGenres = 7;
        public const int ModuleCodeForEntity = 8;
        public const int ModuleCodeForCategory = 9;
        public const int ModuleCodeForVendor = 10;
        public const int ModuleCodeForChannel = 11;
        public const int ModuleCodeForLanguage = 12;
        public const int ModuleCodeForTalent = 13;
        public const int ModuleCodeForCostType = 14;
        public const int ModuleCodeForPlatform = 15;
        public const int ModuleCodeForPaymentTerms = 16;
        public const int ModuleCodeForMaterialMedium = 17;
        public const int ModuleCodeForMaterialType = 18;
        public const int ModuleCodeForPenatly = 19;
        public const int ModuleCodeForCBFCAgent = 20;
        public const int ModuleCodeForSystemSetting = 22;
        public const int ModuleCodeForAmortRule = 23;
        public const int ModuleCodeForApprovalWorkflow = 24;
        public const int ModuleCodeForAssignWorkflow = 25;
        public const int ModuleCodeForTitle = 27;
        public const int ModuleCodeForAcqDeal = 30;
        public const int ModuleCodeForRightRule = 31;
        public const int ModuleCodeForMaterialOrder = 32;
        public const int ModuleCodeForMaterialReceipt = 34;
        public const int ModuleCodeForSynDeal = 35;
        public const int ModuleCodeForAppliedForCBFC = 36;
        public const int ModuleCodeForDraftLFA = 37;
        public const int ModuleCodeForLFAFinalized = 38;
        public const int ModuleCodeForAmortMonthChange = 39;
        public const int ModuleCodeForReports = 40;
        public const int ModuleCodeForMusicReports = 186;
        public const int ModuleCodeForDocumentType = 44;
        public const int ModuleCodeForAncillaryRights = 45;
        public const int ModuleCodeForTheatricalTerritory = 46;
        public const int ModuleCodeForAdditionalExpense = 48;
        public const int ModuleCodeForUserEntityChange = 49;
        public const int ModuleCodeForUploads = 50;
        public const int ModuleCodeForQueryReport = 55;
        public const int ModuleCodeForGradeMaster = 56;
        public const int ModuleCodeForMovieStatusReport = 57;
        public const int ModuleCodeForTerritoryGroup = 59;
        public const int ModuleCodeForRightsCategory = 60;
        public const int ModuleCodeForRevenueAccountedInfo = 66;
        public const int ModuleCodeForRoyaltyCommission = 76;
        public const int ModuleCodeForRoyaltyRecoupment = 79;
        public const int ModuleCodeForFormat = 84;
        public const int ModuleCodeForBoxsetmapping = 82;
        public const int ModuleCodeForMassTerritoryUpdate = 86;
        public const int ModuleCodeFor_ScheduleUpload = 87;
        public const int ModuleCodeFor_AsRunUpload = 88;
        public const int ModuleCodeFor_BV_Exception = 94;
        public const int ModuleCodeFor_HouseIDUpload = 95;
        public const int ModuleCodeForSystemParameter = 98;
        public const int ModuleCodeFor_PAFUpload = 102;
        public const int ModuleCodeForLanguageGroup = 106;
        public const int ModuleCodeFor_DashBoard = 107;
        public const int ModuleCodeFor_IPR_Application = 114;
        public const int ModuleCodeForSAP_WBS = 118;
        public const int ModuleCodeForPlatformwiseAcquisition = 119;
        public const int ModuleCodeForMusic_Title = 153;
        public const int ModuleCodeForDigitalTitleReport = 124;
        public const int ModuleCodeFor_BV_WBS_Export = 125;
        public const int ModuleCodeFor_IPR_Country = 129;
        public const int ModuleCodeForPlatformGroup = 130;
        public const int ModuleCodeForAvail = 135;
        public const int ModuleCodeFor_DashBoard_Graphical = 137;
        public const int ModuleCodeForGlossary = 140;
        public const int ModuleCodeForReportsAndUsage = 145;
        public const int ModuleCodeForFAQ = 146;
        public const int ModuleCodeForContactInfo = 147;
        public const int ModuleCodeForAskanExpert = 148;
        public const int ModuleCodeForContent = 149;
        public const int ModuleCodeForMusicLanguage = 151;
        public const int ModuleCodeForMusicTheme = 152;
        public const int ModuleCodeForMusicExceptionHandling = 154;
        public const int ModuleCodeForMusicLabel = 155;
        public const int ModuleCodeForMusicAlbum = 156;
        public const int ModuleCodeForProgram = 162;
        public const int ModuleCodeForMusicDeal = 163;
        public const int ModuleCodeForRevenueReport = 171;
        public const int ModuleCodeForCostReport = 166;
        public const int ModuleCodeForEmailConfig = 175;
        public const int ModuleCodeForSystemLanguage = 176;
        public const int ModuleCodeForMusicTrackAssignment = 160;
        public const int ModuleCodeForProvisionalDeal = 177;
        public const int ModuleCodeForPromoterRemarks = 178;
        public const int ModuleCodeForAcqDealListReport = 108;
        public const int ModuleCodeForSynDealListReport = 109;
        public const int ModuleCodeForMovieAvailabilityReport = 127;
        public const int ModuleCodeForMovieAvailabilityNewReport = 247;
        public const int ModuleCodeForProgramAvailabilityReport = 134;
        public const int ModuleCodeForTheatricalAvailabilityReport = 121;
        public const int ModuleCodeForIndiacastMovieAvailabilityReport = 184;
        public const int ModuleCodeForIndiacastProgramAvailabilityReport = 185;
        public const int ModuleCodeForSelfUtilizationMovieAvailabilityReport = 186;
        public const int ModuleCodeForSelfUtilizationProgramAvailabilityReport = 187;
        public const int ModuleCodeForMusicTrackActivityReport = 164;
        public const int ModuleCodeForPARightsReport = 111;
        public const int ModuleCodeForDealVersionHistoryReport = 105;
        public const int ModuleCodeForDealExpiryReport = 128;
        public const int ModuleCodeForSyndicationsalesReport = 131;
        public const int ModuleCodeForPlatformwiseSyndicationReport = 133;
        public const int ModuleCodeForTheatricalSyndicationReport = 165;
        public const int ModuleCodeForTerritoryLanguageAuditReport = 117;
        public const int ModuleCodeForMusicDealListReport = 174;
        public const int ModuleCodeForAttachmentReport = 172;
        public const int ModuleCodeForEpisodicCostReport = 173;
        public const int ModuleCodeForRunUtilizationReport = 96;
        public const int ModuleCodeForRunExceptionReport = 97;
        public const int ModuleCodeForRightsUsageReport = 93;
        public const int ModuleCodeForChannelWiseMusicUsageReport = 168;
        public const int ModuleCodeForMusicUsageReport = 150;
        public const int ModuleCodeForLabelwiseMusicCounsumptionReport = 157;
        public const int ModuleCodeForContentwiseMusicUsageReport = 158;
        public const int ModuleCodeForMusicExceptionReport = 159;
        public const int ModuleCodeForMusicAssignmentActivityReport = 161;
        public const int ModuleCodeForMusicAiringReport = 167;
        public const int ModulecodeForLoggedInUsersReport = 110;
        public const int ModulecodeForLoggedInDetailsReport = 115;
        public const int ModuleCodeForMusic_Hub = 190;
        public const int ModuleCodeForAuthorisedMusic = 199;
        public const int ModuleCodeForStatusReport = 200;
        public const int ModuleCodeForDashboard = 191;
        public const int ModuleCodeForMilestoneNature = 203;
        public const int ModuleCodeFortitleMilestoneReport = 204;
        public const int ModuleCodeForProjectMilestone = 208;
        public const int ModuleCodeForPartyCategory = 209;
        public const int ModuleCodeForCustomer = 211;
        public const int ModuleCodeForAcq_Rights_Template = 213;
        public const int ModuleCodeForDealWorkflowStausPending = 217;
        public const int ModuleCodeFor_IPR_Dashboard = 249;
        public const int ModuleCodeForTitleObjection = 251;
        public const int ModuleCodeForDealDescription = 252;
        public const int ModuleCodeForTitleObjectionType = 253;

        #endregion

        #region----------Define Right Codes-----------
        public const int RightCodeForAdd = 1;
        public const int RightCodeForEdit = 2;
        public const int RightCodeForActivate = 3;
        public const int RightCodeForDeactivate = 4;
        public const int RightCodeForReleaseLock = 5;
        public const int RightCodeForDelete = 6;
        public const int RightCodeForView = 7;
        public const int RightCodeForSendForApproval = 8;
        public const int RightCodeForUpgrade = 13;
        public const int RightCodeForViewHistory = 9;
        public const int RightCodeForRightGranted = 10;
        public const int RightCodeForApprove = 11;
        public const int RightCodeForDealReject = 12;
        //public const int RightCodeForMovieAward = 13;
        public const int RightCodeForDraftLFARcd = 14;
        public const int RightCodeForCBFCAPPLY = 15;
        public const int RightCodeForCBFCREAPPLY = 16;
        public const int RightCodeForAmendment = 18;
        public const int RightCodeForAmort = 19;
        public const int RightCodeForUnlockUser = 58;
        public const int RightCodeForAssign = 61;
        public const int RightCodeForAcqGeneralTab = 62;
        public const int RightCodeForAcqRightTab = 63;
        public const int RightCodeForAcqCostTab = 64;
        public const int RightCodeForAcqLinkDataTab = 65;
        public const int RightCodeForAcqAmortTab = 66;
        public const int RightCodeForAcqAttachmentTab = 67;
        public const int RightCodeForAcqPaymentTermsTab = 68;
        public const int RightCodeForAcqMaterialTab = 69;
        public const int RightCodeForAcqStatusHistoryTab = 70;
        public const int RightCodeForAcqContentTab = 71;
        public const int RightCodeForSynGeneralTab = 72;
        public const int RightCodeForSynRightTab = 73;
        public const int RightCodeForSynCostTab = 74;
        public const int RightCodeForSynAttachmentTab = 75;
        public const int RightCodeForSynPaymentTermsTab = 76;
        public const int RightCodeForSynMaterialTab = 77;
        public const int RightCodeForSynStatusHistoryTab = 78;
        public const int RightCodeForAmendAfterSyn = 79;
        public const int RightCodeForCloseMovie = 88;
        public const int RightCodeForDealReopen = 89;
        public const int RightCodeForSynPushBackTab = 110;
        public const int RightCodeForAncillaryTab = 111;
        public const int RightCodeForSynAncillaryTab = 112;
        public const int RightCodeForCountry = 113;
        public const int RightCodeForAcqRunTab = 114;
        public const int RightCodeForAcqPushbackTab = 115;
        public const int RightCodeForRollback = 116;
        public const int RightCodeForAddLanguage = 117;
        public const int RightCodeForAcqSportsTab = 118;
        public const int RightCodeForAcqBudgetTab = 119;
        public const int RightCodeForAcqSupplementaryTab = 172;
        public const int RightCodeForSynRunTab = 120;
        public const int RightCodeForExportToExcel = 121;
        public const int RightCodeForDomesticTab = 122;
        public const int RightCodeForInternationalTab = 123;
        public const int RightCodeForOppositionByTab = 124;
        public const int RightCodeForOppositionAgainstTab = 125;
        public const int RightCodeForTerminate = 127;
        public const int RightCodeForTitleImport = 128;
        public const int RightCodeForMusicBulkImport = 129;
        public const int RightCodeForAssignMusic_NonMusic = 130;
        public const int RightCodeForAssignMusic_Music = 131;
        public const int RightCodeForAssignMusic_LinkShow = 132;
        public const int RightCodeForBulkUpdate = 133;
        public const int RightCodeForEditWOApproval = 134;
        public const int RightCodeForRollWOApproval = 135;
        public const int RightCodeForCost = 136;
        public const int RightCodeForTitleRelease = 137;
        public const int RightCodeForAcqReleaseContent = 138;
        public const int RightCodeForMusicTrackContents = 139;
        public const int RightCodeForAcqDigitalRights = 140;
        public const int RightCodeForEmailConfigure = 141;
        public const int RightCodeForConfigure = 142;
        public const int RightCodeForAllBusinessUnit = 152;
        public const int RightCodeForIFTA = 153;
        public const int RightCodeForCountryLevel = 154;
        public const int RightCodeForTerritoryLevel = 155;
        public const int RightCodeForShowAllSelfUtilizationPlatform = 156;
        public const int RightCodeForResetPassword = 158;
        public const int RightCodeForProductionHouseUser = 157;
        public const int RightCodeForBulkUpdateRun = 161;
        public const int RightCodeForBulkDeleteRun = 162;
        public const int RightCodeForBulkAssignment = 163;
        public const int RightCodeForAddSupplementaryButton = 173;
        public const int RightCodeForDealArchive = 164;
        public const int RightCodeForUserConfigurationTab = 165;
        public const int RightCodeForSendForArchive = 166;
        public const int RightCodeForAllRegionalGEC = 167;
        public const int RightCodeForDownload = 168;

        //added by aditya
        public const int RightCodeForPaymentTermAdd = 159;
        public const int RightCodeForTitleMilestone = 160;


        //added by vipul for Title Content View
        public const int RightCodeForDealInfoContent = 144;
        public const int RightCodeForTitleMetaDataContent = 145;
        public const int RightCodeForMusicContent = 147;
        public const int RightCodeForVersionContent = 148;
        public const int RightCodeForAiringContent = 149;
        public const int RightCodeForStatusHistoryContent = 150;
        public const int RightCodeForRunDefinitionContent = 151;

        //Right Code For Acquisistion Deal
        public const string Page_From_General = "GNR";
        public const string Page_From_Rights = "RGT";
        public const string Page_From_Rights_Detail_View = "RGT_DTL_VW";
        public const string Page_From_Rights_Detail_AddEdit = "RGT_DTL_AE";
        public const string Page_From_Supplementary_AddEdit = "SUPP_DTL_AE";
        public const string Page_From_Pushback = "PBK";
        public const string Page_From_Run = "RUN";
        public const string Page_From_Run_Detail_View = "RUN_DTL_VW";
        public const string Page_From_Run_Detail_AddEdit = "RUN_DTL_AE";
        public const string Page_From_Cost = "CST";
        public const string Page_From_Budget = "BGT";
        public const string Page_From_Sports = "SPT";
        public const string Page_From_Ancillary = "ANC";
        public const string Page_From_PaymentTerm = "PYT";
        public const string Page_From_Material = "MTR";
        public const string Page_From_Attachment = "ATT";
        public const string Page_From_StatusHistory = "STH";
        public const string Page_From_Supplementary = "SUPP";
        public const string Page_From_Amort = "AMORT";
        public const string Page_From_Revenue = "REV";
        public const string Page_From_Rights_Bulk_Update = "BLK";
        public const string Page_From_Run_Bulk_update = "BLK_RUN";
        public const string Page_From_Digital_Rights = "DGR";
        public const string Page_From_Run_Bulk_Delete = "BLK_DEL_RUN";

        //added by shamli
        public const int CodeForColorsIndia = 1;
        public const int CodeForColorsUK = 2;
        public const int CodeForColorsUS = 3;
        public const int CodeForColorsMENA = 4;
        public const int CodeForColorsHD = 5;

        //added by Dada
        public const string ColorsIndiaText = "COLORS INDIA";
        public const string ColorsUKText = "COLORS UK";
        public const string ColorsUSText = "COLORS US";
        public const string ColorsMENAText = "COLORS MENAS";
        public const string ColorsHDText = "COLORS HD";

        //added by shamli
        public const int CodeForChannelBeam_India = 1;
        public const int CodeForChannelBeam_UK = 2;
        public const int CodeForChannelBeam_US = 3;
        public const int CodeForChannelBeam_International = 4;
        public const int CodeForChannelBeam_Africa = 5;
        public const int CodeForChannelBeam_Canada = 6;
        public const int CodeForChannelBeam_MiddleEast = 7;
        public const int CodeForEmbeddedMusic = 5;
        //added by Dada
        public const string TextForChannelBeam_India = "INDIA";
        public const string TextForChannelBeam_UK = "UK";
        public const string TextForChannelBeam_US = "US";
        public const string TextForChannelBeam_International = "INTERNATIONAL";
        public const string TextForChannelBeam_Africa = "AFRICA";
        public const string TextForChannelBeam_Canada = "CANADA";
        public const string TextForChannelBeam_MiddleEast = "MIDDLE EAST";



        //Added By Amul For Set Default Currency value and Category 
        public const string DefaultCurrencyText = "DefaultCurrency";
        public const string DefaultCategoryText = "DefaultCategory";

        public const string Cancel_From_Deal = "QS_Deal_Cancel";
        #endregion
        //added by Anchal
        public const int CodeForStarCast = 2;
        //public static string entity_Type { get; set; }

        public static ArrayList arrEntityType()
        {
            ArrayList arrEntity = new ArrayList();

            //arrEntity.Add(new AttribValue("VIACOM18", "RightsU_Viacom18_dev"));
            //arrEntity.Add(new AttribValue("VMPL", "RightsU_VMPL"));

            arrEntity.Add(new AttribValue("VIACOM18", "RightsU_Client_VMPL"));
            arrEntity.Add(new AttribValue("VMPL", "RightsU_Client_VMPL"));

            return arrEntity;
        }

        public static ArrayList arrYear()
        {
            ArrayList arrYear = new ArrayList();

            arrYear.Add(new AttribValue("January", "1"));
            arrYear.Add(new AttribValue("february", "2"));
            arrYear.Add(new AttribValue("March", "3"));
            arrYear.Add(new AttribValue("April", "4"));
            arrYear.Add(new AttribValue("May", "5"));
            arrYear.Add(new AttribValue("June", "6"));
            arrYear.Add(new AttribValue("July", "7"));
            arrYear.Add(new AttribValue("August", "8"));
            arrYear.Add(new AttribValue("September ", "9"));
            arrYear.Add(new AttribValue("October", "10"));
            arrYear.Add(new AttribValue("November", "11"));
            arrYear.Add(new AttribValue("December", "12"));

            return arrYear;
        }

        public const int timeDiffForLock = 20;
        public const int RoleCode_Director = 1;
        public const int RoleCode_StarCast = 2;
        public const int RoleCode_SaleAgent = 3;
        public const int RoleCode_Producer = 4;
        public const int RoleCode_Distributor = 11;
        public const int RoleCode_Supplier = 9;
        public const int RoleCode_CNFAgent = 5;
        public const int RoleCode_CBFCAgent = 6;
        public const int RoleCode_Studio = 7;
        public const int RoleCode_Assignment = 25;
        public const int RoleCode_License = 26;
        public const int RoleCode_OwnProduction = 27;

        public const string ROLE_TYPE_ENTITY = "E";
        public const string ROLE_TYPE_TALENT = "T";

        public const int RoleCode_Cinematographer = 22;
        public const int RoleCode_Choreographer = 23;
        public const int Deal_Type_Lyricist = 23;
        public const int Deal_Type_Director = 24;
        public const int Deal_Type_DOP = 25;
        public const int Deal_Type_Choreographer = 26;
        public const string LINE_ITEM_NEWLY_ADDED = "N";
        public const string LINE_ITEM_MODIFIED = "M";
        public const string LINE_ITEM_DELETED = "D";
        public const string LINE_ITEM_EXISTING = "E";

        public const string RECORD_ADDED = "A";
        public const string RECORD_UPDATED = "U";
        public const string RECORD_DELETED = "DS";
        public const string RECORD_DUPLICATE = "D";

        public const string sortDirectionAsc = "ASC";
        public const string sortDirectionDesc = "DESC";
        public const string sortImageUrlAsc = "~/Images/scroll-up.gif";
        public const string sortImageUrlDesc = "~/Images/scroll-down.gif";
        public const string sortingImgAltTextAsc = "Ascending Order";
        public const string sortingImgAltTextDesc = "Ascending Order";

        //CONSTANT FOR DEAL AND SYNDICATION DEAL USE FOR VENDOR ROLE CODE
        //public const int Role_Code_Supplier = 9;
        public const int Role_Code_Production = 9;
        public const int Role_Code_SaleAgent = 8;
        public const int Role_Code_Entity = 14;

        #region --- Rights code for Dashboard ---
        public const int RightsCodeForAcquisitionRightsStart = 98;
        public const int RightsCodeForSyndicationRightsStart = 99;
        public const int RightsCodeForAcquisitionRightsEnd = 100;
        public const int RightsCodeForSyndicationRightsEnd = 101;
        public const int RightsCodeForAcquisitionRightsROFR = 102;
        public const int RightsCodeForAcquisitionRightsTentative = 103;
        #endregion

        //View Deal Mode
        public const string DEAL_MODE_ADD = "A";
        public const string DEAL_MODE_ARCHIVE = "AR";
        public const string DEAL_MODE_EDIT = "E";
        public const string DEAL_MODE_VIEW = "V";
        public const string DEAL_MODE_DELETE = "D";
        public const string DEAL_MODE_CLONE = "C";
        public const string DEAL_MODE_AMENDMENT = "AM";
        public const string DEAL_MODE_REOPEN = "RO";
        public const string DEAL_MODE_APPROVE = "APRV";
        public const string DEAL_MODE_SEND_FOR_APPROVAL = "SEND_FOR_AUTH";
        public const string DEAL_MODE_ROLLBACK = "ROLLBACK";
        public const string DEAL_MODE_VIEW_FOR_LFA_RECEIVED = "R";
        public const string DEAL_MODE_VIEW_FOR_LFA_FINALISED = "F";
        public const string DEAL_MOVIE_CLOSE = "DMC";
        public const string DEAL_MODE_EDIT_WO_APPROVAL = "EWOA";

        //Glossary Type
        public const string Glossary_FAQ = "F";
        public const string Glossary_Reports = "R";
        public const string Glossary_Definitions = "D";
        public const string Glossary_ContactInfo = "C";

        //ADDED  BY DADA ON 26-OCT-2010 --CONSTANT FOR SINGERS ROLE CODE 
        public const int Role_Code_Singer = 13;
        public const int Role_code_Producer = 4;
        public const int Role_code_StarCast = 2;

        //ADDED  BY Bhavesh ON 31-DEC-2013 --CONSTANT FOR SINGERS ROLE CODE 
        public const int Role_code_Writer = 20;
        public const int Role_code_DIALOGUES = 19;
        public const int Role_code_SCRIPT = 17;
        public const int Role_code_SCREEN_PLAY = 18;
        public const int Role_code_STORY = 16;
        public const int Role_code_MusicComposer = 21;
        public const int Role_code_lyricist = 15;


        //ADDED  BY DADA ON 26-OCT-2010 --CONSTANT FOR TITLE TYPE FOR TITLE
        public const int Title_Type_Movie = 1; //i.e. deal_type_code from Deal_Type Table 
        public const int Title_Type_Show = 2; //i.e. deal_type_code from Deal_Type Table 
        public const int Title_Type_FormatShow = 3; //i.e. deal_type_code from Deal_Type Table 
        public const int Title_Type_Celebrity = 4; //i.e. deal_type_code from Deal_Type Table 
        //public const int Title_Type_AudioMusic = 5; //i.e. deal_type_code from Deal_Type Table 
        public const int Title_Type_MusicLibrary = 5; //i.e. deal_type_code from Deal_Type Table 
        public const int Title_Type_VideoMusic = 6; //i.e. deal_type_code from Deal_Type Table 
        public const int Title_Type_Contestant = 7; //i.e. deal_type_code from Deal_Type Table 
        public const int Title_Type_Production = 8; //i.e. deal_type_code from Deal_Type Table 


        //ADDED  BY DADA ON 09-MAY-2012 --CONSTANT FOR DEAL TYPE FOR DEAL
        public const int Deal_Type_Movie = 1; //i.e. deal_type_code from Deal_Type Table 
        public const int Deal_Type_Show = 2; //i.e. deal_type_code from Deal_Type Table 
        public const int Deal_Type_FormatShow = 3; //i.e. deal_type_code from Deal_Type Table 
        public const int Deal_Type_Celebrity = 4; //i.e. deal_type_code from Deal_Type Table 
        public const int Deal_Type_Music = 5; //i.e. deal_type_code from Deal_Type Table 
        public const int Deal_Type_VideoMusic = 6; //i.e. deal_type_code from Deal_Type Table 
        public const int Deal_Type_Contestant = 7; //i.e. deal_type_code from Deal_Type Table
        //public const int Deal_Type_Production = 8; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Documentary_Show = 9; //i.e. deal_type_code from Deal_Type Table 
        public const int Deal_Type_ShortFlim = 10; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Content = 11; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Producer = 12; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Format_Program = 13;
        public const int Deal_Type_Performer = 14; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Writer = 15; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Music_Composer = 16; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Other = 17; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Documentary_Film = 21; //i.e. deal_type_code from Deal_Type Table 
        public const int Deal_Type_Event = 22; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Sports = 27; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Other_Talent = 28; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Singer = 29; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_ContentMusic = 30; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_WebSeries = 32; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Featurette = 33; //i.e. deal_type_code from Deal_Type Table
        public const int Deal_Type_Cineplay = 34;
        public const int Deal_Type_Drama_Play = 1034;
        public const int Deal_Type_Tele_Film = 1035;

        public const string Deal_Program = "Deal_Program";
        public const string Deal_Music = "Deal_Music";
        public const string Deal_Movie = "Deal_Movie";
        public const string Sub_Deal_Talent = "Sub_Deal_Talent";


        //ADDED BY BHAVESH ON 30 DEC FOR THE NEW CHANGE IN VIACOM 18 , AS ADDING 2 NEW DEAL TYPES IN THE SYSTEM, i.e documentry & shorflims
        public const int Title_Type_Documentary = 9; //i.e. deal_type_code from Deal_Type Table 
        public const int Title_Type_ShortFilm = 10; //i.e. deal_type_code from Deal_Type Table 


        //Added By Prashant on 11 July 2012 For amort shows
        public const string Amort_Cost_Type_Wise = "CT";
        public const string Amort_Cost_Type_And_Channel_Wise = "CTC";
        public const string No_Recopument_Type = "No Recopument";


        //For Title Release Type
        public static ArrayList arrReleaseType()
        {
            ArrayList arrReleaseType = new ArrayList();
            arrReleaseType.Add(new AttribValue("WorldWide", ReleaseType_WorldWide));
            arrReleaseType.Add(new AttribValue("Territory", ReleaseType_Territory));  //Terrotory Group
            arrReleaseType.Add(new AttribValue("Country", ReleaseType_Country));    //Individual Terrotory
            return arrReleaseType;
        }

        public const string ReleaseType_WorldWide = "W";
        public const string ReleaseType_Territory = "T";
        public const string ReleaseType_Country = "C";

        //Constant FOR View
        public const string ViewNormal = "N";
        public const string ViewDraftLfa = "D";
        public const string ViewLfaFinalized = "F";
        public const string ViewApproveReject = "AR";
        public const string ViewAmort = "AMORT";
        public const string ViewCloseDeamMovie = "C";
        //FOR Upload File Size
        public const int fileSizeInBytes = 20971520;   //i.e. 20 MB.

        //To show old version after ammendment
        public string IsShowVersion = "N";

        #region --- DEAL WORK FLOW RELATED CONSTANTS ----

        public const string DateFormat = "dd/MM/yyyy";
        public const string DateFormat_Display = "dd-MMM-yyyy";

        public const string deal_WFDone_Yes = "Y";
        public const string deal_WFDone_No = "N";

        public const string deal_attachWorkFlow_Yes = "Y";
        public const string deal_attachWorkFlow_No = "N";

        public const string dealWorkFlowStatus_New = "N";
        public const string dealWorkFlowStatus_Edit = "E";
        public const string dealWorkFlowStatus_SendForAuth = "S";
        public const string dealWorkFlowStatus_Approved = "A";
        public const string dealWorkFlowStatus_Declined = "R";
        public const string dealWorkFlowStatus_Waiting = "W";
        public const string dealWorkFlowStatus_ReSendForAuth = "RS";
        public const string dealWorkFlowStatus_RightsPending = "RP";
        public const string dealWorkFlowStatus_RightsAdded = "RA";
        public const string dealWorkFlowStatus_ReSendForAuth_MovieClose = "RC";
        public const string dealWorkFlowStatus_Declined_for_close_Movie = "RD";

        public const int deal_WFZeroLevel = 0;
        //Constant for Module Status History
        public const string dealWorkFlowStatus_Created = "C";
        public const string dealWorkFlowStatus_Ammended = "AM";

        //--------Define Autogenerate Number Formats------------
        public const string dealNoFormat = "D-{year}-{no}";
        public const string dealVersionFormat = "VN{no}";
        public const string dealMOvRightGroupNoFormat = "G-{year}-{no}";
        public const string dealEpisodeFormat = "Episode-{no}";

        #endregion
        #region-----Applied For CBFC Related CONSTANTS-----------
        public const string serviceType_Normal = "N";
        public const string serviceType_Emergency = "E";
        //-----For is_applied_reapplied Column-----------
        public const string cbfcApplied = "A";
        public const string cbfcReApplied = "R";
        //---//For is_applied_reapplied Column-----------
        public const string CBFCObtained_Yes = "Y";
        public const string CBFCObtained_No = "N";
        public const string CBFCApplied_Yes = "Y";
        public const string CBFCApplied_No = "N";
        public const string CBFCType_Obtain = "obt";
        public const string CBFCType_ReApply = "rply";
        public const string CBFCType_Apply = "aply";
        //-----For status Column-----------
        public const string CBFCStatus_Applied = "A";
        public const string CBFCStatus_ReApplied = "RA";
        public const string CBFCStatus_Declined = "OD";
        public const string CBFCStatus_Accepted = "OA";
        public const string CBFCStatus_Deactivated = "D";
        public const string CBFCStatus_Rejected = "R";

        public const string LENGTH_TYPE_METER = "MTR";
        public const string LENGTH_TYPE_MINUTE = "MIN";
        public const string LENGTH_TYPE_NA = "NA";

        public const string LENGTH_TYPE_MTR_Text = "Meter";
        public const string LENGTH_TYPE_MIN_Text = "Minute";
        public const string LENGTH_TYPE_NA_Text = "NA";

        //---//For status Column-----------
        //-----For is_active Column--------
        public const string CBFCIsActive_Yes = "Y";
        public const string CBFCIsActive_No = "N";
        public const string CBFCApplied_Lib = "CA";
        public const string CBFCObtained_Lib = "CO";

        public const string CBFCStatus_Applied_Text = "Applied";
        public const string CBFCStatus_ReApplied_Text = "Re-Applied";
        public const string CBFCStatus_Declined_Text = "Obtained but re-applicatopn required";
        public const string CBFCStatus_Accepted_Text = "Obtained";
        public const string CBFCStatus_Deactivated_Text = "D";
        public const string CBFCStatus_Rejected_Text = "Rejected";
        #endregion
        public const string errFK = "FOREIGN";  //--To check FK Constraint error using #547
        public static ArrayList arrLengthType()
        {
            ArrayList arrLenType = new ArrayList();

            arrLenType.Add(new AttribValue("Minute", "MIN"));
            arrLenType.Add(new AttribValue("Meter", "MTR"));

            return arrLenType;
        }
        public static ArrayList GetArrCBFCServiceType()
        {
            ArrayList arrSerType = new ArrayList();
            arrSerType.Add(new AttribValue("Normal", "N"));
            arrSerType.Add(new AttribValue("Emergency", "E"));
            return arrSerType;
        }
        public static string GetCBFCAppliedStatus(string status)
        {
            string strCBFCStatus = "";
            switch (status)
            {
                case CBFCStatus_Applied:
                    strCBFCStatus = "Applied";
                    break;
                case CBFCStatus_ReApplied:
                    strCBFCStatus = "Re-Applied";
                    break;
                case CBFCStatus_Declined:
                    strCBFCStatus = "Obtained but reapplication required";
                    break;
                case CBFCStatus_Accepted:
                    strCBFCStatus = "Obtained and accepted";
                    break;
                case CBFCStatus_Rejected:
                    strCBFCStatus = CBFCStatus_Rejected_Text;
                    break;
                default:
                    strCBFCStatus = status;
                    break;
            }
            return strCBFCStatus;
        }

        public static string getDeleteMsg(string moduleName, string tblName)
        {
            string refModuleName = "";
            refModuleName = getRefModuleName(tblName);
            string msg = "Cannot delete" + " \\'" + moduleName + "\\' " + "record, as its reference exists in" + " \\'"
                        + refModuleName + "\\'";
            return msg;
        }
        public static string GetDealWorkFlowStatus(string status, int approverCode, out string GroupName)
        {

            string[] arrStr = status.Split(new string[] { "~" }, StringSplitOptions.None);
            status = arrStr[0].ToString();
            string strDealStatus = "";
            GroupName = "";
            switch (status)
            {
                case dealWorkFlowStatus_New:
                    strDealStatus = "Rights Pending";
                    break;
                case dealWorkFlowStatus_SendForAuth:
                    strDealStatus = "Waiting for authorization";
                    break;
                case dealWorkFlowStatus_Waiting:
                    strDealStatus = "Waiting for authorization";
                    break;
                case dealWorkFlowStatus_Approved:
                    strDealStatus = "Approved";
                    break;
                case dealWorkFlowStatus_Declined:
                    strDealStatus = "Declined";
                    break;
                case dealWorkFlowStatus_ReSendForAuth:
                    strDealStatus = "Re sent for authorization";
                    break;
                case dealWorkFlowStatus_Declined_for_close_Movie:
                    strDealStatus = "Declined for close movie";
                    break;
            }
            if (approverCode > 0)
            {
                /*
                Users objApprover = new Users();
                objApprover.IntCode = approverCode;
                objApprover.FetchDeep();
                GroupName = " from " + objApprover.objSecurityGroup.securitygroupname;
                 * //comented by tushar , approverCode is security_group_code
                */
                SecurityGroup objSecurityGroup = new SecurityGroup();
                objSecurityGroup.IntCode = approverCode;
                objSecurityGroup.Fetch();
                GroupName = " from " + objSecurityGroup.securitygroupname;
            }

            return strDealStatus;
        }
        public static string GetDealWorkFlowStatusForStatusHistory(string status, int approverCode, out string GroupName)
        {
            string[] arrStr = status.Split(new string[] { "~" }, StringSplitOptions.None);
            string strDealStatus = "";
            status = arrStr[0].ToString();
            GroupName = "";

            switch (status)
            {
                case dealWorkFlowStatus_New:
                    strDealStatus = "Rights Pending";
                    break;
                case dealWorkFlowStatus_SendForAuth:
                    strDealStatus = "Sent for authorization";
                    break;
                case dealWorkFlowStatus_Waiting:
                    strDealStatus = "Waiting for authorization";
                    break;
                case dealWorkFlowStatus_Approved:
                    strDealStatus = "Approved";
                    break;
                case dealWorkFlowStatus_Declined:
                    strDealStatus = "Declined";
                    break;
                case dealWorkFlowStatus_ReSendForAuth:
                    strDealStatus = "Re sent for authorization";
                    break;
                case dealWorkFlowStatus_Created:
                    strDealStatus = "Created";
                    break;
                case dealWorkFlowStatus_Ammended:
                    strDealStatus = "Ammended";
                    break;
                case dealWorkFlowStatus_ReSendForAuth_MovieClose:
                    strDealStatus = "sent for authorization for movie close";
                    break;
                case dealWorkFlowStatus_Declined_for_close_Movie:
                    strDealStatus = "Declined for movie close";
                    break;
            }

            if (approverCode > 0)
            {
                /*
                Users objApprover = new Users();
                objApprover.IntCode = approverCode;
                objApprover.FetchDeep();
                GroupName = " from " + objApprover.objSecurityGroup.securitygroupname;
                 * //comented by tushar , approverCode is security_group_code
                */
                SecurityGroup objSecurityGroup = new SecurityGroup();
                objSecurityGroup.IntCode = approverCode;
                objSecurityGroup.Fetch();
                GroupName = " from " + objSecurityGroup.securitygroupname;
            }

            return strDealStatus;
        }
        public static string getForeignKeyMsg(string moduleName, string tblName, bool isAdd)
        {
            string refModuleName = "";
            string usrAction = "save";

            if (!isAdd)
            {
                usrAction = "update";
            }

            refModuleName = getRefModuleName(tblName);
            string msg = (string)System.Web.HttpContext.GetGlobalResourceObject("SRMS", "msgFKError");
            msg = msg.Replace("{action}", usrAction).Replace("{moduleName}", moduleName).Replace("{refModuleName}", refModuleName);
            return msg;
        }
        public static string getRefModuleName(string tblName)
        {
            string refModuleName = "";

            switch (tblName.ToUpper().Trim())
            {
                case "DBO.COST_TYPE":
                    refModuleName = "Cost Type Master";
                    break;
                case "DBO.AWARD":
                    refModuleName = "Award Master";
                    break;
                case "DBO.BANK":
                    refModuleName = "Bank Master";
                    break;
                case "DBO.CBFC_COST":
                    refModuleName = "CBFC Cost";
                    break;
                case "DBO.CBFC_RATING":
                    refModuleName = "CBFC Rating Master";
                    break;
                case "DBO.COMPANY_INFO":
                    refModuleName = "NDTV Info";
                    break;
                case "DBO.CURRENCY":
                    refModuleName = "Currency Master";
                    break;
                case "DBO.CURRENCY_EXCHANGE_RATE":
                    refModuleName = "Currency Master";
                    break;
                case "DBO.DEAL_MEMO":
                    refModuleName = "Deal Memo";
                    break;
                case "DBO.DEAL_MEMO_TERRITORY":
                    refModuleName = "Deal Memo-Territory";
                    break;
                case "DBO.DEAL_MOVIE":
                    refModuleName = "Deal Memo-Movie";
                    break;
                case "DBO.DEAL_MOVIE_MATERIAL_TYPE":
                    refModuleName = "Deal Memo-Movie";
                    break;
                case "DBO.DEAL_MOVIE_COST_PAYMENT_TERMS":
                    refModuleName = "Deal Memo-Movie";
                    break;
                case "DBO.DEAL_MOVIE_RIGHTS":
                    refModuleName = "Deal Memo-Movie Rights";
                    break;
                case "DBO.DEAL_MOVIE_RIGHTS_BLACKOUT":
                    refModuleName = "Deal Memo-Movie Rights";
                    break;
                case "DBO.DEAL_MOVIE_RIGHTS_HOLDBACK":
                    refModuleName = "Deal Memo-Movie Rights";
                    break;
                case "DBO.DEAL_MOVIE_RIGHTS_TERRITORY":
                    refModuleName = "Deal Memo-Movie Rights";
                    break;
                case "DBO.ENTITY_AGREEMENT":
                    refModuleName = "Entity Agreement";
                    break;
                case "DBO.ENTITY_Bank":
                    refModuleName = "Entity Bank";
                    break;
                case "DBO.ENTITY_CONTACT":
                    refModuleName = "Entity Contact";
                    break;
                case "DBO.ENTITY_GENERAL":
                    refModuleName = "Entity Master";
                    break;
                case "DBO.ENTITY_ROLE":
                    refModuleName = "Entity Role";
                    break;
                case "DBO.EXPENSE_TYPE":
                    refModuleName = "Expense Type Master";
                    break;
                case "DBO.FESTIVAL":
                    refModuleName = "Festival Master";
                    break;
                case "DBO.GROUP_MODULES":
                    refModuleName = "Group Modules";
                    break;
                case "DBO.GROUP_RIGHTS":
                    refModuleName = "Group Rights";
                    break;
                case "DBO.LANGUAGE":
                    refModuleName = "Language Master";
                    break;
                case "DBO.MATERIAL_NOTICE":
                    refModuleName = "Material Notice";
                    break;
                case "DBO.MATERIAL_MEDIUM":
                    refModuleName = "Material Medium Master";
                    break;
                case "DBO.MATERIAL_TYPE":
                    refModuleName = "Material Type Master";
                    break;
                case "DBO.MODULE_STATUS_HISTORY":
                    refModuleName = "Module Status History";
                    break;
                case "DBO.MODULE_WORKFLOW_DETAIL":
                    refModuleName = "Module Workflow Detail";
                    break;
                case "DBO.MOVIE":
                    refModuleName = "Movie Collection";
                    break;
                case "DBO.MOVIE_AWARD":
                    refModuleName = "Movie Award";
                    break;
                case "DBO.MOVIE_GENRE":
                    refModuleName = "Movie Genre Master";
                    break;
                case "DBO.MOVIE_LANGUAGE":
                    refModuleName = "Movie Language";
                    break;
                case "DBO.MOVIE_GENRE_DETAIL":
                    refModuleName = "Movie Genre Detail";
                    break;
                case "DBO.MOVIE_RELEASES":
                    refModuleName = "Movie Releases";
                    break;
                case "DBO.MOVIE_STARCAST":
                    refModuleName = "Movie Star Cast";
                    break;
                case "DBO.MOVIE_TERRITORY":
                    refModuleName = "Movie Territory";
                    break;
                case "DBO.PAYMENT_TERMS":
                    refModuleName = "Payment Terms Master";
                    break;
                case "DBO.PAYMENT_TERMS_MODULE_RIGHT":
                    refModuleName = "Module Payment Terms";
                    break;
                case "DBO.PAYMENT_TAX":
                    refModuleName = "Payment Tax";
                    break;
                case "DBO.PERIODIC_TAX":
                    refModuleName = "Periodic Tax";
                    break;
                case "DBO.PROCESS_TYPE":
                    refModuleName = "Process Type Master";
                    break;
                case "DBO.RATE_CARD_CBFC_AGENT":
                    refModuleName = "CBFC Agent Rate Card";
                    break;
                case "DBO.RATE_CARD_CNF_AGENT":
                    refModuleName = "CNF Agent Rate Card";
                    break;
                case "DBO.RATE_CARD_STUDIO":
                    refModuleName = "Studio Rate Card";
                    break;
                case "DBO.RIGHTS_TYPE":
                    refModuleName = "Rights Type Master";
                    break;
                case "DBO.ROLE":
                    refModuleName = "Role Master";
                    break;
                case "DBO.SECURITY_GROUP":
                    refModuleName = "Security Group Master";
                    break;
                case "DBO.SYSTEM_MODULE":
                    refModuleName = "System Module";
                    break;
                case "DBO.SYSTEM_MODULE_RIGHT":
                    refModuleName = "System Module Rights";
                    break;
                case "DBO.SYSTEM_RIGHT":
                    refModuleName = "System Rights";
                    break;
                case "DBO.TALENT":
                    refModuleName = "Talent Master";
                    break;
                case "DBO.TALENT_ROLE":
                    refModuleName = "Talent Master";
                    break;
                case "DBO.TAX_TYPE":
                    refModuleName = "Tax Type Master";
                    break;
                case "DBO.TERRITORY":
                    refModuleName = "Territory Master";
                    break;
                case "DBO.USER_MASTER":
                    refModuleName = "User Master";
                    break;
                case "DBO.WORKFLOW":
                    refModuleName = "Workflow Master";
                    break;
                case "DBO.WORKFLOW_MODULE":
                    refModuleName = "Assign Workflow";
                    break;
                case "DBO.WORKFLOW_MODULE_ROLE":
                    refModuleName = "Assign Workflow";
                    break;
                case "DBO.WORKFLOW_ROLE":
                    refModuleName = "Workflow Master";
                    break;
                case "DBO.PAYMENT_DETAIL":
                    refModuleName = "Payment";
                    break;
                case "DBO.PAYMENT":
                    refModuleName = "Payment";
                    break;
                case "DBO.DISPATCH_ADVICE_DETAIL":
                    refModuleName = "Dispatch Advice";
                    break;
                case "DBO.DISPATCH_ADVICE":
                    refModuleName = "Dispatch Advice";
                    break;
                case "DBO.CUSTOME_DUTY":
                    refModuleName = "Custom Duty";
                    break;
                case "DBO.CUSTOME_DUTY_DETAIL":
                    refModuleName = "Custom Duty";
                    break;
                case "DBO.PAYMENT_INTIMATION":
                    refModuleName = "Payment Intimation";
                    break;
                case "DBO.AMORT_RULE":
                    refModuleName = "Amort Rule";
                    break;
                case "DBO.AMORT_RULE_MONTH":
                    refModuleName = "Amort Rule Month";
                    break;
                case "DBO.AMORT_RULE_DEAL_MOVIE":
                    refModuleName = "Amort Rule Deal Movie";
                    break;
            }

            return refModuleName;
        }
        public static void getLableWithToolTip(Label lbl, string val, int len)
        {
            if (val != null && len > 0)
            {
                lbl.Text = (val.Length > len) ? val.Substring(0, len) + " ..." : val;
                lbl.CssClass = (val.Length > len) ? "checkbox" : "";
                lbl.ToolTip = (val.Length > len) ? val : "";
            }
        }
        public static int GetSortColumnIndex(GridView gv, string sortExp)
        {
            foreach (DataControlField field in gv.Columns)
            {
                if (field.SortExpression == sortExp)
                {
                    return gv.Columns.IndexOf(field);
                }
            }
            return -1;
        }
        public static void AddSortImage(int columnIndex, GridViewRow headerRow, string sortDirection)
        {
            Image sortImage = new Image();

            if (sortDirection == GlobalParams.sortDirectionAsc)
            {
                sortImage.ImageUrl = GlobalParams.sortImageUrlAsc;
                sortImage.AlternateText = GlobalParams.sortingImgAltTextAsc;
            }
            else
            {
                sortImage.ImageUrl = GlobalParams.sortImageUrlDesc;
                sortImage.AlternateText = GlobalParams.sortingImgAltTextDesc;
            }

            headerRow.Cells[columnIndex].Controls.Add(sortImage);
        }
        //Yogesh Added-------------------------------------


        #region CONSTANTS

        public const string RECORD_STATUS_CHANGED = "C";
        public const string RECORD_STATUS_LOCKED = "L";
        public const string RECORD_STATUS_DELETED = "D";
        public const string RECORD_STATUS_UPDATABLE = "U";

        #endregion
        public const string msgAdd = "Record added successfully";
        public const string msgUpdate = "Record updated successfully";
        public const string msgDelete = "Record deleted successfully";
        public const string msgSearch = "Please enter search criteria";
        public const string msgDuplicate = "already exists";
        public const string msgActivate = "activated successfully";
        public const string msgDeactivate = "deactivated successfully";
        public const string msgAskActivate = "Are you sure, you want to activate this record?";
        public const string msgAskDeactivate = "Are you sure, you want to deactivate this record?";
        public const string msgAskDelete = "Are you sure, you want to delete this record?";
        public const string msgAskReleaseLock = "Are you sure, you want to release lock of this user?";
        public const string msgEnter = "Please enter";
        public const string msgSelect = "Please Select";
        public const string msgEnterValid = "Enter Valid";
        public const string msgCharLeft = "characters left...";
        public const string msgEmailExpression = "Please enter valid email address";
        public const string msgConfirmPwd = "Entered and confirm passwords do not match";
        public const string msgSecGrpAssignModuleRight = "Please assign at least one Module/Right";
        public const string msgRegion = "Region";
        public const string msgReleaseLock = "User released successfully";
        public const string msgCannotDeactivate = "Cannot deactivate user";
        public const string msgchkconfirmpassNew = "New password and confirm password should be same";
        public const string msgchkconfirmpassOld = "New password and old password cannot be same";
        public const string msgPassChangeConf = "Password changed successfully";
        public const string msgPassIncorr = "Incorrect Old Password";
        public const string msgPassTocorr = "Please change your password, it should not contain your login/name";
        public const string msgIncorrlogin = "Wrong login name.";
        public const string msgIncorrEmail = "Wrong email address.";
        public const string msgSecGrpRefExist = "Cannot delete : Security Group reference exists";
        public const string msgAskClose = "Are you sure, you want to close this deal movie ?";
        public const string msgCompareStartEndDays = "End day should be greater than start day";
        public const string msgNA = "NA";
        public const string msgNO = "No";
        public const string msgCountryTerritory = "Please select region";
        public const string msgRecordLockedByUser = "This record is currently used by {USERNAME}";

        /* Added By Prashant on 10 May 2011	*/
        public const string msgCombinationAlreadyUsed = "Following Combination of movie, platform and country/territory already used.";
        public const string msgInvalidRightPeriod = "Invalid Right Period For Selected Movie, Platform and Territory Combination. Acquisition rights are as follows.";
        public const string msgInvalidRightPeriod_Clone = "Invalid Right Period For Selected Movie, Platform and Territory Combination.";
        public const string msgSublicensingRightsUnavailable = "Sublicensing rights for following Movie/Platform/Territory in given right period is not available";
        public const string msgCombinationAlreadyUsed_Parallel_Deal = "Following Combination of movie, platform and country/territory already used."
        + " If you want to add parallel deal please add run definition first. Or parallel deal not allow in this condition.";
        /* End */

        public const string msgAskCloseDeal = "Are you sure, you want to close this deal?";
        public const string msgCloseDeal = "Deal closed successfully";
        public const string msgAskReOpenDeal = "Are you sure, you want to re-open this deal?";
        public const string msgReOpenDeal = "Deal re-opened successfully";

        /* Upload   */
        public const int VendorUpload = 71;
        public const int CustomerUpload = 68;
        public const int InternalOrder = 83;
        public const int ScheduleUpload = 87;
        public const int AsRunUpload = 88;
        public const int HouseIDUpload = 95;
        /* End */

        // For EX public const string msgAddTapeInv = "Tape Inventory " + msgAdd;

        #region Constant for deal

        public const string Deal_General = "GENERAL";
        public const string Deal_Rights = "RIGHTS";
        public const string Deal_Ancillary = "ANCILLARY";
        public const string Deal_PushBack = "PUSHBACK";
        public const string Deal_Cost = "COST";
        public const string Deal_Royalty = "Royalty";
        public const string Deal_LinkData = "LINKDATA";
        public const string Deal_Amort = "AMORT";
        public const string Deal_Attachment = "ATTACHMENT";
        public const string Deal_Content = "CONTENT";
        public const string Deal_PaymentTerms = "PAYMENTTERMS";
        public const string Deal_Sports = "SPORTSRIGHTS";
        public const string Deal_Sports_Ancillary = "SPORTSANCILLARY";
        public const string Deal_Material = "MATERIAL";
        public const string Deal_Status_History = "STATUSHISTORY";
        public const string Deal_Budget = "BUDGET";
        public const string Deal_Movie_Run = "MovieRUN";
        public const string DealList = "DEALLIST";
        public const string ApprovalList = "APPROVAL";
        public const string DealApproved = "Deal approved successfully";
        public const string DealSentForAppoval = "Deal {dealno} is sent for authorization";
        public const string msgDealDeclined = "Deal rejected successfully";
        public const string DealReleased = "Deal released successfully";
        public const string DealStatuspending = "Pending";
        public const string DealStatusComplete = "Rights and Cost added ";

        public const string SynDealStatuspending = "Rights/Revenue Pending";
        public const string SynDealStatusComplete = "Rights and Revenue added ";

        public const string Acq_Deal_Rights = "Acq_Deal_Rights";
        public const string Syn_Deal_Rights = "Syn_Deal_Rights";
        public const string Syn_Deal_Rights_RHB = "Syn_Deal_Rights_RHB";
        public const string Syn_Deal_Revenue = "Syn_Deal_Revenue";
        public const string Acq_Deal_Run = "Acq_Deal_Run";
        public const string Syn_Deal_Run = "Syn_Deal_Run";
        #endregion

        public void CreateMessageAlert(Page objPage, string alertMSG)
        {
            Label lblMessage = (Label)objPage.FindControl("lblMessage");
            lblMessage.Text = alertMSG;
            ModalPopupExtender MPExtAlert = (ModalPopupExtender)objPage.FindControl("MPExtAlert");
            MPExtAlert.Show();
        }

        public void CreateMessageAlert(Page objPage, Control ctl, string alertMSG)
        {
            Label lblMessage = (Label)objPage.FindControl("lblMessage");
            lblMessage.Text = alertMSG;
            ModalPopupExtender MPExtAlert = (ModalPopupExtender)objPage.FindControl("MPExtAlert");
            MPExtAlert.Show();
            MPExtAlert.OnOkScript = "controlToFocus='" + ctl.ClientID + "';SetFocus();";
        }

        public static void HideRightsButton(ArrayList arrUserRights, int ModuleCode, ArrayList arrParams, bool IsSuperadmin, int Security_Group_Code)
        {
            try
            {
                if (!IsSuperadmin)
                {
                    if (arrUserRights == null)
                    {
                        SecurityGroup ObjSecGr = new SecurityGroup();
                        ObjSecGr.IntCode = Security_Group_Code;
                        arrUserRights = ObjSecGr.getArrUserRightCodes(ObjSecGr.IntCode, ModuleCode, "");
                    }

                    if (arrParams != null && arrParams.Count > 0)
                    {
                        for (int i = 0; i < arrParams.Count; i++)
                        {
                            AttribValue objAttrib = (AttribValue)arrParams[i];
                            int iRightCode = Convert.ToInt32(objAttrib.Val);

                            if (arrUserRights.Contains(iRightCode))
                                makeBtnVisibleTrue(objAttrib.Attrib);
                            else
                                makeBtnVisibleFalse(objAttrib.Attrib);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public static void makeBtnVisibleFalse(object objBtn)
        {
            switch (objBtn.GetType().ToString().Trim())
            {
                case "System.Web.UI.HtmlControls.HtmlInputButton":
                    ((HtmlInputButton)objBtn).Visible = false;
                    break;
                case "System.Web.UI.HtmlControls.HtmlButton":
                    ((HtmlButton)objBtn).Visible = false;
                    break;
                case "System.Web.UI.WebControls.Button":
                    ((Button)objBtn).Visible = false;
                    break;
                case "System.Web.UI.WebControls.TextBox":
                    ((TextBox)objBtn).Visible = false;
                    break;
                case "System.Web.UI.HtmlControls.HtmlAnchor":
                    ((HtmlAnchor)objBtn).Visible = false;
                    break;
                case "System.Web.UI.HtmlControls.HtmlGenericControl":
                    ((HtmlGenericControl)objBtn).Visible = false;
                    break;
            }
        }

        public const string CHANNEL_WISE = "C";
        public const string CHANNEL_WISE_SHARED = "CS";
        public const string CHANNEL_WISE_ALL = "A";
        public const string CHANNEL_SHARED = "S";
        public const string CHANNEL_NA = "N";

        public static ArrayList runDefinationArrayList()
        {
            ArrayList arrList = new ArrayList();
            AttribValue obj = new AttribValue("Channel Wise", CHANNEL_WISE); arrList.Add(obj);
            //obj = new AttribValue("Channel Wise (Min / Max)", CHANNEL_WISE_SHARED); arrList.Add(obj);
            //obj = new AttribValue("All Channel - 1 Run / Channel ", CHANNEL_WISE_ALL); arrList.Add(obj);
            obj = new AttribValue("Shared ", CHANNEL_SHARED); arrList.Add(obj);
            obj = new AttribValue("NA", CHANNEL_NA); arrList.Add(obj);

            return arrList;
        }
        public static ArrayList yesNoArrayList()
        {
            ArrayList arrList = new ArrayList();
            AttribValue obj = new AttribValue("YES", YesNo.Y.ToString()); arrList.Add(obj);
            obj = new AttribValue("NO", YesNo.N.ToString()); arrList.Add(obj);
            return arrList;
        }
        public static ArrayList rightPeriodArrayList()
        {
            ArrayList arrList = new ArrayList();
            AttribValue obj = new AttribValue("Year Based", "Y"); arrList.Add(obj);
            obj = new AttribValue("Perpetuity", "U"); arrList.Add(obj);
            obj = new AttribValue("Milestone", "M"); arrList.Add(obj); // Added by Dada on May 21, 2012 as it is required for Viacom
            return arrList;
        }

        public static ArrayList daysArrayList()
        {
            ArrayList arrList = new ArrayList();
            AttribValue obj = new AttribValue(WeekDays.Mon.ToString(), (int)WeekDays.Mon); arrList.Add(obj);
            obj = new AttribValue(WeekDays.Tue.ToString(), (int)WeekDays.Tue); arrList.Add(obj);
            obj = new AttribValue(WeekDays.Wed.ToString(), (int)WeekDays.Wed); arrList.Add(obj);
            obj = new AttribValue(WeekDays.Thr.ToString(), (int)WeekDays.Thr); arrList.Add(obj);
            obj = new AttribValue(WeekDays.Fri.ToString(), (int)WeekDays.Fri); arrList.Add(obj);
            obj = new AttribValue(WeekDays.Sat.ToString(), (int)WeekDays.Sat); arrList.Add(obj);
            obj = new AttribValue(WeekDays.Sun.ToString(), (int)WeekDays.Sun); arrList.Add(obj);
            return arrList;
        }
        public static void makeBtnVisibleTrue(object objBtn)
        {
            switch (objBtn.GetType().ToString().Trim())
            {
                case "System.Web.UI.HtmlControls.HtmlInputButton":
                    ((HtmlInputButton)objBtn).Visible = true;
                    break;
                case "System.Web.UI.HtmlControls.HtmlButton":
                    ((HtmlButton)objBtn).Visible = true;
                    break;
                case "System.Web.UI.WebControls.Button":
                    ((Button)objBtn).Visible = true;
                    break;
                case "System.Web.UI.WebControls.TextBox":
                    ((TextBox)objBtn).Visible = true;
                    break;
                case "System.Web.UI.HtmlControls.HtmlAnchor":
                    ((HtmlAnchor)objBtn).Visible = true;
                    break;
                case "System.Web.UI.HtmlControls.HtmlGenericControl":
                    ((HtmlGenericControl)objBtn).Visible = true;
                    break;
            }
        }
        public static bool convertMonthStrToNum(out string strDate, string strDateIn)
        {
            switch (strDateIn.ToLower())
            {
                case "jan":
                    strDate = "01";
                    break;
                case "feb":
                    strDate = "02";
                    break;
                case "mar":
                    strDate = "03";
                    break;
                case "apr":
                    strDate = "04";
                    break;
                case "may":
                    strDate = "05";
                    break;
                case "jun":
                    strDate = "06";
                    break;
                case "jul":
                    strDate = "07";
                    break;
                case "aug":
                    strDate = "08";
                    break;
                case "sep":
                    strDate = "09";
                    break;
                case "oct":
                    strDate = "10";
                    break;
                case "nov":
                    strDate = "11";
                    break;
                case "dec":
                    strDate = "12";
                    break;
                default:
                    strDate = "";
                    return false;
            }

            return true;
        }
        public static SqlTransaction DeleteChild(ArrayList arr, SqlTransaction sqlTrans)
        {
            //for (int i = 0; i < arr.Count; i++)
            if (arr.Count > 0)
            {
                Persistent objP = (Persistent)arr[0];

                if (true)
                {
                    if (sqlTrans != null)
                        objP.SqlTrans = sqlTrans;
                    else
                        objP.IsBeginningOfTrans = true;
                    objP.IsDeleted = true;
                }
                //else if (i > 0)
                //{
                //    objP.IntCode = ((Persistent)arr[i]).IntCode;
                //    objP.IsBeginningOfTrans = false;
                //}
                objP.Save();
                sqlTrans = (SqlTransaction)objP.SqlTrans;
            }
            return (SqlTransaction)sqlTrans;
        }

        public static Persistent createInstance(string strType)
        {
            Persistent obj;
            obj = (Persistent)System.Activator.CreateInstance(Type.GetType(strType));
            return obj;
        }

        public const string AmortRulePeriodAmongRights = "A";
        public const string AmortRulePeriodDefineManually = "M";
        public const string AmortRulePeriodAmongRightsText = "Right Period";

        public static ArrayList arrUploadWebformDisplay()
        {
            ArrayList arrUP = new ArrayList();
            /*RevenueForTheatre Upload*/
            arrUP.Add(new AttribValueExcelUpload("Revenue For Theatre", "uploadRevenueForTheatre.xls", "Distributor,Theater,City,Movie,Movie Code,From Date,To Date,Days,Show Per Day,No Of Seat,Ticket Rate,S.T,Ent.Tax,Net,Revenue", "RT", new UploadRevenueDataTheatre()));
            arrUP.Add(new AttribValueExcelUpload("Revenue For Home Video", "uploadRevenueForHomeVideo.xls", "Distributor,Movie,Movie Code,From Date,To Date,Gross,Tax,Net,Copy,Total Revenue", "RH", new UploadRevenueDataHomeVideo()));

            //---- For Customer Vendor Upload --Arraylist Index 2
            arrUP.Add(new AttribValueExcelUpload("CustomerVendor", "CustomerVendor.xls", "Distributor,Movie,Movie Code,From Date,To Date,Gross,Tax,Net,Copy,Total Revenue", "C", new UploadRevenueDataHomeVideo()));

            //---- For Schedule Upload --Arraylist Index 3
            arrUP.Add(new AttribValueExcelUpload("Schedule Upload", "UploadSchedule.txt", "Program Episode Title,Program Episode Number,Program Title,Schedule Item Date Time,Schedule Item Duration,Scheduled Version House Number List", "S", new UploadFile()));

            //---- For As Run Upload --Arraylist Index 4
            arrUP.Add(new AttribValueExcelUpload("AsRun Upload", "UploadAsRun.txt", "ON-AIR,DATE/TIME,ID,S,TITLE,DURATION,STATUS,DEVICE,CH,RECONCILE,TYPE,SEC", "A", new UploadFile()));

            //---- For House ID Upload --Arraylist Index 5
            arrUP.Add(new AttribValueExcelUpload("House ID Upload", "Movies.xls", "House #,Program,Episode Title,Episode,Type,Media,SAP,CC,DVI,Live,Duration", "HU", new UploadFile()));

            //---- For PAF Upload --Arraylist Index 6
            arrUP.Add(new AttribValueExcelUpload("PAF Upload", "PAF.xls", "Master PAF No.,Sub PAF No.,Date of Creation,Show Name,Type of Program,Nature of Program,Department Code,Channel Code,Cost Type,Amount,Service Tax,Amount,Vat Amount,Total Amount,Amount Including VAT", "PAF", new UploadFile()));

            return arrUP;
        }

        public const int formForUpload_ScheduleUpload = 3;
        public const int formForUpload_AsRunUpload = 4;
        public const int formForUpload_HouseIDUpload = 5;
        public const int formForUpload_PAFUpload = 6;


        /* === Migrate Cost === */

        public static ArrayList arrMigrateCostUploadWebformDisplay()
        {
            ArrayList arrMigrateCost = new ArrayList();
            arrMigrateCost.Add(new AttribValueExcelUpload("Migrate Cost", "migrateCost.xls", "Deal Movie Cost Code,Deal Movie Code,Title,Deal Movie Cost", "Movie Cost", new MigrateCost()));
            return arrMigrateCost;
        }

        public static ArrayList arrMigrateCostUploadUpdate()
        {
            ArrayList arrMigrateCostUpdate = new ArrayList();
            arrMigrateCostUpdate.Add(new AttribValueExcelUpload("Migrate Cost", "migrateCost.xls", "Deal Movie Cost Code,Deal Movie Code,Title,Deal Movie Cost", "Movie Cost", new UploadMigrateCost()));
            return arrMigrateCostUpdate;
        }

        public static ArrayList arrMigratCostForUpload()
        {
            ArrayList arrMigratCostForUploadTemp = new ArrayList();
            //arrMigratCostForUploadTemp.Add(new AttribValueExcelUpload("Deal Movie Cost","DealMoviecost",true,true,false,null,null,true,false,999999,false,null,50,false,"deal_movie_cost_code","deal_movie_cost","deal_movie_cost",""));
            arrMigratCostForUploadTemp.Add(new AttribValueExcelUpload("Deal Movie Cost Code", "Deal Movie Cost Code", true, true, false, null, null, false, false, 0, false, null, 50, false, "deal_movie_cost_code", "deal_movie_cost", "deal_movie_cost_code", ""));
            arrMigratCostForUploadTemp.Add(new AttribValueExcelUpload("Deal Title", "Deal Title", true, false, false, null, null, false, false, 0, false, null, 50, false, null, null, null, ""));
            arrMigratCostForUploadTemp.Add(new AttribValueExcelUpload("Deal Movie Cost", "Deal Movie Cost", true, true, false, null, null, false, true, 999999999, false, null, 50, false, null, null, null, ""));
            return arrMigratCostForUploadTemp;
        }

        /* === Migrate Cost === */

        /* === Migrate House ID === */

        public static ArrayList arrMigrateHouseIDUploadWebformDisplay()
        {
            ArrayList arrMigrateHouseID = new ArrayList();
            arrMigrateHouseID.Add(new AttribValueExcelUpload("Migrate House ID", "migrateHouseID.xls", " Title Name,Standard,UK/US Standard " +
                                 ",UK/US Standard Sub title - Edited,Prime Time,Shorter Version (timings),Edited Version " +
                                 ",Edited Version (Song),UK /US Non Prime Time,UK/US Eng Sub Title,UK/US Post 20:00 pm,US/UK Pime time edited,US Standard,UK/US Sub Title Post 21:00 pm,UK/US Sub Title Post 20:00 pm ,UK/US Post 22:00 pm", "Movie House ID", new MigrateHouseID()));

            return arrMigrateHouseID;
        }

        public static ArrayList arrMigrateHouseIDUploadUpdate()
        {
            ArrayList arrMigrateHouseID = new ArrayList();
            arrMigrateHouseID.Add(new AttribValueExcelUpload("Migrate House ID", "migrateHouseID.xls", " Title Name,Standard,UK/US Standard " +
                                 ",UK/US Standard Sub title - Edited,Prime Time,Shorter Version (timings),Edited Version " +
                                 ",Edited Version (Song),UK /US Non Prime Time,UK/US Eng Sub Title,UK/US Post 20:00 pm,US/UK Pime time edited,US Standard,UK/US Sub Title Post 21:00 pm,UK/US Sub Title Post 20:00 pm ", "Movie House ID", new UploadMigrateHouseID()));

            return arrMigrateHouseID;
        }
        /* === Migrate House ID === */

        public static ArrayList arrRevenueForTheatre()
        {
            ArrayList arrRevenueForTheatreTmp = new ArrayList();
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Distributor", "DISTRIBUTOR", true, true, false, null, null, false, false, 0, false, null, 50, true, "vendor_code", "vendor", "vendor_name", ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Theater", "THEATER", true, false, false, null, null, false, false, 0, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("City", "CITY", true, false, false, null, null, false, false, 0, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Movie", "MOVIE", true, true, false, null, null, false, false, 0, false, null, 50, true, "title_code", "title", "original_title", ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Movie Code", "MOVIECODE", true, true, false, null, null, false, false, 0, false, null, 50, false, "title_code_id", "title", "title_code_id", ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("From Date", "FROMDATE", true, true, false, null, null, false, false, 0, true, "dd/MM/yyyy", 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("To Date", "TODATE", true, true, false, null, null, false, false, 0, true, "dd/MM/yyyy", 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Days", "DAYS", true, false, false, null, null, true, false, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Show Per Day", "SHOWPERDAY", true, false, false, null, null, true, false, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("No Of Seat", "NOOFSEAT", true, false, false, null, null, true, false, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Ticket RATE", "TICKETRATE", true, false, false, null, null, false, true, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("S.T", "S.T", true, false, false, null, null, false, true, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Ent.Tax", "ENT.TAX", true, false, false, null, null, false, true, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Net", "NET", true, false, false, null, null, false, true, 999999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Revenue", "REVENUE", true, true, false, null, null, false, true, 999999999, false, null, 50, false, null, null, null, ""));
            return arrRevenueForTheatreTmp;
        }
        public static ArrayList arrRevenueForHomeVideo()
        {
            ArrayList arrRevenueForHomeVideoTmp = new ArrayList();
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("Distributor", "DISTRIBUTOR", true, true, false, null, null, false, false, 0, false, null, 50, true, "vendor_code", "vendor", "vendor_name", ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("Movie", "MOVIE", true, true, false, null, null, false, false, 0, false, null, 50, true, "title_code", "title", "original_title", ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("Movie Code", "MOVIECODE", true, true, false, null, null, false, false, 0, false, null, 50, false, "title_code_id", "title", "title_code_id", ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("From Date", "FROMDATE", true, true, false, null, null, false, false, 0, true, "dd/MM/yyyy", 50, false, null, null, null, ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("To Date", "TODATE", true, true, false, null, null, false, false, 0, true, "dd/MM/yyyy", 50, false, null, null, null, ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("Gross", "GROSS", true, false, false, null, null, false, true, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("Tax", "TAX", true, false, false, null, null, false, true, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("Net", "NET", true, false, false, null, null, false, true, 999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("Copy", "COPY", true, false, false, null, null, true, false, 999999999, false, null, 50, false, null, null, null, ""));
            arrRevenueForHomeVideoTmp.Add(new AttribValueExcelUpload("Total Revenue", "TOTALREVENUE", true, true, false, null, null, false, true, 999999999, false, null, 50, false, null, null, null, ""));
            return arrRevenueForHomeVideoTmp;
        }

        //-------- Added by Dada on 30August2012
        //-------- To get value up to decimal places
        public static double LimitAmountUpToDecimal(double AmountVal)
        {
            double ResultValue = 0;
            int intLimitAmountUpToDecimal = Convert.ToInt32(ConfigurationManager.AppSettings["LimitAmountUpToDecimal"]);

            //double da = 12.878999d; 
            AmountVal = Math.Truncate(AmountVal * 1000d) / 1000d;
            return ResultValue;
        }

        //-------- Added by Dada on 30August2012
        //-------- To Round value up to decimal places
        public static double RoundItOffAmount(double AmountVal)
        {
            double ResultValue = 0;
            int RoundItOffAmount_UpToDecimal = Convert.ToInt32(ConfigurationManager.AppSettings["RoundItOffAmount_UpToDecimal"]);

            //double da = 12.878999d; 
            AmountVal = Math.Round(AmountVal, RoundItOffAmount_UpToDecimal);
            return ResultValue;
        }

        #region --- All Methods Written by Abhay ---
        //---------taking the numberValue and add comma
        //---------CountryCode Must be INR or USD 
        public static string CurrencyFormat(double money)
        {
            string cc = null;
            string OpFormat = string.Empty;

            //Commented by bhavesh on 5 th June 2013
            //try
            //{
            //    Deal objDeal = (Deal)HttpContext.Current.Session["Deal"];
            //    string strSelect = "select currency_name from Currency where currency_code = " + objDeal.CurrencyCode.ToString();
            //    cc = Convert.ToString(DatabaseBroker.ProcessScalarReturnString(strSelect));
            //}catch(Exception)
            //{}

            cc = Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["CountryCodeForCurrencyFormat"]);


            if (!string.IsNullOrEmpty(cc))
            {
                if (cc.Equals("INR"))
                {
                    OpFormat = IndianFormat(money);
                }
                else if (cc.Equals("USD"))
                {
                    OpFormat = USFormat(money);
                }
                else
                {
                    //OpFormat = money.ToString(); //------if CountryCode doesNot match so returning as is it number without any changes.
                    OpFormat = money.ToString("n2"); //------if CountryCode doesNot match so returning as is it number without any changes.
                }
            }
            return OpFormat;
        }

        //------This is for USFormat, It returns the string with addition of ' $' at the end
        private static string USFormat(double money)
        {
            string strMoney = money.ToString("#,##0");
            return strMoney;
        }

        //------This is for IndianFormat, It returns the string with addition of ' INR' at the end
        private static string IndianFormat(double money)
        {

            //string strMoney = money.ToString();
            string strMoney = money.ToString("0.00"); //Changed by Dada on 29Jan2013, becoz here decimal places were ignore earlier.
            string[] x = strMoney.Split('.');
            string x1 = x[0];
            string x3 = x.Length > 1 ? "." + x[1] : "";
            int len = x1.Length;

            if (len > 3)
            {
                string x2 = x1.Substring(len - 3, 3);
                x1 = x1.Substring(0, len - 3);
                string temp = "";
                int count = 0;

                for (int i = x1.Length - 1; i >= 0; i--)
                {
                    count++;

                    if (count % 2 == 0)
                    {
                        if (i == 0)
                            temp = x1[i] + temp;
                        else
                            temp = "," + x1[i] + temp;
                    }
                    else
                    {
                        temp = x1[i] + temp;
                    }
                }

                return temp + "," + x2 + x3;
            }
            else
            {
                return strMoney;
            }
        }

        public static double RemoveCommas(string str)
        {
            double temp = 0;

            if (str != "")
            {
                str = str.Replace(",", "");
                string[] arrStr = str.Split(' ');
                return Convert.ToDouble(arrStr[0]);
            }

            return temp;
        }
        #endregion


        public static string GetCurrentLoggedInUser()
        {
            return "";
        }

        public static ArrayList arrUploadWebformDisplay1()
        {
            ArrayList arrUP = new ArrayList();
            /*RevenueForTheatre Upload*/
            arrUP.Add(new AttribValueExcelUpload("Revenue For Theatre", "uploadRevenueForTheatre.xls", "Distributor,Theater,City,Movie,Movie Code,From Date,To Date,Days,Show Per Day,No Of Seat,Ticket Rate,S.T,Ent.Tax,Net,Revenue", "RT", new UploadRevenueDataTheatre()));
            arrUP.Add(new AttribValueExcelUpload("Revenue For Home Video", "uploadRevenueForHomeVideo.xls", "Distributor,Movie,Movie Code,From Date,To Date,Gross,Tax,Net,Copy,Total Revenue", "RH", new UploadRevenueDataHomeVideo()));

            //---- For Customer Vendor Upload --Arraylist Index 2
            arrUP.Add(new AttribValueExcelUpload("CustomerVendor", "CustomerVendor.xls", "Distributor,Movie,Movie Code,From Date,To Date,Gross,Tax,Net,Copy,Total Revenue", "C", new UploadRevenueDataHomeVideo()));

            //---- For Schedule Upload --Arraylist Index 3
            arrUP.Add(new AttribValueExcelUpload("Schedule Upload", "UploadSchedule.txt", "Program Episode Title,Program Episode Number,Program Title,Schedule Item Date Time,Schedule Item Duration,Scheduled Version House Number List", "S", new UploadFile()));

            //---- For As Run Upload --Arraylist Index 4
            arrUP.Add(new AttribValueExcelUpload("AsRun Upload", "UploadAsRun.txt", "ON-AIR,DATE/TIME,ID,S,TITLE,DURATION,STATUS,DEVICE,CH,RECONCILE,TYPE,SEC", "A", new UploadFile()));

            //---- For House ID Upload --Arraylist Index 5
            arrUP.Add(new AttribValueExcelUpload("House ID Upload", "Movies.xls", "House #,Program,Episode Title,Episode,Type,Media,SAP,CC,DVI,Live,Duration", "HU", new UploadFile()));

            arrUP.Add(new AttribValueExcelUpload("BO Revenue Upload", "uploadRevenueForBO.xls", "Movie,Movie Code,Date (dd-MMM-yyyy),Revenue", "RBO", new UploadRevenueDataBO()));
            return arrUP;
        }

        public static ArrayList arrRevenueForBO()
        {
            ArrayList arrRevenueForTheatreTmp = new ArrayList();
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Movie", "MOVIE", false, false, false, null, null, false, false, 0, false, null, 50, false, "", "", "", ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Movie Code", "Movie Code", true, true, false, null, null, false, false, 0, false, null, 50, true, "title_code", "Deal_movie", "title_code", ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Date (dd-MMM-yyyy)", "Date (dd-MMM-yyyy)", true, true, false, null, null, false, false, 0, true, "dd-mmm-yyyy", 50, false, null, null, null, ""));
            arrRevenueForTheatreTmp.Add(new AttribValueExcelUpload("Revenue", "REVENUE", true, true, false, null, null, true, true, 999999999, false, null, 50, false, null, null, null, ""));
            return arrRevenueForTheatreTmp;
        }
    }

    public class ReportSetting
    {
        public string GetReport(string ReportName)
        {
            string ReportFolder = "";
            string ReportPath = "";

            //ReportFolder = ConfigurationManager.AppSettings["ReportingServerFolder_HV"].ToUpper();
            //ReportFolder = ConfigurationManager.AppSettings["ReportingServerFolder"].ToUpper();
            ReportFolder = Convert.ToString(new GlobalParams().objLoginEntity.ReportingServerFolder);
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

            return ReportPath;
        }

        public string GetHoldbackTypeConfiguration()
        {
            return DatabaseBroker.ProcessScalarReturnString("select parameter_value from system_parameter_new where parameter_name ='Holdback Type'");
        }
    }
}
