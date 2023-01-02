using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Entity.Core.Objects;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.Configuration;
using System.Net.Http.Headers;
using Newtonsoft.Json;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;

namespace RightsU_Plus.Controllers
{
    public class GlobalController : BaseController
    {
        #region Properties
        ReportViewer ReportViewer2;
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value; }
        }
        public Deal_Schema objSynDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.Syn_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.Syn_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.Syn_DEAL_SCHEMA] = value; }
        }
        public LoginEntity objLoginEntity
        {
            get
            {
                if (System.Web.HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity] == null)
                    System.Web.HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity] = new LoginEntity();
                return (LoginEntity)System.Web.HttpContext.Current.Session[RightsU_Session.CurrentLoginEntity];
            }
        }
        #endregion
        public ActionResult Index()
        {
            return View();
        }
        public MultiSelectList BindTitle_List(int? Deal_Code, int? Deal_Type_Code, string Selected_Title_Code = "", string deal_Type = "A")
        {
            MultiSelectList arr_Title_List = new MultiSelectList(new USP_Service(objLoginEntity.ConnectionStringName).USP_Bind_Title(Deal_Code, Deal_Type_Code, deal_Type).ToList(), "Title_Code", "Title_Name", Selected_Title_Code.Split(','));
            return arr_Title_List;
        }

        public MultiSelectList BindSearchList_Rights(int dealCode, string dealTypeCodition, string selectedCodes, string callFor)
        {
            dynamic list = null;
            if (callFor == "A")
            {
                list = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Acq_Deal_Code == dealCode).ToList().
                    Select(s => new
                    {
                        Title_Name = DBUtil.GetTitleNameInFormat(dealTypeCodition, s.Title.Title_Name, s.Episode_Starts_From, s.Episode_End_To),
                        Title_Code = s.Acq_Deal_Movie_Code
                    }).ToList();
            }
            else
            {
                list = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Syn_Deal_Code == dealCode).ToList().
                    Select(s => new
                    {
                        Title_Name = DBUtil.GetTitleNameInFormat(dealTypeCodition, s.Title.Title_Name, s.Episode_From, s.Episode_End_To),
                        Title_Code = s.Syn_Deal_Movie_Code
                    }).ToList();
            }

            MultiSelectList multiList = new MultiSelectList(list, "Title_Code", "Title_Name", selectedCodes.Split(','));
            return multiList;
        }
        public MultiSelectList BindCountry_List(string Is_Thetrical = "N", string Selected_Country_Code = "")
        {
            MultiSelectList arr_Title_List = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y" && i.Is_Theatrical_Territory == Is_Thetrical).Select(i => new { Country_Code = i.Country_Code, Country_Name = i.Country_Name }).OrderBy(x => x.Country_Name).ToList(), "Country_Code", "Country_Name", Selected_Country_Code.Split(','));
            return arr_Title_List;
        }
        public MultiSelectList BindChannel_List(string Selected_Channel_Code = "")
        {
            MultiSelectList arr_Title_List = new MultiSelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y").Select(i => new { Channel_Code = i.Channel_Code, Channel_Name = i.Channel_Name }).OrderBy(x => x.Channel_Name).ToList(), "Channel_Code", "Channel_Name", Selected_Channel_Code.Split(','));
            return arr_Title_List;
        }

        public MultiSelectList BindTerritory_List(string Is_Thetrical = "N", string Selected_Territory_Code = "")
        {
            MultiSelectList arr_Title_List = new MultiSelectList(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y" && i.Is_Thetrical == Is_Thetrical).Select(i => new { Territory_Code = i.Territory_Code, Territory_Name = i.Territory_Name }).OrderBy(x => x.Territory_Name).ToList(), "Territory_Code", "Territory_Name", Selected_Territory_Code.Split(','));
            return arr_Title_List;
        }
        public MultiSelectList BindLanguage_List(string Selected_Language_Code = "")
        {
            MultiSelectList arr_Title_List = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y").Select(i => new { Language_Code = i.Language_Code, Language_Name = i.Language_Name }).OrderBy(x => x.Language_Name).ToList(), "Language_Code", "Language_Name", Selected_Language_Code.Split(','));
            return arr_Title_List;
        }
        public MultiSelectList BindLanguage_Group_List(string Selected_Language_Group_Code = "")
        {
            MultiSelectList arr_Title_List = new MultiSelectList(new Language_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y").Select(i => new { Language_Group_Code = i.Language_Group_Code, Language_Group_Name = i.Language_Group_Name }).OrderBy(x => x.Language_Group_Name).ToList(), "Language_Group_Code", "Language_Group_Name", Selected_Language_Group_Code.Split(','));
            return arr_Title_List;
        }
        public SelectList BindMilestone_List(int Selected_Milestone_Code = 0)
        {
            SelectList arr_Title_List = new SelectList(new Milestone_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Is_Active == "Y").Select(i => new { Milestone_Type_Code = i.Milestone_Type_Code, Milestone_Type_Name = i.Milestone_Type_Name }).ToList(), "Milestone_Type_Code", "Milestone_Type_Name", Selected_Milestone_Code);
            return arr_Title_List;
        }
        public SelectList BindMilestone_Unit_List(int selected_Milestone_Unit)
        {
            return new SelectList(new[]
                {
                    new { ID = "1", Name = "Days" },
                    new { ID = "2", Name = "Weeks" },
                    new { ID = "3", Name = "Months"},
                    new { ID = "4", Name = "Years"}
                },
            "ID", "Name", selected_Milestone_Unit);
        }
        public string Archive(string user_Action, int Acq_Deal_Code, string remarks_Approval = "", int moduleCode = 30)//add user action
        {
            string strMsgType = "";
            try
            {
                //RightsU_Entities.User objLoginUser = ((RightsU_Entities.RightsU_Session)Session[RightsU_Entities.RightsU_Session.SESS_KEY]).Objuser;
                RightsU_BLL.USP_Service objUSP = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName);

                string val = user_Action == "R" ? "R" : "AR";

                string uspResult = string.Empty;
                if (moduleCode == 30)
                {
                    // uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName)
                    //.USP_Assign_Workflow(Acq_Deal_Code, GlobalParams.ModuleCodeForAcqDeal, objLoginUser.Users_Code, val + remarks_Approval).ElementAt(0));
                    uspResult = Convert.ToString(objUSP.USP_Process_Workflow(Acq_Deal_Code, 30, objLoginUser.Users_Code, val, remarks_Approval).ElementAt(0));
                }
                else if (moduleCode == 35)
                {
                    // uspResult = Convert.ToString(new USP_Service(objLoginEntity.ConnectionStringName)
                    //.USP_Assign_Workflow(Acq_Deal_Code, GlobalParams.ModuleCodeForSynDeal, objLoginUser.Users_Code, val + remarks_Approval).ElementAt(0));

                    uspResult = Convert.ToString(objUSP.USP_Process_Workflow(Acq_Deal_Code, 35, objLoginUser.Users_Code, val, remarks_Approval).ElementAt(0));

                }
                if (uspResult == "N")
                {
                    strMsgType = "S";
                }
                else
                    strMsgType = "E";
            }
            catch (Exception ex)
            {
                return strMsgType = ex.Message.Replace("'", "");
            }
            return strMsgType;
        }
        public JsonResult Approve_Reject_Deal(string user_Action, string approvalremarks, string WorkFlowStatus = "")
        {
            try
            {
                RightsU_Entities.User objLoginUser = ((RightsU_Entities.RightsU_Session)Session[RightsU_Entities.RightsU_Session.SESS_KEY]).Objuser;
                RightsU_BLL.USP_Service objUSP = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName);

                Acq_Deal objAcq_Deal = new Acq_Deal();
                if (Session[RightsU_Entities.RightsU_Session.SESS_DEAL] != null)
                {
                    objAcq_Deal = ((Acq_Deal)Session[RightsU_Entities.RightsU_Session.SESS_DEAL]);
                }
                else if (TempData["RedirectAcqDeal"] != null)
                {
                    objAcq_Deal = ((Acq_Deal)TempData["RedirectAcqDeal"]);
                }
                string uspResult = string.Empty;
                if (user_Action == "A")
                {
                    string isApproved = new Module_Workflow_Detail_Service(objLoginEntity.ConnectionStringName)
                        .SearchFor(x => x.Module_Code == 30
                                        && x.Record_Code == objAcq_Deal.Acq_Deal_Code
                                        && x.Group_Code == objLoginUser.Security_Group_Code)
                        .OrderByDescending(x => x.Module_Workflow_Detail_Code)
                        .Select(x => x.Is_Done)
                        .FirstOrDefault();

                    if (isApproved == "Y")
                    {
                        return Json("Already_Approved");
                    }
                }

                if (WorkFlowStatus.Contains("Waiting (Archive)"))
                {
                    uspResult = Archive(user_Action, objAcq_Deal.Acq_Deal_Code, approvalremarks);
                }
                else
                {
                    uspResult = Convert.ToString(objUSP.USP_Process_Workflow(objAcq_Deal.Acq_Deal_Code, 30, objLoginUser.Users_Code, user_Action, approvalremarks).ElementAt(0));

                    if (user_Action == "A")
                    {
                        CommonUtil objCUT = new CommonUtil();
                        objCUT.Send_WBS_Data(GlobalParams.ModuleCodeForAcqDeal, objAcq_Deal.Acq_Deal_Code, objLoginUser.Users_Code, objLoginEntity.ConnectionStringName, "N");
                    }


                    #region ----Contido API Calling Logic

                    string AllowContidoAPILinkCall = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name == "AllowContidoAPILinkCall").Select(x => x.Parameter_Value).FirstOrDefault();
                    if (AllowContidoAPILinkCall == "Y")
                    {
                        //int SecurityGroupCode = Convert.ToInt32(new Module_Workflow_Detail_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Module_Code == 30 && x.Record_Code == objAcq_Deal.Acq_Deal_Code && x.Next_Level_Group == null)
                        //    .Select(x => x.Group_Code));

                        string IsLastLevelApprovar = "N";

                        //new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x=>x.Users_Code == objAcq_Deal.Last_Action_By == )

                        var acq_Deal_Movie = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true)
                          .Where(x => x.Acq_Deal_Code == objAcq_Deal.Acq_Deal_Code).FirstOrDefault();
                        var acq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objAcq_Deal.Acq_Deal_Code);

                        if (acq_Deal.Deal_Workflow_Status == "A" && acq_Deal.Version == "0001" && (acq_Deal.Deal_Type_Code == 11 || acq_Deal.Deal_Type_Code == 22 || acq_Deal.Deal_Type_Code == 32))
                        {
                            string ProgramName = new Title_Service(objLoginEntity.ConnectionStringName).GetById(Convert.ToInt32(acq_Deal_Movie.Title_Code)).Title_Name;

                            // for saving Metadata rms id
                            Map_Extended_Columns_Service objService = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName);
                            Map_Extended_Columns objMap_Extended_Columns = new Map_Extended_Columns();

                            objMap_Extended_Columns.Record_Code = acq_Deal_Movie.Title_Code;
                            objMap_Extended_Columns.Table_Name = "TITLE";
                            objMap_Extended_Columns.Columns_Code = Convert.ToInt32(ConfigurationManager.AppSettings["rms_id_ExtendedColumnsCode"]);// 2061;
                            objMap_Extended_Columns.Column_Value = "RUCONBBTS" + acq_Deal_Movie.Title_Code;
                            objMap_Extended_Columns.EntityState = State.Added;

                            dynamic resultSet;
                            bool isValid = objService.Save(objMap_Extended_Columns, out resultSet);

                            List<ScheduleInfo> lstScheduleInfo = new List<ScheduleInfo>();
                            ScheduleInfo objScheduleInfo = new ScheduleInfo()
                            {
                                id = "5f573eba26d8872940aa6d73",
                                channel_db_id = "5f573eba26d8872940aa6d73",
                                channel_id = "CH02",
                                name = "e-Entertainment",
                                language = "english",
                                is_disaster = false,
                                organisation = "10tv",
                                organisation_code = "10tv",
                                tx_time = 1672131642702
                            };
                            lstScheduleInfo.Add(objScheduleInfo);

                            List<string> lstott_platforms_list = new List<string>();
                            lstott_platforms_list.Add("5d11f18995eabf740e91d3a2");

                            List<string> lstgeography = new List<string>();
                            lstgeography.Add("UAE");
                            lstgeography.Add("SA");
                            lstgeography.Add("QA");

                            List<string> lstDevice_type = new List<string>();
                            lstDevice_type.Add("iOS");
                            lstDevice_type.Add("Android");

                            List<Ottprogramsinfo> lstOttprogramsinfo = new List<Ottprogramsinfo>();
                            Ottprogramsinfo objOttprogramsinfo = new Ottprogramsinfo()
                            {

                                id = "5d11f18995eabf740e91d3a2",
                                display_seq = 1,
                                ott_id = "",
                                platform_name = "e-OTT",
                                language = null,
                                image_path = "",
                                first_publish_time = 1672131649192,
                                second_publish_time = 1672131649192,
                                geography = lstgeography,
                                name = ProgramName,
                                device_type = lstDevice_type
                            };
                            lstOttprogramsinfo.Add(objOttprogramsinfo);

                            List<string> lsttasks_list = new List<string>();
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cb7");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cbc");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cb8");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cbd");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cbf");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cc0");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cc1");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cc2");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cc3");
                            lsttasks_list.Add("5d11bf3295eabf6d8fd76cc5");
                            lsttasks_list.Add("6378c78eaff8d400e57dee09");
                            lsttasks_list.Add("5e5cb80d31ff12c245727649");
                            lsttasks_list.Add("62546c17d4b333678d8a9713");
                            lsttasks_list.Add("5ed50bbdcbc72aa66764ea54");


                            List<object> lstprogram_type = new List<object>();
                            List<object> lstprogram_settings = new List<object>();

                            Data objData = new Data()
                            {
                                language = "english",
                                season_type = "series",
                                season_no = 1,
                                name = ProgramName,
                                season_name = ProgramName,
                                no_of_episodes = 10,
                                rms_id = "RUCONBBTS" + acq_Deal_Movie.Title_Code,
                                channels_list = "5f573eba26d8872940aa6d73",
                                schedule_info = lstScheduleInfo,
                                ott_platforms_list = lstott_platforms_list,
                                ottprogramsinfo = lstOttprogramsinfo,
                                tasks_list = lsttasks_list,
                                program_type = lstprogram_type,
                                program_settings = lstprogram_settings

                            };


                            ContidoInput objContidoInput = new ContidoInput();

                            objContidoInput.role_id = "5c57ee5b95eabf4c15894072";
                            objContidoInput.organisation_db_id = "5bc6fd5695eabfb8f076d784";
                            objContidoInput.username = "geetu@desynova.com";
                            objContidoInput.data = objData;





                            //API Calling
                            string result = "";
                            string Authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJyYW5kb21OdW1iZXIiOiAiMzg3MzY2OTEwMSIsICJ0b2tlbkNyZWF0ZWRBdCI6ICIyMDIyLTEyLTI3IDE2OjAxOjAyLjI4NDc2MyIsICJleHAiOiAiMjExNC0wNC0wMyAwMDowMTowMi4yODQ3NjMiLCAidXNlcm5hbWUiOiAiZ2VldHVAZGVzeW5vdmEuY29tIiwgIm9ial9pZCI6ICI2MzZiNDk4MGNlN2U2MDAwMWIwZWJmZDQiLCAiZmlyc3RuYW1lIjogIkdlZXR1IiwgImxhc3RuYW1lIjogIk1ha2hhbmkiLCAiZ3JvdXBuYW1lIjogW10sICJsb2NhdGlvbiI6ICIiLCAibG9jYXRpb25fdGFnIjogImh5ZCJ9.iTnanvN1o6o_HK6oIYDYJAvS0sX_XqRDMrqumOQYyVTfP4AHrVzSj8dm9KcvVFB8EeBWN14NY8qebE_CPLIbynZ_BNdk2Hp85YFZmeAhiClp_6dojhE3_5zgm_0kMCwbF6Nbmw0WQzoM1xzGndv1ZVh6rfkNHO0ABuTFlUJxqehy-moYeyGNe94LbRKm8nH-wcZPltE19VHGEdmhv22jF6hgZ7sdmRsk6SV5Dgd5BKfslJCMTwM0sQDvJEBJBNGuMUd6xXl6rXy-xud1E1rwVLfOlYxgBAylH8F9gm8ty-zrMWyQRJXsO44rfqihi2UmadrILFJciAzpd042iNueSRT1TxKtIBJFZrEEKJwTGZtl3gEx3D7R4gYFodprmn5PQNtSAi9BdLtwCT0ix_vgsv88Y4OPe5O2n5rbWtRStU-XKtSmRGtt6-6SnDXjWfsyZg7zhEsZton7_4r5X5lOQ6-5lXXgtHvsXQ0IUtRYOcUopgQ96FL-6VpIyg7uPl1IsP9Ph4GTm6YnHGP4G4LD5X5xC6Upq7NPkCtEPeCHL9IcWpKkbEMZWKIneSqSRoqeDDNvE7AsCjZ2rcTwSnUxmwEWadrAK4bLHIi0JHKU4JilGxYLA784IJCfVvixaH7e_sF_eJwKPdOT68dhfhtl2Fxkodo8O_rbYRfkjh60kSA";

                            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://api.desynova.contido.io/api/manage/show/");
                            request.KeepAlive = false;
                            request.ProtocolVersion = HttpVersion.Version10;
                            request.ContentType = "application/Json";
                            request.Method = "POST";
                            request.Headers.Add("ContentType", "application/json");
                            request.Headers.Add("Authorization", Authorization);
                            request.Headers.Add("Service", "true");
                            //API Calling

                            using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                            {
                                string json = JsonConvert.SerializeObject(objContidoInput);
                                streamWriter.Write(json);
                            }

                            try
                            {
                                var httpResponse = (HttpWebResponse)request.GetResponse();
                                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                                {
                                    result = streamReader.ReadToEnd();
                                }

                                var responseobject = JsonConvert.DeserializeObject(result);

                                //var objresponseobject = JsonConvert.DeserializeObject<List<Root_Output>>(result);


                            }
                            catch (Exception ex)
                            {
                                request.Abort();
                            }


                            var objresponseobject1 = JsonConvert.DeserializeObject<Root_Output>(result);
                            // for saving Metadata program id from contido
                            Map_Extended_Columns_Service objService_1 = new Map_Extended_Columns_Service(objLoginEntity.ConnectionStringName);
                            Map_Extended_Columns objMap_Extended_Columns_1 = new Map_Extended_Columns();

                            objMap_Extended_Columns_1.Record_Code = acq_Deal_Movie.Title_Code;
                            objMap_Extended_Columns_1.Table_Name = "TITLE";
                            objMap_Extended_Columns_1.Columns_Code = Convert.ToInt32(ConfigurationManager.AppSettings["program_db_id_ExtendedColumnsCode"]);
                            if (objresponseobject1.response == true)
                            {
                                objMap_Extended_Columns_1.Column_Value = objresponseobject1.data.program_db_id;
                            }
                            else
                            {
                                objMap_Extended_Columns_1.Column_Value = objresponseobject1.errormessage.ToString();
                            }
                            objMap_Extended_Columns_1.EntityState = State.Added;

                            dynamic resultSet_1;
                            bool isValid_1 = objService.Save(objMap_Extended_Columns_1, out resultSet_1);
                        }
                    }

                    #endregion

                }
                return Json(uspResult);
            }
            catch (Exception ex)
            {
                return Json("Error");
            }
        }



        public JsonResult SetApprovalRemarks(string approvalremarks)
        {
            objDeal_Schema.Approver_Remark = approvalremarks.Replace("\r\n", "\n");
            return Json("Success");
        }

        public JsonResult Syn_Approve_Reject_Deal(string user_Action, string approvalremarks, string WorkFlowStatus = "")
        {
            try
            {
                RightsU_Entities.User objLoginUser = ((RightsU_Entities.RightsU_Session)Session[RightsU_Entities.RightsU_Session.SESS_KEY]).Objuser;
                RightsU_BLL.USP_Service objUSP = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName);

                Syn_Deal objSyn_Deal = new Syn_Deal();
                if (Session[RightsU_Entities.RightsU_Session.SESS_DEAL] != null)
                {
                    objSyn_Deal = ((Syn_Deal)Session[RightsU_Entities.RightsU_Session.SESS_DEAL]);
                }
                else if (TempData["RedirectSynDeal"] != null)
                {
                    objSyn_Deal = ((Syn_Deal)TempData["RedirectSynDeal"]);
                }

                if (user_Action == "A")
                {
                    string isApproved = new Module_Workflow_Detail_Service(objLoginEntity.ConnectionStringName)
                        .SearchFor(x => x.Module_Code == 35
                                        && x.Record_Code == objSyn_Deal.Syn_Deal_Code
                                        && x.Group_Code == objLoginUser.Security_Group_Code)
                        .OrderByDescending(x => x.Module_Workflow_Detail_Code)
                        .Select(X => X.Is_Done)
                        .FirstOrDefault();

                    if (isApproved == "Y")
                    {
                        return Json("Already_Approved");
                    }
                }

                string uspResult = String.Empty;
                if (WorkFlowStatus.Contains("Waiting (Archive)"))
                {
                    uspResult = Archive(user_Action, objSyn_Deal.Syn_Deal_Code, approvalremarks, 35);
                }
                else
                {
                    uspResult = Convert.ToString(objUSP.USP_Process_Workflow(objSyn_Deal.Syn_Deal_Code, 35, objLoginUser.Users_Code, user_Action, approvalremarks).ElementAt(0));
                }
                return Json(uspResult);
            }
            catch
            {
                return Json("Error");
            }
        }

        public JsonResult Music_Approve_Reject_Deal(string user_Action, string approvalremarks)
        {
            try
            {
                RightsU_Entities.User objLoginUser = ((RightsU_Entities.RightsU_Session)Session[RightsU_Entities.RightsU_Session.SESS_KEY]).Objuser;
                RightsU_BLL.USP_Service objUSP = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName);

                Music_Deal objMusic_Deal = new Music_Deal();
                if (Session[RightsU_Entities.RightsU_Session.SESS_MUSIC_DEAL] != null)
                {
                    objMusic_Deal = ((Music_Deal)Session[RightsU_Entities.RightsU_Session.SESS_MUSIC_DEAL]);
                }
                else if (TempData["RedirectMusicDeal"] != null)
                {
                    objMusic_Deal = ((Music_Deal)TempData["RedirectMusicDeal"]);
                }

                string uspResult = Convert.ToString(objUSP.USP_Process_Workflow(objMusic_Deal.Music_Deal_Code, GlobalParams.ModuleCodeForMusicDeal, objLoginUser.Users_Code, user_Action, approvalremarks).ElementAt(0));
                return Json(uspResult);
            }
            catch
            {
                return Json("Error");
            }
        }

        public JsonResult SetSynApprovalRemarks(string approvalremarks)
        {
            objSynDeal_Schema.Approver_Remark = approvalremarks.Replace("\r\n", "\n");
            return Json("Success");
        }

        public ActionResult Deal_For_Approval(int DealCode, int ModuleCode, int? Record_Locking_Code, string Req, string Is_Menu = "Y")
        {
            Req = (string.IsNullOrEmpty(Req)) ? "SA" : Req;
            Dictionary<string, string> obj = PreReqForApproval(DealCode, ModuleCode, Record_Locking_Code, Is_Menu, "SA");

            if (ModuleCode == 30 || ModuleCode == 35)
            {
                TempData["QueryString"] = obj;
                TempData["approval"] = "approvallist";
                if (Is_Menu == "N")
                    TempData["QS_LayOut"] = null;

                if (ModuleCode == 30)
                {
                    Session[RightsU_Session.SESS_DEAL] = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).GetById(DealCode);
                    return RedirectToAction("Index", "Acq_Deal");
                }
                else
                {
                    Session[RightsU_Session.SESS_DEAL] = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(DealCode);
                    return RedirectToAction("Index", "Syn_Deal");
                }
            }
            else
            {
                TempData["Music_Deal_Code"] = DealCode;
                if (Req == "SA")
                {
                    TempData["Mode"] = GlobalParams.DEAL_MODE_APPROVE;
                }
                else if (Req == "A" || Req == "R")
                {
                    TempData["Mode"] = GlobalParams.DEAL_MODE_VIEW;
                }
                TempData["RecodLockingCode"] = (Record_Locking_Code ?? 0);

                Session[RightsU_Session.SESS_DEAL] = new Music_Deal_Service(objLoginEntity.ConnectionStringName).GetById(DealCode);
                return RedirectToAction("Index", "Music_Deal");
            }
        }

        public Dictionary<string, string> PreReqForApproval(int DealCode, int ModuleCode, int? Record_Locking_Code, string Is_Menu, string Req)
        {
            string Mode = "";
            string Pushback_Text = DBUtil.GetSystemParameterValue("Pushback_Text").ToUpper();

            if (Req == "SA")
            {

                Mode = GlobalParams.DEAL_MODE_APPROVE;
            }
            else if (Req == "A" || Req == "R")
            {
                Mode = GlobalParams.DEAL_MODE_VIEW;
            }
            Dictionary<string, string> obj = new Dictionary<string, string>();
            if (ModuleCode == 30 || ModuleCode == 35)
            {
                if (ModuleCode == 30)
                    obj.Add("Acq_Deal_Code", DealCode.ToString());
                else
                    obj.Add("Syn_Deal_Code", DealCode.ToString());

                obj.Add("Mode", Mode);
                obj.Add("ModuleCode", ModuleCode.ToString());
                obj.Add("PageNo", null);
                obj.Add("RLCode", Convert.ToString(Record_Locking_Code ?? 0));
                obj.Add("ClearSrchSession", null);
                obj.Add("Pushback_Text", Pushback_Text);
                return obj;
            }
            else
                return null;
        }

        public ActionResult RedirectToControl(string tabName, int listPage_PageNo = 1, int Deal_Type_Code = 0, int ModuleCode = GlobalParams.ModuleCodeForAcqDeal)
        {
            string controllerName = "";
            string ModuleName = "Acq_";
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();

            if (ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                ModuleName = "Syn_";

            switch (tabName)
            {
                case GlobalParams.Page_From_General:
                    controllerName = ModuleName + "General";
                    break;

                case GlobalParams.Page_From_Rights:
                    controllerName = ModuleName + "Rights_List";
                    break;

                case GlobalParams.Page_From_Pushback:
                    controllerName = ModuleName + "Pushback";
                    break;

                case GlobalParams.Page_From_Run:
                    controllerName = ModuleName + "Run_List";
                    break;

                case GlobalParams.Page_From_Sports:
                    controllerName = ModuleName + "Sports";
                    break;

                case GlobalParams.Page_From_Ancillary:
                    if (Deal_Type_Code == GlobalParams.Deal_Type_Sports)
                        controllerName = ModuleName + "Sport_Ancillary";
                    else
                        controllerName = ModuleName + "Ancillary";
                    break;

                case GlobalParams.Page_From_Budget:
                    controllerName = ModuleName + "Budget";//ModuleName + "Cost_New";
                    break;

                case GlobalParams.Page_From_Cost:
                    if (ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                        controllerName = ModuleName + "Cost";
                    else
                        controllerName = ModuleName + "Revenue";
                    break;

                case GlobalParams.Page_From_PaymentTerm:
                    controllerName = ModuleName + "Payment_Term";
                    break;

                case GlobalParams.Page_From_Material:
                    controllerName = ModuleName + "Material";
                    break;

                case GlobalParams.Page_From_Attachment:
                    controllerName = ModuleName + "Attachment";
                    break;

                case GlobalParams.Page_From_StatusHistory:
                    controllerName = ModuleName + "Status_History";
                    break;

                default:
                    controllerName = ModuleName + "List";
                    //obj_Dic.Add("Page_No", listPage_PageNo.ToString());
                    //TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;                   
                    //objQueryString = new { Page_No = listPage_PageNo };
                    break;
            }

            return RedirectToAction("Index", controllerName);
            //return RedirectToAction("Index", controllerName, objQueryString);
        }

        public string GetRedirectURL(string tabName, int listPage_PageNo = 1, UrlHelper Url = null, int Deal_Type_Code = 0, int ModuleCode = GlobalParams.ModuleCodeForAcqDeal)
        {
            string controllerName = "";
            string ModuleName = "Acq_";

            if (ModuleCode == GlobalParams.ModuleCodeForSynDeal)
                ModuleName = "Syn_";

            switch (tabName)
            {
                case GlobalParams.Page_From_General:
                    controllerName = ModuleName + "General";
                    break;

                case GlobalParams.Page_From_Rights:
                    controllerName = ModuleName + "Rights_List";
                    break;

                case GlobalParams.Page_From_Pushback:
                    controllerName = ModuleName + "Pushback";
                    break;

                case GlobalParams.Page_From_Run:
                    controllerName = ModuleName + "Run_List";
                    break;

                case GlobalParams.Page_From_Sports:
                    controllerName = ModuleName + "Sports";
                    break;

                case GlobalParams.Page_From_Ancillary:
                    if (Deal_Type_Code == GlobalParams.Deal_Type_Sports)
                        controllerName = ModuleName + "Sport_Ancillary";
                    else
                        controllerName = ModuleName + "Ancillary";
                    break;

                case GlobalParams.Page_From_Budget:
                    controllerName = ModuleName + "Budget";//ModuleName + "Cost_New";
                    break;

                case GlobalParams.Page_From_Cost:
                    if (ModuleCode == GlobalParams.ModuleCodeForAcqDeal)
                        controllerName = ModuleName + "Cost";
                    else
                        controllerName = ModuleName + "Revenue";
                    break;

                case GlobalParams.Page_From_PaymentTerm:
                    controllerName = ModuleName + "Payment_Term";
                    break;

                case GlobalParams.Page_From_Material:
                    controllerName = ModuleName + "Material";
                    break;

                case GlobalParams.Page_From_Attachment:
                    controllerName = ModuleName + "Attachment";
                    break;

                case GlobalParams.Page_From_StatusHistory:
                    controllerName = ModuleName + "Status_History";
                    break;

                default:
                    controllerName = ModuleName + "List";
                    break;
            }

            string redirectUrl = string.Empty;

            if (Url == null)
                redirectUrl = controllerName + "/Index";
            else
                redirectUrl = Url.Action("Index", controllerName);

            if (tabName.Equals(""))
            {
                if (Url == null)
                    redirectUrl = controllerName + "/Index?Page_No=" + listPage_PageNo;
                else
                    redirectUrl = Url.Action("Index", controllerName, new { @Page_No = listPage_PageNo });
            }

            return redirectUrl;
        }

        public List<USP_Validate_Rights_Duplication_UDT> Acq_Rights_Validation_Popup(List<USP_Validate_Rights_Duplication_UDT> lstDupRecords, string searchForTitles, string PageSize, int PageNo, out int Record_Count)
        {
            if (PageSize == "" || PageSize == "0")
                PageSize = "10";

            int partialPageSize = Convert.ToInt32(PageSize);
            List<string> arrTitleNames;
            List<USP_Validate_Rights_Duplication_UDT> lstDuplicates_Main;

            if (searchForTitles != "")
            {
                arrTitleNames = searchForTitles.Split(',').ToList();
                lstDuplicates_Main = lstDupRecords.Where(x => arrTitleNames.Contains(x.Title_Name)).ToList();
            }
            else
                lstDuplicates_Main = lstDupRecords;

            Record_Count = lstDuplicates_Main.Count;
            return lstDuplicates_Main.Skip((PageNo - 1) * partialPageSize).Take(partialPageSize).ToList();
        }

        public List<USP_Validate_Rev_HB_Duplication_UDT_Acq> Acq_Rev_HB_Validation_Popup(List<USP_Validate_Rev_HB_Duplication_UDT_Acq> lstDupRecords, string searchForTitles, string PageSize, int PageNo, out int Record_Count)
        {
            if (PageSize == "" || PageSize == "0")
                PageSize = "10";

            int partialPageSize = Convert.ToInt32(PageSize);
            List<string> arrTitleNames;
            List<USP_Validate_Rev_HB_Duplication_UDT_Acq> lstDuplicates_Main;

            if (searchForTitles != "")
            {
                arrTitleNames = searchForTitles.Split(',').ToList();
                lstDuplicates_Main = lstDupRecords.Where(x => arrTitleNames.Contains(x.Title_Name)).ToList();
            }
            else
                lstDuplicates_Main = lstDupRecords;

            Record_Count = lstDuplicates_Main.Count;
            return lstDuplicates_Main.Skip((PageNo - 1) * partialPageSize).Take(partialPageSize).ToList();
        }

        public JsonResult ChangeTab(string tabName, int ModuleCode = 30)
        {
            int pageNo = 1;
            string redirectUrl = "";

            if (ModuleCode == 35)
            {
                pageNo = objSynDeal_Schema.PageNo;
                redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(tabName, pageNo, Url, objSynDeal_Schema.Deal_Type_Code, ModuleCode);
            }
            else
            {
                pageNo = objDeal_Schema.PageNo;
                redirectUrl = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetRedirectURL(tabName, pageNo, Url, objDeal_Schema.Deal_Type_Code, ModuleCode);
            }
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Redirect_URL", redirectUrl);
            return Json(obj);
        }

        public JsonResult Refresh_Lock(int RLCode)
        {
            DBUtil.Refresh_Lock(RLCode);
            return Json("Success");
        }

        public JsonResult Release_Lock(int RLCode)
        {
            DBUtil.Release_Record(RLCode);
            return Json("Success");
        }

        public JsonResult Validate_Deal_Approve_List(int dealCode, int moduleCode, int usersCode)
        {
            string strMessage, strViewBagMsg = "";
            int RLCode = 0;
            bool isLocked = true;
            //return Json("S~ddd", JsonRequestBehavior.AllowGet);
            try
            {
                if (usersCode == 0 && ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser != null)
                {
                    usersCode = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser.Users_Code;
                }
                isLocked = DBUtil.Lock_Record(dealCode, moduleCode, usersCode, out RLCode, out strMessage);
                ViewBag.Record_Locking_Code = RLCode;
                if (!isLocked)
                    return Json(strMessage);
                else
                {
                    int Deal_Code = 0;
                    if (moduleCode == GlobalParams.ModuleCodeForAcqDeal)
                    {
                        string[] ErrorChk = { "W", "E", "P" };
                        var objAcqDeal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(S => S.Acq_Deal_Code == dealCode).FirstOrDefault();
                        List<Acq_Deal_Rights> objAcqDealRights = new List<Acq_Deal_Rights>();
                        objAcqDealRights = objAcqDeal.Acq_Deal_Rights.ToList();
                        bool ChkDealStatus = objAcqDealRights.Any(w => ErrorChk.Contains(w.Right_Status));

                        Deal_Code = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Acq_Deal_Code == dealCode && s.Deal_Workflow_Status == "A").Select(i => i.Acq_Deal_Code).FirstOrDefault();
                        if (Deal_Code > 0)
                            return Json(objMessageKey.ThedealisalreadyprocessedbyanotherApprover);
                        else if (ChkDealStatus)
                            return Json("Cannot approved deal as rights are in processing state");
                        else if (Deal_Code == 0)
                        {
                            string isApproved = new Module_Workflow_Detail_Service(objLoginEntity.ConnectionStringName)
                            .SearchFor(x => x.Module_Code == 30
                                            && x.Record_Code == objAcqDeal.Acq_Deal_Code
                                            && x.Group_Code == objLoginUser.Security_Group_Code)
                            .OrderByDescending(x => x.Module_Workflow_Detail_Code)
                            .Select(x => x.Is_Done)
                            .FirstOrDefault();

                            if (isApproved == "Y")
                            {
                                return Json(objMessageKey.ThedealisalreadyprocessedbyanotherApprover);
                            }
                        }

                    }
                    else if (moduleCode == GlobalParams.ModuleCodeForSynDeal)
                    {
                        string[] ErrorChk = { "W", "E", "P" };
                        var objSynDeal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(S => S.Syn_Deal_Code == dealCode).FirstOrDefault();
                        List<Syn_Deal_Rights> objSynDealRights = new List<Syn_Deal_Rights>();
                        objSynDealRights = objSynDeal.Syn_Deal_Rights.ToList();
                        bool ChkDealStatus = objSynDealRights.Any(w => ErrorChk.Contains(w.Right_Status));

                        Deal_Code = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Syn_Deal_Code == dealCode && s.Deal_Workflow_Status == "A").Select(i => i.Syn_Deal_Code).FirstOrDefault();
                        if (Deal_Code > 0)
                            return Json(objMessageKey.ThedealisalreadyprocessedbyanotherApprover);
                        else if (ChkDealStatus)
                            return Json("Cannot approved deal as rights are in processing state");
                        else if (Deal_Code == 0)
                        {
                            string isApproved = new Module_Workflow_Detail_Service(objLoginEntity.ConnectionStringName)
                            .SearchFor(x => x.Module_Code == 35
                                            && x.Record_Code == objSynDeal.Syn_Deal_Code
                                            && x.Group_Code == objLoginUser.Security_Group_Code)
                            .OrderByDescending(x => x.Module_Workflow_Detail_Code)
                            .Select(x => x.Is_Done)
                            .FirstOrDefault();

                            if (isApproved == "Y")
                            {
                                return Json(objMessageKey.ThedealisalreadyprocessedbyanotherApprover);
                            }
                        }

                    }
                    else if (moduleCode == GlobalParams.ModuleCodeForMusicDeal)
                    {
                        Deal_Code = new Music_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Music_Deal_Code == dealCode && s.Deal_Workflow_Status == "A").Select(i => i.Music_Deal_Code).FirstOrDefault();
                        if (Deal_Code > 0)
                            return Json(objMessageKey.ThedealisalreadyprocessedbyanotherApprover);
                    }
                }
            }
            catch (Exception ex)
            {
                strViewBagMsg = ex.Message;
            }
            return Json("S~" + RLCode);
        }

        public void ReportCredential()
        {
            var rptCredetialList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

            string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
            string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

            if (IsCredentialRequired.ToUpper() == "TRUE")
            {
                string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
                string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
                string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];

                ReportViewer2.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
            }



            ReportViewer2.Visible = true;
            ReportViewer2.ServerReport.Refresh();
            ReportViewer2.ProcessingMode = ProcessingMode.Remote;
            if (ReportViewer2.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
            {
                ReportViewer2.ServerReport.ReportServerUrl = new Uri(ReportingServer);
            }
        }
        public ActionResult ExportToExcel(int Module_Code, int SysLanguageCode, string Module_Name, string sortColumnOrder, string StrSearchCriteria)
        {
            ReportViewer2 = new ReportViewer();
            //int RecordCount = 0;
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;
            ReportParameter[] parm = new ReportParameter[6];

            string sortcolumn = "", sortorder = "";
            if (sortColumnOrder == "NA")
            {
                sortcolumn = "NAME";
                sortorder = "ASC";
            }
            else if (sortColumnOrder == "ND")
            {
                sortcolumn = "NAME";
                sortorder = "DSC";
            }
            else
            {
                sortcolumn = "TIME";
                sortorder = "DSC";
            }
            parm[0] = new ReportParameter("Module_Code", Convert.ToString(Module_Code));
            parm[1] = new ReportParameter("SysLanguageCode", Convert.ToString(SysLanguageCode));
            parm[2] = new ReportParameter("Column_Count", "0");
            parm[3] = new ReportParameter("Sort_Column", sortcolumn);
            parm[4] = new ReportParameter("Sort_Order", sortorder);
            parm[5] = new ReportParameter("StrSearchCriteria", string.IsNullOrEmpty(StrSearchCriteria) ? " " : StrSearchCriteria);

            ReportCredential();
            ReportViewer2.ServerReport.ReportPath = string.Empty;
            if (ReportViewer2.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer2.ServerReport.ReportPath = objRS.GetReport("rptListMasters");
            }
            ReportViewer2.ServerReport.SetParameters(parm);
            Byte[] buffer = ReportViewer2.ServerReport.Render("Excel", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-disposition", "filename= " + Module_Name + ".xls");
            Response.OutputStream.Write(buffer, 0, buffer.Length);
            Response.End();
            return RedirectToAction("Index", new { Message = "Attachment File downloaded successfully" });
        }
    }

    public class ContidoInput
    {
        public string role_id { get; set; }
        public string organisation_db_id { get; set; }
        public string username { get; set; }
        public Data data { get; set; }
    }

    public class Data
    {
        public string language { get; set; }
        public string season_type { get; set; }
        public int season_no { get; set; }
        public string name { get; set; }
        public string season_name { get; set; }
        public int no_of_episodes { get; set; }
        public string rms_id { get; set; }
        public string channels_list { get; set; }
        public List<ScheduleInfo> schedule_info { get; set; }
        public List<string> ott_platforms_list { get; set; }
        public List<Ottprogramsinfo> ottprogramsinfo { get; set; }
        public List<string> tasks_list { get; set; }
        public List<object> program_type { get; set; }
        public List<object> program_settings { get; set; }
    }

    public class ScheduleInfo
    {
        public string id { get; set; }
        public string channel_db_id { get; set; }
        public string channel_id { get; set; }
        public string name { get; set; }
        public string language { get; set; }
        public bool is_disaster { get; set; }
        public string organisation { get; set; }
        public string organisation_code { get; set; }
        public long tx_time { get; set; }
    }

    public class Ottprogramsinfo
    {
        public string id { get; set; }
        public int display_seq { get; set; }
        public string ott_id { get; set; }
        public string platform_name { get; set; }
        public object language { get; set; }
        public string image_path { get; set; }
        public long first_publish_time { get; set; }
        public long second_publish_time { get; set; }
        public List<string> geography { get; set; }
        public string name { get; set; }
        public List<string> device_type { get; set; }
    }


    //output

    public class Data_Output
    {
        public string upload_bucket_name_path { get; set; }
        public string upload_bucket_name { get; set; }
        public string upload_audio_bucket_name { get; set; }
        public string upload_audio_bucket_name_path { get; set; }
        public string program_db_id { get; set; }
    }

    public class Root_Output
    {
        public bool response { get; set; }
        public Data_Output data { get; set; }
        public object errorcode { get; set; }
        public object errormessage { get; set; }
        public bool popupmessage { get; set; }
        public string type { get; set; }
        public string header { get; set; }
        public string body { get; set; }
    }
}
